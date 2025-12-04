package com.example.service;

import java.util.List;

import com.example.domain.DayAttendVO;

public interface AttendService {
	// 달력 화면에서 쓰는 일별 근태 조회
	public List<DayAttendVO> selectDayAttend(String empNo, String toDay);

	public String checkIn(DayAttendVO davo);

	public String checkOut(DayAttendVO davo);

	public String fieldwork(DayAttendVO davo);
	
}
