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
		// Map 객체 생성
		Map<String, Object> param = new HashMap<>();

		// 인자들 Map에 담기
		param.put("empNo", empNo);
		param.put("toDay", toDay);
		log.info("paramMap 내용: {}", param);

		// 3. Map을 Mybatis에 전달
		List<DayAttendVO> result = sess.selectList("com.example.repository.DayAttendDAO.dayAttend", param);

		return result;
	}

	public String checkIn(DayAttendVO davo) {
		log.info("[AttendDAO - checkIn 요청 받음]");

		String checkInTime = "";
		DayAttendVO currentInTime;
		log.info("인자값 - davo 내용: " + davo.toString());
		// 데이터가 있는지 먼저 확인~
		DayAttendVO dateCheck = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
		if (dateCheck == null) {
			sess.insert("com.example.repository.DayAttendDAO.insertCheckIn", davo);
			currentInTime = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
			checkInTime = currentInTime.getInTime();
		} else {
			log.info("dateInTimeCheck 내용: "+ dateCheck.toString());
			checkInTime = dateCheck.getInTime();
			davo.setDayAttno(dateCheck.getDayAttno());
			if (checkInTime == null) {
				sess.update("com.example.repository.DayAttendDAO.updateCheckIn", davo);
				currentInTime = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
				checkInTime = currentInTime.getInTime();
			}
		}

		return checkInTime;
	}

	public String checkOut(DayAttendVO davo) {
		log.info("[AttendDAO - checkOut 요청 받음]");


		String checkOutTime = "";
		String status = davo.getAttStatus();
		DayAttendVO currentOutTime;
		
		log.info("인자값 - davo 내용: " + davo.toString());
		
		// 데이터가 있는지 먼저 확인~
		DayAttendVO dateCheck = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
		// 데이터가 없을 경우~
		if (dateCheck == null) {			
			checkOutTime = "출근 데이터가 없습니다.";
			return checkOutTime;
		} 
		
		// 데이터가 있을경우~
		else {			
			log.info("dateInTimeCheck 내용: "+ dateCheck.toString());
			
			String checkStatus = dateCheck.getAttStatus();							
			davo.setDayAttno(dateCheck.getDayAttno());
			// 정상 출근이고 입력값이 조퇴가 아닐 경우~
			if (status.equals("null")) {
				// 인자의 상태값에 데이터에 있는 출근 상태 값을 그대로 넣음~				
				davo.setAttStatus(checkStatus);				
				sess.update("com.example.repository.DayAttendDAO.updateCheckOut", davo);
				
			}
			// 조퇴일 경우~
			else {
				// controller 단에서 넣은 조퇴 상태값 그대로 ㄱㄱ
				sess.update("com.example.repository.DayAttendDAO.updateCheckOut", davo);
			}
			currentOutTime = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
			checkOutTime = currentOutTime.getOutTime();
		}

		return checkOutTime;
	}
}
