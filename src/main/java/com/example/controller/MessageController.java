package com.example.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.EmpVO;
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
	
	// 대화상대자 띄우기
	@ResponseBody
	@GetMapping("/api/message/conversationList")
	public List<MessageVO> getConversationList(@ModelAttribute("login") LoginVO login) {
		return messageService.getConversationList(login.getEmpNo());
	}
	
	// 선택한 사람과의 대화창 띄우기
	@ResponseBody
	@GetMapping("/api/message/chat/{otherUserId}")
	public Map<String, Object> getMessageList(@ModelAttribute("login") LoginVO login, 
			@PathVariable String otherUserId) {
		List<MessageVO> message = messageService.getChatMessage(login.getEmpNo(), otherUserId);
		Map<String, Object> result = new HashMap<>();
		result.put("messages", message);
		return result;
	}
	
	// 쪽지 보내기
	@ResponseBody
	@PostMapping("/api/message/send")
	public Map<String, Object> sendMessage(@ModelAttribute("login") LoginVO login, @RequestBody MessageVO vo) {
		
		Map<String, Object> result = new HashMap<>();
		
		try {
			vo.setSenderEmpNo(login.getEmpNo());
			int message = messageService.sendMessage(vo);
			if(message > 0) result.put("status", "success");
			else result.put("status", "fail");
		} catch (Exception e) {
			log.info(e.getMessage());
			result.put("status", "error");
		}
		
		return result;
		
	}
	
	@ResponseBody
	@GetMapping("/api/message/emp")
	public List<EmpVO> getSelectEmp(@RequestParam(required = false, defaultValue = "") String keyword,
			@ModelAttribute("login") LoginVO login){
		System.out.println(login.getEmpNo() + "메세지보낼사람찾기요청");
		return messageService.getSelectEmpList(keyword, login.getEmpNo());
	}
	
}
