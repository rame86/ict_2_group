package com.example.service;

import java.util.List;

import com.example.domain.SalVO;

public interface SalService {
    List<SalVO> getSalList(int empNo);
}