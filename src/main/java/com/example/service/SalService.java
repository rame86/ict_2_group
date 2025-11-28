package com.example.service;

import java.util.List;

import com.example.domain.SalVO;

public interface SalService {

    // 급여 대장
    List<SalVO> getSalList(String empNo);

    // 급여 명세서 상세
    SalVO getSalaryDetail(String empNo, Integer monthAttno);

    // (옵션) 급여 자동 계산 후 저장하는 메소드 앞으로 여기에 추가 가능
}