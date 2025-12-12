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

   
    
    /** 관리자 여부 */
    private boolean isAdmin(HttpSession session) {
        LoginVO login = (LoginVO) session.getAttribute("login");
        return (login != null && "1".equals(login.getGradeNo()));
    }

    /* =========================================================
       🔹 관리자용 급여 목록 (/sal/admin/list)
       - 월/부서/초과근무 필터 + 정렬 + 요약 카드
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
    	
    	

        if (!isAdmin(session)) {
            return "error/NoAuthPage";
        }

        // MyBatis 파라미터
        Map<String, Object> param = new HashMap<>();
        param.put("month", month);                 // "2025-11"
        param.put("deptNo", deptNo);               // 부서번호
        param.put("onlyOvertime", onlyOvertime);   // 초과근무자만
        param.put("excludeRetired", excludeRetired);
        param.put("excludeDeletePlanned", excludeDeletePlanned);

        param.put("sort", sort);                   // empNo / name / dept / date
        param.put("dir", dir);                     // asc / desc

        // 목록
        List<SalVO> salList = salService.getAdminSalList(param);

        // 요약(총/평균/인원)
        Map<String, Object> summary = salService.getAdminSalSummary(param);
        model.addAttribute("summary", summary);
        

        // 부서 목록(필터용)
        List<DeptVO> deptList = deptService.getDeptList();

        log.info("[adminSalList] month={}, deptNo={}, onlyOvertime={}, sort={}, dir={}, size={}",
                month, deptNo, onlyOvertime, sort, dir, (salList != null ? salList.size() : 0));

        // 모델 세팅
        model.addAttribute("salList", salList);
        model.addAttribute("summary", summary);
        model.addAttribute("deptList", deptList);
        

        // 검색 조건 유지용
        model.addAttribute("searchMonth", month);
        String periodLabel = (month == null || month.isBlank()) ? "전체 기간 기준" : month + " 기준";
        model.addAttribute("periodLabel", periodLabel);

        model.addAttribute("searchDeptNo", deptNo);
        model.addAttribute("onlyOvertime", onlyOvertime);
        model.addAttribute("excludeRetired", excludeRetired);
        model.addAttribute("excludeDeletePlanned", excludeDeletePlanned);

        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);

        model.addAttribute("menu", "saladmin");
        
        log.info("[summary] {}", summary);

        // ✅ 카드 있는 JSP로 고정 (너희 프로젝트 파일명에 맞게)
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

        if (!isAdmin(session)) {
            return "error/NoAuthPage";
        }

        SalVO sal = salService.getSalaryDetail(empNo, monthAttno);
        EmpVO emp = empService.getEmp(empNo);

        model.addAttribute("emp", emp);
        model.addAttribute("sal", sal);
        model.addAttribute("menu", "saladmin");

        return "sal/salDetail";
    }

    /* =========================================================
       🔹 관리자용 급여 목록 엑셀(CSV) 다운로드
       - /sal/admin/export?month=2025-11&deptNo=10&onlyOvertime=true
       ========================================================= */
    @GetMapping("/export")
    public void exportAdminSalary(@RequestParam(required = false) String month,
                                  @RequestParam(required = false) String deptNo,
                                  @RequestParam(required = false, defaultValue = "false") boolean onlyOvertime,
                                  @RequestParam(required = false, defaultValue = "false") boolean excludeRetired,
                                  @RequestParam(required = false, defaultValue = "false") boolean excludeDeletePlanned,
                                  HttpSession session,
                                  HttpServletResponse response) throws Exception {

        if (!isAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Map<String, Object> param = new HashMap<>();
        param.put("month", month);
        param.put("deptNo", deptNo);
        param.put("onlyOvertime", onlyOvertime);
        param.put("excludeRetired", excludeRetired);
        param.put("excludeDeletePlanned", excludeDeletePlanned);

        // export도 정렬이 필요하면 아래 2줄 추가 가능
        // param.put("sort", "date");
        // param.put("dir", "desc");

        List<SalVO> salList = salService.getAdminSalList(param);

        String fileName = "salary_" + (month != null && !month.isEmpty() ? month : "all") + ".csv";
        String encoded = URLEncoder.encode(fileName, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encoded + "\"");

        try (PrintWriter writer = response.getWriter()) {
        	
        	// ✅ UTF-8 BOM 추가 (엑셀 한글 깨짐 방지 핵심!)
            writer.write('\uFEFF');
            // 헤더
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

    /** null 방지용 숫자 변환 (CSV용) */
    private long n(Integer v) {
        return (v == null) ? 0L : v.longValue();
    }
}
