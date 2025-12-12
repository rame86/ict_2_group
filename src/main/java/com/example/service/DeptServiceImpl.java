package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.DeptVO;
import com.example.repository.EmpDeptMapper;


@Service
public class DeptServiceImpl implements DeptService {

    @Autowired
    private EmpDeptMapper deptMapper;

    @Override
    public List<DeptVO> getDeptList() {
        return deptMapper.getDeptList();
    }
}
