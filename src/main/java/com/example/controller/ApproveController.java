package com.example.controller;

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

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ApproveController {
	
	@Autowired
	private ApproveService approveService;
	@Autowired
	private AttendService attendService;

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
		log.info("approveDocument"+vo.toString());
		
		if(vo.getDocType().equals("4")) {
			attendService.insertVacation(vo);
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
		
}
