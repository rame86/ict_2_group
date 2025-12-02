package com.example.controller;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.domain.SalVO;
import com.example.service.EmpService;
import com.example.service.SalService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/sal")
public class SalController {

	@Autowired
	private EmpService empService;

	@Autowired
	private SalService salService;

	/** 🔹 사원용: 본인 월별 급여 목록 */
	@GetMapping("/list")
	public String salList(HttpSession session, Model model) {

		// 1) 로그인 체크
		LoginVO login = (LoginVO) session.getAttribute("login");
		if (login == null) {
			return "redirect:/member/login";
		}

		// 2) 관리자면 바로 관리자 급여대장으로 리다이렉트
		if ("1".equals(login.getGradeNo())) {
			return "redirect:/sal/admin/list";
		}

		// 3) 사원이라면 본인 급여 목록
		String empNo = login.getEmpNo();

		EmpVO emp = empService.getEmp(empNo);
		List<SalVO> salList = salService.getSalList(empNo);

		model.addAttribute("emp", emp);
		model.addAttribute("salList", salList);
		model.addAttribute("menu", "salemp");

		return "sal/salList";
	}

	/** 공통 상세: 관리자/사원 모두 사용 */
	@GetMapping("/detail")
	public String salDetail(@RequestParam String empNo,
			@RequestParam Integer monthAttno,
			HttpSession session,
			Model model) {

		// 1) 로그인 체크
		LoginVO login = (LoginVO) session.getAttribute("login");
		if (login == null) {
			return "redirect:/member/login";
		}

		// 2) 권한 판별: 관리자 or 본인?
		boolean isAdmin = "1".equals(login.getGradeNo());    // 관리자
		boolean isMine  = login.getEmpNo().equals(empNo);    // 내 사번과 같은지

		// 🔒 관리자도 아니고 본인 것도 아니면 차단
		if (!isAdmin && !isMine) {
			return "error/NoAuthPage";
		}

		// 3) 통과한 경우에만 급여 정보 조회
		SalVO sal = salService.getSalaryDetail(empNo, monthAttno);
		EmpVO emp = empService.getEmp(empNo);

		model.addAttribute("emp", emp);
		model.addAttribute("sal", sal);

		// 관리자/사원에 따라 메뉴 표시 다르게 하고 싶으면:
		model.addAttribute("menu", isAdmin ? "saladmin" : "salemp");

		return "sal/salDetail";   // 공통 상세 화면 사용
	}




}