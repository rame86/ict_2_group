package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.EmpSearchVO;
import com.example.domain.EmpVO;
import com.example.repository.EmpMapper;

@Service
public class EmpServiceImpl implements EmpService {

    @Autowired
    private EmpMapper empMapper;

    @Override
    public List<EmpVO> getEmpList(EmpSearchVO search) {
        return empMapper.selectEmpList(search);
    }
}