package com.example.service;

import java.util.List;

import com.example.domain.EmpSearchVO;
import com.example.domain.EmpVO;

public interface EmpService {

    List<EmpVO> getEmpList(EmpSearchVO search); // 검색 포함 조회
	EmpVO getEmp(String empNo);								
	List<EmpVO> selectEmpList();									// 전체 조회
}