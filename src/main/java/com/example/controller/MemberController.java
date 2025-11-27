package com.example.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.domain.EmpVO;
import com.example.domain.MemberVO;
import com.example.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MemberController {
	
	@Autowired
	private MemberService memberService;

	@PostMapping("loginCheck")
	public String loginCheck(MemberVO vo, HttpSession session) {
		log.info("[MemberController - member/loginCheck] 요청받음 :" + vo.toString());
		EmpVO check = memberService.loginCheck(vo);
		if (check != null) {
			session.setAttribute("login", check);
			log.info("로그인 성공" + check.toString());
			return "index";
		} else {
			log.info("로그인 실패");
			return "/member/login";
		}
	}
}
