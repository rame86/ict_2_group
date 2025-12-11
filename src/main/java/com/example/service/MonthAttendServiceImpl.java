package com.example.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.repository.MonthAttendMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MonthAttendServiceImpl implements MonthAttendService {

    @Autowired
    private MonthAttendMapper monthAttendMapper;

    @Override
    public void createMonthAttendForLastMonth() {
        log.info("[MonthAttendServiceImpl] 월근태 생성 시작");

        // 1) 지난 달 YYYY-MM 구하기
        LocalDate now = LocalDate.now();
        LocalDate lastMonth = now.minusMonths(1);
        String targetMonth = lastMonth.format(DateTimeFormatter.ofPattern("yyyy-MM"));

        log.info("[MonthAttendServiceImpl] targetMonth = {}", targetMonth);

        // 2) 이미 집계가 있는지 확인
        int exists = monthAttendMapper.existsMonthAttend(targetMonth);
        if (exists > 0) {
            log.info("[MonthAttendServiceImpl] {} 월 데이터 이미 존재. 생성 스킵", targetMonth);
            return;
        }

        // 3) 없으면 INSERT 수행
        int inserted = monthAttendMapper.insertMonthAttendByMonth(targetMonth);
        log.info("[MonthAttendServiceImpl] {} 월 데이터 생성 완료 ({} 건)", targetMonth, inserted);
    }

	@Override
	public void createDefaultForNewEmp(String empNo) throws Exception {
		 System.out.println("📌 [MonthAttend] 신규 사원 기본 근태 생성: empNo = " + empNo);
		
	}
}
