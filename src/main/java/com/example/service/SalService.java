package com.example.service;

import java.util.List;

import com.example.domain.SalSummaryVO;
import com.example.domain.SalVO;

public interface SalService {

    // 기존: 급여 리스트 조회 (empNo 기준)
    List<SalVO> getSalList(int empNo);

    // 추가: 급여 상세 조회 (salNum 기준, salDetail.jsp 용)
    SalVO getSalDetail(int salNum);

    //  추가: 자동 급여 생성 (고급 버전)
    void generateMonthlySalary(String empNo, int monthAttno, String salDate);
    
 // 급여대장 리스트용 요약
    List<SalSummaryVO> getSalarySummaryList(String empNo);

    // 급여 명세서 상세
    SalVO getSalaryDetail(String empNo, Integer monthAttno);
}