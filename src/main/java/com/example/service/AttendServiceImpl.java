package com.example.service;

import java.util.List;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.DayAttendVO;
import com.example.repository.AttendDAO;
import com.example.repository.MonthAttendMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AttendServiceImpl implements AttendService {

	@Autowired
	private AttendDAO attendDAO;
	@Autowired
    private MonthAttendMapper monthAttendMapper;

	public List<DayAttendVO> selectDayAttend(String empNo, String toDay) {
		log.info("[AttendService - selectDayAttend 요청 받음]");
		List<DayAttendVO> result = attendDAO.selectDayAttend(empNo, toDay);
		return result;
	}

	public String checkIn(DayAttendVO davo) {
		return attendDAO.checkIn(davo);
	}

	public String checkOut(DayAttendVO davo) {
		return attendDAO.checkOut(davo);
	}
	
	public String fieldwork(DayAttendVO davo) {
		return attendDAO.fieldwork(davo);
	}
	
	 @Override
	    public void createMonthAttendForLastMonth() {

	        // 🔹 오늘 기준 전월(YYYY-MM) 구하기
	        LocalDate now = LocalDate.now();
	        LocalDate lastMonth = now.minusMonths(1);
	        String targetMonth = lastMonth.format(DateTimeFormatter.ofPattern("yyyy-MM"));

	        log.info("============== MONTH_ATTEND 생성 시작 ==============");
	        log.info("타겟 월 : {}", targetMonth);

	        int inserted = monthAttendMapper.insertMonthAttendByMonth(targetMonth);

	        log.info("INSERT 결과: {} 행 삽입됨", inserted);
	        log.info("============== MONTH_ATTEND 생성 종료 ==============");
	    }
}
