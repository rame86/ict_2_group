package com.example.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.DayAttendVO;
import com.example.domain.EmpVO;

@Repository
public class AttendDAOImpl implements AttendDAO {

	@Autowired
	private SqlSessionTemplate sess;
	
	@Override
	public List<DayAttendVO> selectDayAttend(EmpVO vo) {
		 List<DayAttendVO> result = sess.selectList("com.example.repository.DayAttendDAO.dayAttend",vo);
		 return result;
	}
	
}


