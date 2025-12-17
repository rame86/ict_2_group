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
import com.example.domain.LoginVO;
import com.example.service.ApproveService;
import com.example.service.AttendService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MainController {

    @Autowired
    private ApproveService approveService;
    
    @Autowired
    private AttendService attendService; // [추가] 근태 서비스 주입
    
    @ModelAttribute("login")
    public LoginVO getLogin(HttpSession session) {
        return (LoginVO) session.getAttribute("login");
    }

    @GetMapping({"/", "/index", "/main"})
    public String index(@ModelAttribute("login") LoginVO login, Model m) {
        
        // 1. 로그인 검사
        if (login == null) {
            return "/member/login";
        }
        
        String empNo = login.getEmpNo();

        // 2. [전자결재] 데이터 바인딩
        try {
            List<ApproveListVO> waitingList = approveService.selectWaitingReceiveList(empNo);
            int receiveWaitCount = (waitingList != null) ? waitingList.size() : 0;
            
            Map<String, Integer> sendCountMap = approveService.getSendCount(empNo);
            int sendWaitCount = sendCountMap.getOrDefault("ACTIVE", 0);

            m.addAttribute("receiveWaitCount", receiveWaitCount);
            m.addAttribute("sendWaitCount", sendWaitCount);
            
        } catch (Exception e) {
            log.error("전자결재 데이터 로딩 중 에러: " + e.getMessage());
        }

        // ==========================================
        // 3. [추가] 근태 관리 데이터 바인딩
        // ==========================================
        try {
            // (1) 오늘 날짜 구하기 (YYYY-MM-DD)
            LocalDate now = LocalDate.now();
            String todayStr = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            String currentMonth = now.format(DateTimeFormatter.ofPattern("yyyy-MM"));

            // (2) 이번 달 근태 목록 가져오기
            List<DayAttendVO> monthList = attendService.selectDayAttend(empNo, currentMonth);
            
            // (3) 오늘 날짜의 기록 찾기
            DayAttendVO todayAttend = null;
            if (monthList != null) {
                for (DayAttendVO vo : monthList) {
                    // vo.getDateAttend()는 "yyyy-MM-dd HH:mm:ss" 포맷일 수 있으므로 앞 10자리 비교
                    if (vo.getDateAttend() != null && vo.getDateAttend().startsWith(todayStr)) {
                        todayAttend = vo;
                        break;
                    }
                }
            }
            
            // (4) 화면에 보낼 데이터 가공
            String myStatus = "미출근";
            String myInTime = "-";
            String myOutTime = "-";

            if (todayAttend != null) {
                // 출근 시간 파싱 (YYYY-MM-DD HH:mm:ss -> HH:mm)
                if (todayAttend.getInTime() != null && todayAttend.getInTime().length() > 11) {
                    myInTime = todayAttend.getInTime().substring(11, 16);
                    myStatus = "근무중"; // 기본값
                }
                
                // 퇴근 시간 파싱
                if (todayAttend.getOutTime() != null && todayAttend.getOutTime().length() > 11) {
                    myOutTime = todayAttend.getOutTime().substring(11, 16);
                    myStatus = "퇴근완료";
                }
                
                // 상태값(지각, 조퇴 등)이 있으면 그것을 우선 표시
                if (todayAttend.getAttStatus() != null) {
                    // AttendDAOImpl에서 이미 한글로 변환해서 줌 (출근, 지각, 조퇴 등)
                    myStatus = todayAttend.getAttStatus();
                }
            }

            m.addAttribute("myStatus", myStatus);
            m.addAttribute("myInTime", myInTime);
            m.addAttribute("myOutTime", myOutTime);

        } catch (Exception e) {
            log.error("근태 데이터 로딩 중 에러: " + e.getMessage());
        }

        return "index";
    }
}