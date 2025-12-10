package com.example.controller;

import lombok.extern.slf4j.Slf4j;

import java.io.File;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.domain.BoardVO;
import com.example.domain.FileVO;
import com.example.service.BoardService;
import com.example.util.MD5Generator;

import jakarta.servlet.http.HttpSession;

@Slf4j
@Controller

public class BoardController {

	// -- 의존성 주입(Dependency Injection, DI) --
	@Autowired
	private BoardService boardService;

	//

	// getBoardList() --------------------
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

	}// end of getBoardList()

	//

	// getBoard() --------------------
	@GetMapping("/board/getBoard")
	public void getBoard(BoardVO vo, Model m) {
		log.info("[BoardController - board/getBoard] 요청");

		HashMap result = boardService.getBoard(vo);

		m.addAttribute("getBoard", result);
	}// end of getBoard()

	//

	// insertBoard() --------------------
	@GetMapping("/board/insertBoard")
	public void insertBoard() {
		log.info("[BoardController - board/insertBoard] 요청");
	} // end of insertBoard()

	//

	// updateBoard() --------------------
	@PostMapping("/board/updateBoard")
	public String updateBoard(BoardVO vo) {
		log.info("[BoardController - board/updateBoard] 요청 :" + vo.toString());
		boardService.updateBoard(vo);

		return "redirect:/board/getBoard?seq=" + vo.getBoardNo();
	}// end of updateBoard()

	//

	// deleteBoard() --------------------
	@GetMapping("/board/deleteBoard")
	public String deleteBoard(BoardVO vo) {
		log.info("[BoardController - board/deleteBoard] 요청" + vo.toString());
		boardService.deleteBoard(vo);

		return "redirect:/board/getBoardList";
	}// end of deleteBoard()

	//

	// saveBoard() --------------------
	@PostMapping("/board/saveBoard")
	public String saveBoard(@RequestParam("file") MultipartFile files, BoardVO vo) {
		log.info("[BoardController - board/saveBoard] 요청 - 회원가입 정보: " + vo.toString());

		// fileUpload
		try {

			String originalFilename = files.getOriginalFilename();
			log.info("원본파일명:" + originalFilename);

			if (originalFilename != null && !originalFilename.equals("")) {
				String filename = new MD5Generator(originalFilename).toString();

				// ------------------------------------
				// 확장자 추출 로직 시작
				// 파일 이름에서 마지막 . 의 인덱스를 찾아 dotIndex에 저장함
				int dotIndex = originalFilename.lastIndexOf(".");

				// . 이 발견되었고, . 이 파일 이름의 마지막이 아닌 경우 (확장자가 있는 경우)
				String fileExt = "";
				if (dotIndex > 0 && dotIndex < originalFilename.length() - 1) {
					// . 을 포함하여 그 뒤의 문자열을 잘라서 fileExt에 넣음. (예: .jpg)
					fileExt = originalFilename.substring(dotIndex);
				}

				// 변경된 파일 이름에 확장자 붙여 finalFilename 변수에 저장
				String finalFilename = filename + fileExt;

				log.info("변경파일명: " + finalFilename);
				// ------------------------------------

				// file 경로 지정
				String savepath = System.getProperty("user.dir") + "\\src\\main\\resources\\static\\files\\board";
				log.info("저장경로:" + savepath);
				// 경로 해당하는 디렉토리가 존재하지 않을경우 해당 경로에 디렉토리 생성
				if (!new File(savepath).exists()) {
					// mkdir : 지정된 단일 디렉토리를 생성
					// mkdirs : 지정된 디렉토리를 생성하며, 그 경로에 필요한 존재하지 않는 모든 부모 디렉토리까지 함께 생성
					new File(savepath).mkdir();
				}

				// 저장하기
				String filepath = savepath + "\\" + finalFilename;

				files.transferTo(new File(filepath));
				log.info(filepath + "에 저장됨");
				// 파일 완성됨

				FileVO fileVO = new FileVO();

				fileVO.setOriginfilename(originalFilename);
				fileVO.setFilename(finalFilename);
				fileVO.setFilepath(filepath);

				boardService.saveBoard(vo, fileVO);

			} else {
				boardService.saveBoard(vo, null);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} // end of fileUpload
		return "redirect:/board/getBoardList";
	}// end of saveBoard()
}
