package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import java.time.LocalDate;
import org.springframework.format.annotation.DateTimeFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.domain.EmpVO;
import com.example.domain.DeptVO;
import com.example.domain.EditVO;
import com.example.domain.LoginVO;
import com.example.service.DeptService;
import com.example.service.EmpService;

import jakarta.servlet.http.HttpSession;

@Controller
public class EmpController {

    @Autowired
    private EmpService empService;
    
    @Autowired
    private DeptService deptService;

    /** 🔹 사원 사진 실제 저장 경로 (외부 폴더) */
    private static final String EMP_UPLOAD_PATH = "C:/emp_upload/emp/";

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
                String newFileName = saveEmpImage(empImageFile);
                vo.setEmpImage(newFileName);      // 새 이미지로 교체

                // 이전 파일 삭제
                deleteEmpImage(oldEmpImage);
            } else {
                // 새 파일이 없으면 기존 파일 유지
                vo.setEmpImage(oldEmpImage);
            }

            // 2) EMP 테이블 기본정보 수정
            int cnt = empService.updateEmp(vo);   // ★ 여기서 cnt 선언

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

        // 필요하다면 여기서 empNo로 사원 조회 → empImage 가져와서 파일도 같이 삭제
        // EmpVO emp = empService.selectEmpByEmpNo(empNo);
        // deleteEmpImage(emp.getEmpImage());

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
        List<DeptVO> deptList = deptService.getDeptList();   // 🔹 새로 추가
        System.out.println("📌 사원등록용 부서 개수 = " + (deptList == null ? 0 : deptList.size()));

        // 2) 화면에서 사용할 데이터 세팅
        model.addAttribute("deptList", deptList);            // 🔹 새로 추가
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

        // 필요하면 관리자 권한 체크
        if (!isAdmin(session)) {
            System.out.println("❌ 사원 등록 권한 없음");
            return "DENY";
        }

        try {
            // 사진 파일이 있으면 저장
            if (empImageFile != null && !empImageFile.isEmpty()) {
                String savedName = saveEmpImage(empImageFile);   // C:/emp_upload/emp/ 에 저장
                vo.setEmpImage(savedName);                       // EmpVO 필드명에 맞게 (empImage)
            }

            int cnt = empService.insertEmp(vo);
            System.out.println("✔ 사원 등록 완료, cnt = " + cnt);

            return (cnt > 0) ? "OK" : "FAIL";

        } catch (Exception e) {
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

    /** 🔹 사진 저장 (외부 폴더 C:/emp_upload/emp/) */
    private String saveEmpImage(MultipartFile file) throws IOException {

        if (file == null || file.isEmpty()) {
            return null;
        }

        String original = file.getOriginalFilename();
        if (original == null) original = "emp.jpg";

        // "시간_원본파일명" 형식으로 저장 (중복 방지)
        String savedName = System.currentTimeMillis() + "_" + original;

        File dir = new File(EMP_UPLOAD_PATH);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        File dest = new File(dir, savedName);
        file.transferTo(dest);

        System.out.println("📁 사진 저장 경로 = " + dest.getAbsolutePath());

        // DB에는 파일명만 저장 → /upload/emp/{파일명} 으로 접근
        return savedName;
    }

    /** 🔹 사진 삭제 */
    private void deleteEmpImage(String fileName) {
        if (fileName == null || fileName.isBlank()) return;

        File f = new File(EMP_UPLOAD_PATH, fileName);
        if (f.exists()) {
            boolean deleted = f.delete();
            System.out.println("🗑 사진 삭제 (" + f.getAbsolutePath() + ") = " + deleted);
        }
    }
}
