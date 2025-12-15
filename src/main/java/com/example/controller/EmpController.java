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

    @Autowired
    private EmpService empService;

    @Autowired
    private DeptService deptService;

    @Autowired
    private MonthAttendService monthAttendService;

    @Autowired
    private SalService salService;

    // ✅ 실제 저장할 디렉터리 (프로젝트 경로 기준)
    private File empUploadDir;

    // (선택) 로그 확인용
    private String empUploadPath;

    /* =========================================================
       0. 업로드 디렉터리 초기화 (src/main/resources/static/upload/emp)
       ========================================================= */
    @PostConstruct
    public void initUploadDir() {

        empUploadPath = System.getProperty("user.dir")
                + File.separator + "src"
                + File.separator + "main"
                + File.separator + "resources"
                + File.separator + "static"
                + File.separator + "upload"
                + File.separator + "emp";

        File dir = new File(empUploadPath);

        if (!dir.exists()) {
            boolean made = dir.mkdirs();
            System.out.println("[EmpController] 업로드 폴더 생성 = " + made);
        }

        empUploadDir = dir;

        System.out.println("[EmpController] 사진 업로드 경로 = " + dir.getAbsolutePath());
    }

    /* =========================================================
       1. 사원 목록 (✅ 관리자만 접근 가능)
       ========================================================= */
    @GetMapping("/emp/list")
    public String empList(HttpSession session, Model model) {

        System.out.println("📌 /emp/list 접근됨");

        // ✅ 변경: 로그인 체크
        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) {
            System.out.println("❌ 로그인 정보 없음 → 로그인 페이지로 이동");
            return "redirect:/login/loginForm"; // ✅ 프로젝트에서 실제 쓰는 경로로 통일
        }

        // ✅ 변경: 관리자(grade 1,2)만 허용
        if (!isAdmin(session)) {
            System.out.println("❌ 사원목록 접근 권한 없음");
            return "error/NoAuthPage";
        }

        boolean canModify = true; // 어차피 관리자만 들어오므로 true 고정 가능

        List<EmpVO> list = empService.selectEmpList();
        System.out.println("📌 조회된 사원 수 = " + (list == null ? "null" : list.size()));

        model.addAttribute("empList", list);
        model.addAttribute("menu", "emp");
        model.addAttribute("loginGradeNo", login.getGradeNo());
        model.addAttribute("canModify", canModify);

        return "emp/empList";
    }

    /* =========================================================
       2. 인사카드(사원 상세)
       - ✅ 관리자만 접근으로 유지하면: 아래처럼
       - (만약 "본인 카드"는 허용하고 싶으면 조건 바꿔드릴게요)
       ========================================================= */
    @GetMapping("/emp/card")
    public String empCard(@RequestParam("empNo") String empNo,
                          HttpSession session,
                          Model model) {

        System.out.println("📌 /emp/card 접근됨, empNo = " + empNo);

        // ✅ 변경: 로그인 체크 통일
        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) {
            return "redirect:/login/loginForm";
        }

        // ✅ 변경: 관리자만 허용(원하면 "본인만 허용"으로 확장 가능)
        if (!isAdmin(session)) {
            return "error/NoAuthPage";
        }

        EmpVO emp = empService.selectEmpByEmpNo(empNo);
        boolean canModify = true;

        String editNoteHistory = empService.getEditNoteHistory(empNo);
        System.out.println("📌 editNoteHistory = \n" + editNoteHistory);

        model.addAttribute("emp", emp);
        model.addAttribute("canModify", canModify);
        model.addAttribute("editNoteHistory", editNoteHistory);

        return "emp/empCard";
    }

    /* =========================================================
       3. 사원 수정 (사진 포함) - 관리자만
       ========================================================= */
    @PostMapping("/emp/update")
    @ResponseBody
    public String updateEmp(
            EmpVO vo,
            @RequestParam(value = "empImageFile", required = false) MultipartFile empImageFile,
            @RequestParam(value = "oldEmpImage", required = false) String oldEmpImage,
            @RequestParam(value = "retireDate", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate retireDate,
            HttpSession session) {

        System.out.println("📌 /emp/update 호출, vo = " + vo);

        if (!isAdmin(session)) {
            System.out.println("❌ 수정 권한 없음");
            return "DENY";
        }

        LoginVO login = (LoginVO) session.getAttribute("login");

        try {
            // 1) 사진 처리
            if (empImageFile != null && !empImageFile.isEmpty()) {

                long maxSize = 2 * 1024 * 1024;
                if (empImageFile.getSize() > maxSize) {
                    System.out.println("❌ 파일 용량 초과");
                    return "FILE_SIZE";
                }

                String fileName = empImageFile.getOriginalFilename();
                String lower = (fileName == null) ? "" : fileName.toLowerCase();

                if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg")
                        || lower.endsWith(".png") || lower.endsWith(".gif"))) {
                    System.out.println("❌ 허용되지 않는 파일 타입");
                    return "FILE_TYPE";
                }

                String newFileName = saveEmpImage(empImageFile);
                vo.setEmpImage(newFileName);

                deleteEmpImage(oldEmpImage);

            } else {
                vo.setEmpImage(oldEmpImage);
            }

            // 2) EMP 테이블 기본정보 수정
            int cnt = empService.updateEmp(vo);

            // 3) 비고 이력 저장
            if (vo.getENote() != null && !vo.getENote().isBlank()) {
                String writerName = (login != null ? login.getEmpName() : "SYSTEM");
                empService.saveEmpEditHistory(vo.getEmpNo(), retireDate, vo.getENote(), writerName);
            }

            return (cnt > 0) ? "OK" : "FAIL";

        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR";
        }
    }

    /* =========================================================
       4. 사원 삭제 - 관리자만
       ========================================================= */
    @PostMapping("/emp/delete")
    @ResponseBody
    public String deleteEmp(@RequestParam("empNo") String empNo,
                            HttpSession session) {

        System.out.println("📌 /emp/delete 호출, empNo = " + empNo);

        if (!isAdmin(session)) {
            System.out.println("❌ 삭제 권한 없음");
            return "DENY";
        }

        EmpVO emp = empService.selectEmpByEmpNo(empNo);
        if (emp != null) {
            deleteEmpImage(emp.getEmpImage());
        }

        empService.deleteEmp(empNo);
        System.out.println("✔ 사원 삭제 완료");

        return "OK";
    }

    /* =========================================================
       5. 사원 등록 폼 - 관리자만
       ========================================================= */
    @GetMapping("/emp/new")
    public String empNewForm(HttpSession session, Model model) {

        System.out.println("📌 /emp/new 접근됨");

        // ✅ 변경: 로그인 체크 통일
        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) return "redirect:/login/loginForm";

        // ✅ 변경: 권한 체크는 isAdmin으로 통일 (중복 제거)
        if (!isAdmin(session)) {
            System.out.println("❌ 사원 등록 권한 없음");
            return "error/NoAuthPage";
        }

        List<DeptVO> deptList = deptService.getDeptList();
        System.out.println("📌 사원등록용 부서 개수 = " + (deptList == null ? 0 : deptList.size()));

        model.addAttribute("deptList", deptList);
        model.addAttribute("menu", "empNew");

        return "emp/empNewForm";
    }

    /* =========================================================
       6. 사원 등록 (사진 포함) - 관리자만
       ========================================================= */
    @PostMapping("/emp/insert")
    @ResponseBody
    public String insertEmp(
            @ModelAttribute EmpVO vo,
            @RequestParam(value = "empImageFile", required = false) MultipartFile empImageFile,
            HttpSession session) {

        System.out.println("📌 /emp/insert 호출, vo = " + vo);

        if (!isAdmin(session)) {
            System.out.println("❌ 사원 등록 권한 없음");
            return "DENY";
        }

        try {
            // 1) 입사일 미래 날짜 금지
            if (vo.getEmpRegdate() != null && !vo.getEmpRegdate().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date regDate = sdf.parse(vo.getEmpRegdate());
                    Date today = new Date();

                    if (regDate.after(today)) {
                        System.out.println("❌ 미래 입사일 오류");
                        return "REGDATE_FUTURE";
                    }

                } catch (ParseException e) {
                    System.out.println("❌ 입사일 파싱 실패");
                    return "REGDATE_PARSE_ERROR";
                }
            }

            // 2) 사진 업로드 검증 + 저장
            if (empImageFile != null && !empImageFile.isEmpty()) {

                long maxSize = 2 * 1024 * 1024;
                if (empImageFile.getSize() > maxSize) {
                    System.out.println("❌ 파일 용량 초과");
                    return "FILE_SIZE";
                }

                String fileName = empImageFile.getOriginalFilename();
                String lower = (fileName == null) ? "" : fileName.toLowerCase();

                if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg")
                        || lower.endsWith(".png") || lower.endsWith(".gif"))) {
                    System.out.println("❌ 허용되지 않는 파일 타입");
                    return "FILE_TYPE";
                }

                String savedName = saveEmpImage(empImageFile);
                vo.setEmpImage(savedName);
            }

            // 3) 사원 정보 DB 저장
            int cnt = empService.insertEmp(vo);
            System.out.println("✔ 사원 등록 완료, cnt = " + cnt);

            if (cnt <= 0) return "FAIL";

            // 4) 신규 사원 → 기본 근태/급여 생성
            try {
                monthAttendService.createDefaultForNewEmp(vo.getEmpNo());
                salService.createBaseSalaryForNewEmp(vo.getEmpNo());
            } catch (Exception initEx) {
                System.out.println("⚠ 기본 근태/급여 생성 중 오류 (등록은 성공): " + initEx.getMessage());
            }

            return "OK";

        } catch (Exception e) {
            System.out.println("❌ 등록 중 서버 오류");
            e.printStackTrace();
            return "ERROR";
        }
    }

    /* =========================================================
       7. 관리자 여부 체크 (grade 1,2)
       ========================================================= */
    private boolean isAdmin(HttpSession session) {
        LoginVO login = (LoginVO) session.getAttribute("login");

        System.out.println("📌 [isAdmin] login = " + login);

        if (login == null) {
            System.out.println("❌ [isAdmin] 로그인 정보 없음");
            return false;
        }

        System.out.println("📌 [isAdmin] gradeNo = " + login.getGradeNo());

        String grade = login.getGradeNo();
        return grade != null && ("1".equals(grade) || "2".equals(grade));
    }

    /* =========================================================
       8. 사번 중복 체크 (AJAX)
       - ✅ 관리자만 사용하게 하려면 isAdmin 체크 추가 가능
       ========================================================= */
    @GetMapping("/emp/checkEmpNo")
    @ResponseBody
    public String checkEmpNo(@RequestParam("empNo") String empNo, HttpSession session) {

        // (선택) 관리자만 허용하고 싶다면 ↓ 주석 해제
        // if (!isAdmin(session)) return "DENY";

        boolean dup = empService.isEmpNoDuplicate(empNo);
        return dup ? "DUP" : "OK";
    }

    /* =========================================================
       9. 파일 저장/삭제 헬퍼 메서드
       ========================================================= */

    /** ✅ 사진 저장 – src/main/resources/static/upload/emp 에 저장 */
    private String saveEmpImage(MultipartFile file) throws IOException {

        if (file == null || file.isEmpty()) {
            return null;
        }

        String originalName = file.getOriginalFilename();
        String ext = "";
        int dot = (originalName != null) ? originalName.lastIndexOf('.') : -1;
        if (dot > -1) {
            ext = originalName.substring(dot);
        }

        // ✅ UUID + 확장자 (공백/한글 문제 방지)
        String savedName = UUID.randomUUID().toString() + ext;

        if (empUploadDir == null) {
            throw new IllegalStateException("empUploadDir 가 초기화되지 않았습니다.");
        }

        File dest = new File(empUploadDir, savedName);
        file.transferTo(dest);

        return savedName;
    }

    /** ✅ 사진 삭제 */
    private void deleteEmpImage(String fileName) {
        if (fileName == null || fileName.isBlank()) return;
        if (empUploadDir == null) return;

        File f = new File(empUploadDir, fileName);
        if (f.exists()) {
            boolean deleted = f.delete();
            System.out.println("🗑 사진 삭제 (" + f.getAbsolutePath() + ") = " + deleted);
        } else {
            System.out.println("⚠ 삭제 대상 파일이 존재하지 않습니다: " + f.getAbsolutePath());
        }
    }
}
