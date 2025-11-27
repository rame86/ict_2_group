package com.example.repository;

import java.util.List;

import com.example.domain.DayAttendVO;
import com.example.domain.EmpVO;

public interface AttendDAO {
	public List<DayAttendVO> selectDayAttend(EmpVO vo);

}
