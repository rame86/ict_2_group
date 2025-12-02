package com.example.repository;

import java.util.List;

import com.example.domain.DayAttendVO;
import com.example.domain.LoginVO;

public interface AttendDAO {
	public List<DayAttendVO> selectDayAttend(String empNo,String toDay);

}
