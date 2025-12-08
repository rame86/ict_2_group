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
		String totalDaySt = totalDayStr.replaceAll("[^0-9]", "");
		Integer totalDays = 0;
		if (!totalDaySt.isEmpty()) {
			totalDays = Integer.parseInt(totalDaySt);
		}

		String startDate = toDate.getFomatterDate(vo.getStartDate());
		String endDate = toDate.getFomatterDate(vo.getEndDate());

		davo.setEmpNo(vo.getEmpNo());
		davo.setUpdateTime(toDate.getToDay());
		davo.setMemo("연차 :" + startDate + "~" + endDate + ", " + vo.getTotalDays());
		log.info("메모는??" + davo.getMemo());
		davo.setAttStatus("연차");
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
			if (nowTime.compareTo(standardTime) < 0 && !davoStatus.equals("조퇴") && !davoStatus.equals("외근")) {
				davo.setAttStatus("출근");
			} else if (nowTime.compareTo(standardTime) > 0 && !davoStatus.equals("조퇴") && !davoStatus.equals("외근")) {
				davo.setAttStatus("지각");
			}
			attendDAO.commuteCorrectionCheckIn(davo);

			// 퇴근시간 정정 요청시
		} else if (vo.getMemo().equals("outTime")) {
			davo.setOutTime(newModifyTime);
			davo.setMemo("퇴근시간 변경");
			// 역시나 퇴근시간이 기준시간보다 이르면 조퇴~
			String standardTime = "18:00:00";
			if (nowTime.compareTo(standardTime) < 0 && !davoStatus.equals("지각") && !davoStatus.equals("외근")) {
				davo.setAttStatus("조퇴");
			} else if (nowTime.compareTo(standardTime) > 0 && !davoStatus.equals("지각") && !davoStatus.equals("외근")) {
				davo.setAttStatus("출근");
			}

			attendDAO.commuteCorrectionCheckOut(davo);
		}

	}
}
