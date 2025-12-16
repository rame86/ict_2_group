package com.example.repository;

import java.util.List;

import com.example.domain.DayAttendVO;
import com.example.domain.DocVO;

public interface AttendDAO {
	
	// 월별 근태 조회
	public List<DayAttendVO> selectDayAttend(String empNo, String toDay);

	// 출근 처리
	public String checkIn(DayAttendVO davo);
	
	// Service에서 데이터 존재 여부 및 기존 상태 확인용 (checkOut 로직에서 사용)
	public DayAttendVO selectDateCheck(DayAttendVO davo);
	
	// 퇴근 처리
	public String checkOut(DayAttendVO davo);
	
	// 순수 퇴근 시간 업데이트 (Service에서 호출)
	public void updateCheckOut(DayAttendVO davo);

	// 근무 시간(FullTime) 업데이트 (Service에서 계산 후 호출)
	public void updateDayFullTime(DayAttendVO davo);
	
	// 외근 처리
	public String fieldwork(DayAttendVO davo);
	
	// 휴가 데이터 삽입 (단일 건)
	public void insertVacation(DayAttendVO davo);
	
	// 문서 번호로 근태 조회
	public DayAttendVO selectDayAttend(DocVO vo);
	
	// 근태 수정 (출근)
	public void commuteCorrectionCheckIn(DayAttendVO davo);
	
	// 근태 수정 (퇴근)
	public void commuteCorrectionCheckOut(DayAttendVO davo);
	
	// 전 사원 번호 조회
	public List<String> getAllEmpNos();

	// 결근 일괄 등록
	public int insertAbsenceRecords();
	
	// 미퇴근자 결근 처리
	public int updateIncompleteAttendanceToAbsence();
	
	// 해당 날짜 기록 카운트 (중복 방지용)
	public int countAttendRecordByDate(DayAttendVO davo);

}