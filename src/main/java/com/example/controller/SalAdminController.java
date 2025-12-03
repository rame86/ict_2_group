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
import java.util.List;
import java.util.HashMap;
import java.util.Map;

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
    public String adminSalList(
    		@RequestParam(name = "sort", defaultValue = "month") String sort,
            @RequestParam(name = "dir",  defaultValue = "asc")   String dir,
            HttpSession session,
            Model model) {

    	// 1) 관리자 권한 체크
        if (!isAdmin(session)) {
            return "error/NoAuthPage";
        }

        // 2) 관리자용 급여 대장 데이터 조회
        //    (조건 검색은 나중에 추가해도 되고 지금은 전체 조회)
        Map<String, String> param = new HashMap<>();
        param.put("sort", sort);   // month, empNo, name, dept
        param.put("dir", dir);     // asc, desc
        
     // 3) 서비스 호출 (정렬 반영된 관리자 급여 목록)
        List<SalVO> salList = salService.getAdminSalList(param);

        // 4) 화면으로 전달
        model.addAttribute("salList", salList);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);
        model.addAttribute("menu", "saladmin");

        return "sal/adminList";   // /WEB-INF/views/sal/adminList.jsp
    }

    /**
     * 🔹 관리자용 급여 상세 화면
     *  - 이미 있는 SalController의 /sal/detail 과 거의 같지만
     *    관리자 권한을 한 번 더 체크하는 버전
     */
    @GetMapping("/detail")
    public String SalDetail(@RequestParam String empNo,
                            @RequestParam Integer monthAttno,
                            HttpSession session,
                            Model model) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) {
            return "redirect:/member/login";
        }

        boolean isAdmin = "1".equals(login.getGradeNo());

        // 🔒 관리자 아니면 무조건 차단
        if (!isAdmin(session)) {
            return "error/NoAuthPage";
        }

        SalVO sal = salService.getSalaryDetail(empNo, monthAttno);
        EmpVO emp = empService.getEmp(empNo);

        model.addAttribute("emp", emp);
        model.addAttribute("sal", sal);
        model.addAttribute("menu", "saladmin");

        return "sal/salDetail";    // 또는 "sal/adminDetail" (관리자 전용 화면 쓰고 싶으면)
    }
}