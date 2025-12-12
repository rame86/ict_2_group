package com.example.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.domain.DeptVO;

@Mapper
public interface EmpDeptMapper{
	
	
	List<DeptVO> getDeptList();
	
	
}