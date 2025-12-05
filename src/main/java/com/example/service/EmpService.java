package com.example.service;

import java.util.List;

import com.example.domain.EmpSearchVO;
import com.example.domain.EmpVO;

public interface EmpService {

    // 🔹 검색 조건 포함 사원 목록 조회 (다른 화면에서 사용 중일 수 있음)
    List<EmpVO> getEmpList(EmpSearchVO search);

    // 🔹 사번으로 사원 1명 조회 (다른 모듈에서 사용 가능)
    EmpVO getEmp(String empNo);

    // 🔹 전체 사원 목록 조회 (지금 /emp/list 에서 사용)
    List<EmpVO> selectEmpList();

    // 🔹 인사카드용 상세 조회 (지금 /emp/card 에서 사용)
    EmpVO selectEmpByEmpNo(String empNo);

    // 🔹 사원 삭제
    int deleteEmp(String empNo);

    // 🔹 사원 정보 수정 (재직상태, 연락처, 이메일, 주소 등)
    int updateEmp(EmpVO vo);
}
