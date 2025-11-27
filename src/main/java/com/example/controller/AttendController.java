package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AttendController {

	@GetMapping("/attend/attend")
	public String attend() {		
		log.info("[요청 /attend/attend]");
		return "/attend/attend";
	}

}
