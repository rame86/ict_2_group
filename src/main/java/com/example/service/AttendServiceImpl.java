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

	public List<DayAttendVO> selectDayAttend(String empNo, String toDay) {
		log.info("[AttendService - selectDayAttend 요청 받음]");
		return attendDAO.selectDayAttend(empNo, toDay);
	}

	public String checkIn(DayAttendVO davo) {
		return attendDAO.checkIn(davo);
	}

	public String checkOut(DayAttendVO davo) {
		return attendDAO.checkOut(davo);
	}

	public String fieldwork(DayAttendVO davo) {
		return attendDAO.fieldwork(davo);
	}

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
			toDate.getFomatterDate(vo.getEndDate());
		}

		davo.setEmpNo(vo.getEmpNo());
		davo.setUpdateTime(toDate.getToDay());
		davo.setMemo(status + ":" + startDate + "~" + endDate + ", " + vo.getTotalDays());
		davo.setAttStatus(status);
		davo.setDateAttend(startDate);
		attendDAO.insertVacation(davo, totalDays);

	}

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
			} else if (nowTime.compareTo(standardTime) > 0 && !davoStatus.equals("3") && !davoStatus.equals("4")) {
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
			} else if (nowTime.compareTo(standardTime) > 0 && !davoStatus.equals("2") && !davoStatus.equals("4")) {
				davo.setAttStatus("1");
			}

			attendDAO.commuteCorrectionCheckOut(davo);
		}

	}

	@Transactional
	public int processDailyAbsence() {
		log.info("[AttendService] 결근자 일괄 처리 시작...");
		// 오늘 날짜로 DAY_ATTEND 기록이 없는 사원들에 대해 일괄 삽입 쿼리 실행
		int insertedCount = attendDAO.insertAbsenceRecords();
		log.info("[AttendService] 결근 처리 완료. 삽입된 레코드 수: {}", insertedCount);

		return insertedCount;
	}
	
	
	@Transactional
	public int processIncompleteAttendance() {

	    log.info("[AttendService] 미퇴근 결근자 일괄 처리 시작...");     
	  
	    int updatedCount = attendDAO.updateIncompleteAttendanceToAbsence();	    

	    log.info("[AttendService] 미퇴근 결근 처리 완료. 업데이트된 레코드 수: {}", updatedCount);
        
	    return updatedCount;
	}
}
