package com.example.service;

import java.util.List;

import com.example.domain.SalVO;

public interface SalService {

    // 급여 대장
    List<SalVO> getSalList(String empNo);

    // 급여 명세서 상세
    SalVO getSalaryDetail(String empNo, Integer monthAttno);

	List<SalVO> getAdminSalList(Integer monthAttno, String deptNo, String keyword);

	// 🔹 관리자용 급여 대장
    List<SalVO> getAdminSalList();
	
}