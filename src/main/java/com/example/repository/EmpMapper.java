package com.example.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.domain.EmpVO;
import com.example.domain.EmpSearchVO;


@Mapper
public interface EmpMapper {
    List<EmpVO> selectEmpList(EmpSearchVO search);

    EmpVO getEmp(String empNo);
}