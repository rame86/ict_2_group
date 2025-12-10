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

	@Autowired
	private BoardService boardService;

	// getNoticeBoardList() -------------------------
	// 공지 게시판 누르면 공지목록 가져오기~
	@GetMapping("/board/getNoticeBoardList")
	public String getNoticeBoardList(FreeBoardVO vo, Model m, HttpSession session) {
		log.info("BoardController - getNoticeBoardList 요청됨");
		Object login = session.getAttribute("login");

		if (login == null) {
			return "redirect:/";
		}

		log.info(login.toString());

		List<NoticeBoardVO> result = boardService.getNoticeBoardList();

		m.addAttribute("noticeBoardList", result);

		log.info("--- NoticeBoard List Start ---");
		for (NoticeBoardVO board : result) {
			log.info(board.toString());
		}
		log.info("--- NoticeBoard List End ---");

		log.info("getBoardList로");

		return "/board/getNoticeBoardList";
	}// end of getFreeBoardList() -------------------------

	// 새 공지 등록~~
	// insertNoticeBoard() -------------------------
	@PostMapping("/board/insertNoticeBoard")
	public String insertNoticeBoard(NoticeBoardVO vo) {
		log.info("BoardController - insertNoticeBoard 요청됨");

		// insert와 modify(update) 나누기~
		if (vo.getNoticeNo() == null || vo.getNoticeNo().isEmpty()) {
			log.info("새 공지 작성");
			boardService.insertNoticeBoard(vo);
		} else {
			log.info("기존 공지 수정");
			boardService.updateNoticeBoard(vo);
		}

		return "redirect:/board/getNoticeBoardList";
	}// end of insertNoticeBoard() -------------------------

	// 글 내용 가져오기~~
	// getContentNoticeBoard() -------------------------
	@PostMapping("/board/getContentNoticeBoard")
	@ResponseBody
	public NoticeBoardVO getContentNoticeBoard(@RequestParam("noticeNo") String noticeNo,Model m) {
		
		NoticeBoardVO result = boardService.getContentNoticeBoard(noticeNo);
		m.addAttribute("noticeContent", result);
		
		return result;
	}	
	// end of getContentNoticeBoard() -------------------------
}
