package com.example.service;

import java.util.List;

import com.example.domain.DayAttendVO;
import com.example.domain.DocVO;

public interface AttendService {
	
	// 달력 화면 및 조회용
	public List<DayAttendVO> selectDayAttend(String empNo, String toDay);

	// 출근
	public String checkIn(DayAttendVO davo);

	// 퇴근
	public String checkOut(DayAttendVO davo);

	// 외근
	public String fieldwork(DayAttendVO davo);

	// 휴가 처리 (DocVO 받아서 내부에서 DayAttendVO로 변환 및 반복문 처리)
	public void insertVacation(DocVO vo);

	// 근태 수정 요청 처리
	public void commuteCorrection(DocVO vo);
	
	// 결근 일괄 처리
	public int processDailyAbsence();

	// 미퇴근자 처리
	public int processIncompleteAttendance();

}