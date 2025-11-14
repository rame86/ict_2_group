package com.example.controller;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class TestController {

	Logger logger = LoggerFactory.getLogger(TestController.class);

	/*******************************************
	 * 
	 * [샘플]
	 * @RequestMapping("요청명")
	 * public String 함수명(){
	 * 
	 * retrun "뷰페이지명";
	 * }
	 * 
	 * Spring 컨트롤러 함수의 리턴값은 뷰페이지명
	 * 
	 *******************************************/

	@RequestMapping("/modelValue.do")
	public String xxx(Model m) { // Model m 에 값을 넣어 jsp로 넘김

		// 서비스 -> 레포지토리 - DB
		// 데이터 베이스에서 넘겨받은 값
		String dbValue = "디비에서 받은 값";
		String userName = "홍길동";

		// 속성값을 넣어줌
		m.addAttribute("db", dbValue);
		m.addAttribute("user", userName);

		return "model";
	}

	/*******************************************
	 * 스프링 컨트롤러 함수의 리턴값이 void 인 경우
	 * 자동으로
	 * 요청명과 동일한 뷰페이지 지정됨
	 *******************************************/

	@RequestMapping("voidReturn.do")
	public void abc(Model vo) {
		vo.addAttribute("serverValue", new Date().toString());
		vo.addAttribute("myMessage", "메세지에용");

		logger.info("voidReturn 요청받음");
	}
	
	
	/*
	 * 1. 뷰페이지로 데이터 전달 방식
	 * (1) Model
	 * 
	 * (2) ModelAndView
	 *  
	 */
	@RequestMapping("modelandview.do")
	public ModelAndView asdf() {
		ModelAndView mv = new ModelAndView();
		mv.addObject("myDate", "안녕하세요");
		mv.addObject("myName","홍길동");
		mv.setViewName("mvpage");
		
		logger.info("modelandview 요청받음");
		
		return mv;
	

		
	}
	

}
