package com.example.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.example.domain.ApproveListVO;
import com.example.domain.DayAttendVO;
import com.example.domain.DeptVO;
import com.example.domain.EmpVO;
import com.example.domain.FreeBoardVO;
import com.example.domain.LoginVO;
import com.example.domain.MemberVO;
import com.example.domain.NoticeBoardVO;
import com.example.service.ApproveService;
import com.example.service.AttendService;
import com.example.service.BoardService;
import com.example.service.DeptService;
import com.example.service.EmpService;
import com.example.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MainController {

	@Autowired
	private ApproveService approveService;

	@Autowired
	private AttendService attendService;

	@Autowired
	private BoardService boardService;

	@Autowired
	private EmpService empService;

	@Autowired
	private DeptService deptService;

	@Autowired
	private MemberService memberService;

	// 로그인 세션 편의 메소드
	@ModelAttribute("login")
	public LoginVO getLogin(HttpSession session) {

		return (LoginVO) session.getAttribute("login");
	}

	
	
	
	
	
//	
//	/********************** 테스트용 **************************/
//	@GetMapping({ "/", "/index", "/main" })
//	public String index(@ModelAttribute("login") LoginVO login, Model m, HttpSession session) {
//
//		// 1. 로그인 검사 및 강제 로그인 처리
//		if (login == null) {
//			log.info("세션 없음: 7777 계정으로 자동 로그인 시도");
//
//			// 강제로 로그인 정보를 담을 VO 생성
//			MemberVO autoVO = new MemberVO();
//			autoVO.setEmpNo("7777");
//			autoVO.setEmpPass("7777");
//
//			// MemberService를 통해 로그인 정보 가져오기
//			LoginVO check = memberService.loginCheck(autoVO);
//
//			if (check != null) {
//				session.setAttribute("login", check);
//				login = check; // 이후 로직에서 사용할 수 있도록 변수에 할당
//				log.info("자동 로그인 성공: " + check.getEmpName());
//			} else {
//				log.error("자동 로그인 실패: 7777 계정이 DB에 없습니다.");
//				return "redirect:/member/login";
//			}
//		}
//
//		// 이후 로직은 동일합니다 (login 변수가 null이 아니므로 정상 진행됨)
//		String empNo = login.getEmpNo();
//		int deptNo = 0;
//		try {
//			deptNo = Integer.parseInt(login.getDeptNo());
//		} catch (Exception e) {
//		}
//
//		// [전자결재] 데이터 로딩
//		try {
//			List<ApproveListVO> waitingList = approveService.selectWaitingReceiveList(empNo);
//			int receiveWaitCount = (waitingList != null) ? waitingList.size() : 0;
//			Map<String, Integer> sendCountMap = approveService.getSendCount(empNo);
//			int sendWaitCount = sendCountMap.getOrDefault("ACTIVE", 0);
//			m.addAttribute("receiveWaitCount", receiveWaitCount);
//			m.addAttribute("sendWaitCount", sendWaitCount);
//		} catch (Exception e) {
//			log.error("전자결재 데이터 로딩 중 에러", e);
//		}
//
//		// [근태 관리] 데이터 로딩
//		try {
//			LocalDate now = LocalDate.now();
//			String todayStr = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
//			String currentMonth = now.format(DateTimeFormatter.ofPattern("yyyy-MM"));
//			List<DayAttendVO> monthList = attendService.selectDayAttend(empNo, currentMonth);
//			String myStatus = "미출근";
//			String myInTime = "-";
//			String myOutTime = "-";
//			if (monthList != null) {
//				for (DayAttendVO vo : monthList) {
//					if (vo.getDateAttend() != null && vo.getDateAttend().startsWith(todayStr)) {
//						myStatus = (vo.getAttStatus() != null) ? vo.getAttStatus() : "근무중";
//						if (vo.getInTime() != null && vo.getInTime().length() > 11) {
//							myInTime = vo.getInTime().substring(11, 16);
//						}
//						if (vo.getOutTime() != null && vo.getOutTime().length() > 11) {
//							myOutTime = vo.getOutTime().substring(11, 16);
//							if (myStatus.equals("근무중"))
//								myStatus = "퇴근완료";
//						}
//						break;
//					}
//				}
//			}
//			m.addAttribute("myStatus", myStatus);
//			m.addAttribute("myInTime", myInTime);
//			m.addAttribute("myOutTime", myOutTime);
//		} catch (Exception e) {
//			log.error("근태 데이터 로딩 중 에러", e);
//		}
//
//		// [게시판] 데이터 로딩
//		try {
//			List<NoticeBoardVO> globalNotices = boardService.getGlobalNoticeList();
//			if (globalNotices != null && globalNotices.size() > 5)
//				globalNotices = globalNotices.subList(0, 5);
//			m.addAttribute("noticeList", globalNotices);
//
//			List<NoticeBoardVO> deptNotices = boardService.getDeptNoticeList(deptNo);
//			if (deptNotices != null && deptNotices.size() > 5)
//				deptNotices = deptNotices.subList(0, 5);
//			m.addAttribute("deptNoticeList", deptNotices);
//
//			List<FreeBoardVO> deptFreeList = boardService.getDeptFreeBoardList(deptNo);
//			if (deptFreeList != null && deptFreeList.size() > 5)
//				deptFreeList = deptFreeList.subList(0, 5);
//			m.addAttribute("deptFreeList", deptFreeList);
//		} catch (Exception e) {
//			log.error("게시판 데이터 로딩 중 에러", e);
//		}
//
//		// [주소록] 데이터 로딩
//		try {
//			List<DeptVO> deptList = deptService.getOrgChartData();
//			m.addAttribute("deptList", deptList);
//		} catch (Exception e) {
//			log.error("부서 주소록 로딩 중 에러", e);
//		}
//
//		return "index";
//	}
//
//	/********************************************************************************/
//	
	
	
	@GetMapping({ "/", "/index", "/main" })
	public String index(@ModelAttribute("login") LoginVO login, Model m) {

		// 1. 로그인 검사
		if (login == null) {
			return "redirect:/member/login";
		}

		String empNo = login.getEmpNo();
		int deptNo = 0;
		try {
			deptNo = Integer.parseInt(login.getDeptNo());
		} catch (Exception e) {
		}

		// ==========================================
		// 2. [전자결재] 데이터 로딩
		// ==========================================
		try {
			List<ApproveListVO> waitingList = approveService.selectWaitingReceiveList(empNo);
			int receiveWaitCount = (waitingList != null) ? waitingList.size() : 0;

			Map<String, Integer> sendCountMap = approveService.getSendCount(empNo);
			int sendWaitCount = sendCountMap.getOrDefault("ACTIVE", 0);

			m.addAttribute("receiveWaitCount", receiveWaitCount);
			m.addAttribute("sendWaitCount", sendWaitCount);

		} catch (Exception e) {
			log.error("전자결재 데이터 로딩 중 에러", e);
		}

		// ==========================================
		// 3. [근태 관리] 데이터 로딩
		// ==========================================
		try {
			LocalDate now = LocalDate.now();
			String todayStr = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
			String currentMonth = now.format(DateTimeFormatter.ofPattern("yyyy-MM"));

			List<DayAttendVO> monthList = attendService.selectDayAttend(empNo, currentMonth);

			String myStatus = "미출근";
			String myInTime = "-";
			String myOutTime = "-";

			if (monthList != null) {
				for (DayAttendVO vo : monthList) {
					if (vo.getDateAttend() != null && vo.getDateAttend().startsWith(todayStr)) {
						myStatus = (vo.getAttStatus() != null) ? vo.getAttStatus() : "근무중";

						if (vo.getInTime() != null && vo.getInTime().length() > 11) {
							myInTime = vo.getInTime().substring(11, 16);
						}
						if (vo.getOutTime() != null && vo.getOutTime().length() > 11) {
							myOutTime = vo.getOutTime().substring(11, 16);
							if (myStatus.equals("근무중"))
								myStatus = "퇴근완료";
						}
						break;
					}
				}
			}
			m.addAttribute("myStatus", myStatus);
			m.addAttribute("myInTime", myInTime);
			m.addAttribute("myOutTime", myOutTime);

		} catch (Exception e) {
			log.error("근태 데이터 로딩 중 에러", e);
		}

		// ==========================================
		// 4. [게시판] 데이터 로딩 (수정됨)
		// ==========================================
		try {
			// (1) 전체 공지 (5개만)
			List<NoticeBoardVO> globalNotices = boardService.getGlobalNoticeList();
			if (globalNotices != null && globalNotices.size() > 5) {
				globalNotices = globalNotices.subList(0, 5);
			}
			m.addAttribute("noticeList", globalNotices);

			// (2) 부서 공지 (내 부서 + 하위 부서 모두 포함, 5개만)
			List<NoticeBoardVO> deptNotices = boardService.getDeptNoticeList(deptNo);
			if (deptNotices != null && deptNotices.size() > 5) {
				deptNotices = deptNotices.subList(0, 5);
			}
			m.addAttribute("deptNoticeList", deptNotices);

			// (3) 부서 자유게시판 (이름 수정됨: getDeptFreeBoardList)
			// ★ 여기가 문제였습니다. getFreeBoardList -> getDeptFreeBoardList 로 수정 ★
			List<FreeBoardVO> deptFreeList = boardService.getDeptFreeBoardList(deptNo);
			if (deptFreeList != null && deptFreeList.size() > 5) {
				deptFreeList = deptFreeList.subList(0, 5);
			}
			m.addAttribute("deptFreeList", deptFreeList);

		} catch (Exception e) {
			log.error("게시판 데이터 로딩 중 에러", e);
		}

		// ==========================================
		// 5. [주소록] 부서 목록 데이터 로딩 (모달용) 🔹 [추가됨]
		// ==========================================
		try {
			List<DeptVO> deptList = deptService.getOrgChartData(); // DAO에서 selectAllDeptList 호출함
			m.addAttribute("deptList", deptList);
		} catch (Exception e) {
			log.error("부서 주소록 로딩 중 에러", e);
		}

		return "index";
	}

	@GetMapping("/emp/myInfo")
	public String empMyInfo(@ModelAttribute("login") LoginVO login, Model model) {
		// 2. 내 정보 조회 (로그인 세션의 empNo 사용)
		EmpVO emp = empService.selectEmpByEmpNo(login.getEmpNo());

		// 3. 비고 이력 조회
		String editNoteHistory = empService.getEditNoteHistory(login.getEmpNo());

		// 4. 모델 담기
		model.addAttribute("emp", emp);
		model.addAttribute("editNoteHistory", editNoteHistory);

		// 중요: 대시보드에서는 수정/삭제 버튼을 숨기기 위해 false 설정
		model.addAttribute("canModify", false);

		return "emp/empCard"; // empCard.jsp 조각 반환
	}

}