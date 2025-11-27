package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.DayAttendVO;
import com.example.domain.EmpVO;
import com.example.service.AttendService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AttendController {

	@Autowired
	private AttendService attendService;	
	
	@GetMapping("/attend/attend")
	public String attend() {		
		log.info("[요청 /attend/attend]");
		return "/attend/attend";
	}
	
	@PostMapping("/attend/dayAttend")
	@ResponseBody
	public List<DayAttendVO> dayAttend(EmpVO vo){
		List<DayAttendVO> result = attendService.selectDayAttend(vo);
		return result; 
	}

}
