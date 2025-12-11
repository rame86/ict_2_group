package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.FreeBoardVO;
import com.example.domain.NoticeBoardVO;
import com.example.service.BoardService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BoardController {

	// =======================================
	@Autowired
	private BoardService boardService;
	// =======================================

	// ************* 공지사항 영역~ *************

	// =======================================================================================
	// getNoticeBoardList()
	@GetMapping("/board/getNoticeBoardList") // 공지사항 목록
	public String getNoticeBoardList(FreeBoardVO vo, Model m, HttpSession session) {
		log.info("[BoardController - getNoticeBoardList()] 요청받음");

		// 1. 로그인 세션 확인 (로그인 유효성 검사)
		Object login = session.getAttribute("login");

		if (login == null) {
			return "redirect:/";
		}

		log.info("로그인 세션 정보: {}", login.toString());

		// 2. 공지사항 목록 조회
		List<NoticeBoardVO> result = boardService.getNoticeBoardList();

		m.addAttribute("noticeBoardList", result);

		log.info("--- NoticeBoard List Start ---");
		for (NoticeBoardVO board : result) {
			log.info("공지사항 목록 데이터: {}", board.toString());
		}
		log.info("--- NoticeBoard List End ---");

		// 3. 공지사항 목록 페이지 반환
		return "/board/getNoticeBoardList";
	}
	// end of getNoticeBoardList()
	// =======================================================================================

	//

	// =======================================================================================
	// insertNoticeBoard()
	@PostMapping("/board/insertNoticeBoard")
	public String insertNoticeBoard(NoticeBoardVO vo) {
		log.info("[BoardController - insertNoticeBoard()] 요청받음");

		// insert와 modify(update) 나누기~ (noticeNo의 존재 여부로 신규/수정 구분)
		if (vo.getNoticeNo() == null || vo.getNoticeNo().isEmpty()) {
			log.info("새 공지 작성");
			boardService.insertNoticeBoard(vo);
		} else {
			log.info("기존 공지 수정");
			boardService.updateNoticeBoard(vo);
		}

		// 목록 페이지로 리다이렉트
		return "redirect:/board/getNoticeBoardList";
	}
	// end of insertNoticeBoard()
	// =======================================================================================

	//

	// =======================================================================================
	// getContentNoticeBoard()
	@PostMapping("/board/getContentNoticeBoard")
	@ResponseBody

	public NoticeBoardVO getContentNoticeBoard(@RequestParam("noticeNo") String noticeNo) {
		log.info("[BoardController - getContentNoticeBoard()] 요청받음");

		// 공지 번호로 글 내용 조회
		NoticeBoardVO result = boardService.getContentNoticeBoard(noticeNo);

		return result; // JSON 형태로 반환
	}
	// end of getContentNoticeBoard()
	// =======================================================================================

	//

	// ************* 자유게시판 영역~ *************
	// =======================================================================================
	// getFreeBoardList()
	@GetMapping("/board/getFreeBoardList") //
	public String getFreeBoardList(FreeBoardVO vo, Model m, HttpSession session) {
		log.info("[BoardController - getFreeBoardList()] 요청받음");

		// 1. 로그인 세션 확인 (로그인 유효성 검사)
		Object login = session.getAttribute("login");

		if (login == null) {
			return "redirect:/";
		}

		log.info("로그인 세션 정보: {}", login.toString());

		// 2. 자유게시판 목록 조회
		List<FreeBoardVO> result = boardService.getFreeBoardList();

		m.addAttribute("freeBoardList", result);

		log.info("--- FreeBoardVO List Start ---");
		for (FreeBoardVO board : result) {
			log.info("자유게시판 목록 데이터: {}", board.toString());
		}
		log.info("--- FreeBoardVO List End ---");

		// 3. 자우게시판 목록 페이지 반환
		return "/board/getFreeBoardList";
	}
	// end of getFreeBoardList()
	// =======================================================================================

	// =======================================================================================
	// insertFreeBoard()
	@PostMapping("/board/insertFreeBoard")
	public String insertFreeBoard(FreeBoardVO vo) {
		log.info("[BoardController - insertFreeBoard()] 요청받음");

		// insert와 modify(update) 나누기~ (boardNo의 존재 여부로 신규/수정 구분)
		if (vo.getBoardNo() == null || vo.getBoardNo().isEmpty()) {
			log.info("새 자유 게시글 작성");
			boardService.insertFreeBoard(vo);
		} else {
			log.info("기존 자유 게시글 수정");
			boardService.updateFreeBoard(vo);
		}

		// 목록 페이지로 리다이렉트
		return "redirect:/board/getFreeBoardList";
	}
	// end of insertFreeBoard()
	// =======================================================================================

	// =======================================================================================
	// getContentFreeBoard()
	@PostMapping("/board/getContentFreeBoard")
	@ResponseBody
	public FreeBoardVO getContentFreeBoard(@RequestParam("boardNo") String boardNo) {
		log.info("[BoardController - getContentFreeBoard()] 요청받음");

		// 공지 번호로 글 내용 조회
		FreeBoardVO result = boardService.getContentFreeBoard(boardNo);

		return result; // JSON 형태로 반환
	}
	// end of getContentFreeBoard()
	// =======================================================================================

}