package com.example.service;

import java.util.List;
import java.util.Map;

import com.example.domain.SalVO;

public interface SalService {

    // 사원 개인용 (기존 그대로 유지)
    List<SalVO> getSalList(String empNo);

    SalVO getSalaryDetail(String empNo, Integer monthAttno);

    // ✅ 관리자용 : 정렬/검색용 전체 목록
    List<SalVO> getAdminSalList(Map<String, String> param);

	
    
	
}