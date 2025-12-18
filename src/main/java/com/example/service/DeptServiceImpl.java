package com.example.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.domain.DeptVO;
import com.example.domain.DocVO;

import com.example.domain.EmpVO;
import com.example.repository.DeptDAO;
import com.example.repository.EmpDAO;
import com.example.repository.EmpDeptMapper;

@Service
public class DeptServiceImpl implements DeptService {

	@Autowired
	private EmpDeptMapper deptMapper;
	@Autowired
	private DeptDAO deptDAO;
	@Autowired
	private EmpDAO empDAO;

	public List<DeptVO> getDeptList() {
		return deptMapper.getDeptList();
	}

	public List<DeptVO> getOrgChartData() {

		return deptDAO.selectAllDeptList();
	}

	public List<EmpVO> getEmployeesByDept(int deptNo) {
		return deptDAO.selectEmpListByDept(deptNo);
	}

	public void createDept(DeptVO vo) {
		deptDAO.insertDept(vo);
	}

	@Transactional // ⭐️ 트랜잭션 필수: 사원 업데이트 후 부서 삭제가 원자적으로 일어나야 함
	public void removeDept(int deptNo) {
		// 1. 해당 부서원들을 무소속으로 변경
		deptDAO.updateEmpDeptNull(deptNo);
		// 2. 부서 삭제
		deptDAO.deleteDept(deptNo);
	}

	@Transactional
	public void changeEmpDept(int empNo, int newDeptNo, String writerEmpNo, String note) {
		// 1. Map 생성 (파라미터 포장)
		Map<String, Object> map = new HashMap<>();
		map.put("empNo", empNo);
		map.put("deptNo", newDeptNo);
		map.put("writer", writerEmpNo);
		map.put("eNote", note); // "부서 이동"

		// 2. 사원 정보 업데이트
		deptDAO.updateEmpDept(map);

		// 3. 로그 저장
		deptDAO.insertEditLog(map);
	}

	public void setDeptManager(DocVO vo) {
		Map<String, Object> map = new HashMap<>();
		map.put("empNo", vo.getTargetEmpNo());
		map.put("writer", vo.getEmpNo());
		map.put("targetDeptNo", vo.getTargetDeptNo());
		
		if (vo.getDocType().equals("6")) {
			map.put("jobTitle", vo.getMemo()+" 부서장");
			map.put("eNote", vo.getMemo() + "부서장 임명 및 권한등급 상향");
			map.put("targetGradeNo", 2);
			map.put("managerEmpNo", vo.getTargetEmpNo());
			
		}else if  (vo.getDocType().equals("7")) {			
			map.put("jobTitle", "사원");
			map.put("eNote", vo.getMemo() + "부서장 해임 및 권한등급 하향");
			map.put("targetGradeNo", 3);
			map.put("managerEmpNo", null);
		}

		deptDAO.setDeptManager(map);
		empDAO.setEmpJobTitle(map);
	}
	
	// 부서 수정
    public void editDept(DeptVO vo) {
        deptDAO.updateDept(vo);
    }
}
