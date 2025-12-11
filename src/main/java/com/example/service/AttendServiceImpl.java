package com.example.service;

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
		return attendDAO.checkIn(davo);
	}
	// end of checkIn()
	// =======================================================================================

	//
	
	// =======================================================================================
	// checkOut()
	public String checkOut(DayAttendVO davo) {
		return attendDAO.checkOut(davo);
	}
	// end of checkOut()
	// =======================================================================================

	//
	
	// =======================================================================================
	// fieldwork()
	public String fieldwork(DayAttendVO davo) {
		return attendDAO.fieldwork(davo);
	}
	// end of fieldwork()
	// =======================================================================================

	// =======================================================================================
	// insertVacation()
	@Transactional
	public void insertVacation(DocVO vo) {
		log.info("[AttendService - insertVacation 요청 받음]");
		log.info(vo.toString());
		DayAttendVO davo = new DayAttendVO();

		String totalDayStr = vo.getTotalDays();
		String totalDaySt = totalDayStr.replaceAll("[^0-9\\.]", "");
		Double totalDays = 0.0;
		if (!totalDaySt.isEmpty()) {
			totalDays = Double.parseDouble(totalDaySt);
		}
		String getstatus = vo.getAttStatus();
		String status = "";

		// 넘어온 휴가신청 상태값에 따라 입력내용 변경
		switch (getstatus) {
		case "annual":
			status = "5";
			break;
		case "half_am":
			status = "6";
			break;
		case "half_pm":
			status = "7";
			break;
		case "sick":
			status = "8";
			break;
		case "compensatory":
			status = "9";
			break;
		default:
			status = "11";
			break;
		}

		String startDate = toDate.getFomatterDate(vo.getStartDate());

		String endDate = "";
		if (vo.getEndDate() != null) {
			endDate = toDate.getFomatterDate(vo.getEndDate());
		}

		davo.setEmpNo(vo.getEmpNo());
		davo.setUpdateTime(toDate.getToDay());
		davo.setMemo(status + ":" + startDate + "~" + endDate + ", " + vo.getTotalDays());
		davo.setAttStatus(status);
		davo.setDateAttend(startDate);// --- 🚨 여기서부터 중복 체크 로직 추가 시작 🚨 ---
	    
	    // 넘어온 dateAttend 날짜를 currentDateString에 저장
	    String currentDateString = davo.getDateAttend();

	    // totalDays 만큼 반복
	    for (int i = 0; i < totalDays; i++) {
	        DayAttendVO davoToInsert = new DayAttendVO();
	        
	        davoToInsert.setEmpNo(davo.getEmpNo());
	        davoToInsert.setAttStatus(davo.getAttStatus());
	        davoToInsert.setMemo(davo.getMemo());
	        davoToInsert.setDateAttend(currentDateString); // 현재 날짜 설정

	        // 💡 1. 해당 날짜에 이미 근태 기록이 있는지 확인
	        int recordCount = attendDAO.countAttendRecordByDate(davoToInsert);

	        if (recordCount == 0) {
	            // 2. 기록이 없을 경우에만 삽입
	            log.info("INSERT 시도 - dateAttend: " + davoToInsert.getDateAttend());
	            // attendDAO.insertVacation(davoToInsert, 1.0); // DAO 메서드를 1일 단위로 호출하도록 변경 필요 (아래 3번 참고)
	            attendDAO.insertVacation(davoToInsert); // DAO의 기존 insertVacation이 이미 1일 단위 삽입 로직이므로, 반복문 내에서 호출
	            
	        } else {
	            // 2-1. 기록이 이미 있을 경우: 삽입 건너뛰기
	            log.warn("날짜 {} 에 이미 근태 기록({})이 존재하여 휴가 삽입을 건너뜁니다.", currentDateString, davo.getEmpNo());
	        }

	        // ToDate 유틸리티를 사용하여 다음 날짜를 계산하고 다시 넣어줌~
	        currentDateString = toDate.addDay(currentDateString);
	    }
	}
	// end of insertVacation()
	// =======================================================================================
	//
	
	// =======================================================================================
	// commuteCorrection()
	public void commuteCorrection(DocVO vo) {
		log.info("[AttendService - commuteCorrection 요청 받음]");
		log.info(vo.toString());
		String date = toDate.getFomatterDate(vo.getStartDate());
		String time = vo.getNewmodifyTime();

		// 타임스템프에 넣기위해 기준날짜 + 시간 합쳐서 yyyymmdd hhmmss 타입으로 변경
		String newModifyTime = toDate.combineDateAndTime(date, time);
		// 출근, 지각 체크를 위해 hhssmm 형식으로 추가 변환
		String nowTime = toDate.getFomatterHHmmss(newModifyTime);
		vo.setStartDate(date);
		vo.setNewmodifyTime(newModifyTime);
		// 이전에 저장되어 있는 데이터 불러오기
		DayAttendVO davo = attendDAO.selectDayAttend(vo);
		// 이전 데이터에 따라 상태값 입력
		String davoStatus = davo.getAttStatus();

		// 출근시간 정정 요청시
		if (vo.getMemo().equals("inTime")) {
			davo.setInTime(newModifyTime);
			davo.setMemo("출근시간 변경");
			// 수정시간이 기준시간보다 늦을 경우 지각~
			String standardTime = "09:00:00";
			if (nowTime.compareTo(standardTime) < 0 && !davoStatus.equals("3") && !davoStatus.equals("4")) {
				davo.setAttStatus("1");
			} else if (nowTime.compareTo(standardTime) >= 0 && !davoStatus.equals("3") && !davoStatus.equals("4")) {
				davo.setAttStatus("2");
			}
			attendDAO.commuteCorrectionCheckIn(davo);

			// 퇴근시간 정정 요청시
		} else if (vo.getMemo().equals("outTime")) {
			davo.setOutTime(newModifyTime);
			davo.setMemo("퇴근시간 변경");
			// 역시나 퇴근시간이 기준시간보다 이르면 조퇴~
			String standardTime = "18:00:00";
			if (nowTime.compareTo(standardTime) < 0 && !davoStatus.equals("2") && !davoStatus.equals("4")) {
				davo.setAttStatus("3");
			} else if (nowTime.compareTo(standardTime) >= 0 && !davoStatus.equals("2") && !davoStatus.equals("4")) {
				davo.setAttStatus("1");
			}

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
		log.info("[AttendService] 결근자 일괄 처리 시작...");
		// 오늘 날짜로 DAY_ATTEND 기록이 없는 사원들에 대해 일괄 삽입 쿼리 실행
		int insertedCount = attendDAO.insertAbsenceRecords();
		log.info("[AttendService] 결근 처리 완료. 삽입된 레코드 수: {}", insertedCount);

		return insertedCount;
	}
	// end of processDailyAbsence()
	// =======================================================================================

	//
	
	// =======================================================================================
	// processIncompleteAttendance()
	@Transactional
	public int processIncompleteAttendance() {

		log.info("[AttendService] 미퇴근 결근자 일괄 처리 시작...");

		int updatedCount = attendDAO.updateIncompleteAttendanceToAbsence();

		log.info("[AttendService] 미퇴근 결근 처리 완료. 업데이트된 레코드 수: {}", updatedCount);

		return updatedCount;
	}
	// end of processIncompleteAttendance()
	// =======================================================================================

}