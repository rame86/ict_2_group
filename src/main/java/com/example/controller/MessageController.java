package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.LoginVO;
import com.example.domain.MessageVO;
import com.example.service.MessageService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MessageController {

	@Autowired
	private MessageService messageService;

	// 로그인 세션 받아오기
	@ModelAttribute("login")
	public LoginVO getLogin(HttpSession session) {
		return (LoginVO)session.getAttribute("login");
	}

	// 쪽지함 띄우기
	@GetMapping("/message/messageList")
	public void messageList() {}
	
	@ResponseBody
	@GetMapping("/api/message/conversationList")
	public List<MessageVO> getConversationList(@ModelAttribute("login") LoginVO login) {
		return messageService.getConversationList(login.getEmpNo());
	}
	
	// 쪽지 보내기
	@ResponseBody
	@PostMapping("/api/message/send")
	public String sendMessage(@ModelAttribute("login") LoginVO login, @RequestBody MessageVO vo) {
		vo.setSenderEmpNo(login.getEmpNo());
		int result = messageService.sendMessage(vo);
		if(result > 0) return "success";
		else return "fail";
	}

}
