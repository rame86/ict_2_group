package com.example.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.domain.ApproveListVO;
import com.example.domain.ApproveVO;
import com.example.domain.DocVO;
import com.example.domain.LoginVO;
import com.example.service.ApproveService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ApproveController {
	
	@Autowired
	private ApproveService approveService;

	// 로그인 세션 받아오기
	@ModelAttribute("login")
	public LoginVO getLogin(HttpSession session) {
		return (LoginVO)session.getAttribute("login");
	}
	
	@GetMapping("approve/statusList")
	public void statusList(@ModelAttribute("login") LoginVO login, Model m) {
		Map<String, List<ApproveListVO>> list = approveService.approveStatusList(login.getEmpNo(), 5);
		m.addAllAttributes(list);
	}
	
	// 결재 할 문서들이 있는곳
	@GetMapping("approve/receiveList")
	public String receiveList(@ModelAttribute("login") LoginVO login , Model m) {
		System.out.println(login.getEmpNo());
		List<ApproveListVO> list = approveService.selectReceiveApproveList(login.getEmpNo());
		m.addAttribute("list", list);
		return "approve/receiveList";
	}
	
	// 결재 신청한 문서들이 있는곳
	@GetMapping("approve/sendList")
	public String sendList(@ModelAttribute("login") LoginVO login, Model m) {
		List<ApproveListVO> list = approveService.selectSendApproveList(login.getEmpNo());
		m.addAttribute("list", list);
		return "approve/sendList";
	}
	
	@GetMapping("approve/createForm")
	public void createForm() {
		
	}
	
	@PostMapping("approve/approve-form")
	public String approveForm(DocVO dvo, ApproveVO avo){
		approveService.ApprovalApplication(dvo, avo);
		return "redirect:statusList";
	}
	
}
