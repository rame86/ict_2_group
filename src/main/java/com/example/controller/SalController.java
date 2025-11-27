package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.domain.SalVO;
import com.example.service.SalService;

@Controller
public class SalController {

    @Autowired
    private SalService salService;

    @GetMapping("/sal/list")
    public String salList(@RequestParam(required = false) Integer empNo, Model model) {

        // empNo가 없으면(=null이면) 사원목록으로 돌려보내기 등 처리
        if (empNo == null) {
            return "redirect:/emp/list";
        }

        // TODO: 급여 서비스 호출
        // List<SalVO> list = salService.getSalList(empNo);
        // model.addAttribute("salList", list);

        return "sal/salList";
    }
}