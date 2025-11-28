package com.example.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.DayAttendVO;
import com.example.domain.EmpVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class AttendDAOImpl implements AttendDAO {

	@Autowired
	private SqlSessionTemplate sess;
	
	@Override
	public List<DayAttendVO> selectDayAttend(EmpVO vo) {
		log.info("[AttendDAO-selectDayAttend 요청 받음]");	 
		 List<DayAttendVO> result = sess.selectList("com.example.repository.DayAttendDAO.dayAttend", vo);
		 return result;
	}
	
}


