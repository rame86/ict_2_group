package com.example.controller;

import java.util.ArrayList; // 리스트 합치기 위해 추가
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
        Object login = session.getAttribute("login");
        if (login == null) return "redirect:/";

        LoginVO loginUser = (LoginVO) login;
        Integer userDeptNo = Integer.parseInt(loginUser.getDeptNo());

        // 1. 전사 공지 가져오기
        List<NoticeBoardVO> globalNotices = boardService.getGlobalNoticeList();
        
        // 2. 부서 공지 (하위 부서 포함 계층형) 가져오기
        List<NoticeBoardVO> deptNotices = boardService.getDeptNoticeList(userDeptNo);

        // 3. [중요] JSP 로직에 맞춰 두 리스트를 하나로 합침
        List<NoticeBoardVO> combinedList = new ArrayList<>();
        if (globalNotices != null) combinedList.addAll(globalNotices);
        if (deptNotices != null) combinedList.addAll(deptNotices);

        // 4. JSP 변수명인 'noticeBoardList'로 전달
        m.addAttribute("noticeBoardList", combinedList);

        return "/board/getNoticeBoardList";
    }

	@PostMapping("/board/insertNoticeBoard")
	public String insertNoticeBoard(NoticeBoardVO vo, HttpSession session) {
		LoginVO login = (LoginVO) session.getAttribute("login");
		if(login != null) {
			vo.setEmpNo(login.getEmpNo());
			vo.setNoticeWriter(login.getEmpName());
		}
		
		// JSP <select>에서 넘어온 deptNo (0 또는 부서번호) 사용
		// 만약 값이 없으면 기본값(내 부서) 설정
		if (vo.getDeptNo() == null) {
			vo.setDeptNo(Integer.parseInt(login.getDeptNo()));
		}

		if (vo.getNoticeNo() == null || vo.getNoticeNo().isEmpty()) {
			boardService.insertNoticeBoard(vo);
		} else {
			boardService.updateNoticeBoard(vo);
		}
		return "redirect:/board/getNoticeBoardList";
	}

	@PostMapping("/board/getContentNoticeBoard")
	@ResponseBody
	public NoticeBoardVO getContentNoticeBoard(@RequestParam("noticeNo") String noticeNo) {
		return boardService.getContentNoticeBoard(noticeNo);
	}


	// ************* 자유게시판 영역 (기존 유지) *************

	@GetMapping("/board/getFreeBoardList")
    public String getFreeBoardList(Model m, HttpSession session) {
        Object login = session.getAttribute("login");
        if (login == null) return "redirect:/";

        LoginVO loginUser = (LoginVO) login;
        Integer userDeptNo = Integer.parseInt(loginUser.getDeptNo());

        // 1. [전체 자유게시판] 가져오기
        List<FreeBoardVO> globalFreeBoards = boardService.getGlobalFreeBoardList();
        
        // 2. [부서 자유게시판] (내 부서 + 하위 부서) 가져오기
        List<FreeBoardVO> deptFreeBoards = boardService.getDeptFreeBoardList(userDeptNo);
        
        // 3. JSP 변수명인 'freeBoardList'로 전달하기 위해 두 리스트를 하나로 합침
        List<FreeBoardVO> combinedList = new ArrayList<>();
        if (globalFreeBoards != null) combinedList.addAll(globalFreeBoards);
        if (deptFreeBoards != null) combinedList.addAll(deptFreeBoards);

        m.addAttribute("freeBoardList", combinedList);
        return "/board/getFreeBoardList";
    }

	@PostMapping("/board/insertFreeBoard")
    public String insertFreeBoard(FreeBoardVO vo, HttpSession session) {
        LoginVO login = (LoginVO) session.getAttribute("login");
        if(login != null) {
            vo.setEmpNo(login.getEmpNo());
            vo.setBoardWriter(login.getEmpName());
            if(vo.getDeptNo() == null) {
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
	
	@PostMapping("/board/getContentFreeBoard")
	@ResponseBody
	public FreeBoardVO getContentFreeBoard(@RequestParam("boardNo") String boardNo) {
		return boardService.getContentFreeBoard(boardNo);
	}
}