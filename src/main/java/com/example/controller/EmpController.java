package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.domain.EmpSearchVO;
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

        if(!isAdmin(session)) {
        	return "error/NoAuthPage";
        }
    	
    	List<EmpVO> list = empService.selectEmpList();
        model.addAttribute("empList", list);
        model.addAttribute("menu", "emplist");

        return "emp/empList";
    }
    private boolean isAdmin(HttpSession session) {
    	LoginVO login = (LoginVO) session.getAttribute("login");
    	return login != null
    			&& login.getGradeNo() != null
    			&& "1".equals(login.getGradeNo()); //1 = 관리자
    	
    }
}