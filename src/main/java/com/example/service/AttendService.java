package com.example.service;

import java.util.List;

import com.example.domain.DayAttendVO;



public interface AttendService {
	public List<DayAttendVO> selectDayAttend(String empNo, String toDay);

}
