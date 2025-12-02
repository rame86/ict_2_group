package com.example.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.DayAttendVO;


import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class AttendDAOImpl implements AttendDAO {

	@Autowired
	private SqlSessionTemplate sess;

	public List<DayAttendVO> selectDayAttend(String empNo, String toDay) {
		log.info("[AttendDAO - selectDayAttend 요청 받음]");
		// 1. Map 객체 생성
		Map<String, Object> paramMap = new HashMap<>();

		// 2. 인자들을 Map에 담기
		// EmpVO 객체 자체를 "empVO"라는 이름으로 담고,
		// today 문자열을 "today"라는 이름으로 담습니다.
		paramMap.put("empNo", empNo);
		paramMap.put("today", toDay);
		log.info("paramMap 내용: {}", paramMap);

		// 3. Map을 Mybatis에 전달
		List<DayAttendVO> result = sess.selectList("com.example.repository.DayAttendDAO.dayAttend", paramMap);

		return result;
	}

}
