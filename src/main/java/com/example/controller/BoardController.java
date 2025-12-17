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

import com.example.domain.AlertVO;
import com.example.domain.FreeBoardVO;
import com.example.domain.LoginVO;
import com.example.domain.NoticeBoardVO;
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

	// ************* 공지사항 영역 *************

	@GetMapping("/board/getNoticeBoardList")
	public String getNoticeBoardList(Model m, HttpSession session, 
	                                 @RequestParam(value = "noticeNo", required = false) String noticeNo) { // 👈 파라미터 추가
	    Object login = session.getAttribute("login");
	    if (login == null) return "redirect:/";

	    LoginVO loginUser = (LoginVO) login;
	    Integer userDeptNo = Integer.parseInt(loginUser.getDeptNo());

	    // 1. 공지 목록 가져오기 (기존 로직 유지)
	    List<NoticeBoardVO> globalNotices = boardService.getGlobalNoticeList();
	    List<NoticeBoardVO> deptNotices = boardService.getDeptNoticeList(userDeptNo);

	    List<NoticeBoardVO> combinedList = new ArrayList<>();
	    if (globalNotices != null) combinedList.addAll(globalNotices);
	    if (deptNotices != null) combinedList.addAll(deptNotices);

	    m.addAttribute("noticeBoardList", combinedList);
	    
	    // ⭐ [추가] 알림을 타고 들어왔다면, 열어야 할 글 번호를 JSP로 전달
	    if (noticeNo != null) {
	        m.addAttribute("targetNoticeNo", noticeNo);
	    }

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
			sendNoticeAlert(vo);
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
	
	private void sendNoticeAlert(NoticeBoardVO vo) {
        List<String> targetEmpList;

        if (vo.getDeptNo() == 0) {
            // 전사 공지: 모든 사원 리스트 조회
            targetEmpList = empService.getAllEmpNoList();
        } else {
            // 부서 공지: 해당 부서 사원 리스트 조회
            targetEmpList = empService.getEmpNoListByDept(Integer.toString(vo.getDeptNo()));
        }

        for (String targetEmpNo : targetEmpList) {
            // 작성자 본인은 제외 (선택 사항)
            if (targetEmpNo.equals(vo.getEmpNo())) continue;

            AlertVO alert = new AlertVO();
            alert.setEmpNo(targetEmpNo);
            alert.setLinkType("BOARD");
            alert.setLinkId(Integer.parseInt(vo.getNoticeNo()));
            alert.setAlertStatus("NOTICE");
            
            String deptPrefix = (vo.getDeptNo() == 0) ? "[전체공지] " : "[부서공지] ";
            alert.setContent(deptPrefix + " " + vo.getNoticeTitle() + " 공지가 등록되었습니다.");

            // DB 저장 및 실시간 알림 전송 
            alertService.saveNewAlert(alert);
            notificationService.pushNewAlert(alert); 
        }
    }
}