package com.example.exception;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice("com.example")
public class GeneralException {

	// 추후에는 구체적인 예외처리 ex) MemberException, SQLException
	@ExceptionHandler(Exception.class)
	public String handleException(Exception e, Model m) {
		
		m.addAttribute("error",e);
		
		return "error/TransErrorPage";
		
	}
}
