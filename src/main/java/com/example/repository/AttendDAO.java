package com.example.repository;

import java.util.List;

import com.example.domain.DayAttendVO;

public interface AttendDAO {
	public List<DayAttendVO> selectDayAttend(String empNo, String toDay);

	public String checkIn(DayAttendVO davo);
	
	public String checkOut(DayAttendVO davo);
	
	public String fieldwork(DayAttendVO davo);

}
