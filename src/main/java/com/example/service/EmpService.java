package com.example.service;

import java.time.LocalDate;
import java.util.List;

import com.example.domain.DocVO;
import com.example.domain.EditVO;
import com.example.domain.EmpSearchVO;
import com.example.domain.EmpVO;

/**
 * EmpService ------------------------------------------------- 사원관리 도메인의 핵심
 * Service 인터페이스
 *
 * ✔ 사원 CRUD ✔ 인사카드 조회 ✔ 사번 중복 체크 ✔ 사원 비고(Edit) 이력 관리 ✔ 조직/직책(Doc) 연계 기능
 *
 * ⚠ 데이터 접근 방식 - 본 Service는 EmpMapper(MyBatis) 기반 구현을 사용 - EmpDAO는 팀 내 다른 구현
 * 방식으로, 본 Service에서는 사용하지 않음 (공존 상태)
 */
public interface EmpService {

	/*
	 * ===================================================== 사원 조회
	 * =====================================================
	 */

	/** 🔹 검색 조건(EmpSearchVO)을 포함한 사원 목록 조회 */
	List<EmpVO> getEmpList(EmpSearchVO search);

	/** 🔹 사번으로 사원 단건 조회 (공용 상세 조회) */
	EmpVO getEmp(String empNo);

	/** 🔹 전체 사원 목록 조회 (검색 조건 없음) */
	List<EmpVO> selectEmpList();

	/**
	 * 🔹 인사카드 전용 상세 조회 - SQL은 getEmp와 유사하지만 - 화면 용도 분리를 위해 메소드 분리
	 */
	EmpVO selectEmpByEmpNo(String empNo);

	/*
	 * ===================================================== 사원 등록 / 수정 / 삭제
	 * =====================================================
	 */

	/** 🔹 사원 삭제 */
	int deleteEmp(String empNo);

	/**
	 * 🔹 사원 수정 - 재직상태(statusNo) ↔ 권한등급(gradeNo) 규칙은 ServiceImpl에서 일괄 적용
	 */
	int updateEmp(EmpVO vo);

	/**
	 * 🔹 사원 등록 - 재직상태/권한등급 규칙 Service에서 강제
	 */
	int insertEmp(EmpVO vo);

	/** 🔹 사번 중복 여부 확인 (true = 중복) */
	boolean isEmpNoDuplicate(String empNo);

	/*
	 * ===================================================== 사원 비고(Edit) 이력 관리
	 * =====================================================
	 */

	/**
	 * 🔹 사원 비고 이력 저장 - 호출 시마다 EDIT 테이블에 한 건씩 누적
	 *
	 * @param empNo      사번
	 * @param retireDate 퇴사일 (없으면 null)
	 * @param eNote      새로 입력한 비고
	 * @param writerName 수정자 이름
	 */
	void saveEmpEditHistory(String empNo, LocalDate retireDate, String eNote, String writerName);

	/** 🔹 최근 비고 1건 조회 */
	EditVO getLastEdit(String empNo);

	/**
	 * 🔹 비고 전체 이력을 하나의 문자열로 조회 - 인사카드 화면에서 사용
	 */
	String getEditNoteHistory(String empNo);

	/**
	 * 🔹 직책/부서장 설정 - 결재/문서(Doc) 모듈에서 호출
	 */
	void setEmpJobTitle(DocVO vo);

	// 알람용
	List<String> getEmpNoListByDept(String deptNo);

	List<String> getAllEmpNoList();

}
