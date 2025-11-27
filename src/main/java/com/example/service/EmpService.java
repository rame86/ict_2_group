package com.example.service;

import java.util.List;

import com.example.domain.EmpSearchVO;
import com.example.domain.EmpVO;

public interface EmpService {
    List<EmpVO> getEmpList(EmpSearchVO search);
}