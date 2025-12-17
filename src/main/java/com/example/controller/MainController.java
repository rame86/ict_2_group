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
import com.example.domain.FreeBoardVO;
import com.example.domain.LoginVO;
import com.example.domain.NoticeBoardVO;
import com.example.service.ApproveService;
import com.example.service.AttendService;
import com.example.service.BoardService;

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
    
    // 로그인 세션 편의 메소드
    @ModelAttribute("login")
    public LoginVO getLogin(HttpSession session) {
        return (LoginVO) session.getAttribute("login");
    }

    @GetMapping({"/", "/index", "/main"})
    public String index(@ModelAttribute("login") LoginVO login, Model m) {
        
        // 1. 로그인 검사
        if (login == null) {
            return "redirect:/member/login"; 
        }
        
        String empNo = login.getEmpNo();
        int deptNo = 0;
        try {
            deptNo = Integer.parseInt(login.getDeptNo());
        } catch (Exception e) {}

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
                            if(myStatus.equals("근무중")) myStatus = "퇴근완료";
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
            if(globalNotices != null && globalNotices.size() > 5) {
                globalNotices = globalNotices.subList(0, 5);
            }
            m.addAttribute("noticeList", globalNotices);

            // (2) 부서 공지 (내 부서 + 하위 부서 모두 포함, 5개만)
            List<NoticeBoardVO> deptNotices = boardService.getDeptNoticeList(deptNo);
            if(deptNotices != null && deptNotices.size() > 5) {
                deptNotices = deptNotices.subList(0, 5);
            }
            m.addAttribute("deptNoticeList", deptNotices);

            // (3) 부서 자유게시판 (이름 수정됨: getDeptFreeBoardList)
            // ★ 여기가 문제였습니다. getFreeBoardList -> getDeptFreeBoardList 로 수정 ★
            List<FreeBoardVO> deptFreeList = boardService.getDeptFreeBoardList(deptNo);
            if(deptFreeList != null && deptFreeList.size() > 5) {
                deptFreeList = deptFreeList.subList(0, 5);
            }
            m.addAttribute("deptFreeList", deptFreeList);
            
        } catch (Exception e) {
             log.error("게시판 데이터 로딩 중 에러", e);
        }

        return "index";
    }
}