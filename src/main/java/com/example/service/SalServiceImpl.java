package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.SalVO;
import com.example.repository.SalMapper;

@Service
public class SalServiceImpl implements SalService {

    @Autowired
    private SalMapper salMapper;

    @Override
    public List<SalVO> getSalList(int empNo) {
        return salMapper.selectSalList(empNo);
    }
}