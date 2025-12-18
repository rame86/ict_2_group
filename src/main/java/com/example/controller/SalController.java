package com.example.controller;

import java.util.Collections;
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

    /* =========================================================
       ✅ 급여관리 관리자 허용 여부
       - gradeNo: 1(대표이사), 2(팀장급)
       - deptNo : 1001(대표이사), 2000(운영총괄), 2020(재무회계)
       ========================================================= */
    private boolean isSalaryAdmin(LoginVO login) {
        if (login == null) return false;

        String gradeNo = (login.getGradeNo() == null) ? "" : login.getGradeNo().trim();
        String deptNo  = (login.getDeptNo()  == null) ? "" : login.getDeptNo().trim();

        boolean gradeOk = "1".equals(gradeNo) || "2".equals(gradeNo);
        boolean deptOk  = "1001".equals(deptNo) || "2000".equals(deptNo) || "2020".equals(deptNo);

        return gradeOk && deptOk;
    }

    /* =========================================================
       🔹 사원용: 본인 월별 급여 목록
       - 관리자면 /sal/admin/list 로 리다이렉트
       ========================================================= */
    @GetMapping("/list")
    public String salList(HttpSession session, Model model) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return "redirect:/member/login";

        // ✅ 관리자면 관리자 화면으로
        if (isSalaryAdmin(login)) {
            return "redirect:/sal/admin/list";
        }

        // ✅ 사원은 본인 empNo만 사용 (파라미터 없음)
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

    /* =========================================================
       🔹 공통 상세: 관리자/사원 모두 사용 (salDetail.jsp 재사용)
       ✅ 안정화 핵심
       - 사원은 empNo 파라미터를 신뢰하지 않고 세션 empNo로 강제
       - 정정 이력은 관리자만 조회
       ========================================================= */
    @GetMapping("/detail")
    public String salDetail(@RequestParam(required = false) String empNo,
                            @RequestParam Integer monthAttno,
                            HttpSession session,
                            Model model) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return "redirect:/member/login";

        boolean isAdmin = isSalaryAdmin(login);
        model.addAttribute("isAdmin", isAdmin);

        // ✅ 사원: empNo는 세션 기준으로 강제
        // ✅ 관리자: empNo 파라미터가 반드시 있어야 함(없으면 NoData)
        String targetEmpNo;
        if (isAdmin) {
            if (empNo == null || empNo.trim().isEmpty()) {
                model.addAttribute("msg", "잘못된 요청입니다. (empNo 누락)");
                return "error/NoDataPage";
            }
            targetEmpNo = empNo.trim();
        } else {
            targetEmpNo = login.getEmpNo();
        }

        log.info("[SalController-salDetail] isAdmin={}, targetEmpNo={}, monthAttno={}",
                isAdmin, targetEmpNo, monthAttno);

        // ✅ 급여 단건 조회 (사번 + 월근태번호)
        SalVO sal = salService.getSalaryDetail(targetEmpNo, monthAttno);
        if (sal == null) {
            model.addAttribute("msg", "해당 월의 급여 정보가 없습니다.");
            return "error/NoDataPage";
        }

        // ✅ 사원 정보
        EmpVO emp = empService.getEmp(targetEmpNo);

        // ✅ 관리자 전용: 정정 이력 조회 (사원은 조회 X)
        List<SalEditVO> edits = Collections.emptyList();
        if (isAdmin) {
            Integer salNum = sal.getSalNum();
            if (salNum != null && salNum > 0) {
                edits = salService.getEditsBySalNum(salNum);
            }
        }

        model.addAttribute("sal", sal);
        model.addAttribute("edits", edits); // JSP는 isAdmin && not empty edits 로 출력
        model.addAttribute("emp", emp);
        model.addAttribute("menu", isAdmin ? "saladmin" : "salemp");

        return "sal/salDetail";
    }

    /* =========================================================
       🔹 급여 생성(테스트/배치용)
       ✅ 안정화: 관리자만 실행 가능
       ========================================================= */
    @GetMapping("/salMake")
    public String makeSalary(@RequestParam("month") String month,
                             HttpSession session) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return "redirect:/member/login";
        if (!isSalaryAdmin(login)) return "error/NoAuthPage";

        salService.createSalaryByMonth(month);
        return "redirect:/sal/admin/list?month=" + month;
    }

    @GetMapping("/create")
    public String createSalary(@RequestParam("month") String month,
                               HttpSession session) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return "redirect:/member/login";
        if (!isSalaryAdmin(login)) return "error/NoAuthPage";

        salService.createSalaryByMonth(month);
        return "redirect:/sal/admin/list?month=" + month;
    }

    /* =========================================================
       ✅ 공용 진입 URL: /sal
       - 관리자면 관리자 목록
       - 사원이면 내 목록
       ========================================================= */
    @GetMapping({"", "/"})
    public String salaryEntry(HttpSession session) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return "redirect:/member/login";

        if (isSalaryAdmin(login)) return "redirect:/sal/admin/list";
        return "redirect:/sal/list";
    }
}
