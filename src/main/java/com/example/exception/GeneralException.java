package com.example.exception;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.support.RedirectAttributes; // ⭐ 추가

@ControllerAdvice("com.example")
public class GeneralException {

	// 추후에는 구체적인 예외처리 ex) MemberException, SQLException
	@ExceptionHandler(Exception.class)
	// RedirectAttributes 추가
	public String handleException(Exception e, RedirectAttributes redirectAttributes) {
		
		// 1. 오류 메시지를 Flash Attribute에 담아 리다이렉트 후에도 사용 가능하게 함.
		// 이 메시지는 다음 요청(redirect된 /member/register)의 Model에 자동으로 추가.
		redirectAttributes.addFlashAttribute("errorMessage", "오류가 발생했습니다: " + e.getMessage());
		
		// 2. 리다이렉트할 경로를 반환.
		// /member/register 매핑 메소드를 호출. (MemberController 참고)
		return "redirect:/member/register"; 
		
	}
}