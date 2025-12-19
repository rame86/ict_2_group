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

		LoginVO login = (LoginVO) session.getAttribute("login");

		// 권한 기본값 false
		boolean canCreateAuth = false; // 부서생성, 부서장임명 (등급2이상 + 2000/2010부서)
		boolean canMoveAuth = false; // 부서원 이동 (등급2이상)
		boolean canViewAuth = false; // 상세정보 확인 (등급3이상)

		if (login != null) {
			m.addAttribute("myDeptNo", login.getDeptNo());

			int deptNo = Integer.parseInt(login.getDeptNo());
			int gradeNo = Integer.parseInt(login.getGradeNo());

			log.info("[DeptController] 접속자 부서: " + deptNo + ", 등급: " + gradeNo);

			// 1. 부서 생성 및 부서장 임명 권한: 권한등급 2이상 AND (부서 2000 OR 2010)
			if (gradeNo <= 2 && (deptNo == 2000 || deptNo == 2010)) {
				canCreateAuth = true;
			}

			// 2. 부서원 이동 권한: 권한등급 2이상 (부서 무관)
			if (gradeNo <= 2) {
				canMoveAuth = true;
			}

			// 3. 부서원 정보 확인 권한: 권한등급 3이상 (부서 무관)
			if (gradeNo <= 3) {
				canViewAuth = true;
			}
		}

		// JSP로 권한 플래그 전달
		m.addAttribute("canCreateAuth", canCreateAuth);
		m.addAttribute("canMoveAuth", canMoveAuth);
		m.addAttribute("canViewAuth", canViewAuth);

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
	public String createDept(DeptVO vo, HttpSession session) {
		// 서버 측 권한 검증
		LoginVO login = (LoginVO) session.getAttribute("login");
		if (login == null)
			return "FAIL";

		int deptNo = Integer.parseInt(login.getDeptNo());
		int gradeNo = Integer.parseInt(login.getGradeNo());

		// 권한등급 2이상 + 특정부서(2000, 2010)만 가능
		if (!(gradeNo <= 2 && (deptNo == 2000 || deptNo == 2010))) {
			return "NO_AUTH";
		}

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
	public String deleteDept(@RequestParam("deptNo") int deptNo, HttpSession session) {
		// 서버 측 권한 검증
		LoginVO login = (LoginVO) session.getAttribute("login");
		if (login == null)
			return "FAIL";

		int userDeptNo = Integer.parseInt(login.getDeptNo());
		int gradeNo = Integer.parseInt(login.getGradeNo());

		// 권한등급 2이상 + 특정부서(2000, 2010)만 가능
		if (!(gradeNo <= 2 && (userDeptNo == 2000 || userDeptNo == 2010))) {
			return "NO_AUTH";
		}

		// 핵심 부서 보호 로직
		if (deptNo == 1001 || deptNo == 2000 || deptNo == 2010 || deptNo == 3000 || deptNo == 4000) {
			return "PROTECTED";
		}
		// 전체 부서 목록에서 해당 부서의 매니저가 있는지 확인
		List<DeptVO> allDepts = deptService.getOrgChartData();
		for (DeptVO d : allDepts) {
			if (Integer.parseInt(d.getDeptNo()) == deptNo) {
				if (d.getManagerEmpNo() != null && !d.getManagerEmpNo().equals("0") && !d.getManagerEmpNo().isEmpty()) {
					return "HAS_MANAGER"; // 부서장이 있으면 삭제 거부
				}
				break;
			}
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
	public String updateDept(DeptVO vo, HttpSession session) {
		// 서버 측 권한 검증
		LoginVO login = (LoginVO) session.getAttribute("login");
		if (login == null)
			return "FAIL";

		int userDeptNo = Integer.parseInt(login.getDeptNo());
		int gradeNo = Integer.parseInt(login.getGradeNo());

		// 권한등급 2이상 + 특정부서(2000, 2010)만 가능
		if (!(gradeNo <= 2 && (userDeptNo == 2000 || userDeptNo == 2010))) {
			return "NO_AUTH";
		}

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
		if (login == null)
			return "FAIL";

		int gradeNo = Integer.parseInt(login.getGradeNo());

		// 권한 체크: 권한등급 2이상만 가능 (부서 무관)
		if (gradeNo > 2) {
			return "NO_AUTH";
		}

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