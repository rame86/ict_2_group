package com.example.controller;



import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;


import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;


@Slf4j
@Controller
public class TestController {

//	 @PathVariable
//	 step 변수에 자동으로 요청값이 들어가고 추적하여 열어줌
	@RequestMapping("{step}")
	public void asdf(@PathVariable String step) {
		log.info("요청받은 step : " + step);
	}
	
	@RequestMapping("rame/test")
	public void zz() {
		
	}

	
	
}
