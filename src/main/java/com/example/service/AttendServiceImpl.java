package com.example.service;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;

import com.example.domain.DayAttendVO;
import com.example.domain.EmpVO;
import com.example.repository.AttendDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AttendServiceImpl implements AttendService {

	@Autowired
	private AttendDAO attendDAO;
	
	@Override
	public List<DayAttendVO> selectDayAttend(EmpVO vo) {
		log.info("[AttendService - selectDayAttend 요청 받음]");	 
		List<DayAttendVO> result = attendDAO.selectDayAttend(vo);
		 return result;
	}
	
}


