package com.example.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
	
	// 결재 신청
	@Override
	@Transactional
	public void ApprovalApplication(DocVO dvo, ApproveVO avo) {
		
		int docNo = approveDao.selectDocSeqNextVal();
		int empNo = avo.getEmpNo();
		
		dvo.setDocNo(docNo);
		dvo.setDocWriter(String.valueOf(empNo));
		approveDao.insertDoc(dvo);
		
		avo.setDocNo(docNo);
		
		DeptVO manager = approveDao.selectManager(empNo);
		Integer step1ManagerNo =  Integer.parseInt(manager.getManagerEmpNo()); //내 부서의 매니저
		
		int deptNo = Integer.parseInt(manager.getDeptNo()); 
		DeptVO parent = approveDao.selectParentDept(deptNo); // 내 매니저의 deptNo로 상위부서 정보 얻어오기
		int step2ManagerNo = (parent.getParentManagerEmpNo() != null) 
								? Integer.valueOf(parent.getParentManagerEmpNo()) 
								: null;
		
		if(step1ManagerNo == step2ManagerNo) {
			avo.setStep1ManagerNo(null);
			avo.setStep1Status("X");
			avo.setStep2ManagerNo(step1ManagerNo);
			avo.setStep2Status("W");
		}else {
			avo.setStep1ManagerNo(step1ManagerNo);
			avo.setStep1Status("W");
			avo.setStep2ManagerNo(step2ManagerNo);
			avo.setStep2Status("W");
		}
				
		approveDao.insertApprove(avo);
		
	}
	
	// 결재 해야 할 문서 리스트
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

	// 결재 신청한 문서 리스트
	@Override
	public Map<String, List<ApproveListVO>> selectSendApproveList(String empNo) {
		
		// 결재 처리중인 문서들
		Map<String, Object> waitParam = new HashMap<>();
		
		waitParam.put("empNo", empNo);
		waitParam.put("limit", null);
		waitParam.put("statusType", "ACTIVE");
		
		List<ApproveListVO> waitList = approveDao.selectSendApproveList(waitParam);
		
		// 결재 반려된 문서들
		Map<String, Object> rejectParam = new HashMap<>();
		
	    rejectParam.put("empNo", empNo);
	    rejectParam.put("limit", null);
	    rejectParam.put("statusType", "REJECT");
	    
	    List<ApproveListVO> rejectList = approveDao.selectSendApproveList(rejectParam);
	    
	    // 결재 승인된 문서들
	    Map<String, Object> finishParam = new HashMap<>();
	    
	    finishParam.put("empNo", empNo);
	    finishParam.put("limit", null);
	    finishParam.put("statusType", "FINISH");
	    
	    List<ApproveListVO> finishList = approveDao.selectSendApproveList(finishParam);
	    
	    // 결재 완료(승인 + 반려)된 문서들
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

	// 결재 현황 리스트
	@Override
	public Map<String, List<ApproveListVO>> approveStatusList(String empNo, Integer limit) {
		
		// 결재 해야하는 문서 최신 5개
		Map<String, Object> receiveParam = new HashMap<>();
		
		receiveParam.put("empNo", empNo);
		receiveParam.put("limit", limit);
		
		List<ApproveListVO> receiveList = approveDao.selectWaitingReceiveListLimit(receiveParam);
		
		// 결재 받아야하는 문서 최신 5개
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
		}else if("R".equals(status)) {
			param.put("rejectReason", rejectReason);
			approveDao.updateRejectStatus(param);
		}
		
	}

	// 결재 요청한 문서 수
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

}
