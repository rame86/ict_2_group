package com.example.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.domain.SalEditVO;
import com.example.domain.SalVO;

import com.example.service.EmpService;
import com.example.service.SalService;


import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/sal")
public class SalController {

    @Autowired private EmpService empService;
    @Autowired private SalService salService;

    // ✅ 관리자 급여관리 허용 여부(대표이사/운영총괄/재무회계 팀장)
    private boolean isSalaryAdmin(LoginVO login) {
        if (login == null) return false;

        String gradeNo = login.getGradeNo() == null ? "" : login.getGradeNo().trim();
        String deptNo  = login.getDeptNo()  == null ? "" : login.getDeptNo().trim();

        boolean gradeOk = "1".equals(gradeNo) || "2".equals(gradeNo);
        boolean deptOk  = "1001".equals(deptNo) || "2000".equals(deptNo) || "2020".equals(deptNo);

        return gradeOk && deptOk;
    }

    /** 🔹 사원용: 본인 월별 급여 목록 */
    @GetMapping("/list")
    public String salList(HttpSession session, Model model) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return "redirect:/member/login";

        // ✅ 여기 수정: gradeNo=1만 보지 말고 관리자 조건 통일
        if (isSalaryAdmin(login)) {
            return "redirect:/sal/admin/list";
        }

        String empNo = login.getEmpNo();

        EmpVO emp = empService.getEmp(empNo);
        List<SalVO> salList = salService.getSalList(empNo);
        Map<String, Object> summary = salService.getEmpSalSummary(empNo);

        model.addAttribute("summary", summary);
        model.addAttribute("emp", emp);
        model.addAttribute("salList", salList);
        model.addAttribute("menu", "salemp");

        return "sal/salList";
    }

    /** 공통 상세: 관리자/사원 모두 사용 */
    @GetMapping("/detail")
    public String salDetail(@RequestParam String empNo,
                            @RequestParam Integer monthAttno,
                            HttpSession session,
                            Model model) {

        log.info("[SalController-salDetail] empNo = {}, monthAttno = {}", empNo, monthAttno);

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return "redirect:/member/login";

        // ✅ 여기 수정: 관리자 판별도 통일
        boolean isAdmin = isSalaryAdmin(login);
        model.addAttribute("isAdmin", isAdmin);

        boolean isMine = login.getEmpNo().equals(empNo);
        if (!isAdmin && !isMine) return "error/NoAuthPage";

        SalVO sal = salService.getSalaryDetail(empNo, monthAttno);
        if (sal == null) {
            model.addAttribute("msg", "해당 월의 급여 정보가 없습니다.");
            return "error/NoDataPage";
        }

        Integer salNum = sal.getSalNum();
        List<SalEditVO> edits = salService.getEditsBySalNum(salNum);

        EmpVO emp = empService.getEmp(empNo);

        model.addAttribute("sal", sal);
        model.addAttribute("edits", edits);
        model.addAttribute("emp", emp);
        model.addAttribute("menu", isAdmin ? "saladmin" : "salemp");

        return "sal/salDetail";
    }

    /** 🔹 급여 생성 테스트용 */
    @GetMapping("/salMake")
    public String makeSalary(@RequestParam("month") String month) {
        salService.createSalaryByMonth(month);
        return "redirect:/sal/admin/list?month=" + month;
    }

    @GetMapping("/create")
    public String createSalary(@RequestParam("month") String month) {
        salService.createSalaryByMonth(month);
        return "redirect:/sal/admin/list?month=" + month;
    }

    /** ✅ 공용 진입 URL: /sal */
    @GetMapping({"", "/"})
    public String salaryEntry(HttpSession session) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return "redirect:/member/login";

        if (isSalaryAdmin(login)) return "redirect:/sal/admin/list";
        return "redirect:/sal/list";
    }
}