package com.example.service;

import java.util.List;

import com.example.domain.DeptVO;
import com.example.domain.EmpVO;

public interface DeptService {

	List<DeptVO> getDeptList();

	public List<DeptVO> getOrgChartData();

	public List<EmpVO> getEmployeesByDept(int deptNo);
}
