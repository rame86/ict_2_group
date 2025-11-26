package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class TestController {
	
	@GetMapping("approve/statusList")
	public void statusList() {
		
	}
	
	@GetMapping("approve/receiveList")
	public void receiveList() {
		
	}
	
	@GetMapping("approve/sendList")
	public void sendList() {
		
	}
	
	@GetMapping("aapprove/createForm")
	public void createForm() {
		
	}
}
