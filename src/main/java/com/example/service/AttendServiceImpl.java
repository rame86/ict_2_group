package com.example.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.example.domain.DayAttendVO;
import com.example.domain.EmpVO;
import com.example.repository.AttendDAO;

@Service
public class AttendServiceImpl implements AttendService {

	@Autowired
	private AttendDAO attendDAO;
	
	@Override
	public List<DayAttendVO> selectDayAttend(EmpVO vo) {
		 List<DayAttendVO> result = attendDAO.selectDayAttend(vo);
		 return result;
	}
	
}


