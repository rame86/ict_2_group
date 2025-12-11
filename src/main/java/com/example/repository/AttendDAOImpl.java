package com.example.repository;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.controller.ToDate;
import com.example.domain.DayAttendVO;
import com.example.domain.DocVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class AttendDAOImpl implements AttendDAO {

	@Autowired
	private SqlSessionTemplate sess;
	@Autowired
	private ToDate toDate;

	// =======================================================================================
	// selectDayAttend()
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

		for (DayAttendVO vo : result) {
			String attStatusCode = vo.getAttStatus();
			String koreanStatus;

			switch (attStatusCode) {
			case "0":
				koreanStatus = "퇴근";
				break;
			case "1":
				koreanStatus = "출근";
				break;
			case "2":
				koreanStatus = "지각";
				break;
			case "3":
				koreanStatus = "조퇴";
				break;
			case "4":
				koreanStatus = "외근";
				break;
			case "5":
				koreanStatus = "연차";
				break;
			case "6":
				koreanStatus = "오전반차";
				break;
			case "7":
				koreanStatus = "오후반차";
				break;
			case "8":
				koreanStatus = "병가";
				break;
			case "9":
				koreanStatus = "보상휴가";
				break;
			case "10":
				koreanStatus = "결근";
				break;
			case "11":
				koreanStatus = "출장";
				break;
			default:
				koreanStatus = "알 수 없음";
				break;
			}

			// 3. 변환된 한글 값을 VO 객체에 설정
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

		String checkInTime = "";
		DayAttendVO currentData;
		log.info("인자값 - davo 내용: " + davo.toString());

		// 데이터가 있는지 먼저 확인~
		DayAttendVO dateCheck = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);

		if (dateCheck == null) {
			// 1. 해당 날짜에 데이터가 아예 없는 경우: 새로 출근 기록 INSERT
			log.info("오늘 출근 기록이 없으므로 새로운 레코드를 삽입합니다.");
			sess.insert("com.example.repository.DayAttendDAO.insertCheckIn", davo);

			// 삽입 후 현재 데이터 다시 조회하여 IN_TIME 반환
			currentData = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
			checkInTime = currentData.getInTime();

		} else {
			// 2. 해당 날짜에 데이터가 이미 있는 경우
			davo.setDayAttno(dateCheck.getDayAttno());

			// 2-1. IN_TIME이 이미 존재하는 경우: 중복 출근 체크를 방지하고 기존 시간 반환
			if (dateCheck.getInTime() != null) {
				log.warn("이미 출근 시간이 기록되어 있습니다. 중복 처리를 방지합니다.");
				// dateCheck에서 실제 출근 시간을 가져와 반환 (쿼리에서 'IN_TIME'은 TO_CHAR된 값, 'inTime'은
				// TIMESTAMP)
				checkInTime = dateCheck.getInTime();
			}

			// 2. IN_TIME이 NULL인 경우 (예: 결근처리, 휴가 등에 출근을 시도할 때)
			else {
				log.info("기존 레코드가 있으나 IN_TIME이 NULL입니다. 출근 시간 및 상태를 업데이트합니다.");
				sess.update("com.example.repository.DayAttendDAO.updateCheckIn", davo);

				// 업데이트 후 현재 데이터 다시 조회하여 IN_TIME 반환
				currentData = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
				checkInTime = currentData.getInTime();
			}
		}
		return checkInTime;
	}
	// end of checkIn()
	// =======================================================================================

	//

	// =======================================================================================
	// checkOut()
	public String checkOut(DayAttendVO davo) {
		log.info("[AttendDAO - checkOut 요청 받음]");

		String checkOutTime = "";
		String status = davo.getAttStatus();
		DayAttendVO currentData;

		log.info("[AttendDAO - checkOut - 인자값 davo 내용: " + davo.toString() + "]");

		// 데이터가 있는지 먼저 확인~
		DayAttendVO dateCheck = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
		// 데이터가 없을 경우~
		if (dateCheck == null) {
			checkOutTime = "출근 데이터가 없습니다.";
			return checkOutTime;
		}

		// 데이터가 있을경우~
		else {
			log.info("[AttendDAO - checkOut - dateCheck 내용: " + dateCheck.toString() + "]");

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
			currentData = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);

			// 퇴근시간 정상 입력되면 근무시간 계산하여 dayFulltime을 입력~
			if (currentData.getInTime() != null && currentData.getOutTime() != null) {
				// 열심히 만둘어둔 ToDate 클래스 dateTime 메소드 이용해서 파싱~
				LocalDateTime inTime = toDate.dateTime(currentData.getInTime());
				LocalDateTime outTime = toDate.dateTime(currentData.getOutTime());
				// 총 근무 시간 계산
				Duration workTime = Duration.between(inTime, outTime);
				// 휴식시간 1시간 까기
				Duration restTime = Duration.ofHours(1); // 초단위로 변경(1시간이라 3600초 나옴)
				// 총근무시간에 휴식시간 빼서 초기화~
				Duration realWorkTime = workTime.minus(restTime);

				// 총 근무 시간이 1시간(restTime) 이상일 때만 휴식 시간을 뺌
				if (workTime.compareTo(restTime) > 0) {
					realWorkTime = workTime.minus(restTime);
				} else {
					// 1시간 미만 근무 시 휴식 시간 차감 없음 (총 근무 시간이 그대로 실 근무 시간)
					realWorkTime = workTime;
				}

				// 초단위를 다시 시간, 분 단위로 분리하기위해 long 타입으로 변환~
				long totalSeconds = realWorkTime.getSeconds();

				// 먼저 시간을 구함(1시간은 3600초니까 토탈 초를 3600으로 나눈값을 넣음)
				long hours = totalSeconds / 3600;
				// 분은 시간(3600)으로 나누고 남은 값을 60초로 또 나눠서 저장함
				long minutes = (totalSeconds % 3600) / 60;
				// 초는 모든 초를 분으로 나누고 남은값이니 토탈 초에 60을 나누고 남은값을 저장함
				long seconds = totalSeconds % 60;

				// String.format 사용해서 HH:mm:ss 형식으로 바꿔서 저장함
				String dayFulltime = String.format("%02d:%02d:%02d", hours, minutes, seconds);
				currentData.setDayFulltime(dayFulltime);
				log.info("[AttendDAO - checkOut - 총근무시간 계산 확인 :" + dayFulltime + "]");

				log.info("[AttendDAO - checkOut - currentData :" + currentData + "]");
				sess.update("com.example.repository.DayAttendDAO.updateDayFullTime", currentData);

				log.info("[AttendDAO - checkOut - 총근무시간 업데이트 완료 후 currentData :" + currentData + "]");

			}
			checkOutTime = currentData.getOutTime();
		}
		return checkOutTime;
	}
	// end of checkOut()
	// =======================================================================================

	//

	// =======================================================================================
	// fieldwork()
	public String fieldwork(DayAttendVO davo) {
		log.info("[AttendDAO - fieldwork 요청 받음]");

		String result = toDate.getFomatterHHmmss(davo.getOutTime());
		davo.setMemo("외근 (" + result + ")");

		// 데이터가 있는지 먼저 확인~
		DayAttendVO dateCheck = sess.selectOne("com.example.repository.DayAttendDAO.dateCheck", davo);
		// 데이터가 없을 경우~
		if (dateCheck == null) {
			result = "출근 데이터가 없습니다.";
			return result;
		} else {
			log.info("[AttendDAO - fieldwork - dateCheck 내용: " + dateCheck.toString() + "]");

			String checkStatus = dateCheck.getAttStatus();
			davo.setDayAttno(dateCheck.getDayAttno());
			// 정상출근일 경우에
			if (checkStatus.equals("1") || checkStatus.equals("0")) {
				davo.setAttStatus("4");
				sess.update("com.example.repository.DayAttendDAO.updateFieldwork", davo);
			}
			// 지각등의 사유가 있을 시
			else {
				davo.setAttStatus(checkStatus);
				sess.update("com.example.repository.DayAttendDAO.updateFieldwork", davo);
			}

		}
		return result;
	}
	// end of fieldwork()
	// =======================================================================================

	//

	// =======================================================================================
	// countAttendRecordByDate() 해당 날짜에 기록이 있는지 카운트
	public int countAttendRecordByDate(DayAttendVO davo) {
		log.info("[AttendDAO - countAttendRecordByDate 요청 받음]");
		return sess.selectOne("com.example.repository.DayAttendDAO.countAttendRecordByDate", davo);
	}
	// end of countAttendRecordByDate()
	// =======================================================================================

	//

	// =======================================================================================
	// insertVacation() 연차 승인후 입력 (단일 날짜 처리로 변경)
	public void insertVacation(DayAttendVO davo) {
	    log.info("[AttendDAO - insertVacation 요청 받음]");
	    log.info("INSERT 시도 - dateAttend: " + davo.getDateAttend());
	    sess.insert("com.example.repository.DayAttendDAO.insertVacation", davo);
	}
	// end of insertVacation()
	// =======================================================================================

	//

	// =======================================================================================
	// selectDayAttend()
	public DayAttendVO selectDayAttend(DocVO vo) {
		log.info("[AttendDAO - selectDayAttend 요청 받음]");
		DayAttendVO davo = sess.selectOne("com.example.repository.DayAttendDAO.selectDayAttend", vo);
		log.info("[select 결과 - " + davo.toString());
		return davo;
	}
	// end of selectDayAttend()
	// =======================================================================================

	//

	// =======================================================================================
	// commuteCorrection()
	public void commuteCorrectionCheckIn(DayAttendVO davo) {
		log.info("[AttendDAO - commuteCorrectionCheckIn 요청 받음]");
		sess.update("com.example.repository.DayAttendDAO.commuteCorrectionCheckIn", davo);
	}
	// end of commuteCorrection()
	// =======================================================================================

	//

	// =======================================================================================
	// commuteCorrection()
	public void commuteCorrectionCheckOut(DayAttendVO davo) {
		log.info("[AttendDAO - commuteCorrectionCheckOut 요청 받음]");
		sess.update("com.example.repository.DayAttendDAO.commuteCorrectionCheckOut", davo);
	}
	// end of commuteCorrection()
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
		// insertAbsenceRecords 쿼리 실행
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
