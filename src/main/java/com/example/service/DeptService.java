package com.example.service;

import java.util.List;

import com.example.domain.DeptVO;
import com.example.domain.DocVO;
import com.example.domain.EmpVO;

public interface DeptService {

	List<DeptVO> getDeptList();

	public List<DeptVO> getOrgChartData();

	public List<EmpVO> getEmployeesByDept(int deptNo);

	void createDept(DeptVO vo);

	void removeDept(int deptNo);
	
	void changeEmpDept(int empNo, int newDeptNo, String writerEmpNo, String note);
	
	public void setDeptManager(DocVO vo);
	
}
