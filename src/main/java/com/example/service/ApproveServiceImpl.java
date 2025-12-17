package com.example.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.domain.AlertVO;
import com.example.domain.ApproveListVO;
import com.example.domain.ApproveVO;
import com.example.domain.DeptVO;
import com.example.domain.DocVO;
import com.example.repository.ApproveDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ApproveServiceImpl implements ApproveService {

    @Autowired
    private ApproveDAO approveDao;
    
    @Autowired
    AlertService alertService;
    
    @Autowired
    private NotificationService notificationService;
    
    // 결재 신청
    @Override
    @Transactional
    public void ApprovalApplication(DocVO dvo, ApproveVO avo) {
        
        // 1. [수정] 사원번호 Null 체크 및 안전한 추출
        if (avo.getEmpNo() == null) {
            throw new IllegalArgumentException("로그인 정보(사원번호)가 누락되었습니다.");
        }
        int empNo = avo.getEmpNo(); // 이제 안전함
        
        // 문서 번호 채번 및 저장
        int docNo = approveDao.selectDocSeqNextVal();
        
        dvo.setDocNo(docNo);
        dvo.setDocWriter(String.valueOf(empNo));
        approveDao.insertDoc(dvo);
        
        avo.setDocNo(docNo);
        
        // 2. 변수 초기화 (화면에서 넘어온 값을 기본값으로 설정 - 안전장치)
        Integer step1ManagerNo = avo.getStep1ManagerNo();
        Integer step2ManagerNo = avo.getStep2ManagerNo();
        String parentDeptNo = null;

        // 3. DB에서 정확한 매니저 및 상위 부서 정보 조회 시도
        DeptVO manager = approveDao.selectManager(empNo);
        
        // manager가 null이 아닐 때만 내부 로직 실행
        if (manager != null) {
            try {
                // 1차 매니저 정보 갱신
                if (manager.getManagerEmpNo() != null) {
                    step1ManagerNo = Integer.parseInt(manager.getManagerEmpNo());
                }

                // 상위 부서 정보 조회
                if (manager.getDeptNo() != null) {
                    int deptNo = Integer.parseInt(manager.getDeptNo());
                    DeptVO parent = approveDao.selectParentDept(deptNo);
                    
                    if (parent != null) {
                        // 2차 매니저 정보 갱신
                        if (parent.getParentManagerEmpNo() != null) {
                            step2ManagerNo = Integer.parseInt(parent.getParentManagerEmpNo());
                        }
                        // 상위 부서 코드 획득
                        parentDeptNo = parent.getParentDeptNo();
                    }
                }
            } catch (Exception e) {
                log.warn("매니저/부서 정보 변환 중 오류 발생 (기본값 사용): " + e.getMessage());
            }
        }

        // 4. 결재선 로직 적용 (Null Safe)
        if ("1001".equals(parentDeptNo)) {
            // 최상위 부서인 경우 (1차 생략, 바로 2차로)
            avo.setStep1ManagerNo(null);
            avo.setStep1Status("X");
            avo.setStep2ManagerNo(step1ManagerNo); // 원래 1차였던 사람을 2차 위치로
            avo.setStep2Status("W");
            
        } else if (step1ManagerNo != null && step1ManagerNo.equals(step2ManagerNo)) {
            // 1차와 2차 결재자가 같은 경우 (1차 생략)
            avo.setStep1ManagerNo(null);
            avo.setStep1Status("X");
            avo.setStep2ManagerNo(step1ManagerNo);
            avo.setStep2Status("W");
            
        } else {
            // 일반적인 경우 (1차 -> 2차)
            avo.setStep1ManagerNo(step1ManagerNo);
            avo.setStep1Status("W");
            avo.setStep2ManagerNo(step2ManagerNo);
            avo.setStep2Status("W");
        }
                
        // 5. 결재선 저장
        approveDao.insertApprove(avo);
        
        // 6. 알림 발송 (Service 내부 알림)
        // avo에 갱신된 결재자 정보를 넣어줘야 Controller에서 정확한 알림을 보낼 수 있음
        avo.setStep1ManagerNo(step1ManagerNo); 
        
        if(avo.getStep1ManagerNo() != null && "W".equals(avo.getStep1Status())) {
            log.info("ApproveService 알림 - 1차 수신자 : " + avo.getStep1ManagerNo());
            sendApprovalAlert(avo.getStep1ManagerNo(), dvo.getDocNo(), "결재 요청");
            
        } else if("X".equals(avo.getStep1Status()) && avo.getStep2ManagerNo() != null && "W".equals(avo.getStep2Status())) {
            log.info("ApproveService 알림 - 2차 수신자(1차생략) : " + avo.getStep2ManagerNo());
            sendApprovalAlert(avo.getStep2ManagerNo(), dvo.getDocNo(), "결재 요청");
        }
    }
    
    @Override
    public Map<String, List<ApproveListVO>> selectReceiveApproveList(String empNo) {

        Map<String, Object> param = new HashMap<>();
        param.put("empNo", empNo);
        
        List<ApproveListVO> list = approveDao.selectReceiveApproveList(param);
        List<ApproveListVO> waitingList = new ArrayList<>();
        List<ApproveListVO> finishList = new ArrayList<>();
        for(ApproveListVO vo : list) {
            String status = vo.getProgressStatus();
            if(status.endsWith("대기")) {
                waitingList.add(vo);
            }else {
                finishList.add(vo);
            }
        }
        Map<String, List<ApproveListVO>> result = new HashMap<>();
        result.put("waitingList", waitingList);
        result.put("finishList", finishList);
        return result;
    }
    
    @Override
    public List<ApproveListVO> selectWaitingReceiveList(String empNo) {
        return selectReceiveApproveList(empNo).get("waitingList");
    }

    @Override
    public List<ApproveListVO> selectFinishReceiveList(String empNo) {
        return selectReceiveApproveList(empNo).get("finishList");
    }

    @Override
    public Map<String, List<ApproveListVO>> selectSendApproveList(String empNo) {
        Map<String, Object> waitParam = new HashMap<>();
        waitParam.put("empNo", empNo);
        waitParam.put("limit", null);
        waitParam.put("statusType", "ACTIVE");
        List<ApproveListVO> waitList = approveDao.selectSendApproveList(waitParam);
        
        Map<String, Object> rejectParam = new HashMap<>();
        rejectParam.put("empNo", empNo);
        rejectParam.put("limit", null);
        rejectParam.put("statusType", "REJECT");
        List<ApproveListVO> rejectList = approveDao.selectSendApproveList(rejectParam);
        
        Map<String, Object> finishParam = new HashMap<>();
        finishParam.put("empNo", empNo);
        finishParam.put("limit", null);
        finishParam.put("statusType", "FINISH");
        List<ApproveListVO> finishList = approveDao.selectSendApproveList(finishParam);
        
        List<ApproveListVO> sendList = new ArrayList<>();
        sendList.addAll(finishList);
        sendList.addAll(rejectList);
        
        Map<String, List<ApproveListVO>> result = new HashMap<>();
        result.put("waitList", waitList);
        result.put("rejectList", rejectList);
        result.put("finishList", finishList);
        result.put("sendList", sendList);
        return result;
    }

    @Override
    public Map<String, List<ApproveListVO>> approveStatusList(String empNo, Integer limit) {
        Map<String, Object> receiveParam = new HashMap<>();
        receiveParam.put("empNo", empNo);
        receiveParam.put("limit", limit);
        List<ApproveListVO> receiveList = approveDao.selectWaitingReceiveListLimit(receiveParam);
        
        Map<String, Object> sendParam = new HashMap<>();
        sendParam.put("empNo", empNo);
        sendParam.put("limit", limit);
        sendParam.put("statusType", "ACTIVE");
        List<ApproveListVO> sendList = approveDao.selectSendApproveList(sendParam);
        
        Map<String, List<ApproveListVO>> result = new HashMap<>();
        result.put("receive", receiveList);
        result.put("send", sendList);
        return result;
    }
    
    @Override
    public DocVO selectDocNo(Integer docNo) {
        return approveDao.selectDocNo(docNo);
    }

    @Override
    public void approveDocument(Integer docNo, String status, Integer empNo, String rejectReason) {
        DocVO docVo = approveDao.selectDocNo(docNo);
        String step = null;
        
        if(empNo.equals(docVo.getStep1ManagerNo())) {
            step = "STEP1";
        }else if(empNo.equals(docVo.getStep2ManagerNo())) {
            step = "STEP2";
        }
        
        Map<String, Object> param = new HashMap<>();
        param.put("docNo", docNo);
        param.put("status", status);
        param.put("step", step);
        
        if("A".equals(status)) {
            approveDao.updateApproveStatus(param);
            if("STEP1".equals(step)) {
                Integer step2ManagerNo = docVo.getStep2ManagerNo();
                if(step2ManagerNo != null && !step2ManagerNo.equals(docVo.getStep1ManagerNo())) {
                    sendApprovalAlert(step2ManagerNo, docNo, "결재 요청");
                }
            }
            if("STEP2".equals(step)) {
                String writerEmpNo = docVo.getDocWriter();
                if(writerEmpNo != null) {
                    sendApprovalAlert(Integer.parseInt(writerEmpNo), docNo, "최종 승인");
                }
            }
        }else if("R".equals(status)) {
            param.put("rejectReason", rejectReason);
            approveDao.updateRejectStatus(param);
            String writerEmpNo = docVo.getDocWriter(); 
            if (writerEmpNo != null) {
                sendApprovalAlert(Integer.parseInt(writerEmpNo), docNo, "결재 반려");
            }
        }
    }

    @Override
    public Map<String, Integer> getSendCount(String empNo) {
        List<Map<String, Object>> sendCount = approveDao.countSendApproveStatus(empNo);
        Map<String, Integer> result = new HashMap<>();
        result.put("ACTIVE", 0);
        result.put("REJECT", 0);
        result.put("FINISH", 0);
        
        for(Map<String, Object> row : sendCount) {
            String status = (String) row.get("STATUSTYPE");
            Integer count = ((Number) row.get("COUNT")).intValue();
            result.put(status, count);
        }
        return result;
    }
    
    private void sendApprovalAlert(Integer receiveEmpNo, Integer docNo, String alertTitle) {
        if(receiveEmpNo == null || receiveEmpNo == 0) {
            log.info("Alert: 수신자 사원 번호가 유효하지 않아 알림을 저장하지 못했습니다. docNo: {}", docNo);
            return;
        }
        
        log.info("Alert 시도: 수신자 {}, 문서 {}", receiveEmpNo, docNo);
        AlertVO alert = new AlertVO();
        alert.setEmpNo(String.valueOf(receiveEmpNo));
        alert.setLinkType("APPROVAL");
        alert.setLinkId(docNo);
        alert.setTitle(alertTitle);
        alert.setContent(alertTitle + " 알림이 도착했습니다.");
        
        if (alertTitle.contains("요청")) {
            alert.setAlertStatus("REQUEST");
        } else if (alertTitle.contains("승인")) {
            alert.setAlertStatus("FINAL_APPROVAL");
        } else if (alertTitle.contains("반려")) {
            alert.setAlertStatus("REJECT");
        } else {
            alert.setAlertStatus("IN_PROGRESS");
        }
        
        try {
            alertService.saveNewAlert(alert);
            notificationService.pushNewAlert(alert);
        } catch (Exception e) {
            log.error("Alert: 알림 저장 중 오류 발생 (수신자: {}): {}", receiveEmpNo, e.getMessage());
        }
    }
}