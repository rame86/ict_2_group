package com.example.service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.controller.ToDate;
import com.example.domain.DayAttendVO;
import com.example.domain.DocVO;
import com.example.repository.AttendDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AttendServiceImpl implements AttendService {

	@Autowired
	private ToDate toDate;
	@Autowired
	private AttendDAO attendDAO;

	// =======================================================================================
	// selectDayAttend()
	public List<DayAttendVO> selectDayAttend(String empNo, String toDay) {
		log.info("[AttendService - selectDayAttend 요청 받음]");
		return attendDAO.selectDayAttend(empNo, toDay);
	}
	// end of selectDayAttend()
	// =======================================================================================

	//

	// =======================================================================================
	// checkIn()
	public String checkIn(DayAttendVO davo) {
		log.info("[AttendService - checkIn 요청 받음]");
		return attendDAO.checkIn(davo);
	}
	// end of checkIn()
	// =======================================================================================

	//

	// =======================================================================================
	// checkOut() 퇴근 처리 및 근무시간 계산 (핵심 로직 이동)
	@Transactional
	public String checkOut(DayAttendVO davo) {
		log.info("[AttendService - checkOut 요청 받음]");
		log.info("[AttendService - checkOut - 인자값 davo : " + davo.toString() + "]");

		// 1. 오늘 출근 기록이 있는지 확인
		DayAttendVO currentData = attendDAO.selectDateCheck(davo);

		// 데이터가 없을 경우
		if (currentData == null) {
			log.info("[AttendService - checkOut - 출근 데이터 없음]");
			return "출근 데이터가 없습니다.";
		}

		// 데이터가 있을 경우
		log.info("[AttendService - checkOut - 기존 데이터 확인 : " + currentData.toString() + "]");

		// 2. 상태값 업데이트 로직
		String checkStatus = currentData.getAttStatus();
		davo.setDayAttno(currentData.getDayAttno());

		// 정상 출근 상태에서 별도의 조퇴 요청이 없으면("null") 기존 상태 유지
		if ("null".equals(davo.getAttStatus())) {
			davo.setAttStatus(checkStatus);
		}
		// 조퇴 등 Controller에서 넘겨준 상태값이 있다면 그 값 사용 (davo에 이미 set되어 있음)

		// 3. DB에 퇴근 시간 및 상태 업데이트
		log.info("[AttendService - checkOut - 퇴근 정보 업데이트 시도]");
		attendDAO.updateCheckOut(davo);

		// 4. 근무 시간 계산 로직 (DAO에서 가져온 로직)
		// 정확성을 위해 DB의 출근시간(currentData.getInTime())과 현재 퇴근시간(davo.getOutTime()) 사용
		if (currentData.getInTime() != null && davo.getOutTime() != null) {
			log.info("[AttendService - checkOut - 근무 시간 계산 시작]");
			try {
				// ToDate 유틸을 이용한 파싱
				LocalDateTime inTime = toDate.dateTime(currentData.getInTime());
				LocalDateTime outTime = toDate.dateTime(davo.getOutTime());

				// 총 근무 시간 계산
				Duration workTime = Duration.between(inTime, outTime);
				// 휴식시간 1시간 설정
				Duration restTime = Duration.ofHours(1);

				Duration realWorkTime;
				// 총 근무 시간이 1시간(restTime) 이상일 때만 휴식 시간을 뺌
				if (workTime.compareTo(restTime) > 0) {
					realWorkTime = workTime.minus(restTime);
				} else {
					realWorkTime = workTime;
				}

				long totalSeconds = realWorkTime.getSeconds();
				long hours = totalSeconds / 3600;
				long minutes = (totalSeconds % 3600) / 60;
				long seconds = totalSeconds % 60;

				String dayFulltime = String.format("%02d:%02d:%02d", hours, minutes, seconds);

				// 계산된 근무시간을 VO에 담아 업데이트
				currentData.setDayFulltime(dayFulltime);
				log.info("[AttendService - checkOut - 계산된 총 근무시간 : " + dayFulltime + "]");
				
				// 근무시간 DB 반영
				attendDAO.updateDayFullTime(currentData);
				log.info("[AttendService - checkOut - 근무시간 DB 업데이트 완료]");

			} catch (Exception e) {
				log.error("[AttendService - checkOut - 근무시간 계산 중 오류 발생 : " + e.getMessage() + "]");
			}
		}

		return davo.getOutTime();
	}
	// end of checkOut()
	// =======================================================================================

	//

	// =======================================================================================
	// fieldwork()
	public String fieldwork(DayAttendVO davo) {
		log.info("[AttendService - fieldwork 요청 받음]");
		return attendDAO.fieldwork(davo);
	}
	// end of fieldwork()
	// =======================================================================================

	//

	// =======================================================================================
	// insertVacation()
	@Transactional
	public void insertVacation(DocVO vo) {
		log.info("[AttendService - insertVacation 요청 받음]");
		log.info("[AttendService - insertVacation - DocVO : " + vo.toString() + "]");
		
		DayAttendVO davo = new DayAttendVO();

		String totalDayStr = vo.getTotalDays().replaceAll("[^0-9\\.]", "");
		Double totalDays = totalDayStr.isEmpty() ? 0.0 : Double.parseDouble(totalDayStr);

		String status;
		switch (vo.getAttStatus()) {
		case "annual": status = "5"; break;
		case "half_am": status = "6"; break;
		case "half_pm": status = "7"; break;
		case "sick": status = "8"; break;
		case "compensatory": status = "9"; break;
		default: status = "11"; break;
		}

		String startDate = toDate.getFomatterDate(vo.getStartDate());
		String endDate = vo.getEndDate() != null ? toDate.getFomatterDate(vo.getEndDate()) : "";

		davo.setEmpNo(vo.getEmpNo());
		davo.setMemo(status + ":" + startDate + "~" + endDate + ", " + vo.getTotalDays());
		davo.setAttStatus(status);
		davo.setDateAttend(startDate);

		String currentDateString = davo.getDateAttend();

		log.info("[AttendService - insertVacation - 루프 시작 (TotalDays: " + totalDays + ")]");

		for (int i = 0; i < totalDays; i++) {
			DayAttendVO davoToInsert = new DayAttendVO();
			davoToInsert.setEmpNo(davo.getEmpNo());
			davoToInsert.setAttStatus(davo.getAttStatus());
			davoToInsert.setMemo(davo.getMemo());
			davoToInsert.setDateAttend(currentDateString);

			// 중복 체크 로직
			int recordCount = attendDAO.countAttendRecordByDate(davoToInsert);

			if (recordCount == 0) {
				log.info("[AttendService - insertVacation - INSERT 수행 날짜 : " + currentDateString + "]");
				attendDAO.insertVacation(davoToInsert);
			} else {
				log.warn("[AttendService - insertVacation - 중복 데이터 존재로 건너뜀 : " + currentDateString + "]");
			}
			currentDateString = toDate.addDay(currentDateString);
		}
		log.info("[AttendService - insertVacation - 처리 완료]");
	}
	// end of insertVacation()
	// =======================================================================================

	//

	// =======================================================================================
	// commuteCorrection()
	public void commuteCorrection(DocVO vo) {
		log.info("[AttendService - commuteCorrection 요청 받음]");
		// 기존 로직 유지 (생략 없이 로그만 추가한다고 가정)
		String date = toDate.getFomatterDate(vo.getStartDate());
		String time = vo.getNewmodifyTime();
		String newModifyTime = toDate.combineDateAndTime(date, time);
		String nowTime = toDate.getFomatterHHmmss(newModifyTime);
		vo.setStartDate(date);
		vo.setNewmodifyTime(newModifyTime);
		
		DayAttendVO davo = attendDAO.selectDayAttend(vo);
		String davoStatus = davo.getAttStatus();

		if (vo.getMemo().equals("inTime")) {
			davo.setInTime(newModifyTime);
			davo.setMemo("출근시간 변경");
			String standardTime = "09:00:00";
			if (nowTime.compareTo(standardTime) < 0 && !davoStatus.equals("3") && !davoStatus.equals("4")) {
				davo.setAttStatus("1");
			} else if (nowTime.compareTo(standardTime) >= 0 && !davoStatus.equals("3") && !davoStatus.equals("4")) {
				davo.setAttStatus("2");
			}
			log.info("[AttendService - commuteCorrection - CheckIn 업데이트]");
			attendDAO.commuteCorrectionCheckIn(davo);
			
		} else if (vo.getMemo().equals("outTime")) {
			davo.setOutTime(newModifyTime);
			davo.setMemo("퇴근시간 변경");
			String standardTime = "18:00:00";
			if (nowTime.compareTo(standardTime) < 0 && !davoStatus.equals("2") && !davoStatus.equals("4")) {
				davo.setAttStatus("3");
			} else if (nowTime.compareTo(standardTime) >= 0 && !davoStatus.equals("2") && !davoStatus.equals("4")) {
				davo.setAttStatus("1");
			}
			log.info("[AttendService - commuteCorrection - CheckOut 업데이트]");
			attendDAO.commuteCorrectionCheckOut(davo);
		}
	}
	// end of commuteCorrection()
	// =======================================================================================

	//

	// =======================================================================================
	// processDailyAbsence()
	@Transactional
	public int processDailyAbsence() {
		log.info("[AttendService - processDailyAbsence 요청 받음]");
		int insertedCount = attendDAO.insertAbsenceRecords();
		log.info("[AttendService - processDailyAbsence 완료 - 삽입된 레코드 수: " + insertedCount + "]");
		return insertedCount;
	}
	// end of processDailyAbsence()
	// =======================================================================================

	//

	// =======================================================================================
	// processIncompleteAttendance()
	@Transactional
	public int processIncompleteAttendance() {
		log.info("[AttendService - processIncompleteAttendance 요청 받음]");
		int updatedCount = attendDAO.updateIncompleteAttendanceToAbsence();
		log.info("[AttendService - processIncompleteAttendance 완료 - 업데이트된 레코드 수: " + updatedCount + "]");
		return updatedCount;
	}
	// end of processIncompleteAttendance()
	// =======================================================================================

}