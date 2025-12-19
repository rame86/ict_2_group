package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.domain.DeptVO;
import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.service.DeptService;
import com.example.service.EmpService;
import com.example.service.MonthAttendService;
import com.example.service.SalService;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpSession;

@Controller
public class EmpController {

    @Autowired private EmpService empService;
    @Autowired private DeptService deptService;
    @Autowired private MonthAttendService monthAttendService;
    @Autowired private SalService salService;

    /* =========================
       ✅ null-safe 공통
       ========================= */
    private String safeStr(Object v) {
        return (v == null) ? "" : String.valueOf(v).trim();
    }

    /* =========================
       ✅ 안정화 리턴 코드
       ========================= */
    private static final String RES_OK = "OK";
    private static final String RES_FAIL = "FAIL";
    private static final String RES_DENY = "DENY";
    private static final String RES_ERROR = "ERROR";
    private static final String RES_FILE_SIZE = "FILE_SIZE";
    private static final String RES_FILE_TYPE = "FILE_TYPE";
    private static final String RES_REGDATE_FUTURE = "REGDATE_FUTURE";
    private static final String RES_REGDATE_PARSE_ERROR = "REGDATE_PARSE_ERROR";

    // ✅ 실제 저장 디렉터리
    private File empUploadDir;
    private String empUploadPath;

    /* =========================================================
       0. 업로드 디렉터리 초기화
       ========================================================= */
    @PostConstruct
    public void initUploadDir() {
        empUploadPath = System.getProperty("user.dir")
                + File.separator + "src" + File.separator + "main"
                + File.separator + "resources" + File.separator + "static"
                + File.separator + "upload" + File.separator + "emp";

        File dir = new File(empUploadPath);

        if (!dir.exists()) {
            boolean made = dir.mkdirs();
            System.out.println("[EmpController] 업로드 폴더 생성 = " + made);
        }

        empUploadDir = dir;
        System.out.println("[EmpController] 사진 업로드 경로 = " + dir.getAbsolutePath());
    }

    /* =========================================================
       1. 사원 목록 (✅ 관리자만 접근 가능: grade 1~3)
       ========================================================= */
    @GetMapping("/emp/list")
    public String empList(HttpSession session, Model model) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return "redirect:/login/loginForm";

        // ✅ 관리자만 허용
        int g = 99;
        try { g = Integer.parseInt(safeStr(login.getGradeNo())); } catch (Exception e) {}
        if (g < 1 || g > 3) return "error/NoAuthPage";

        List<EmpVO> list = empService.selectEmpList();

        model.addAttribute("empList", list);
        model.addAttribute("menu", "emp");
        model.addAttribute("loginGradeNo", login.getGradeNo());

        String dept = safeStr(login.getDeptNo());
        model.addAttribute("canModify", "2010".equals(dept));                 // 수정/등록: 인사팀장
        model.addAttribute("canDelete", "2000".equals(dept) || "2010".equals(dept)); // 삭제: 운영총괄/인사팀장

