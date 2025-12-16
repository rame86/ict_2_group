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
import com.example.domain.LoginVO;
import com.example.service.BoardService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BoardController {

	@Autowired
	private BoardService boardService;

	// ************* 공지사항 영역 *************

	@GetMapping("/board/getNoticeBoardList")
	public String getNoticeBoardList(Model m, HttpSession session) {
		log.info("[BoardController - getNoticeBoardList()] 요청받음");

		// 🚨 수정: EmpVO -> LoginVO 로 변경
		Object login = session.getAttribute("login");

		if (login == null) {
			return "redirect:/";
		}

		// 세션에 저장된 객체가 LoginVO이므로 LoginVO로 캐스팅해야 합니다.
		LoginVO loginUser = (LoginVO) login; 

		// LoginVO에 deptNo 필드와 getter가 있어야 합니다. (아래 2번 항목 확인)
		Integer userDeptNo = Integer.parseInt(loginUser.getDeptNo()); 
		
		log.info("로그인 사용자: {}, 부서번호: {}", loginUser.getEmpName(), userDeptNo);

		// 부서번호 전달
		List<NoticeBoardVO> result = boardService.getNoticeBoardList(userDeptNo);

		m.addAttribute("noticeBoardList", result);
		return "/board/getNoticeBoardList";
	}

	@PostMapping("/board/insertNoticeBoard")
	public String insertNoticeBoard(NoticeBoardVO vo) {
		log.info("[BoardController - insertNoticeBoard()] 요청받음");
		log.info("입력된 게시판 정보: Title={}, DeptNo={}", vo.getNoticeTitle(), vo.getDeptNo());

		if (vo.getNoticeNo() == null || vo.getNoticeNo().isEmpty()) {
			log.info("새 공지 작성");
			boardService.insertNoticeBoard(vo);
		} else {
			log.info("기존 공지 수정");
			boardService.updateNoticeBoard(vo);
		}
		return "redirect:/board/getNoticeBoardList";
	}

	@PostMapping("/board/getContentNoticeBoard")
	@ResponseBody
	public NoticeBoardVO getContentNoticeBoard(@RequestParam("noticeNo") String noticeNo) {
		return boardService.getContentNoticeBoard(noticeNo);
	}


	// ************* 자유게시판 영역 *************

	@GetMapping("/board/getFreeBoardList")
	public String getFreeBoardList(Model m, HttpSession session) {
		log.info("[BoardController - getFreeBoardList()] 요청받음");

		// 🚨 수정: EmpVO -> LoginVO 로 변경
		Object login = session.getAttribute("login");

		if (login == null) {
			return "redirect:/";
		}

		LoginVO loginUser = (LoginVO) login;
		Integer userDeptNo = Integer.parseInt(loginUser.getDeptNo());
		
		log.info("로그인 사용자: {}, 부서번호: {}", loginUser.getEmpName(), userDeptNo);

		List<FreeBoardVO> result = boardService.getFreeBoardList(userDeptNo);

		m.addAttribute("freeBoardList", result);
		return "/board/getFreeBoardList";
	}

	@PostMapping("/board/insertFreeBoard")
	public String insertFreeBoard(FreeBoardVO vo) {
		log.info("[BoardController - insertFreeBoard()] 요청받음");
		log.info("입력된 게시판 정보: Title={}, DeptNo={}", vo.getBoardTitle(), vo.getDeptNo());

		if (vo.getBoardNo() == null || vo.getBoardNo().isEmpty()) {
			log.info("새 자유 게시글 작성");
			boardService.insertFreeBoard(vo);
		} else {
			log.info("기존 자유 게시글 수정");
			boardService.updateFreeBoard(vo);
		}
		return "redirect:/board/getFreeBoardList";
	}

	@PostMapping("/board/getContentFreeBoard")
	@ResponseBody
	public FreeBoardVO getContentFreeBoard(@RequestParam("boardNo") String boardNo) {
		return boardService.getContentFreeBoard(boardNo);
	}
}