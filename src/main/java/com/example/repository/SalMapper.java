package com.example.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.domain.EmpVO;
import com.example.domain.SalVO;

@Mapper
public interface SalMapper {
	EmpVO getEmp(int empNo);
    List<SalVO> selectSalList(int empNo);
}