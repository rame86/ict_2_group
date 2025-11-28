package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.domain.EmpVO;
import com.example.domain.SalSummaryVO;
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

    // 급여대장 리스트
    @GetMapping("/list")
    public String salList(@RequestParam String empNo, Model model) {

        EmpVO emp = empService.getEmp(empNo);
        List<SalSummaryVO> summaryList = salService.getSalarySummaryList(empNo);

        model.addAttribute("emp", emp);
        model.addAttribute("summaryList", summaryList);

        return "sal/salList";   // 아래 JSP
    }

    // 월 클릭 → 급여 명세서
    @GetMapping("/detail")
    public String salDetail(@RequestParam String empNo,
                            @RequestParam Integer monthAttno,
                            Model model) {

        EmpVO emp = empService.getEmp(empNo);
        SalVO sal = salService.getSalaryDetail(empNo, monthAttno);

        model.addAttribute("emp", emp);
        model.addAttribute("sal", sal);

        return "sal/salDetail"; // 명세서 JSP
    }
}
