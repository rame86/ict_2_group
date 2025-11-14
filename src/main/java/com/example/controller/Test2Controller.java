package com.example.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.domain.MemberVO;

@Controller
@RequestMapping("/re") //re폴더를 지정
public class Test2Controller {
	Logger logger = LoggerFactory.getLogger(TestController.class);
	
	
	@RequestMapping(value={"a.do","b.do"}) //요청만 지정
	public void ab() {			
		logger.info("[re/a.do]요청받음");
	
	}
	
	@RequestMapping("c.do")
//	public void cd(@RequestParam("id") String id) {
	public void cd(String id) {
		logger.info("[re/c.do] 요청받음");
		logger.info("전 화면에서 넘겨받은 파라메터:" + id);
		
	}
	@RequestMapping("request.do")
	public void frm(MemberVO vo) {
		logger.info("[request.do] 요청받음");
		logger.info("사용자 입력값: " + vo.toString());
	}
	
	
	
}
