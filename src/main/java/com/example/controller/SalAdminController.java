package com.example.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
@RequestMapping("/sal/admin")
public class SalAdminController {

    @Autowired
    private SalService salService;

    @Autowired
    private EmpService empService;

    /** 관리자 판별 공통 메서드 */
    private boolean isAdmin(HttpSession session) {
        LoginVO login = (LoginVO) session.getAttribute("login");
        return (login != null && "1".equals(login.getGradeNo()));
    }

    /** 🔹 관리자용 급여 대장 */
    @GetMapping("/list")
    public String adminSalList(
            @RequestParam(name = "month", required = false) String month,
            @RequestParam(name = "sort",  defaultValue = "month") String sort,
            @RequestParam(name = "dir",   defaultValue = "asc")   String dir,
            HttpSession session,
            Model model) {

        if (!isAdmin(session)) {
            return "error/NoAuthPage";
        }

        Map<String, String> param = new HashMap<>();
        param.put("sort", sort);
        param.put("dir",  dir);

        if (month != null && !month.isBlank()) {
            param.put("month", month);
        }

        List<SalVO> salList = salService.getAdminSalList(param);

        model.addAttribute("salList", salList);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);
        model.addAttribute("searchMonth", month);
        model.addAttribute("menu", "saladmin");

        return "sal/adminList";
    }

    /** 🔹 관리자용 급여 상세 */
    @GetMapping("/detail")
    public String SalDetail(@RequestParam String empNo,
                            @RequestParam Integer monthAttno,
                            HttpSession session,
                            Model model) {

        if (!isAdmin(session)) {
            return "error/NoAuthPage";
        }

        SalVO sal = salService.getSalaryDetail(empNo, monthAttno);
        EmpVO emp = empService.getEmp(empNo);

        model.addAttribute("emp",  emp);
        model.addAttribute("sal",  sal);
        model.addAttribute("menu", "saladmin");

        return "sal/salDetail";
    }
}
