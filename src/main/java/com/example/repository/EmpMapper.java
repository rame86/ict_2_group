package com.example.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.domain.MemberVO;
import com.example.domain.EmpSearchVO;


@Mapper
public interface EmpMapper {

    // 🔍 검색 포함 목록 조회
    List<EmpVO> getEmpList(EmpSearchVO search);

    // 📄 전체 사원 목록 조회 (검색 없이)
    List<EmpVO> selectEmpList();

    // 단건 조회
    EmpVO getEmp(String empNo);
    EmpVO selectEmpByEmpNo(String empNo);

    // 등록/수정/삭제
    int insertEmp(EmpVO vo);
    int updateEmp(EmpVO vo);
    int deleteEmp(String empNo);

    // 로그인
    LoginVO loginCheck(MemberVO vo);
}
	