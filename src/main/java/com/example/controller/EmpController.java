package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.service.EmpService;

import jakarta.servlet.http.HttpSession;

@Controller
public class EmpController {

    @Autowired
    private EmpService empService;

    /**
     * 사원 목록 화면
     * - 등급 상관없이 "로그인만 되어 있으면" 조회 가능
     */
    @GetMapping("/emp/list")
    public String empList(HttpSession session, Model model) {

        System.out.println("📌 /emp/list 접근됨");

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) {
            System.out.println("❌ 로그인 정보 없음 → 로그인 페이지로 이동");
            return "redirect:/login/loginForm";   // 프로젝트 경로에 맞게 수정
        }

        boolean canModify = isAdmin(session);

        List<EmpVO> list = empService.selectEmpList();
        System.out.println("📌 조회된 사원 수 = " + (list == null ? "null" : list.size()));

        model.addAttribute("empList", list);
        model.addAttribute("menu", "emp");
        model.addAttribute("loginGradeNo", login.getGradeNo()); // 원하면 화면에서 사용
        model.addAttribute("canModify", canModify);             // 필요하면 사용

        return "emp/empList";
    }

    /**
     * 인사카드(사원 1명 상세)
     * - 모든 로그인 사용자 조회 가능
     * - 수정/삭제 버튼은 canModify로 제어
     */
    @GetMapping("/emp/card")
    public String empCard(@RequestParam("empNo") String empNo,
                          HttpSession session,
                          Model model) {

        System.out.println("📌 /emp/card 접근됨, empNo = " + empNo);

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) {
            System.out.println("❌ 로그인 정보 없음 → 권한 없음 페이지");
            return "error/NoAuthPage";
        }

        EmpVO emp = empService.selectEmpByEmpNo(empNo);
        System.out.println("📌 emp = " + emp);

        boolean canModify = isAdmin(session);

        model.addAttribute("emp", emp);
        model.addAttribute("canModify", canModify); // JSP에서 버튼 노출 조건으로 사용

        return "emp/empCard";
    }

    /**
     * 사원 정보 수정 처리 (예: 수정 폼에서 submit)
     * - 🔐 1,2등급만 허용
     */
    @PostMapping("/emp/update")
    @ResponseBody   // 🔹 AJAX 응답용
    public String updateEmp(EmpVO vo, HttpSession session) {

        System.out.println("📌 /emp/update 호출, vo = " + vo);

        // 권한 체크
        if (!isAdmin(session)) {
            System.out.println("❌ 수정 권한 없음");
            return "DENY";          // (원하면 JS에서 이 값 보고 alert 띄워도 됨)
        }

        int cnt = empService.updateEmp(vo);
        System.out.println("✔ 사원 수정 완료, cnt = " + cnt);

        // 성공/실패 여부에 따라 값 다르게 내려주고 싶으면 이렇게
        return (cnt > 0) ? "OK" : "FAIL";
    }

    /**
     * 사원 삭제 처리 (AJAX 호출을 가정)
     * - 🔐 1,2등급만 허용
     */
    @PostMapping("/emp/delete")
    @ResponseBody
    public String deleteEmp(@RequestParam("empNo") String empNo,
                            HttpSession session) {

        System.out.println("📌 /emp/delete 호출, empNo = " + empNo);

        if (!isAdmin(session)) {
            System.out.println("❌ 삭제 권한 없음");
            return "DENY";   // 프론트에서 이 값 보고 "권한 없음" 안내
        }

        empService.deleteEmp(empNo);
        System.out.println("✔ 사원 삭제 완료");

        return "OK";
    }

    /**
     * 관리자(1,2 등급) 여부 체크
     */
    private boolean isAdmin(HttpSession session) {
        LoginVO login = (LoginVO) session.getAttribute("login");

        System.out.println("📌 [isAdmin] login = " + login);

        if (login == null) {
            System.out.println("❌ [isAdmin] 로그인 정보 없음");
            return false;
        }

        System.out.println("📌 [isAdmin] gradeNo = " + login.getGradeNo());

        String grade = login.getGradeNo();
        return grade != null && ("1".equals(grade) || "2".equals(grade));
    }
}
