package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.domain.BoardVO;
import com.example.service.BoardService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BoardController {

	@Autowired
	private BoardService boardService;

	@GetMapping("/board/getBoardList")
	public String getFreeBoardList(BoardVO vo, Model m, HttpSession session) {
		log.info("BoardController - getBoardList 요청됨");
		Object login = session.getAttribute("login");

		if (login == null) {
			return "redirect:/";
		}

		log.info(login.toString());

		List<BoardVO> result = boardService.getFreeBoardList();

		m.addAttribute("freeBoardList", result);
		
		
		

		log.info("--- FreeBoard List Start ---");
		for (BoardVO board : result) {
			log.info(board.toString());
		}
		log.info("--- FreeBoard List End ---");

		log.info("getBoardList로");

		return "/board/getBoardList";

	}
}
