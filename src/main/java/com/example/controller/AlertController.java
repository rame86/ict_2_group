package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.example.domain.AlertVO;
import com.example.domain.LoginVO;
import com.example.service.AlertService;

@RestController
public class AlertController {
	
	@Autowired
	private AlertService alertService;
	
	@GetMapping("/alert/unreadCount")
	public int getUnreadAlert(@SessionAttribute("login") LoginVO login) {
		return alertService.getUnreadAlert(login.getEmpNo());
	}
	
	@GetMapping("/alert/latestView")
	public List<AlertVO> alertLatestView(@SessionAttribute("login") LoginVO login) {
		return  alertService.getUnreadAlertView(login.getEmpNo());
	}
	
	@PostMapping("/alert/markAllAsRead")
	public void markUpdateAsRead(@SessionAttribute("login") LoginVO login) {
		alertService.markUpdateAsRead(login.getEmpNo());
	}

}
