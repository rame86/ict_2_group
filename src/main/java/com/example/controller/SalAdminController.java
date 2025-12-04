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
@RequestMapping("/sal/admin")
public class SalAdminController {

    @Autowired
    private SalService salService;

    @Autowired
    private EmpService empService;

    /** 관리자 판별 공통 메서드 */
    private boolean isAdmin(HttpSession session) {
        LoginVO login = (LoginVO) session.getAttribute("login");
        return (login != null && "1".equals(login.getGradeNo()));
    }

    /** 🔹 관리자용 급여 대장 */
    @GetMapping("/list")
    public String adminSalList(
            @RequestParam(name = "month", required = false) String month,
            @RequestParam(name = "sort",  required = false, defaultValue = "date") String sort,
            @RequestParam(name = "dir",   required = false, defaultValue = "desc") String dir,
            HttpSession session,
            Model model) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) {
            return "redirect:/member/login";
        }

        // 관리자(gradeNo = "1")가 아니면 권한 없음
        if (!"1".equals(login.getGradeNo())) {
            return "error/NoAuthPage";
        }

        // MyBatis에 넘길 파라미터
        Map<String, String> param = new HashMap<>();
        param.put("month", month);   // 예: "2025-11"
        param.put("sort",  sort);    // empNo / name / dept / date
        param.put("dir",   dir);     // asc / desc

        List<SalVO> salList = salService.getAdminSalList(param);
        log.info("[adminSalList] month={}, sort={}, dir={}, size={}",
                 month, sort, dir, (salList != null ? salList.size() : 0));

        // ★ JSP에서 사용하는 이름과 맞추기
        model.addAttribute("salList", salList);

        // 월 검색 박스 값 유지
        model.addAttribute("searchMonth", month);

        model.addAttribute("menu", "saladmin");

        // 방금 보여준 JSP 파일 이름이 이거니까
        return "sal/adminList";   // 실제 JSP 경로가 sal/adminDetail.jsp 라면
    }


    /** 🔹 관리자용 급여 상세 */
    @GetMapping("/detail")
    public String SalDetail(@RequestParam String empNo,
                            @RequestParam Integer monthAttno,
                            HttpSession session,
                            Model model) {

        if (!isAdmin(session)) {
            return "error/NoAuthPage";
        }

        SalVO sal = salService.getSalaryDetail(empNo, monthAttno);
        EmpVO emp = empService.getEmp(empNo);

        model.addAttribute("emp",  emp);
        model.addAttribute("sal",  sal);
        model.addAttribute("menu", "saladmin");

        return "sal/salDetail";
    }
}
