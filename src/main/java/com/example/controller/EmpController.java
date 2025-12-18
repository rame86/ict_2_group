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

	/* =========================================================
       ✅ 안정화용 리턴 코드(프론트가 처리하는 규격 고정)
       - 문자열로 통일하되, "오타"로 인한 버그를 막기 위해 상수화
       ========================================================= */
	private static final String RES_OK = "OK";
	private static final String RES_FAIL = "FAIL";
	private static final String RES_DENY = "DENY";
	private static final String RES_ERROR = "ERROR";
	private static final String RES_FILE_SIZE = "FILE_SIZE";
	private static final String RES_FILE_TYPE = "FILE_TYPE";
	private static final String RES_REGDATE_FUTURE = "REGDATE_FUTURE";
	private static final String RES_REGDATE_PARSE_ERROR = "REGDATE_PARSE_ERROR";

	// ✅ 실제 저장할 디렉터리 (프로젝트 경로 기준)
	private File empUploadDir;

	// (선택) 로그 확인용
	private String empUploadPath;

	/* =========================================================
       0. 업로드 디렉터리 초기화 (src/main/resources/static/upload/emp)
       ========================================================= */
	@PostConstruct
	public void initUploadDir() {

		/**
		 * ✅ 안정화 포인트
		 * - 팀 내 공유/발표용이므로 "프로젝트 내부 경로" 고정 사용
		 * - 단, 모든 팀원이 프로젝트 구조를 동일하게 유지해야 함
		 *   (src/main/resources/static/upload/emp 폴더 존재 필수)
		 */
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

		// ✅ 안정화: 로그인 체크 (null이면 리다이렉트)
		LoginVO login = (LoginVO) session.getAttribute("login");
		if (login == null) {
			System.out.println("❌ 로그인 정보 없음 → 로그인 페이지로 이동");
			return "redirect:/login/loginForm";
		}

		// ✅ 안정화: 관리자만 허용
		if (!isAdmin(session)) {
			System.out.println("❌ 사원목록 접근 권한 없음");
			return "error/NoAuthPage";
		}

		// ✅ 안정화: list가 null일 가능성 방어(서비스가 null 반환하는 경우 대비)
		List<EmpVO> list = empService.selectEmpList();
		System.out.println("📌 조회된 사원 수 = " + (list == null ? "null" : list.size()));

		model.addAttribute("empList", list);
		model.addAttribute("menu", "emp");
		model.addAttribute("loginGradeNo", login.getGradeNo());
		model.addAttribute("canModify", true); // 관리자만 들어오므로 true

		return "emp/empList";
	}

	/* =========================================================
       2. 인사카드(사원 상세) - 관리자만
       ========================================================= */
	@GetMapping("/emp/card")
	public String empCard(@RequestParam("empNo") String empNo,
			HttpSession session,
			Model model) {

		System.out.println("📌 /emp/card 접근됨, empNo = " + empNo);

		LoginVO login = (LoginVO) session.getAttribute("login");
		if (login == null) return "redirect:/login/loginForm";

		if (!isAdmin(session)) return "error/NoAuthPage";

		// ✅ 안정화: empNo로 조회 결과가 null일 수 있음
		EmpVO emp = empService.selectEmpByEmpNo(empNo);
		if (emp == null) {
			// 실서비스라면 404 화면 등을 띄우지만, 팀프로젝트는 오류 방지 목적
			model.addAttribute("msg", "해당 사원을 찾을 수 없습니다.");
			return "error/NoAuthPage"; // 프로젝트에 맞는 공용 에러 JSP 있으면 그걸로 변경 추천
		}

		String editNoteHistory = empService.getEditNoteHistory(empNo);
		System.out.println("📌 editNoteHistory = \n" + editNoteHistory);

		model.addAttribute("emp", emp);
		model.addAttribute("canModify", true);
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

		// ✅ 권한 체크
		if (!isAdmin(session)) {
			System.out.println("❌ 수정 권한 없음");
			return RES_DENY;
		}

		LoginVO login = (LoginVO) session.getAttribute("login");

		/**
		 * =========================
		 * ✅ 안정화 핵심 로직
		 * =========================
		 * - 새 이미지 업로드가 있는 경우:
		 *   1) 새 파일 저장
		 *   2) DB 업데이트 시도
		 *   3) DB 성공이면 old 삭제
		 *   4) DB 실패/예외면 새 파일 삭제(롤백)
		 *
		 * - 새 이미지 업로드가 없는 경우:
		 *   oldEmpImage 유지
		 */
		String newSavedName = null; // ✅ 새로 저장된 파일명 (실패 시 롤백 삭제에 사용)

		try {
			// 1) 사진 처리 (새 파일이 있으면 저장만 먼저 해둠)
			if (empImageFile != null && !empImageFile.isEmpty()) {

				// ✅ 공통 검증(용량/확장자 등)
				String valid = validateImageFile(empImageFile);
				if (!RES_OK.equals(valid)) return valid;

				// ✅ 새 파일 저장 (아직 old는 삭제하지 않음)
				newSavedName = saveEmpImage(empImageFile);
				vo.setEmpImage(newSavedName);

			} else {
				// ✅ 새 파일 없으면 기존 이미지 유지
				vo.setEmpImage(oldEmpImage);
			}

			// 2) DB 업데이트 실행
			int cnt = empService.updateEmp(vo);

			if (cnt <= 0) {
				// ✅ DB 실패면 새로 저장한 파일이 있으면 롤백 삭제
				if (newSavedName != null) {
					deleteEmpImage(newSavedName);
				}
				return RES_FAIL;
			}

			// 3) DB 성공 후 처리
			// ✅ 새 파일 업로드가 있었을 때만 old 삭제 (old가 null/blank이면 deleteEmpImage가 알아서 return)
			if (newSavedName != null) {
				deleteEmpImage(oldEmpImage);
			}

			// 4) 비고 이력 저장 (공백 방어)
			if (vo.getENote() != null && !vo.getENote().isBlank()) {
				String writerName = (login != null ? login.getEmpName() : "SYSTEM");
				empService.saveEmpEditHistory(vo.getEmpNo(), retireDate, vo.getENote(), writerName);
			}

			return RES_OK;

		} catch (Exception e) {
			e.printStackTrace();

			// ✅ 예외 발생 시에도 새 파일 저장했다면 롤백 삭제
			if (newSavedName != null) {
				deleteEmpImage(newSavedName);
			}

			return RES_ERROR;
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
			return RES_DENY;
		}

		EmpVO emp = empService.selectEmpByEmpNo(empNo);
		if (emp != null) {
			deleteEmpImage(emp.getEmpImage());
		}

		empService.deleteEmp(empNo);
		System.out.println("✔ 사원 삭제 완료");

		return RES_OK;
	}

	/* =========================================================
       5. 사원 등록 폼 - 관리자만
       ========================================================= */
	@GetMapping("/emp/new")
	public String empNewForm(HttpSession session, Model model) {

		System.out.println("📌 /emp/new 접근됨");

		LoginVO login = (LoginVO) session.getAttribute("login");
		if (login == null) return "redirect:/login/loginForm";

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
			return RES_DENY;
		}

		String savedName = null; // ✅ 안정화: 저장 후 DB 실패 시 롤백(파일 삭제)용

		try {
			// 1) 입사일 미래 날짜 금지 + 파싱 안정화
			String reg = vo.getEmpRegdate();
			if (reg != null && !reg.isBlank()) {
				try {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					sdf.setLenient(false); // ✅ 2025-99-99 같은 이상값 방지
					Date regDate = sdf.parse(reg);

					if (regDate.after(new Date())) {
						System.out.println("❌ 미래 입사일 오류");
						return RES_REGDATE_FUTURE;
					}
				} catch (ParseException e) {
					System.out.println("❌ 입사일 파싱 실패");
					return RES_REGDATE_PARSE_ERROR;
				}
			}

			// 2) 사진 업로드 검증 + 저장
			if (empImageFile != null && !empImageFile.isEmpty()) {

				String valid = validateImageFile(empImageFile);
				if (!RES_OK.equals(valid)) return valid;

				savedName = saveEmpImage(empImageFile);
				vo.setEmpImage(savedName);
			}

			// 3) 사원 정보 DB 저장
			int cnt = empService.insertEmp(vo);
			System.out.println("✔ 사원 등록 완료, cnt = " + cnt);

			if (cnt <= 0) {
				// ✅ 안정화: DB insert 실패 시 업로드 파일 롤백
				deleteEmpImage(savedName);
				return RES_FAIL;
			}

			// 4) 신규 사원 → 기본 근태/급여 생성
			try {
				monthAttendService.createDefaultForNewEmp(vo.getEmpNo());
				salService.createBaseSalaryForNewEmp(vo.getEmpNo());
			} catch (Exception initEx) {
				System.out.println("⚠ 기본 근태/급여 생성 중 오류 (등록은 성공): " + initEx.getMessage());
			}

			return RES_OK;

		} catch (Exception e) {
			System.out.println("❌ 등록 중 서버 오류");
			e.printStackTrace();

			// ✅ 안정화: 예외 발생 시에도 파일 롤백(가능하면)
			deleteEmpImage(savedName);

			return RES_ERROR;
		}
	}

	/* =========================================================
       7. 관리자 여부 체크 (grade 1,2)
       ========================================================= */
	private boolean isAdmin(HttpSession session) {
		/**
		 * ✅ 안정화 포인트:
		 * - gradeNo가 String일 수도, int일 수도, 공백이 섞일 수도 있음
		 * - 팀원 코드/VO 수정으로 타입이 바뀌어도 최대한 안전하게 동작하도록 방어
		 */
		LoginVO login = (LoginVO) session.getAttribute("login");
		if (login == null) return false;

		Object gradeObj = login.getGradeNo(); // String일 수도 있고 int일 수도 있다는 가정(안정화용)
		if (gradeObj == null) return false;

		String gradeStr = String.valueOf(gradeObj).trim();

		// "1", "2"만 관리자
		return "1".equals(gradeStr) || "2".equals(gradeStr);
	}

	/* =========================================================
       8. 사번 중복 체크 (AJAX)
       ========================================================= */
	@GetMapping("/emp/checkEmpNo")
	@ResponseBody
	public String checkEmpNo(@RequestParam("empNo") String empNo, HttpSession session) {

		// 안정화: empNo 빈값 방어
		if (empNo == null || empNo.isBlank()) return RES_FAIL;

		boolean dup = empService.isEmpNoDuplicate(empNo);
		return dup ? "DUP" : RES_OK;
	}

	/* =========================================================
       9. 파일 검증/저장/삭제 헬퍼
       ========================================================= */

	/**
	 * ✅ 이미지 파일 검증 공통화
	 * - 용량 제한
	 * - 확장자 제한
	 * - contentType(보조 체크)
	 */
	private String validateImageFile(MultipartFile file) {

		long maxSize = 2 * 1024 * 1024; // 2MB
		if (file.getSize() > maxSize) {
			System.out.println("❌ 파일 용량 초과");
			return RES_FILE_SIZE;
		}

		String fileName = file.getOriginalFilename();
		String lower = (fileName == null) ? "" : fileName.toLowerCase();

		if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg")
				|| lower.endsWith(".png") || lower.endsWith(".gif"))) {
			System.out.println("❌ 허용되지 않는 파일 타입");
			return RES_FILE_TYPE;
		}

		// (보조) contentType 체크: 브라우저/환경에 따라 null일 수 있어서 강제 실패로 쓰진 않음
		String ct = file.getContentType();
		if (ct != null && !ct.startsWith("image/")) {
			System.out.println("⚠ contentType이 image가 아님: " + ct);
			// 발표용에서는 여기서 FAIL 처리까지는 하지 않고 경고만 남김
		}

		return RES_OK;
	}

	/** ✅ 사진 저장 – src/main/resources/static/upload/emp 에 저장 */
	private String saveEmpImage(MultipartFile file) throws IOException {

		if (file == null || file.isEmpty()) return null;

		String originalName = file.getOriginalFilename();
		String ext = "";
		int dot = (originalName != null) ? originalName.lastIndexOf('.') : -1;
		if (dot > -1) ext = originalName.substring(dot);

		// ✅ UUID + 확장자 (공백/한글/중복 문제 방지)
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
