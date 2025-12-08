package com.example.repository;

import java.util.List;

import com.example.domain.DayAttendVO;
import com.example.domain.DocVO;

public interface AttendDAO {
	public List<DayAttendVO> selectDayAttend(String empNo, String toDay);

	public String checkIn(DayAttendVO davo);
	
	public String checkOut(DayAttendVO davo);
	
	public String fieldwork(DayAttendVO davo);
	
	public void insertVacation(DayAttendVO davo, Integer totalDays);
	
	public DayAttendVO selectDayAttend(DocVO vo);
	
	public void commuteCorrectionCheckIn(DayAttendVO davo);
	
	public void commuteCorrectionCheckOut(DayAttendVO davo);

}
