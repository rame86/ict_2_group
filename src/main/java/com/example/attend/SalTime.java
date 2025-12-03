package com.example.attend;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.service.SalService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 월별 급여 자동 생성 배치
 * - MONTH_ATTEND 집계가 끝난 지난달 데이터를 기준으로 SAL에 급여를 생성
 * - SalService#createSalaryByMonth(String targetMonth) 를 호출해서 처리
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class SalTime {

    private final SalService salService;

    // ===================== 실제 운용용 스케줄 =====================
    // 매달 15일 새벽 2시에 지난달 급여 생성
    // (예: 2025-12-15 02:00 에 2025-11월 급여 생성)
    @Scheduled(cron = "0 0 2 15 * ?")
    public void runMonthlySalaryBatch() {

        // 오늘 기준으로 지난달(YYYY-MM) 계산
        LocalDate today = LocalDate.now();
        YearMonth target = YearMonth.from(today).minusMonths(1);
        String targetMonth = target.format(DateTimeFormatter.ofPattern("yyyy-MM"));

        log.info("============== SAL 배치 시작 ==============");
        log.info("▶ 타겟 월(급여 기준월) : {}", targetMonth);

        // createSalaryByMonth 가 int(삽입 행 수)를 리턴하도록 되어 있어야 함
        int inserted = salService.createSalaryByMonth(targetMonth);

        log.info("▶ SAL INSERT 결과: {} 행 삽입됨", inserted);
        log.info("============== SAL 배치 종료 ==============");
    }

    // ===================== 테스트용 스케줄 (원하면 사용) =====================
    // 개발/테스트 중에만 잠깐 열어서 동작 확인할 때 썼던 버전이에요.
    // 필요할 때만 주석 풀어서 사용하세요.
    /*
    @Scheduled(fixedRate = 60000) // 60초마다 한 번씩 실행
    public void testSalaryBatch() {
        String targetMonth = "2025-11";   // 테스트용 고정 값

        log.info("===== [테스트용] SAL 배치 시작 : {} =====", targetMonth);
        int inserted = salService.createSalaryByMonth(targetMonth);
        log.info("===== [테스트용] SAL 배치 종료 : {} 행 삽입 =====", inserted);
    }
    */
}
