package com.example.controller;

import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import com.example.domain.SalEditVO;
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
       - gradeNo: 1~3 (최고/상급/하급관리자)
       - deptNo : 1001(대표이사), 2000(운영총괄), 2020(재무회계)
       ========================================================= */
    private boolean isSalaryAdmin(HttpSession session) {
        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return false;

        String gradeNo = safeTrim(login.getGradeNo());
        String deptNo  = safeTrim(login.getDeptNo());

        // ✅ 등급: 1~3 허용
        boolean gradeOk = "1".equals(gradeNo) || "2".equals(gradeNo) || "3".equals(gradeNo);

        // ✅ 부서: 급여 접근 부서만 허용
        boolean deptOk  = "1001".equals(deptNo) || "2000".equals(deptNo) || "2020".equals(deptNo);

        return gradeOk && deptOk;
    }

    /* =========================================================
       ✅ (안정화) 관리자 목록/요약/CSV 공용 파라미터 빌더
       - 입력값을 "규칙대로 정규화"해서 Mapper로 안전하게 전달
       ========================================================= */
    private Map<String, Object> buildAdminSearchParam(String month,
                                                      String deptNo,
                                                      boolean onlyOvertime,
                                                      boolean excludeRetired,
                                                      boolean excludeDeletePlanned,
                                                      String sort,
                                                      String dir) {

        Map<String, Object> param = new HashMap<>();

        // 1) month: null/blank면 null로 통일 (JSP에서 '전체 기간 기준' 처리하기 쉬움)
        month = safeTrim(month);
        param.put("month", (month.isEmpty() ? null : month));

        // 2) deptNo: null/blank면 null로 통일
        deptNo = safeTrim(deptNo);
        param.put("deptNo", (deptNo.isEmpty() ? null : deptNo));

        // 3) 체크박스류는 그대로 boolean 전달
        param.put("onlyOvertime", onlyOvertime);
        param.put("excludeRetired", excludeRetired);

        // 4) (선택) 삭제예정 제외 옵션
        param.put("excludeDeletePlanned", excludeDeletePlanned);

        // 5) 정렬(sort) 화이트리스트
        sort = safeTrim(sort);
        Set<String> allowedSort = Set.of("empNo", "name", "dept", "date");
        if (!allowedSort.contains(sort)) sort = "date";
        param.put("sort", sort);

        // 6) 방향(dir) 화이트리스트 (✅ SQL 인젝션 방지)
        dir = safeTrim(dir).toLowerCase();
        if (!("asc".equals(dir) || "desc".equals(dir))) dir = "desc";
        param.put("dir", dir);

        return param;
    }

    private String safeTrim(Object v) {
        return (v == null) ? "" : String.valueOf(v).trim();
    }

    /* =========================================================
       🔹 관리자용 급여 목록 (/sal/admin/list)
       - 리스트 + 상단 요약(summary) + 부서필터 목록
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

        // ✅ 권한 체크
        if (!isSalaryAdmin(session)) return "error/NoAuthPage";

        // ✅ 검색 파라미터 정규화(안정화)
        Map<String, Object> param = buildAdminSearchParam(
                month, deptNo, onlyOvertime, excludeRetired, excludeDeletePlanned, sort, dir
        );

        // ✅ 조회
        List<SalVO> salList = salService.getAdminSalList(param);
        Map<String, Object> summary = salService.getAdminSalSummary(param);
        List<DeptVO> deptList = deptService.getDeptList();

        // ✅ 화면 데이터
        model.addAttribute("salList", salList);
        model.addAttribute("summary", summary);
        model.addAttribute("deptList", deptList);

        // ✅ 검색 조건 유지 (JSP에서 form value 유지용)
        model.addAttribute("searchMonth", param.get("month"));
        model.addAttribute("searchDeptNo", param.get("deptNo"));
        model.addAttribute("onlyOvertime", param.get("onlyOvertime"));
        model.addAttribute("excludeRetired", param.get("excludeRetired"));
        model.addAttribute("excludeDeletePlanned", param.get("excludeDeletePlanned"));
        model.addAttribute("sort", param.get("sort"));
        model.addAttribute("dir", param.get("dir"));

        // ✅ “전체 기간 기준” 라벨
        String m = (String) param.get("month");
        String periodLabel = (m == null) ? "전체 기간 기준" : (m + " 기준");
        model.addAttribute("periodLabel", periodLabel);

        model.addAttribute("menu", "saladmin");

        log.info("[adminSalList] month={}, deptNo={}, onlyOvertime={}, excludeRetired={}, sort={}, dir={}, size={}",
                param.get("month"), param.get("deptNo"), onlyOvertime, excludeRetired, param.get("sort"), param.get("dir"),
                (salList != null ? salList.size() : 0));

        return "sal/adminList";
    }

    /* =========================================================
       🔹 관리자용 급여 상세 (/sal/admin/detail)
       - 기존 상세 JSP 재사용(sal/salDetail)
       - ✅ 관리자일 때만 정정 이력(SAL_EDIT) 조회해서 내려줌
       ========================================================= */
    @GetMapping("/detail")
    public String salDetailAdmin(@RequestParam String empNo,
                                 @RequestParam Integer monthAttno,
                                 HttpSession session,
                                 Model model) {

        // ✅ 권한 체크
        if (!isSalaryAdmin(session)) return "error/NoAuthPage";

        // ✅ 급여/사원 조회
        SalVO sal = salService.getSalaryDetail(empNo, monthAttno);
        EmpVO emp = empService.getEmp(empNo);

        // ✅ 관리자 상세에서만 "정정 이력" 조회
        List<SalEditVO> edits = java.util.Collections.emptyList();
        if (sal != null && sal.getSalNum() != null) {
            edits = salService.getEditsBySalNum(sal.getSalNum());
        }

        // ✅ JSP에서 쓰는 이름으로 통일해서 내려주기
        model.addAttribute("emp", emp);
        model.addAttribute("sal", sal);

        model.addAttribute("isAdmin", true);
        model.addAttribute("edits", edits);

        model.addAttribute("menu", "saladmin");

        return "sal/salDetail";
    }

    /* =========================================================
       🔹 관리자용 급여 목록 CSV 다운로드 (/sal/admin/export)
       - list와 동일한 검색조건으로 출력되게 "같은 param builder" 사용
       - ✅ BOM 포함(엑셀 한글 깨짐 방지)
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

        Map<String, Object> param = buildAdminSearchParam(
                month, deptNo, onlyOvertime, excludeRetired, excludeDeletePlanned, "date", "desc"
        );

        List<SalVO> salList = salService.getAdminSalList(param);

        String m = (String) param.get("month");
        String fileName = "salary_" + (m != null ? m : "all") + ".csv";
        String encoded = URLEncoder.encode(fileName, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encoded + "\"");

        try (PrintWriter writer = response.getWriter()) {
            writer.write('\uFEFF'); // ✅ BOM
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
       - GET  /sal/admin/edit?salNum=...
       - POST /sal/admin/edit
       - 저장 후 /sal/admin/list 로 복귀
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
        if (login == null) return "error/NoAuthPage";

        String editorEmpNo = login.getEmpNo();

        salService.editSalaryWithHistory(
                salNum, salBase, salBonus, salPlus, overtimePay, insurance, tax, editReason, editorEmpNo
        );

        return "redirect:/sal/admin/list";
    }
}
