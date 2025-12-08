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
	private final NotificationService notificationService;
	
	public ApproveController(NotificationService notificationService) {
		this.notificationService = notificationService;
	}

	// 로그인 세션 받아오기
	@ModelAttribute("login")
	public LoginVO getLogin(HttpSession session) {
		return (LoginVO)session.getAttribute("login");
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
	public Map<String, Object> simpleList(@ModelAttribute("login") LoginVO login, @RequestParam("status") String status) {
		
		List<ApproveListVO> documentList = null;
		String empNo = login.getEmpNo();
		
		if("receiveFinish".equals(status)) {
			documentList = approveService.selectFinishReceiveList(empNo);
		}else if("receiveWait".equals(status)) {
			documentList = approveService.selectWaitingReceiveList(empNo);
		}else {
			Map<String, List<ApproveListVO>> sendList = approveService.selectSendApproveList(empNo);
			documentList = sendList.get(status);
		}
		
		Map<String, Object> result = new HashMap<>();
		
		result.put("documentList", documentList);
		
		return result;
		
	}
	
	// 결재 할 문서들이 있는곳
	@GetMapping("approve/receiveList")
	public String receiveList(@ModelAttribute("login") LoginVO login , Model m) {
		List<ApproveListVO> list =  approveService.selectWaitingReceiveList(login.getEmpNo());
		m.addAttribute("list", list);
		return "approve/receiveList";
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
	public void createForm() {}
	
	// 문서 작성
	@PostMapping("approve/approve-form")
	public String approveForm(DocVO dvo, ApproveVO avo){
		System.out.println("approve-form 도착" + dvo.toString() + avo.toString());
		approveService.ApprovalApplication(dvo, avo);
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
	public void approveDocument(@RequestParam Integer docNo,
			@RequestParam String status,
			@RequestParam(required = false) String rejectReason,
			@ModelAttribute("login") LoginVO login){
		Integer empNo = Integer.parseInt(login.getEmpNo());
		approveService.approveDocument(docNo, status, empNo, rejectReason);
		
		DocVO vo = approveService.selectDocNo(docNo);
		String docWriter = vo.getDocWriter(); // 문서를 쓴 작성자
				
		if(vo.getDocType().equals("4")) {
			attendService.insertVacation(vo);
		}else if(vo.getDocType().equals("5")) {
			attendService.commuteCorrection(vo);
		}
		
		System.out.println("DEBUG: 조회된 작성자 사번 = " + docWriter);
		notificationService.sendApprovalNotification(docWriter, "문서가 처리되었습니다.");
		System.out.println("DEBUG: 알림 서비스 호출 완료. 다음 로직으로 이동.");
		
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
		
}
