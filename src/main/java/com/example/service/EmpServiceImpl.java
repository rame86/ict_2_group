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

    // 🔹 검색 포함 사원 목록 조회
    @Override
    public List<EmpVO> getEmpList(EmpSearchVO search) {
        return empMapper.getEmpList(search);
    }

    // 🔹 사번으로 사원 1명 조회
    @Override
    public EmpVO getEmp(String empNo) {
        return empMapper.getEmp(empNo);
    }

    // 🔹 전체 사원 목록 조회
    @Override
    public List<EmpVO> selectEmpList() {
        return empMapper.selectEmpList();
    }

    // 🔹 인사카드용 상세 조회
    @Override
    public EmpVO selectEmpByEmpNo(String empNo) {
        return empMapper.selectEmpByEmpNo(empNo);
    }

    // 🔹 사원 삭제
    @Override
    public int deleteEmp(String empNo) {
        return empMapper.deleteEmp(empNo);
    }

    // 🔹 사원 정보 수정
    @Override
    public int updateEmp(EmpVO vo) {
        return empMapper.updateEmp(vo);
    }
    
    // 🔹 추가: 사원 등록
	@Override
	public int insertEmp(EmpVO vo) {
		return empMapper.insertEmp(vo);
	}
}
