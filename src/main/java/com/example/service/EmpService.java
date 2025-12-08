package com.example.service;

import java.util.List;

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
}
