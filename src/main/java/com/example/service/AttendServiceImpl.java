package com.example.service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
	// checkOut() 퇴근 처리 및 근무시간 계산
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

		// 4. 근무 시간 계산 로직 (공통 메소드 호출)
		// checkOut 시점에는 empNo와 오늘 날짜(dateAttend)를 기준으로 재계산
		calculateAndSaveWorkTime(davo.getEmpNo(), davo.getDateAttend());

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

		// 숫자와 점(.)을 제외한 문자 제거 (예: "3.5일" -> "3.5")
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
		// 종료일이 없으면 시작일과 동일하게 처리 방지 (null 체크)
		String endDate = vo.getEndDate() != null ? toDate.getFomatterDate(vo.getEndDate()) : "";

		String empNo = vo.getDocWriter();
		davo.setEmpNo(empNo);
		davo.setMemo(status + ":" + startDate + "~" + endDate + ", " + vo.getTotalDays());
		davo.setAttStatus(status);
		davo.setDateAttend(startDate);
		

		String currentDateString = davo.getDateAttend();
		log.info(davo.toString());
		
		log.info("[AttendService - insertVacation - 루프 시작 (TotalDays: " + totalDays + ")]");

		// 반차(0.5)인 경우 루프를 1번 돌도록 올림 처리하거나 로직 조정 필요. 
		// 여기서는 정수 단위 반복문이므로 0.5일 경우 1번 실행되도록 Math.ceil 등 고려 가능하나, 
		// 기존 로직(i < totalDays) 유지 시 0.5면 실행 안될 수 있음. 
		// 일단 사용자 요구사항인 "반차" 입력을 위해 totalDays가 1 미만이어도 1회 실행되도록 보완.
		int loopCount = (totalDays > 0 && totalDays < 1) ? 1 : totalDays.intValue();

		for (int i = 0; i < loopCount; i++) {
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
	// commuteCorrection() 근태 수정 요청 처리
	@Transactional
	public void commuteCorrection(DocVO vo) {
		log.info("[AttendService - commuteCorrection 요청 받음]");
		
		// 1. 날짜 및 시간 포맷팅
		String date = toDate.getFomatterDate(vo.getStartDate()); // yyyy-MM-dd
		String time = vo.getNewmodifyTime(); // HH:mm
		
		// toDate.combineDateAndTime을 사용하여 정확한 날짜+시간 문자열 생성
		String newModifyTime = toDate.combineDateAndTime(date, time); // yyyy-MM-dd HH:mm:ss
		String nowTime = toDate.getFomatterHHmmss(newModifyTime); // HH:mm:ss 추출

		// 데이터 주입
		String empNo = vo.getDocWriter();
		vo.setStartDate(date);
		vo.setNewmodifyTime(newModifyTime);
		vo.setEmpNo(empNo);
		log.info(vo.toString());
		// 2. 기존 근태 기록 조회
		DayAttendVO davo = attendDAO.selectDayAttend(vo);
		
		if(davo == null) {
			log.error("[AttendService - commuteCorrection] 해당 날짜의 근태 기록이 없습니다.");
			return;
		}

		String davoStatus = davo.getAttStatus();

		// 3. 출근 또는 퇴근 시간 업데이트 및 상태값 재판별
		if (vo.getMemo().equals("inTime")) {
			davo.setInTime(newModifyTime);
			davo.setMemo("출근시간 변경");
			String standardTime = "09:00:00";
			
			// 상태값 판별 (조퇴나 외근이 아닌 경우에만 지각/정상출근 판별)
			if (nowTime.compareTo(standardTime) <= 0 && !davoStatus.equals("3") && !davoStatus.equals("4")) {
				davo.setAttStatus("1"); // 정상출근
			} else if (nowTime.compareTo(standardTime) > 0 && !davoStatus.equals("3") && !davoStatus.equals("4")) {
				davo.setAttStatus("2"); // 지각
			}
			
			log.info("[AttendService - commuteCorrection - CheckIn 업데이트]");
			attendDAO.commuteCorrectionCheckIn(davo);
			
		} else if (vo.getMemo().equals("outTime")) {
			davo.setOutTime(newModifyTime);
			davo.setMemo("퇴근시간 변경");
			String standardTime = "18:00:00";
			
			// 상태값 판별 (지각이나 외근이 아닌 경우에만 조퇴/정상출근 판별)
			if (nowTime.compareTo(standardTime) < 0 && !davoStatus.equals("2") && !davoStatus.equals("4")) {
				davo.setAttStatus("3"); // 조퇴
			} else if (nowTime.compareTo(standardTime) >= 0 && !davoStatus.equals("2") && !davoStatus.equals("4")) {
				davo.setAttStatus("1"); // 정상출근 (기존이 지각이었으면 지각 유지해야 하나, 여기선 정상처리 로직으로 둠)
			}
			
			log.info("[AttendService - commuteCorrection - CheckOut 업데이트]");
			attendDAO.commuteCorrectionCheckOut(davo);
		}
		
		// 4. ★★★ [핵심] 근무 시간(FullTime) 재계산 ★★★
		// 정정된 출/퇴근 시간을 바탕으로 실제 근무 시간을 다시 계산하여 DB에 저장해야 함.
		calculateAndSaveWorkTime(davo.getEmpNo(), davo.getDateAttend());
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
	
	
	// =======================================================================================
	// [private Method] calculateAndSaveWorkTime
	// 출퇴근 시간 차이를 계산하여 DAY_FULLTIME을 업데이트하는 공통 로직
	// =======================================================================================
	private void calculateAndSaveWorkTime(String empNo, String dateAttendStr) {
		log.info("[AttendService - calculateAndSaveWorkTime] 근무시간 재계산 시작 - 사번: " + empNo + ", 날짜: " + dateAttendStr);
		
		try {
			// 1. 재계산할 날짜의 최신 근태 정보를 DB에서 다시 조회 (시간 정보 갱신됨)
			DayAttendVO searchVo = new DayAttendVO();
			searchVo.setEmpNo(empNo);
			// dateAttendStr가 "yyyy-MM-dd HH:mm:ss" 형식일 수 있으므로 앞 10자리만 추출
			if(dateAttendStr.length() > 10) {
				dateAttendStr = dateAttendStr.substring(0, 10);
			}
			searchVo.setDateAttend(dateAttendStr);
			
			DayAttendVO currentData = attendDAO.selectDateCheck(searchVo);

			// 출근시간과 퇴근시간이 모두 존재할 때만 계산
			if (currentData != null && currentData.getInTime() != null && currentData.getOutTime() != null) {
				
				// 2. ToDate 클래스를 사용하여 정확한 LocalDateTime 생성
				// selectDateCheck 쿼리 결과인 IN_TIME, OUT_TIME은 "HH:mm:ss" 형식임 (Mapper 참조)
				// 과거 날짜 데이터일 경우 LocalDate.now()를 쓰면 안되므로, combineDateAndTime 사용
				
				String fullInTimeStr = toDate.combineDateAndTime(dateAttendStr, currentData.getInTime());
				String fullOutTimeStr = toDate.combineDateAndTime(dateAttendStr, currentData.getOutTime());
				
				// 3. LocalDateTime 파싱 (combineDateAndTime 결과는 "yyyy-MM-dd HH:mm:ss")
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
				LocalDateTime inTime = LocalDateTime.parse(fullInTimeStr, formatter);
				LocalDateTime outTime = LocalDateTime.parse(fullOutTimeStr, formatter);

				// 4. 근무 시간(Duration) 계산
				Duration workTime = Duration.between(inTime, outTime);
				Duration restTime = Duration.ofHours(1); // 점심시간 1시간 제외 규칙

				Duration realWorkTime;
				// 총 근무 시간이 1시간 초과일 때만 휴식 시간 차감 (음수 방지)
				if (workTime.compareTo(restTime) > 0) {
					realWorkTime = workTime.minus(restTime);
				} else {
					realWorkTime = workTime; // 1시간 미만 근무 시 차감 없음 (혹은 0 처리 등 정책에 따름)
				}

				// 5. 시:분:초 포맷팅
				long totalSeconds = realWorkTime.getSeconds();
				long hours = totalSeconds / 3600;
				long minutes = (totalSeconds % 3600) / 60;
				long seconds = totalSeconds % 60;

				String dayFulltime = String.format("%02d:%02d:%02d", hours, minutes, seconds);

				// 6. DB 업데이트
				currentData.setDayFulltime(dayFulltime);
				attendDAO.updateDayFullTime(currentData);
				
				log.info("[AttendService - calculateAndSaveWorkTime] 재계산 완료 및 DB 반영: " + dayFulltime);
			} else {
				log.info("[AttendService - calculateAndSaveWorkTime] 출/퇴근 시간 중 하나가 누락되어 계산 불가");
			}
		} catch (Exception e) {
			log.error("[AttendService - calculateAndSaveWorkTime] 오류 발생", e);
		}
	}

}