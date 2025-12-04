package com.example.service;

public interface MonthAttendService {

    /**
     * 지난 달 DAY_ATTEND 데이터를 기반으로
     * MONTH_ATTEND 테이블을 생성/갱신하는 배치 로직
     */
    void createMonthAttendForLastMonth();

    // 나중에 월별 리스트 조회 같은 것들도 여기로:
    // List<MonthAttendVO> getMonthAttendList(String empNo, String month);
}
