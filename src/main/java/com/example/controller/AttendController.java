package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.LoginVO;
import com.example.domain.DayAttendVO;
import com.example.domain.DocVO;
import com.example.service.ApproveService;
import com.example.service.AttendService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class AttendController {

	@Autowired
	private AttendService attendService;
	@Autowired
	private ToDate toDate;
	@Autowired
	private ApproveService aproveService;

	// =======================================================================================
	// getLogin() 로그인 세션 받아오기
	@ModelAttribute("login")
	public LoginVO getLogin(HttpSession session) {
		return (LoginVO) session.getAttribute("login");
	}
	// end of getLogin()
	// =======================================================================================

	//

	// =======================================================================================
	// attend() 근태관리 페이지 로드
	@GetMapping("/attend/attend")
	public String attend(@ModelAttribute("login") LoginVO login, Model m) {
		log.info("[AttendController-attend 요청 받음]");

		String toDay = toDate.getToMonth();
		String empNo = login.getEmpNo();

		log.info("toDay : " + toDay);
		log.info("empNo : " + empNo);

		// vo.empNo에 유효한 값이 설정되었으므로 DB 쿼리 실행
		List<DayAttendVO> result = attendService.selectDayAttend(empNo, toDay);

		for (DayAttendVO day : result) {
			log.info("데이터: {}", day.toString()); // VO 객체의 toString() 호출
		}

		m.addAttribute("result", result);

		return "/attend/attend";
	}
	// end of attend()
	// =======================================================================================

	//

	// =======================================================================================
	// checkIn() 출근
	@GetMapping("/attend/checkIn")
	@ResponseBody
	public String checkIn(@ModelAttribute("login") LoginVO login, Model m, DayAttendVO davo) {
		log.info("[AttendController - checkIn 요청 받음]");

		// 출근 기준시간 설정
		String standardTime = "09:00:00";

		String toDay = toDate.getToDay();
		davo.setDateAttend(toDay);
		String empNo = login.getEmpNo();
		davo.setEmpNo(empNo);
		String nowTime = toDate.getCurrentTime();
		String nowDateTime = toDate.getCurrentDateTime();
		davo.setInTime(nowDateTime);

		// 기준시간보다 늦으면 지각~
		if (nowTime.compareTo(standardTime) < 0) {
			davo.setAttStatus("1");
		} else {
			davo.setAttStatus("2");
		}
		log.info(davo.toString());

		String result = attendService.checkIn(davo);

		return result;
	}
	// end of checkIn()
	// =======================================================================================

	//

	// =======================================================================================
	// checkOut() 퇴근
	@GetMapping("/attend/checkOut")
	@ResponseBody
	public String checkOut(@ModelAttribute("login") LoginVO login, Model m, DayAttendVO davo) {
		log.info("[AttendController - checkOut 요청 받음]");

		// 퇴근 기준시간 설정
		String standardTime = "18:00:00";

		String toDay = toDate.getToDay();
		davo.setDateAttend(toDay);
		String empNo = login.getEmpNo();
		davo.setEmpNo(empNo);
		String nowTime = toDate.getCurrentTime();
		String nowDateTime = toDate.getCurrentDateTime();
		davo.setOutTime(nowDateTime);

		// 기준시간보다 먼저가면 조퇴~
		if (nowTime.compareTo(standardTime) < 0) {
			davo.setAttStatus("3");
		} else {
			davo.setAttStatus("null");
		}
		log.info(davo.toString());

		String result = attendService.checkOut(davo);

		return result;
	}
	// end of checkOut()
	// =======================================================================================

	//

	// =======================================================================================
	// fieldwork() 외근
	@GetMapping("/attend/fieldwork")
	@ResponseBody
	public String fieldwork(@ModelAttribute("login") LoginVO login, Model m, DayAttendVO davo) {
		log.info("[AttendController - fieldwork 요청 받음]");

		String toDay = toDate.getToDay();
		davo.setDateAttend(toDay);
		String empNo = login.getEmpNo();
		davo.setEmpNo(empNo);
		String nowDateTime = toDate.getCurrentDateTime();
		davo.setOutTime(nowDateTime);

		log.info(davo.toString());

		String result = attendService.fieldwork(davo);

		return result;
	}
	// end of checkOut()
	// =======================================================================================

	//

	// =======================================================================================
	// calendar() 캘린더 갱신
	@GetMapping("/attend/calendar")
	@ResponseBody
	public List<DayAttendVO> calendar(@ModelAttribute("login") LoginVO login, @RequestParam("date") String toDay) {
		log.info("[AttendController - calendar 요청 받음]");
		log.info("[AttendController - date : " + toDay + "]");
		String empNo = login.getEmpNo();

		log.info("toDay : " + toDay);
		log.info("empNo : " + empNo);

		// vo.empNo에 유효한 값이 설정되었으므로 DB 쿼리 실행
		List<DayAttendVO> result = attendService.selectDayAttend(empNo, toDay);

		for (DayAttendVO day : result) {
			log.info("데이터: {}", day.toString()); // VO 객체의 toString() 호출
		}

		return result;
	}
	// end of calendar()
	// =======================================================================================

	// =======================================================================================
	// vacation() 외근
	@GetMapping("/attend/vacation")
	public String vacation(@ModelAttribute("login") Model m) {
		log.info("[AttendController - vacation 요청 받음]");

		// Model에서 "docNo" 키로 데이터 꺼내기
		Integer docNo = (Integer) m.getAttribute("docNo");
		;
		// 문서번호로 내용 가져오기
		DocVO docInfo = aproveService.selectDocNo(docNo);
		log.info("[AttendController - vacation - docInfo 데이터 : " + docInfo.toString() + "]");

		return "redirect:/approve/receiveList";
	}
	// end of checkOut()
	// =======================================================================================

	//

	// =======================================================================================
	// processAbsence() 결근처리
	@GetMapping("/attend/processAbsence")
	@ResponseBody
	public ResponseEntity<String> processAbsence() {
		try {
			int count = attendService.processDailyAbsence();
			String message = "결근 처리 완료. 총 " + count + "명의 사원에 대해 처리되었습니다.";
			return ResponseEntity.ok(message);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.internalServerError().body("결근 처리 중 오류 발생: " + e.getMessage());
		}
	}
	// end of processAbsence()
	// =======================================================================================
	
	@GetMapping("/attend/processIncomplete")
	@ResponseBody
	public ResponseEntity<String> processIncompleteAttendance() {
	    try {
	        int updatedCount = attendService.processIncompleteAttendance();

	        if (updatedCount > 0) {
	            String message = String.format("미퇴근 처리 완료. 총 %d건의 출근/지각 기록이 결근 처리되었습니다.", updatedCount);
	            return ResponseEntity.ok(message);
	        } else {
	            return ResponseEntity.ok("미퇴근 처리할 대상이 없습니다.");
	        }
	    } catch (Exception e) {
	        // 실제 운영 환경에서는 e.getMessage() 대신 상세 로그를 찍어야 합니다.
	        return ResponseEntity.status(500).body("미퇴근 결근 처리 중 서버 오류가 발생했습니다: " + e.getMessage());
	    }
	}
	
}
