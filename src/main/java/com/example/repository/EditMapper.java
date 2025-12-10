package com.example.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.domain.EditVO;

@Mapper
public interface EditMapper {
	
	int insertEdit(EditVO vo);
	
	// 🔹 해당 사원의 모든 비고 이력 조회
	List<EditVO> selectEditListByEmpNo(String empNo);

	

	EditVO selectLastEditByEmpNo(String empNo);

	
}
