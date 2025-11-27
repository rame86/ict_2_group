package com.example.service;

import java.util.List;

import com.example.domain.DayAttendVO;
import com.example.domain.EmpVO;

public interface AttendService {
	public List<DayAttendVO> selectDayAttend(EmpVO vo);

}
