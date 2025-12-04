package com.example.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.domain.LoginVO;
import com.example.service.MonthAttendService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/monthAttend")
public class MonthAttendController {

    @Autowired
    private MonthAttendService monthAttendService;

    @GetMapping("/make")
    public String makeMonth(HttpSession session) {

        log.info("[MonthAttendController - make 요청 받음]");

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null || !"1".equals(login.getGradeNo())) {
            return "error/NoAuthPage";
        }

        monthAttendService.createMonthAttendForLastMonth();

        // 작업 끝나면 원래 근태 화면으로
        return "redirect:/attend/attend";
        // ↑ 원본 AttendController가 사용하는 URL에 맞춤
    }
}

