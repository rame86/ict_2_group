package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.domain.EmpVO;
import com.example.domain.SalVO;
import com.example.service.EmpService;
import com.example.service.SalService;

@Controller
public class SalController {

    @Autowired
    private EmpService empService;

    @Autowired
    private SalService salService;

    @GetMapping("/sal/list")
    public String salList(@RequestParam(required = false) Integer empNo,
                          Model model) {

        // empNo 없이 직접 URL로 들어온 경우 → 사원 목록으로 보냄
        if (empNo == null) {
            return "redirect:/emp/list";
        }

        // 1. 사원 정보 1건
        EmpVO emp = empService.getEmp(empNo);   // ← 이 메서드는 EmpService에 새로 추가해야 함

        // 2. 해당 사원의 급여 리스트
        List<SalVO> salList = salService.getSalList(empNo);

        model.addAttribute("emp", emp);
        model.addAttribute("salList", salList);

        // /WEB-INF/views/sal/salList.jsp
        return "sal/salList";
    }
}