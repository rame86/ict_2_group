package com.example.controller;

import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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

import com.example.domain.DeptVO;
import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.domain.SalVO;
import com.example.service.DeptService;
import com.example.service.EmpService;
import com.example.service.SalService;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/sal/admin")
public class SalAdminController {

    @Autowired private SalService salService;
    @Autowired private EmpService empService;
    @Autowired private DeptService deptService;

    /* =========================================================
       ✅ 급여관리 관리자 접근 권한
       - gradeNo: 1(대표이사), 2(팀장급)
       - deptNo : 1001(대표이사), 2000(운영총괄), 2020(재무회계)
       ========================================================= */
    private boolean isSalaryAdmin(HttpSession session) {
        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return false;

        String gradeNo = login.getGradeNo() == null ? "" : login.getGradeNo().trim();
        String deptNo  = login.getDeptNo()  == null ? "" : login.getDeptNo().trim();

        boolean gradeOk = "1".equals(gradeNo) || "2".equals(gradeNo);
        boolean deptOk  = "1001".equals(deptNo) || "2000".equals(deptNo) || "2020".equals(deptNo);

        return gradeOk && deptOk;
    }

    /* =========================================================
       🔹 관리자용 급여 목록 (/sal/admin/list)
       ========================================================= */
    @GetMapping("/list")
    public String adminSalList(@RequestParam(required = false) String month,
                               @RequestParam(required = false) String deptNo,
                               @RequestParam(required = false, defaultValue = "false") boolean onlyOvertime,
                               @RequestParam(required = false, defaultValue = "false") boolean excludeRetired,
                               @RequestParam(required = false, defaultValue = "false") boolean excludeDeletePlanned,
                               @RequestParam(required = false, defaultValue = "date") String sort,
                               @RequestParam(required = false, defaultValue = "desc") String dir,
                               HttpSession session,
                               Model model) {

        if (!isSalaryAdmin(session)) return "error/NoAuthPage";

        Map<String, Object> param = new HashMap<>();
        param.put("month", month);
        param.put("deptNo", deptNo);
        param.put("onlyOvertime", onlyOvertime);
        param.put("excludeRetired", excludeRetired);
        param.put("excludeDeletePlanned", excludeDeletePlanned);
        param.put("sort", sort);
        param.put("dir", dir);

        List<SalVO> salList = salService.getAdminSalList(param);
        Map<String, Object> summary = salService.getAdminSalSummary(param);
        List<DeptVO> deptList = deptService.getDeptList();

        model.addAttribute("salList", salList);
        model.addAttribute("summary", summary);
        model.addAttribute("deptList", deptList);

        // 검색 조건 유지
        model.addAttribute("searchMonth", month);
        model.addAttribute("searchDeptNo", deptNo);
        model.addAttribute("onlyOvertime", onlyOvertime);
        model.addAttribute("excludeRetired", excludeRetired);
        model.addAttribute("excludeDeletePlanned", excludeDeletePlanned);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);

        String periodLabel = (month == null || month.isBlank()) ? "전체 기간 기준" : month + " 기준";
        model.addAttribute("periodLabel", periodLabel);

        model.addAttribute("menu", "saladmin");

        log.info("[adminSalList] month={}, deptNo={}, onlyOvertime={}, sort={}, dir={}, size={}",
                month, deptNo, onlyOvertime, sort, dir, (salList != null ? salList.size() : 0));

        return "sal/adminList";
    }

    /* =========================================================
       🔹 관리자용 급여 상세 (/sal/admin/detail)
       ========================================================= */
    @GetMapping("/detail")
    public String salDetailAdmin(@RequestParam String empNo,
                                 @RequestParam Integer monthAttno,
                                 HttpSession session,
                                 Model model) {

        if (!isSalaryAdmin(session)) return "error/NoAuthPage";

        SalVO sal = salService.getSalaryDetail(empNo, monthAttno);
        EmpVO emp = empService.getEmp(empNo);

        model.addAttribute("emp", emp);
        model.addAttribute("sal", sal);
        model.addAttribute("menu", "saladmin");

        return "sal/salDetail";
    }

    /* =========================================================
       🔹 관리자용 급여 목록 CSV 다운로드 (/sal/admin/export)
       ========================================================= */
    @GetMapping("/export")
    public void exportAdminSalary(@RequestParam(required = false) String month,
                                  @RequestParam(required = false) String deptNo,
                                  @RequestParam(required = false, defaultValue = "false") boolean onlyOvertime,
                                  @RequestParam(required = false, defaultValue = "false") boolean excludeRetired,
                                  @RequestParam(required = false, defaultValue = "false") boolean excludeDeletePlanned,
                                  HttpSession session,
                                  HttpServletResponse response) throws Exception {

        if (!isSalaryAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Map<String, Object> param = new HashMap<>();
        param.put("month", month);
        param.put("deptNo", deptNo);
        param.put("onlyOvertime", onlyOvertime);
        param.put("excludeRetired", excludeRetired);
        param.put("excludeDeletePlanned", excludeDeletePlanned);

        List<SalVO> salList = salService.getAdminSalList(param);

        String fileName = "salary_" + (month != null && !month.isEmpty() ? month : "all") + ".csv";
        String encoded = URLEncoder.encode(fileName, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encoded + "\"");

        try (PrintWriter writer = response.getWriter()) {
            writer.write('\uFEFF'); // ✅ BOM (엑셀 한글 깨짐 방지)
            writer.println("지급월,사번,이름,부서,기본급,초과근무수당,성과급,기타수당,공제합계,실지급액");

            for (SalVO s : salList) {
                writer.printf("%s,%s,%s,%s,%d,%d,%d,%d,%d,%d%n",
                        s.getYearMonthLabel(),
                        s.getEmpNo(),
                        s.getEmpName(),
                        s.getDeptName(),
                        n(s.getSalBase()),
                        n(s.getOvertimePay()),
                        n(s.getSalBonus()),
                        n(s.getSalPlus()),
                        n(s.getDeductTotal()),
                        n(s.getRealPay())
                );
            }
        }
    }

    private long n(Integer v) {
        return (v == null) ? 0L : v.longValue();
    }

    /* =========================================================
       ✅ 관리자 급여 정정
       GET  /sal/admin/edit?salNum=...
       POST /sal/admin/edit
       저장 후 /sal/admin/list 로 복귀
       ========================================================= */
    @GetMapping("/edit")
    public String editForm(@RequestParam int salNum,
                           HttpSession session,
                           Model model) {

        if (!isSalaryAdmin(session)) return "error/NoAuthPage";

        SalVO sal = salService.getSalDetailBySalNum(salNum);
        if (sal == null) {
            model.addAttribute("msg", "해당 급여 데이터가 없습니다.");
            return "error/NoDataPage";
        }

        model.addAttribute("sal", sal);
        model.addAttribute("menu", "saladmin");
        return "sal/adminEdit";
    }

    @PostMapping("/edit")
    public String editSubmit(@RequestParam int salNum,
                             @RequestParam int salBase,
                             @RequestParam int salBonus,
                             @RequestParam int salPlus,
                             @RequestParam int overtimePay,
                             @RequestParam int insurance,
                             @RequestParam int tax,
                             @RequestParam String editReason,
                             HttpSession session) {

        if (!isSalaryAdmin(session)) return "error/NoAuthPage";

        LoginVO login = (LoginVO) session.getAttribute("login");
        String editorEmpNo = login.getEmpNo();

        salService.editSalaryWithHistory(
            salNum, salBase, salBonus, salPlus, overtimePay, insurance, tax, editReason, editorEmpNo
        );

        return "redirect:/sal/admin/list";
    }
}
