package com.example.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.domain.EmpVO;
import com.example.domain.MemberVO;
import com.example.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ApproveController {
	
	@Autowired
	private MemberService memberService;	
	
	@GetMapping("approve/statusList")
	public void statusList() {
		
	}
	
	@PostMapping("approve/approve-form")
	public String approveForm(){
		return "approve/statusList";
	}
	
	@GetMapping("approve/receiveList")
	public void receiveList() {
		
	}
	
	@GetMapping("approve/sendList")
	public void sendList() {
		
	}
	
	@GetMapping("approve/createForm")
	public void createForm() {
		
	}
}
