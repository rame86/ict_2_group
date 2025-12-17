package com.example.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
    
    @ModelAttribute("login")
    public LoginVO getLogin(HttpSession session) {
        return (LoginVO) session.getAttribute("login");
    }

    @GetMapping({"/", "/index", "/main"})
    public String index(@ModelAttribute("login") LoginVO login, Model m) {
        
        // 1. 로그인 체크
        if (login == null) {
            return "/member/login";
        }
        
        String empNo = login.getEmpNo();
        // LoginVO의 deptNo가 String이므로 Integer로 변환 (안전하게 처리)
        int deptNo = 0;
        try {
            deptNo = Integer.parseInt(login.getDeptNo());
        } catch (NumberFormatException e) {
            log.warn("부서 번호 변환 실패: " + login.getDeptNo());
        }

        // ==========================================
        // 2. [전자결재] 데이터
        // ==========================================
        try {
            List<ApproveListVO> waitingList = approveService.selectWaitingReceiveList(empNo);
            int receiveWaitCount = (waitingList != null) ? waitingList.size() : 0;
            
            Map<String, Integer> sendCountMap = approveService.getSendCount(empNo);
            int sendWaitCount = sendCountMap.getOrDefault("ACTIVE", 0);

            m.addAttribute("receiveWaitCount", receiveWaitCount);
            m.addAttribute("sendWaitCount", sendWaitCount);
            
        } catch (Exception e) {
            log.error("전자결재 데이터 로딩 실패", e);
        }

        // ==========================================
        // 3. [근태 관리] 데이터
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
                        // 상태값
                        if (vo.getAttStatus() != null) myStatus = vo.getAttStatus();
                        else myStatus = "근무중"; // 출근 기록은 있는데 상태가 없으면 근무중으로 간주
                        
                        // 시간 (YYYY-MM-DD HH:mm:ss -> HH:mm 추출)
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
            log.error("근태 데이터 로딩 실패", e);
        }
        
        // ==========================================
        // 4. [게시판] 데이터 (메소드명 수정 및 필터링 적용)
        // ==========================================
        try {
            // (1) 공지사항 가져오기 (전체 + 내 부서가 섞여서 옴)
            List<NoticeBoardVO> allNotices = boardService.getNoticeBoardList(deptNo);
            
            if (allNotices == null) allNotices = Collections.emptyList();

            // -> 전체 공지 (deptNo == 0) 필터링 & 최신 5개
            List<NoticeBoardVO> globalNotices = allNotices.stream()
                    .filter(n -> n.getDeptNo() != null && n.getDeptNo() == 0)
                    .limit(5)
                    .collect(Collectors.toList());

            // -> 부서 공지 (deptNo != 0) 필터링 & 최신 5개
            List<NoticeBoardVO> deptNotices = allNotices.stream()
                    .filter(n -> n.getDeptNo() != null && n.getDeptNo() != 0)
                    .limit(5)
                    .collect(Collectors.toList());
            
            m.addAttribute("noticeList", globalNotices);
            m.addAttribute("deptNoticeList", deptNotices);

            // (2) 자유게시판 가져오기
            List<FreeBoardVO> allFreeBoards = boardService.getFreeBoardList(deptNo);
            
            if (allFreeBoards == null) allFreeBoards = Collections.emptyList();

            // -> 최신 5개만 자르기
            List<FreeBoardVO> deptFreeList = allFreeBoards.stream()
                    .limit(5)
                    .collect(Collectors.toList());
            
            m.addAttribute("deptFreeList", deptFreeList);
            
        } catch (Exception e) {
            log.error("게시판 데이터 로딩 실패", e);
        }

        return "index";
    }
}