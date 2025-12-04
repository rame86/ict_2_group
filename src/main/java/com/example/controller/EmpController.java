package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.service.EmpService;

import jakarta.servlet.http.HttpSession;

@Controller
public class EmpController {

    @Autowired
    private EmpService empService;

    @GetMapping("/emp/list")
    public String empList(HttpSession session, Model model) {

        System.out.println("📌 /emp/list 접근됨");

        if (!isAdmin(session)) {
            System.out.println("❌ 관리자 아님 → 차단됨");
            return "error/NoAuthPage";
        } else {
            System.out.println("✔ 관리자 확인됨");
        }

        List<EmpVO> list = empService.selectEmpList();
        System.out.println("📌 조회된 사원 수 = " + (list == null ? "null" : list.size()));

        model.addAttribute("empList", list);
        model.addAttribute("menu", "emp");

        return "emp/empList";
    }

    private boolean isAdmin(HttpSession session) {
        LoginVO login = (LoginVO) session.getAttribute("login");

        System.out.println("📌 [isAdmin] login = " + login);

        if (login == null) {
            System.out.println("❌ [isAdmin] 로그인 정보 없음");
            return false;
        }

        System.out.println("📌 [isAdmin] gradeNo = " + login.getGradeNo());

        // 1, 2를 관리자라고 했으니까 둘 다 허용
        return login.getGradeNo() != null
                && (login.getGradeNo().equals("1") || login.getGradeNo().equals("2"));
    }
}
