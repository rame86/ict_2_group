package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.DeptVO;
import com.example.domain.EmpVO;
import com.example.repository.DeptDAO;
import com.example.repository.EmpDeptMapper;

@Service
public class DeptServiceImpl implements DeptService {

	@Autowired
	private EmpDeptMapper deptMapper;
	@Autowired
	private DeptDAO deptDAO;

	public List<DeptVO> getDeptList() {
		return deptMapper.getDeptList();
	}

	public List<DeptVO> getOrgChartData() {

		return deptDAO.selectAllDeptList();
	}

	public List<EmpVO> getEmployeesByDept(int deptNo) {
		return deptDAO.selectEmpListByDept(deptNo);
	}

}
