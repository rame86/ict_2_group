package com.example.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.AlertVO;
import com.example.domain.FreeBoardVO;
import com.example.domain.LoginVO;
import com.example.domain.NoticeBoardVO;
import com.example.domain.ReplyVO;
import com.example.service.AlertService;
import com.example.service.BoardService;
import com.example.service.EmpService;
import com.example.service.NotificationService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BoardController {

	@Autowired
	private BoardService boardService;

	@Autowired
	private EmpService empService;

	@Autowired
	private NotificationService notificationService;

	@Autowired
	private AlertService alertService;

	// =========================================================
	// 공지사항 영역
	// =========================================================

	@GetMapping("/board/getNoticeBoardList")
	public String getNoticeBoardList(Model m, HttpSession session,
			@RequestParam(value = "noticeNo", required = false) String noticeNo) {
		Object login = session.getAttribute("login");
		if (login == null)
			return "redirect:/";

		LoginVO loginUser = (LoginVO) login;
		Integer userDeptNo = Integer.parseInt(loginUser.getDeptNo());

		// 권한 등급 확인
		Integer gradeNo = Integer.parseInt(loginUser.getGradeNo());
		if (gradeNo == null)
			gradeNo = 99; // 안전장치

		// 공지 목록 가져오기
		List<NoticeBoardVO> globalNotices = boardService.getGlobalNoticeList();
		List<NoticeBoardVO> deptNotices = boardService.getDeptNoticeList(userDeptNo);

		List<NoticeBoardVO> combinedList = new ArrayList<>();
		if (globalNotices != null)
			combinedList.addAll(globalNotices);
		if (deptNotices != null)
			combinedList.addAll(deptNotices);

		m.addAttribute("noticeBoardList", combinedList);

		// 2. 알림 타고 들어온 경우 처리함~
		if (noticeNo != null) {
			m.addAttribute("targetNoticeNo", noticeNo);
		}

		// canWriteGlobal: 등급 1(최고), 2(상급) 만 전체 공지 가능~
		boolean canWriteGlobal = (gradeNo <= 2);

		// canWriteNotice: 등급 3(관리자)까지 공지 작성 버튼 노출~
		boolean canWriteNotice = (gradeNo <= 3);

		m.addAttribute("canWriteGlobal", canWriteGlobal);
		m.addAttribute("canWriteNotice", canWriteNotice);

		return "/board/getNoticeBoardList";
	}

	@PostMapping("/board/insertNoticeBoard")
	public String insertNoticeBoard(NoticeBoardVO vo, HttpSession session) {
		LoginVO login = (LoginVO) session.getAttribute("login");
		if (login == null)
			return "redirect:/";

		// 한번더 권한확인~
		Integer gradeNo = Integer.parseInt(login.getGradeNo());
		
	

		// 3등급(관리자)보다 낮은 등급은 작성 불가 판정으로 되돌려버리기~
		if (gradeNo > 3) {
			return "redirect:/board/getNoticeBoardList";
		}

		vo.setEmpNo(login.getEmpNo());
		vo.setNoticeWriter(login.getEmpName());

		// JSP에서 넘어온 deptNo가 없으면(null) 내 부서로 설정
		if (vo.getDeptNo() == null) {
			vo.setDeptNo(Integer.parseInt(login.getDeptNo()));
		}

		// 만약 사용자가 '0'(전체공지)을 보냈는데, 권한(등급 1,2)이 없으면 강제로 본인 부서로 변경
		if (vo.getDeptNo() == 0) {
			if (gradeNo > 2) {
				vo.setDeptNo(Integer.parseInt(login.getDeptNo()));
			}
		}

		if (vo.getNoticeNo() == null || vo.getNoticeNo().isEmpty()) {
			boardService.insertNoticeBoard(vo);
			sendNoticeAlert(vo);
		} else {
			boardService.updateNoticeBoard(vo);
		}
		return "redirect:/board/getNoticeBoardList";
	}

	// 공지사항 삭제
	@PostMapping("/board/deleteNoticeBoard")
	public String deleteNoticeBoard(@RequestParam("noticeNo") String noticeNo) {
		boardService.deleteNoticeBoard(noticeNo);
		return "redirect:/board/getNoticeBoardList";
	}

	@PostMapping("/board/getContentNoticeBoard")
	@ResponseBody
	public NoticeBoardVO getContentNoticeBoard(@RequestParam("noticeNo") String noticeNo) {
		return boardService.getContentNoticeBoard(noticeNo);
	}

	// =========================================================
	// 자유게시판 영역
	// =========================================================

	@GetMapping("/board/getFreeBoardList")
	public String getFreeBoardList(Model m, HttpSession session) {
		Object login = session.getAttribute("login");
		if (login == null)
			return "redirect:/";

		LoginVO loginUser = (LoginVO) login;
		Integer userDeptNo = Integer.parseInt(loginUser.getDeptNo());

		List<FreeBoardVO> globalFreeBoards = boardService.getGlobalFreeBoardList();
		List<FreeBoardVO> deptFreeBoards = boardService.getDeptFreeBoardList(userDeptNo);

		List<FreeBoardVO> combinedList = new ArrayList<>();
		if (globalFreeBoards != null)
			combinedList.addAll(globalFreeBoards);
		if (deptFreeBoards != null)
			combinedList.addAll(deptFreeBoards);

		m.addAttribute("freeBoardList", combinedList);
		return "/board/getFreeBoardList";
	}

	@PostMapping("/board/insertFreeBoard")
	public String insertFreeBoard(FreeBoardVO vo, HttpSession session) {
		LoginVO login = (LoginVO) session.getAttribute("login");
		if (login != null) {
			vo.setEmpNo(login.getEmpNo());
			vo.setBoardWriter(login.getEmpName());
			if (vo.getDeptNo() == null) {
				vo.setDeptNo(Integer.parseInt(login.getDeptNo()));
			}
		}

		if (vo.getBoardNo() == null || vo.getBoardNo().isEmpty()) {
			boardService.insertFreeBoard(vo);
		} else {
			boardService.updateFreeBoard(vo);
		}
		return "redirect:/board/getFreeBoardList";
	}

	// 자유게시판 삭제
	@PostMapping("/board/deleteFreeBoard")
	public String deleteFreeBoard(@RequestParam("boardNo") String boardNo) {
		boardService.deleteFreeBoard(boardNo);
		return "redirect:/board/getFreeBoardList";
	}

	@PostMapping("/board/getContentFreeBoard")
	@ResponseBody
	public FreeBoardVO getContentFreeBoard(@RequestParam("boardNo") String boardNo) {
		return boardService.getContentFreeBoard(boardNo);
	}

	// 알림 전송 로직
	private void sendNoticeAlert(NoticeBoardVO vo) {
		List<String> targetEmpList;
		if (vo.getDeptNo() == 0) {
			targetEmpList = empService.getAllEmpNoList();
		} else {
			targetEmpList = empService.getEmpNoListByDept(Integer.toString(vo.getDeptNo()));
		}
		for (String targetEmpNo : targetEmpList) {
			if (targetEmpNo.equals(vo.getEmpNo()))
				continue;
			AlertVO alert = new AlertVO();
			alert.setEmpNo(targetEmpNo);
			alert.setLinkType("BOARD");
			alert.setLinkId(Integer.parseInt(vo.getNoticeNo()));
			alert.setAlertStatus("NOTICE");
			String deptPrefix = (vo.getDeptNo() == 0) ? "[전체공지] " : "[부서공지] ";
			alert.setContent(deptPrefix + " " + vo.getNoticeTitle() + " 공지가 등록되었습니다.");
			alertService.saveNewAlert(alert);
			notificationService.pushNewAlert(alert);
		}
	}

	// =========================================================
	// 댓글 영역
	// =========================================================

	@PostMapping("/replies/insert")
	@ResponseBody
	public String insertReply(@RequestBody ReplyVO vo, HttpSession session) {
		LoginVO login = (LoginVO) session.getAttribute("login");
		if (login == null)
			return "fail";
		vo.setReplyWriterEmpNo(login.getEmpNo());
		int result = boardService.insertReply(vo);
		return result > 0 ? "success" : "fail";
	}

	@GetMapping("/replies/list")
	@ResponseBody
	public List<ReplyVO> getReplyList(ReplyVO vo) {
		return boardService.getReplyList(vo);
	}

	@PostMapping("/replies/delete")
	@ResponseBody
	public String deleteReply(@RequestParam("replyNo") Long replyNo, HttpSession session) {
		int result = boardService.deleteReply(replyNo);
		return result > 0 ? "success" : "fail";
	}
}