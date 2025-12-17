package com.example.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.domain.MemberSaveVO;
import com.example.domain.MemberVO;
import com.example.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MemberController {

	@Autowired
	private MemberService memberService;

	// step 변수에 자동으로 요청값이 들어가고 추적하여 열어줌
	// @PathVariable
	@GetMapping("{step}")
	public void asdf(@PathVariable String step) {
		log.info("요청받은 step : " + step);
	}

//	@GetMapping("/")
//	public String index(HttpSession session) {
//		Object login = session.getAttribute("login");
//		if (login == null) {
//			return "/member/login";
//		}
//		return "index";
//	}
 
	@GetMapping("/member/empNoCheck")
	@ResponseBody
	public String empNoCheck(String empNo, String empName, EmpVO vo, HttpSession session) {
		log.info("MemberControll empNoCheck 요청받음. empNo :" + empNo);
		vo.setEmpNo(empNo);
		vo.setEmpName(empName);

		// 세션에서 넘겨받은 카카오id가 있는지 체크
		String kakaoId = (String) session.getAttribute("kakaoId");
		if (kakaoId != null) {
			vo.setKakaoId(kakaoId);
		}

		// 아이디 와 이름 확인 시도
		String empCheckResult = memberService.empNoCheck(vo);

		if (empCheckResult != null) {
			log.info("MemberControll empNoCheck 결과값 :" + empCheckResult);
		}
		return empCheckResult;

	}

	@PostMapping("loginCheck")
    public String loginCheck(MemberVO vo, HttpSession session) {

        log.info("[MemberController - loginCheck] 요청받음 :" + vo.toString());

        LoginVO check = memberService.loginCheck(vo);

        if (check != null) {           
            session.setAttribute("login", check);
            
            log.info("로그인 성공: " + check.getEmpName());
                       
            return "redirect:/"; 
            
        } else {
            log.info("로그인 실패");
            return "member/login"; // 실패 시 다시 로그인 페이지
        }
    }
	// 로그인 페이지 이동
    @GetMapping("/member/login")
    public String memberLoginPage() {
        return "member/login";
    }
    
	@GetMapping("/login")
	public String loginPage() {
		return "member/login";
	}

	@GetMapping("/member/register")
	public String register() {
		return "/member/register";
	}

	@Transactional
	@PostMapping("member/memberSave")
	public String memberSave(MemberSaveVO vo, HttpSession session) {
		String kakaoId = (String) session.getAttribute("kakaoId");
		vo.setKakaoId(kakaoId);

		log.info(vo.toString());

		Integer result = memberService.memberSave(vo);

		if (result != null) {
			return "redirect:/";

		} else {
			log.info("회원가입 실패");
			return "redirect:/member/register.jsp";
		}
	}

}
