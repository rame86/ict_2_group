package com.example.controller;

import java.util.List;

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

    /**
     * 🔹 로그인한 사용자가 관리자(gradeNo == "1")인지 확인하는 메서드
     */
    private boolean isAdmin(HttpSession session) {
        LoginVO login = (LoginVO) session.getAttribute("login");

        // 로그인 안 했거나, 등급 정보가 없으면 관리자 아님
        if (login == null || login.getGradeNo() == null) {
            return false;
        }

        // gradeNo는 String 이라 "1" 과 비교해야 함
        return "1".equals(login.getGradeNo());
    }

    /**
     * 🔹 관리자용 급여 대장 화면
     *  - 일단은 화면 접근 권한만 체크하고, 리스트는 나중에 붙여도 됨
     */
    @GetMapping("/list")
    public String adminSalList(HttpSession session, Model model) {

    	// 1) 관리자 권한 체크
        if (!isAdmin(session)) {
            return "error/NoAuthPage";
        }

        // 2) 관리자용 급여 대장 데이터 조회
        //    (조건 검색은 나중에 추가해도 되고 지금은 전체 조회)
        List<SalVO> salList = salService.getAdminSalList();

        model.addAttribute("salList", salList);
        model.addAttribute("menu", "saladmin");

        return "sal/adminList";   // /WEB-INF/views/sal/adminList.jsp
    }

    /**
     * 🔹 관리자용 급여 상세 화면
     *  - 이미 있는 SalController의 /sal/detail 과 거의 같지만
     *    관리자 권한을 한 번 더 체크하는 버전
     */
    @GetMapping("/detail")
    public String adminSalDetail(@RequestParam String empNo,
                                 @RequestParam Integer monthAttno,
                                 HttpSession session,
                                 Model model) {

        // 1) 관리자 권한 체크
        if (!isAdmin(session)) {
            return "error/NoAuthPage";
        }

        // 2) 급여 상세 + 사원 정보 조회 (기존 서비스 재사용)
        SalVO sal = salService.getSalaryDetail(empNo, monthAttno);
        EmpVO emp = empService.getEmp(empNo);

        model.addAttribute("emp", emp);
        model.addAttribute("sal", sal);
        model.addAttribute("menu", "saladmin");

        return "sal/adminDetail";   // /WEB-INF/views/sal/adminDetail.jsp
    }
}