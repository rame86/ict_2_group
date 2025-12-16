package com.example.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.DayAttendVO;
import com.example.domain.DocVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class AttendDAOImpl implements AttendDAO {

	@Autowired
	private SqlSessionTemplate sess;

	// =======================================================================================
	// selectDayAttend()
	public List<DayAttendVO> selectDayAttend(String empNo, String toDay) {
		log.info("[AttendDAO - selectDayAttend 요청 받음]");
		Map<String, Object> param = new HashMap<>();
		param.put("empNo", empNo);
		param.put("toDay", toDay);
		log.info("paramMap 내용: {}", param);

		List<DayAttendVO> result = sess.selectList("com.example.repository.DayAttendDAO.dayAttend", param);
		
		// 한글 상태값 변환
		for (DayAttendVO vo : result) {
			String attStatusCode = vo.getAttStatus();
			String koreanStatus = "알 수 없음";
			if(attStatusCode != null) {
				switch (attStatusCode) {
				case "0": koreanStatus = "퇴근"; break;
				case "1": koreanStatus = "출근"; break;
				case "2": koreanStatus = "지각"; break;
				case "3": koreanStatus = "조퇴"; break;
				case "4": koreanStatus = "외근"; break;
				case "5": koreanStatus = "연차"; break;
				case "6": koreanStatus = "오전반차"; break;
				case "7": koreanStatus = "오후반차"; break;
				case "8": koreanStatus = "병가"; break;
				case "9": koreanStatus = "보상휴가"; break;
				case "10": koreanStatus = "결근"; break;
				case "11": koreanStatus = "출장"; break;
				}
			}
			vo.setAttStatus(koreanStatus);
		}
		return result;
	}
	// end of selectDayAttend()
	// =======================================================================================

	//

	// =======================================================================================
	// checkIn()
	public String checkIn(DayAttendVO davo) {
		log.info("[AttendDAO - checkIn 요청 받음]");
		log.info("인자값 - davo 내용: " + davo.toString());

		String checkInTime = "";
		DayAttendVO dateCheck = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);

		if (dateCheck == null) {
			log.info("오늘 출근 기록이 없으므로 새로운 레코드를 삽입합니다.");
			sess.insert("com.example.repository.DayAttendDAO.insertCheckIn", davo);
			DayAttendVO currentData = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
			checkInTime = currentData.getInTime();
		} else {
			davo.setDayAttno(dateCheck.getDayAttno());
			if (dateCheck.getInTime() != null) {
				log.warn("이미 출근 시간이 기록되어 있습니다.");
				checkInTime = dateCheck.getInTime();
			} else {
				log.info("기존 레코드(결근/휴가 등)에 출근 시간 업데이트");
				sess.update("com.example.repository.DayAttendDAO.updateCheckIn", davo);
				DayAttendVO currentData = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
				checkInTime = currentData.getInTime();
			}
		}
		return checkInTime;
	}
	// end of checkIn()
	// =======================================================================================

	//
	
	// =======================================================================================
	// selectDateCheck() Service에서 사용 (데이터 존재 확인용)
	public DayAttendVO selectDateCheck(DayAttendVO davo) {
		log.info("[AttendDAO - selectDateCheck 요청 받음]");
		return sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
	}
	// end of selectDateCheck()
	// =======================================================================================

	//

	// =======================================================================================
	// checkOut() - 인터페이스 유지용 (실제 로직은 Service로 이동됨)
	public String checkOut(DayAttendVO davo) {
		log.info("[AttendDAO - checkOut (Deprecated) 요청 받음 - Service에서 로직 처리됨]");
		return null; 
	}
	// end of checkOut()
	// =======================================================================================

	//
	
	// =======================================================================================
	// updateCheckOut() Service에서 호출
	public void updateCheckOut(DayAttendVO davo) {
		log.info("[AttendDAO - updateCheckOut 요청 받음]");
		sess.update("com.example.repository.DayAttendDAO.updateCheckOut", davo);
	}
	// end of updateCheckOut()
	// =======================================================================================

	//

	// =======================================================================================
	// updateDayFullTime() Service에서 호출
	public void updateDayFullTime(DayAttendVO davo) {
		log.info("[AttendDAO - updateDayFullTime 요청 받음]");
		log.info("[AttendDAO - updateDayFullTime - FullTime값 : " + davo.getDayFulltime() + "]");
		sess.update("com.example.repository.DayAttendDAO.updateDayFullTime", davo);
	}
	// end of updateDayFullTime()
	// =======================================================================================

	//

	// =======================================================================================
	// fieldwork()
	public String fieldwork(DayAttendVO davo) {
		log.info("[AttendDAO - fieldwork 요청 받음]");
		
		DayAttendVO dateCheck = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
		if (dateCheck == null) {
			return "출근 데이터가 없습니다.";
		} else {
			log.info("[AttendDAO - fieldwork - dateCheck 내용: " + dateCheck.toString() + "]");
			String checkStatus = dateCheck.getAttStatus();
			davo.setDayAttno(dateCheck.getDayAttno());
			if (checkStatus.equals("1") || checkStatus.equals("0")) {
				davo.setAttStatus("4");
			} else {
				davo.setAttStatus(checkStatus);
			}
			sess.update("com.example.repository.DayAttendDAO.updateFieldwork", davo);
			
			return davo.getOutTime(); 
		}
	}
	// end of fieldwork()
	// =======================================================================================

	//

	// =======================================================================================
	// countAttendRecordByDate()
	public int countAttendRecordByDate(DayAttendVO davo) {
		// 단순 조회라 로그 생략 가능하지만 요청대로 추가함
		// log.info("[AttendDAO - countAttendRecordByDate 요청]"); 
		return sess.selectOne("com.example.repository.DayAttendDAO.countAttendRecordByDate", davo);
	}
	// end of countAttendRecordByDate()
	// =======================================================================================

	//

	// =======================================================================================
	// insertVacation()
	public void insertVacation(DayAttendVO davo) {
		log.info("[AttendDAO - insertVacation 요청 받음]");
		sess.insert("com.example.repository.DayAttendDAO.insertVacation", davo);
	}
	// end of insertVacation()
	// =======================================================================================

	//

	// =======================================================================================
	// selectDayAttend() (DocVO 오버로딩)
	public DayAttendVO selectDayAttend(DocVO vo) {
		log.info("[AttendDAO - selectDayAttend(DocVO) 요청 받음]");
		return sess.selectOne("com.example.repository.DayAttendDAO.selectDayAttend", vo);
	}
	// end of selectDayAttend()
	// =======================================================================================

	//

	// =======================================================================================
	// commuteCorrectionCheckIn()
	public void commuteCorrectionCheckIn(DayAttendVO davo) {
		log.info("[AttendDAO - commuteCorrectionCheckIn 요청 받음]");
		sess.update("com.example.repository.DayAttendDAO.commuteCorrectionCheckIn", davo);
	}
	// end of commuteCorrectionCheckIn()
	// =======================================================================================

	//

	// =======================================================================================
	// commuteCorrectionCheckOut()
	public void commuteCorrectionCheckOut(DayAttendVO davo) {
		log.info("[AttendDAO - commuteCorrectionCheckOut 요청 받음]");
		sess.update("com.example.repository.DayAttendDAO.commuteCorrectionCheckOut", davo);
	}
	// end of commuteCorrectionCheckOut()
	// =======================================================================================

	//

	// =======================================================================================
	// getAllEmpNos()
	public List<String> getAllEmpNos() {
		return sess.selectList("com.example.repository.DayAttendDAO.getAllEmpNos");
	}
	// end of getAllEmpNos()
	// =======================================================================================

	//

	// =======================================================================================
	// insertAbsenceRecords()
	public int insertAbsenceRecords() {
		log.info("[AttendDAO - insertAbsenceRecords 요청 받음]");
		return sess.insert("com.example.repository.DayAttendDAO.insertAbsenceRecords");
	}
	// end of insertAbsenceRecords()
	// =======================================================================================

	//

	// =======================================================================================
	// updateIncompleteAttendanceToAbsence()
	public int updateIncompleteAttendanceToAbsence() {
		log.info("[AttendDAO - updateIncompleteAttendanceToAbsence 요청 받음]");
		return sess.update("com.example.repository.DayAttendDAO.updateIncompleteAttendanceToAbsence");
	}
	// end of updateIncompleteAttendanceToAbsence()
	// =======================================================================================

}