        return "emp/empList";
    }

    /* =========================================================
       2. 인사카드 (관리자만)
       ========================================================= */
    @GetMapping("/emp/card")
    public String empCard(@RequestParam("empNo") String empNo, HttpSession session, Model model) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return "redirect:/login/loginForm";

        if (!isAdmin(session)) return "error/NoAuthPage";

        EmpVO emp = empService.selectEmpByEmpNo(empNo);
        if (emp == null) return "error/NoAuthPage";

        String editNoteHistory = empService.getEditNoteHistory(empNo);

        model.addAttribute("emp", emp);
        model.addAttribute("editNoteHistory", editNoteHistory);

        String dept = safeStr(login.getDeptNo());
        model.addAttribute("canModify", "2010".equals(dept));
        model.addAttribute("canDelete", "2000".equals(dept) || "2010".equals(dept));

        return "emp/empCard";
    }

    /* =========================================================
       3. 사원 수정 (인사팀장만)
       ========================================================= */
    @PostMapping("/emp/update")
    @ResponseBody
    public String updateEmp(EmpVO vo,
                            @RequestParam(value="empImageFile", required=false) MultipartFile empImageFile,
                            @RequestParam(value="oldEmpImage", required=false) String oldEmpImage,
                            @RequestParam(value="retireDate", required=false)
                            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate retireDate,
                            HttpSession session) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return RES_DENY;

        if (!"2010".equals(safeStr(login.getDeptNo()))) return RES_DENY;

        String newSavedName = null;

        try {
            if (empImageFile != null && !empImageFile.isEmpty()) {
                String valid = validateImageFile(empImageFile);
                if (!RES_OK.equals(valid)) return valid;

                newSavedName = saveEmpImage(empImageFile);
                vo.setEmpImage(newSavedName);
            } else {
                vo.setEmpImage(oldEmpImage);
            }

            int cnt = empService.updateEmp(vo);
            if (cnt <= 0) {
                if (newSavedName != null) deleteEmpImage(newSavedName);
                return RES_FAIL;
            }

            if (newSavedName != null) deleteEmpImage(oldEmpImage);

            if (vo.getENote() != null && !vo.getENote().isBlank()) {
                String writerName = safeStr(login.getEmpName());
                if (writerName.isBlank()) writerName = "SYSTEM";
                empService.saveEmpEditHistory(vo.getEmpNo(), retireDate, vo.getENote(), writerName);
            }

            return RES_OK;

        } catch (Exception e) {
            e.printStackTrace();
            if (newSavedName != null) deleteEmpImage(newSavedName);
            return RES_ERROR;
        }
    }

    /* =========================================================
       4. 사원 삭제 (운영총괄/인사팀장)
       ========================================================= */
    @PostMapping("/emp/delete")
    @ResponseBody
    public String deleteEmp(@RequestParam("empNo") String empNo, HttpSession session) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return RES_DENY;

        String deptNo = safeStr(login.getDeptNo());
        if (!"2000".equals(deptNo) && !"2010".equals(deptNo)) return RES_DENY;

        EmpVO emp = empService.selectEmpByEmpNo(empNo);
        if (emp != null) deleteEmpImage(emp.getEmpImage());

        empService.deleteEmp(empNo);
        return RES_OK;
    }

    /* =========================================================
       5. 사원 등록 폼 (인사팀장만)  ✅ 여기서 null-safe로 오류 방지
       ========================================================= */
    @GetMapping("/emp/new")
    public String empNewForm(HttpSession session, Model model) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return "redirect:/login/loginForm";

        String deptNo = safeStr(login.getDeptNo()); // ✅ 여기서 null-safe
        if (!"2010".equals(deptNo)) return "error/NoAuthPage";

        List<DeptVO> deptList = deptService.getDeptList();
        model.addAttribute("deptList", deptList);
        model.addAttribute("menu", "empNew");
        return "emp/empNewForm";
    }

    /* =========================================================
       6. 사원 등록 (인사팀장만)
       ========================================================= */
    @PostMapping("/emp/insert")
    @ResponseBody
    public String insertEmp(@ModelAttribute EmpVO vo,
                            @RequestParam(value="empImageFile", required=false) MultipartFile empImageFile,
                            HttpSession session) {

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return RES_DENY;

        if (!"2010".equals(safeStr(login.getDeptNo()))) return RES_DENY;

        String savedName = null;

        try {
            String reg = vo.getEmpRegdate();
            if (reg != null && !reg.isBlank()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    sdf.setLenient(false);
                    Date regDate = sdf.parse(reg);
                    if (regDate.after(new Date())) return RES_REGDATE_FUTURE;
                } catch (ParseException e) {
                    return RES_REGDATE_PARSE_ERROR;
                }
            }

            if (empImageFile != null && !empImageFile.isEmpty()) {
                String valid = validateImageFile(empImageFile);
                if (!RES_OK.equals(valid)) return valid;

                savedName = saveEmpImage(empImageFile);
                vo.setEmpImage(savedName);
            }

            int cnt = empService.insertEmp(vo);
            if (cnt <= 0) {
                deleteEmpImage(savedName);
                return RES_FAIL;
            }

            try {
                monthAttendService.createDefaultForNewEmp(vo.getEmpNo());
                salService.createBaseSalaryForNewEmp(vo.getEmpNo());
            } catch (Exception ignore) {}

            return RES_OK;

        } catch (Exception e) {
            e.printStackTrace();
            deleteEmpImage(savedName);
            return RES_ERROR;
        }
    }

    /* =========================================================
       7. 관리자 여부 체크 (grade 1~3) ✅ 깔끔 버전
       ========================================================= */
    private boolean isAdmin(HttpSession session) {
        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return false;

        int g = 99;
        try { g = Integer.parseInt(safeStr(login.getGradeNo())); } catch (Exception e) {}
        return g >= 1 && g <= 3;
    }

    /* =========================================================
       8. 사번 중복 체크
       ========================================================= */
    @GetMapping("/emp/checkEmpNo")
    @ResponseBody
    public String checkEmpNo(@RequestParam("empNo") String empNo) {
        if (empNo == null || empNo.isBlank()) return RES_FAIL;
        return empService.isEmpNoDuplicate(empNo) ? "DUP" : RES_OK;
    }

    /* =========================================================
       9. 파일 검증/저장/삭제 헬퍼
       ========================================================= */
    private String validateImageFile(MultipartFile file) {

        long maxSize = 2 * 1024 * 1024; // 2MB
        if (file.getSize() > maxSize) return RES_FILE_SIZE;

        String fileName = file.getOriginalFilename();
        String lower = (fileName == null) ? "" : fileName.toLowerCase();

        if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".gif"))) {
            return RES_FILE_TYPE;
        }
        return RES_OK;
    }

    private String saveEmpImage(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) return null;

        String originalName = file.getOriginalFilename();
        String ext = "";
        int dot = (originalName != null) ? originalName.lastIndexOf('.') : -1;
        if (dot > -1) ext = originalName.substring(dot);

        String savedName = UUID.randomUUID().toString() + ext;

        if (empUploadDir == null) throw new IllegalStateException("empUploadDir 가 초기화되지 않았습니다.");

        File dest = new File(empUploadDir, savedName);
        file.transferTo(dest);
        return savedName;
    }

    private void deleteEmpImage(String fileName) {
        if (fileName == null || fileName.isBlank()) return;
        if (empUploadDir == null) return;

        File f = new File(empUploadDir, fileName);
        if (f.exists()) f.delete();
    }
    
    /* =========================================================
    10. 사원이 직접 프로필 사진 수정 (마이페이지에서 호출하면 됨)
    ========================================================= */
 @PostMapping("/emp/updateProfileImage")
 @ResponseBody
 public String updateProfileImage(@RequestParam("empNo") String empNo,
                                  @RequestParam("empImageFile") MultipartFile empImageFile,
                                  HttpSession session) {

     LoginVO login = (LoginVO) session.getAttribute("login");
     if (login == null) return RES_FAIL;

     if (!safeStr(login.getEmpNo()).equals(empNo) && !isAdmin(session)) return RES_DENY;

     String newSavedName = null;
     String oldSavedName = safeStr(login.getEmpImage());

     try {
         String valid = validateImageFile(empImageFile);
         if (!RES_OK.equals(valid)) return valid;

         newSavedName = saveEmpImage(empImageFile);

         int cnt = empService.updateProfileImage(empNo, newSavedName);
         if (cnt > 0) {
             if (!oldSavedName.isBlank() && !"default_profile.png".equals(oldSavedName)) {
                 deleteEmpImage(oldSavedName);
             }
             login.setEmpImage(newSavedName);
             session.setAttribute("login", login);
             return newSavedName;
         }

         deleteEmpImage(newSavedName);
         return RES_FAIL;

     } catch (Exception e) {
         e.printStackTrace();
         if (newSavedName != null) deleteEmpImage(newSavedName);
         return RES_ERROR;
     }
 }
}