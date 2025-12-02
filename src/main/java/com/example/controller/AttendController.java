package com.example.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.domain.LoginVO;
import com.example.domain.DayAttendVO;
import com.example.domain.EmpVO;
import com.example.service.AttendService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AttendController {

	@Autowired
	private AttendService attendService;

	@GetMapping("/attend/attend")
	public String attend(LoginVO vo, Model m, HttpSession session) {
		log.info("[AttendController-attend 요청 받음]");

		
	    Object loginInfoObj = session.getAttribute("login");
	    
		if (loginInfoObj != null) {			
			try {
				// LoginVO 타입으로 캐스팅
				vo = (LoginVO)loginInfoObj;				

			} catch (ClassCastException e) {				
				log.error("세션 속성 'login'을 LoginVO로 캐스팅하는 데 실패했습니다. 타입이 다릅니다.", e);
			}

		} else {
			// 로그인 되지 않은 상태
			log.warn("세션에 'login' 객체가 존재하지 않습니다. 로그인 상태를 확인하세요.");			
		}

		LocalDate todayDate = LocalDate.now();
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
				
		String toDay = todayDate.format(formatter);
		String empNo = vo.getEmpNo();
		
		
		// ************** 테스트용 toDay************
		toDay = "2025-11";
		log.info("toDay : "+toDay);		
		log.info("empNo : "+empNo);
		
		// vo.empNo에 유효한 값이 설정되었으므로 DB 쿼리 실행
		List<DayAttendVO> result = attendService.selectDayAttend(empNo, toDay);

		for (DayAttendVO day : result) {
			log.info("데이터: {}", day.toString()); // VO 객체의 toString() 호출
		}

		m.addAttribute("result", result);

		return "/attend/attend";
	}

}
