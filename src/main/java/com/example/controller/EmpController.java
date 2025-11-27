package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.domain.EmpSearchVO;
import com.example.domain.EmpVO;
import com.example.service.EmpService;

@Controller
public class EmpController {

    @Autowired
    private EmpService empService;

    @GetMapping("/emp/list")
    public String empList(EmpSearchVO search, Model model) {

        List<EmpVO> list = empService.getEmpList(search);
        model.addAttribute("empList", list);

        return "emp/empList";
    }
}