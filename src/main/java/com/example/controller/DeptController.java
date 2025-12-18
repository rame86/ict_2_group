package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.DeptVO;
import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.service.DeptService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DeptController {

	@Autowired
	private DeptService deptService;

	@GetMapping("/dept/dept")
	public String department(Model m, HttpSession session) {
		List<DeptVO> deptList = deptService.getOrgChartData();
		m.addAttribute("deptList", deptList);
		
		// 2. 권한 체크 로직 (여기서 확실하게 계산)
		LoginVO login = (LoginVO) session.getAttribute("login");
		boolean isAdmin = false;

		if (login != null) {		
			m.addAttribute("myDeptNo", login.getDeptNo()); 

			// String으로 변환해서 비교
			String dNo = String.valueOf(login.getDeptNo());
			String gNo = String.valueOf(login.getGradeNo()).trim();

			log.info("[DeptController] 접속자 부서: " + dNo + ", 등급: " + gNo);

			// 인사부(2010) or 운영총괄(2000) AND 관리자급(1 or 2)
			if ((dNo.equals("2000") || dNo.equals("2010")) && (gNo.equals("1") || gNo.equals("2"))) {
				isAdmin = true;
			}
		}

		log.info("[DeptController] 관리자 권한 여부: " + isAdmin);

		// 3. JSP로 결과 전달
		m.addAttribute("isAdmin", isAdmin);

		return "/dept/dept";
	}

	// JSP의 loadEmployeeList() 함수에서 ajax로 호출될 URL
	@GetMapping("/dept/api/employees")
	@ResponseBody
	public List<EmpVO> getEmployeeList(@RequestParam("deptNo") int deptNo) {
		return deptService.getEmployeesByDept(deptNo);
	}

	// 부서 생성
	@PostMapping("/dept/create")
	@ResponseBody
	public String createDept(DeptVO vo) {
		try {
			deptService.createDept(vo);
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "FAIL";
		}
	}

	// 부서 삭제
	@PostMapping("/dept/delete")
	@ResponseBody
	public String deleteDept(@RequestParam("deptNo") int deptNo) {

		// 1. 핵심 부서(CEO, 운영총괄, 인사, CTO, CBO) 삭제 방지 로직
		if (deptNo == 1001 || deptNo == 2000 || deptNo == 2010 || deptNo == 3000 || deptNo == 4000) {
			return "PROTECTED"; // "보호된 부서"라는 신호를 보냄
		}

		try {
			deptService.removeDept(deptNo);
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "FAIL";
		}
	}

	// 부서 수정
	@PostMapping("/dept/update")
	@ResponseBody
	public String updateDept(DeptVO vo) {
		try {
			deptService.editDept(vo);
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "FAIL";
		}
	}

	// 사원 부서 이동 / 제외 처리
	@PostMapping("/dept/moveEmp")
	@ResponseBody
	public String moveEmp(@RequestParam("empNo") int empNo, @RequestParam("newDeptNo") int newDeptNo,
			HttpSession session) {

		LoginVO login = (LoginVO) session.getAttribute("login");

		String dNo = String.valueOf(login.getDeptNo());
		String gNo = String.valueOf(login.getGradeNo());
		// 권한 체크 (2000, 2010 부서의 관리자만 가능)
		boolean isAuth = false;
		if ((dNo.equals("2000") || dNo.equals("2010")) && (gNo.equals("1") || gNo.equals("2"))) {
			isAuth = true;
		}

		if (!isAuth)
			return "NO_AUTH";

		try {
			// newDeptNo가 0이면 '제외', 아니면 '이동'
			deptService.changeEmpDept(empNo, newDeptNo, login.getEmpNo(), "부서 이동");
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "FAIL";
		}
	}
}