package com.example.repository;

import java.util.List;

import com.example.domain.DeptVO;
import com.example.domain.EmpVO;


public interface DeptDAO {
    // 조직도 전체 조회
    public List<DeptVO> selectAllDeptList();
    
    // 부서별 사원 조회
    public List<EmpVO> selectEmpListByDept(int deptNo);
}