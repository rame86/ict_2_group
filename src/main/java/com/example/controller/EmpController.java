package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;   // retireDate 파라미터 타입에서 사용
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
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
// import com.example.domain.EditVO;  // ⚠ 사용 안 하면 지워도 됨
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

    // 🔹 실제 저장할 디렉터리 (classpath:/static/upload/emp → 빌드 후 target/classes 기준)
    private File empUploadDir;

    /* =========================================================
       0. 업로드 디렉터리 초기화
       ========================================================= */
    @PostConstruct
    public void initUploadDir() throws IOException {

        // classpath:/static/upload/emp/ 실제 경로 얻기
        ClassPathResource resource = new ClassPathResource("static/upload/emp/");
        File dir = resource.getFile();   // target/classes/static/upload/emp/

        if (!dir.exists()) {
            dir.mkdirs();
        }

        empUploadDir = dir;

        System.out.println("[EmpController] 사진 업로드 경로 = " + dir.getAbsolutePath());
    }

    /* =========================================================
       1. 사원 목록
       ========================================================= */
    @GetMapping("/emp/list")
    public String empList(HttpSession session, Model model) {

        System.out.println("📌 /emp/list 접근됨");

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) {
            System.out.println("❌ 로그인 정보 없음 → 로그인 페이지로 이동");
            return "redirect:/login/loginForm";
        }

        boolean canModify = isAdmin(session);

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
       ========================================================= */
    @GetMapping("/emp/card")
    public String empCard(@RequestParam("empNo") String empNo,
                          HttpSession session,
                          Model model) {

        System.out.println("📌 /emp/card 접근됨, empNo = " + empNo);

        LoginVO login = (LoginVO) session.getAttribute("login");
        if (login == null) {
            return "error/NoAuthPage";
        }

        EmpVO emp = empService.selectEmpByEmpNo(empNo);
        boolean canModify = isAdmin(session);

        // 🔹 비고 히스토리 문자열 조회
        String editNoteHistory = empService.getEditNoteHistory(empNo);
        System.out.println("📌 editNoteHistory = \n" + editNoteHistory);

        model.addAttribute("emp", emp);
        model.addAttribute("canModify", canModify);
        model.addAttribute("editNoteHistory", editNoteHistory);

        return "emp/empCard";
    }

    /* =========================================================
       3. 사원 수정 (사진 포함)
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
                String newFileName = saveEmpImage(empImageFile);  // 새 파일 저장
                vo.setEmpImage(newFileName);                      // 새 이미지로 교체

                // 이전 파일 삭제
                deleteEmpImage(oldEmpImage);
            } else {
                // 새 파일이 없으면 기존 파일 유지
                vo.setEmpImage(oldEmpImage);
            }

            // 2) EMP 테이블 기본정보 수정
            int cnt = empService.updateEmp(vo);

            // 3) 비고 이력 저장 (EDIT 테이블에 INSERT)
            if (vo.getENote() != null && !vo.getENote().isBlank()) {
                String writerName = (login != null ? login.getEmpName() : "SYSTEM");
                empService.saveEmpEditHistory(vo.getEmpNo(), retireDate, vo.getENote(), writerName);
            }

            // 4) 결과 리턴
            return (cnt > 0) ? "OK" : "FAIL";

        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR";
        }
    }

    /* =========================================================
       4. 사원 삭제
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

        // 🔹 삭제 전에 사진 파일도 함께 삭제
        EmpVO emp = empService.selectEmpByEmpNo(empNo);
        if (emp != null) {
            deleteEmpImage(emp.getEmpImage());
        }

        empService.deleteEmp(empNo);
        System.out.println("✔ 사원 삭제 완료");

        return "OK";
    }

    /* =========================================================
       5. 사원 등록 폼
       ========================================================= */
    @GetMapping("/emp/new")
    public String empNewForm(HttpSession session, Model model) {

        System.out.println("📌 /emp/new 접근됨");

        if (!isAdmin(session)) {
            System.out.println("❌ 사원 등록 권한 없음");
            return "error/NoAuthPage";
        }

        // 1) 부서 목록 조회 (DEPT 테이블 → DeptVO 리스트)
        List<DeptVO> deptList = deptService.getDeptList();
        System.out.println("📌 사원등록용 부서 개수 = " + (deptList == null ? 0 : deptList.size()));

        // 2) 화면에서 사용할 데이터 세팅
        model.addAttribute("deptList", deptList);
        model.addAttribute("menu", "empNew");

        // 3) 사원 등록 JSP로 이동
        return "emp/empNewForm";
    }

    /* =========================================================
       6. 사원 등록 (사진 포함)
       ========================================================= */
    @PostMapping("/emp/insert")
    @ResponseBody
    public String insertEmp(
            @ModelAttribute EmpVO vo,
            @RequestParam(value = "empImageFile", required = false) MultipartFile empImageFile,
            HttpSession session) {

        System.out.println("📌 /emp/insert 호출, vo = " + vo);

        // 0) 관리자 권한 체크
        if (!isAdmin(session)) {
            System.out.println("❌ 사원 등록 권한 없음");
            return "DENY";
        }

        try {
            /* ===========================================================
               1) 입사일 미래 날짜 금지 (String → Date 파싱)
            =========================================================== */
            if (vo.getEmpRegdate() != null && !vo.getEmpRegdate().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date regDate = sdf.parse(vo.getEmpRegdate());  // "2025-12-10"

                    Date today = new Date(); // 현재 시각

                    if (regDate.after(today)) {
                        System.out.println("❌ 미래 입사일 오류");
                        return "REGDATE_FUTURE";
                    }

                } catch (ParseException e) {
                    System.out.println("❌ 입사일 파싱 실패");
                    return "REGDATE_PARSE_ERROR";
                }
            }

            /* ===========================================================
               2) 사진 업로드 검증 (확장자 + 크기 제한)
            =========================================================== */
            if (empImageFile != null && !empImageFile.isEmpty()) {

                // 🔹 2MB 제한
                long maxSize = 2 * 1024 * 1024;
                if (empImageFile.getSize() > maxSize) {
                    System.out.println("❌ 파일 용량 초과");
                    return "FILE_SIZE";
                }

                // 🔹 확장자 검사
                String fileName = empImageFile.getOriginalFilename();
                String lower = (fileName == null) ? "" : fileName.toLowerCase();

                if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg")
                        || lower.endsWith(".png") || lower.endsWith(".gif"))) {
                    System.out.println("❌ 허용되지 않는 파일 타입");
                    return "FILE_TYPE";
                }

                // 🔹 통과 → 저장
                String savedName = saveEmpImage(empImageFile);
                vo.setEmpImage(savedName);
            }

            /* ===========================================================
               3) 사원 정보 DB 저장
            =========================================================== */
            int cnt = empService.insertEmp(vo);
            System.out.println("✔ 사원 등록 완료, cnt = " + cnt);

            if (cnt <= 0) return "FAIL";

            /* ===========================================================
               4) 활동 로그 기록 (선택 – 나중에 logService 붙이기)
            =========================================================== */
            try {
                LoginVO login = (LoginVO) session.getAttribute("login");
                System.out.println(
                    "📘 LOG : 등록자 = " + (login != null ? login.getEmpNo() : "UNKNOWN")
                    + ", 대상사번 = " + vo.getEmpNo()
                );
                // logService.logNewEmp(login.getEmpNo(), vo.getEmpNo()); // TODO: 나중에 구현
            } catch (Exception logEx) {
                System.out.println("⚠ 활동 로그 기록 중 오류 (치명적이지 않음): " + logEx.getMessage());
            }

            /* ===========================================================
               5) 신규 사원 → 기본 근태/급여 생성
            =========================================================== */
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
       7. 관리자 여부 체크
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
       ========================================================= */
    @GetMapping("/emp/checkEmpNo")
    @ResponseBody
    public String checkEmpNo(@RequestParam("empNo") String empNo) {

        boolean dup = empService.isEmpNoDuplicate(empNo);
        return dup ? "DUP" : "OK";
    }

    /* =========================================================
       9. 파일 저장/삭제 헬퍼 메서드
       ========================================================= */

    /** 🔹 사진 저장 – classpath:/static/upload/emp/ 경로 사용 */
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

        String savedName = UUID.randomUUID().toString() + ext;

        // ✅ 실제 저장 위치: classpath:/static/upload/emp/
        if (empUploadDir == null) {
            throw new IllegalStateException("empUploadDir 가 초기화되지 않았습니다.");
        }

        File dest = new File(empUploadDir, savedName);
        file.transferTo(dest);

        return savedName;   // DB에는 파일명만 저장
    }

    /** 🔹 사진 삭제 – 업로드 디렉터리에서 파일 제거 */
    private void deleteEmpImage(String fileName) {
        if (fileName == null || fileName.isBlank()) return;
        if (empUploadDir == null) return;  // 방어 코드

        File f = new File(empUploadDir, fileName);
        if (f.exists()) {
            boolean deleted = f.delete();
            System.out.println("🗑 사진 삭제 (" + f.getAbsolutePath() + ") = " + deleted);
        } else {
            System.out.println("⚠ 삭제 대상 파일이 존재하지 않습니다: " + f.getAbsolutePath());
        }
    }
}
