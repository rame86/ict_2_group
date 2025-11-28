package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.domain.EmpVO;
import com.example.domain.SalVO;
import com.example.service.EmpService;
import com.example.service.SalService;

@Controller
@RequestMapping("/sal")
public class SalController {

    @Autowired
    private EmpService empService;

    @Autowired
    private SalService salService;

    /** 급여 대장: 사원 한 명의 월별 급여 목록 */
    @GetMapping("/list")
    public String salList(@RequestParam String empNo, Model model) {

        System.out.println("[SalController] /sal/list empNo = " + empNo);

        EmpVO emp = empService.getEmp(empNo);          // 사원 기본 정보
        List<SalVO> salList = salService.getSalList(empNo);  // 급여 목록

        System.out.println("[SalController] salList size = "
                + (salList == null ? "null" : salList.size()));

        model.addAttribute("emp", emp);
        model.addAttribute("salList", salList);

        // 사이드바 메뉴 active 용
        model.addAttribute("menu", "salemp");

        return "sal/salList";
    }

    /** 급여 명세서: 특정 월 상세 */
    @GetMapping("/detail")
    public String salDetail(@RequestParam String empNo,
                            @RequestParam Integer monthAttno,
                            Model model) {

        SalVO sal = salService.getSalaryDetail(empNo, monthAttno);
        EmpVO emp = empService.getEmp(empNo);

        model.addAttribute("emp", emp);
        model.addAttribute("sal", sal);
        model.addAttribute("menu", "salemp");

        return "sal/salDetail";
    }
}