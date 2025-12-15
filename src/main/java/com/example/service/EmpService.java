package com.example.service;

import java.time.LocalDate;
import java.util.List;

import com.example.domain.DocVO;
import com.example.domain.EditVO;
import com.example.domain.EmpSearchVO;
import com.example.domain.EmpVO;

public interface EmpService {

    // 🔹 검색 포함 사원 목록
    List<EmpVO> getEmpList(EmpSearchVO search);

    // 🔹 사번으로 사원 1명 조회
    EmpVO getEmp(String empNo);

    // 🔹 전체 사원 목록
    List<EmpVO> selectEmpList();

    // 🔹 인사카드용 상세 조회
    EmpVO selectEmpByEmpNo(String empNo);

    // 🔹 삭제
    int deleteEmp(String empNo);

    // 🔹 수정
    int updateEmp(EmpVO vo);

    // 🔹 등록
    int insertEmp(EmpVO vo);

    // 🔹 사번 중복 여부
    //    중복이면 true, 아니면 false
    boolean isEmpNoDuplicate(String empNo);
    
    /** 비고 이력 저장 (한 번 호출할 때마다 EDIT 테이블에 한 줄 INSERT) */
    void saveEmpEditHistory(String empNo,
                            LocalDate retireDate,  // 없으면 null
                            String eNote,
                            String writerName);   // 수정한 사람 이름
	
	// 🔹사원 비고 이력 전체 조회
	EditVO getLastEdit(String empNo);
	
	// 비고 히스토리(헤더까지 포함한 문자열) 조회
    String getEditNoteHistory(String empNo);

	
	public void setEmpJobTitle(DocVO vo);
	
}
