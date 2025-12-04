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
import lombok.extern.slf4j.Slf4j;

@Slf4j
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

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) {
            return "redirect:/member/login";
        }

        // 관리자는 관리자 목록으로 리다이렉트
        if ("1".equals(login.getGradeNo())) {
            return "redirect:/sal/admin/list";
        }

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

    	log.info("[SalController-salDetail] empNo = {}, monthAttno = {}", empNo, monthAttno);
    	
        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) {
            return "redirect:/member/login";
        }

        boolean isAdmin = "1".equals(login.getGradeNo());
        boolean isMine  = login.getEmpNo().equals(empNo);

        if (!isAdmin && !isMine) {
            return "error/NoAuthPage";
        }

        SalVO sal = salService.getSalaryDetail(empNo, monthAttno);
        EmpVO emp = empService.getEmp(empNo);

        model.addAttribute("emp", emp);
        model.addAttribute("sal", sal);
        model.addAttribute("menu", isAdmin ? "saladmin" : "salemp");

        return "sal/salDetail";
    }

    /** 🔹 급여 생성 테스트용: /sal/salMake?month=2025-11 */
    @GetMapping("/salMake")
    public String makeSalary(@RequestParam("month") String month) {

        log.info("[SalController-makeSalary] month = {}", month);

        salService.createSalaryByMonth(month);

        return "redirect:/sal/admin/list?month=" + month;
    }
    

}
