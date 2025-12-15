package com.example.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import org.springframework.web.servlet.ModelAndView;

import com.example.domain.ApproveListVO;
import com.example.domain.ApproveVO;
import com.example.domain.DocVO;
import com.example.domain.LoginVO;
import com.example.service.ApproveService;
import com.example.service.AttendService;
import com.example.service.DeptService;
import com.example.service.EmpService;
import com.example.service.NotificationService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ApproveController {

	@Autowired
	private ApproveService approveService;
	@Autowired
	private AttendService attendService;
	@Autowired
	private DeptService deptService;
	@Autowired
	private EmpService empService;

	private final NotificationService notificationService;

	public ApproveController(NotificationService notificationService) {
		this.notificationService = notificationService;
	}

	// 로그인 세션 받아오기
	@ModelAttribute("login")
	public LoginVO getLogin(HttpSession session) {
		return (LoginVO) session.getAttribute("login");
	}

	// 결재 현황
	@GetMapping("approve/statusList")
	public void statusList(@ModelAttribute("login") LoginVO login, Model m) {

		String empNo = login.getEmpNo();

		// 결재 해야할 문서 현황
		int receiveFinishCount = approveService.selectFinishReceiveList(empNo).size();
		int receiveWaitCount = approveService.selectWaitingReceiveList(empNo).size();

		// 결재 요청한 문서 현황
		Map<String, Integer> sendCount = approveService.getSendCount(empNo);

		int sendWaitCount = sendCount.get("ACTIVE");
		int sendFinishCount = sendCount.get("FINISH");
		int sendrejectCount = sendCount.get("REJECT");

		// 모든 문서(보낸문서 + 요청된문서) 현황
		int totalCount = sendFinishCount + sendWaitCount + sendrejectCount + receiveFinishCount + receiveWaitCount;

		m.addAttribute("sendFinishCount", sendFinishCount);
		m.addAttribute("sendWaitCount", sendWaitCount);
		m.addAttribute("sendrejectCount", sendrejectCount);
		m.addAttribute("receiveFinishCount", receiveFinishCount);
		m.addAttribute("receiveWaitCount", receiveWaitCount);
		m.addAttribute("totalCount", totalCount);

		// 최근 5개의 문서 뽑아내기
		Map<String, List<ApproveListVO>> listLimit = approveService.approveStatusList(empNo, 5);

		List<ApproveListVO> receiveListLimit = listLimit.get("receive");
		List<ApproveListVO> sendListLimit = listLimit.get("send");

		m.addAttribute("receive", receiveListLimit);
		m.addAttribute("send", sendListLimit);

	}

	// 결재 현황 카드
	@ResponseBody
	@GetMapping("approve/simpleList")
	public Map<String, Object> simpleList(@ModelAttribute("login") LoginVO login,
			@RequestParam("status") String status) {

		List<ApproveListVO> documentList = null;
		String empNo = login.getEmpNo();

		if ("receiveFinish".equals(status)) {
			documentList = approveService.selectFinishReceiveList(empNo);
		} else if ("receiveWait".equals(status)) {
			documentList = approveService.selectWaitingReceiveList(empNo);
		} else {
			Map<String, List<ApproveListVO>> sendList = approveService.selectSendApproveList(empNo);
			documentList = sendList.get(status);
		}

		Map<String, Object> result = new HashMap<>();

		result.put("documentList", documentList);

		return result;

	}

	// 결재 할 문서들이 있는곳
	@GetMapping("approve/receiveList")
	public String receiveList(@ModelAttribute("login") LoginVO login, Model m) {
		List<ApproveListVO> list = approveService.selectWaitingReceiveList(login.getEmpNo());
		m.addAttribute("list", list);
		return "approve/receiveList";
	}

	// 결재 할 문서들의 수(뱃지)
	@GetMapping("approve/getWaitingCount")
	@ResponseBody
	public Integer getWaitingCount(@ModelAttribute("login") LoginVO login) {
		return approveService.selectWaitingReceiveList(login.getEmpNo()).size();
	}

	// 결재 신청한 문서들이 있는곳
	@GetMapping("approve/sendList")
	public String sendList(@ModelAttribute("login") LoginVO login, Model m) {
		Map<String, List<ApproveListVO>> list = approveService.selectSendApproveList(login.getEmpNo());
		m.addAttribute("waitList", list.get("waitList"));
		m.addAttribute("rejectList", list.get("rejectList"));
		return "approve/sendList";
	}

	// 문서 작성
	@GetMapping("approve/createForm")
	public void createForm() {
	}

	// 문서 작성
	@PostMapping("approve/approve-form")
	public String approveForm(DocVO dvo, ApproveVO avo) {
		log.info("approve/approve-form 요청받음");
		log.info(dvo.toString());
		approveService.ApprovalApplication(dvo, avo);
		notificationService.sendApprovalNotification(Integer.toString(avo.getStep1ManagerNo()), "새로운 결재가 도착했습니다");
		if (dvo.getDocType().equals("4") || dvo.getDocType().equals("5") || dvo.getDocType().equals("6"))
			return "OK";
		else
			return "redirect:statusList";
	}

	// 문서 상세보기
	@GetMapping("/approve/documentDetail")
	public String documentDetail(@RequestParam Integer docNo, Model m) {
		m.addAttribute("vo", approveService.selectDocNo(docNo));
		return "approve/documentDetail";
	}

	// 문서 결재
	@ResponseBody
	@PostMapping("approve/approveDocument")
	public void approveDocument(@RequestParam Integer docNo, @RequestParam String status,
			@RequestParam(required = false) String rejectReason, @ModelAttribute("login") LoginVO login) {

		Integer empNo = Integer.parseInt(login.getEmpNo());
		approveService.approveDocument(docNo, status, empNo, rejectReason);

		DocVO vo = approveService.selectDocNo(docNo); // 문서조회
		log.info("approveDocument:" + vo.toString());
		String docWriter = vo.getDocWriter(); // 문서를 쓴 작성자
		Integer step2Manager = vo.getStep2ManagerNo(); // 2차결재자의 사번
		String step2Status = vo.getStep2Status(); // 2차결재의 상태
		String writeNotificationMessage;

		if (vo.getDocType().equals("4") && step2Status.equals("A")) {
			log.info("DocType :" + vo.getDocType());			
			attendService.insertVacation(vo);
		} else if (vo.getDocType().equals("5") && step2Status.equals("A")) {
			attendService.commuteCorrection(vo);
			log.info("DocType :" + vo.getDocType());
		} else if ((vo.getDocType().equals("6") || vo.getDocType().equals("7")) && step2Status.equals("A")) {
			log.info("DocType :" + vo.getDocType());
			deptService.setDeptManager(vo);
			empService.setEmpJobTitle(vo);
		}
		

		notificationService.sendApprovalNotification(Integer.toString(empNo), "결재가 성공적으로 완료되었습니다.");

		if (step2Status != null && step2Status.equals("A"))
			writeNotificationMessage = "문서가 최종 승인 되었습니다.";
		else if (status.equals("R"))
			writeNotificationMessage = "문서가 반려되었습니다";
		else
			writeNotificationMessage = "문서결재가 진행되고있습니다.";

		notificationService.sendApprovalNotification(docWriter, writeNotificationMessage);

		if (step2Manager != null && step2Status.equals("W")) {
			String manager = Integer.toString(step2Manager);
			notificationService.sendApprovalNotification(manager, "새로운 결재가 도착했습니다");
		}

	}

	// 결재 완료된 문서들
	@GetMapping("approve/finishList")
	public void finishList(@ModelAttribute("login") LoginVO login, Model m) {
		List<ApproveListVO> receiveList = approveService.selectFinishReceiveList(login.getEmpNo());
		Map<String, List<ApproveListVO>> sendList = approveService.selectSendApproveList(login.getEmpNo());
		m.addAttribute("receiveList", receiveList);
		m.addAttribute("sendList", sendList.get("sendList"));
	}

	// 내가 보낸 문서 상세보기
	@GetMapping("approve/documentDetailPopup")
	public void documentDetailPopup(@RequestParam Integer docNo, Model m, @ModelAttribute("login") LoginVO login) {
		DocVO vo = approveService.selectDocNo(docNo);
		m.addAttribute("dept", login.getDeptName());
		m.addAttribute("vo", vo);
	}

	// 다른 폼에서 오는 ajax 결제관리
	@PostMapping("approve/approve-ajax")
	@ResponseBody // 이건 새로 만드는 거니까 붙여도 되죠?
	public String approveFormAjax(DocVO dvo, ApproveVO avo) {
		log.info("approve/approve-ajax 요청받음");
		log.info(dvo.toString());
		// 서비스 로직은 똑같이 호출
		approveService.ApprovalApplication(dvo, avo);
		notificationService.sendApprovalNotification(Integer.toString(avo.getStep1ManagerNo()), "새로운 결재가 도착했습니다");

		// 무조건 텍스트 리턴
		return "OK";
	}

}
