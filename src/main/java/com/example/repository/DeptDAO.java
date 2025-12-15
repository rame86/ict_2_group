package com.example.repository;

import java.util.List;
import java.util.Map;

import com.example.domain.DeptVO;
import com.example.domain.DocVO;
import com.example.domain.EmpVO;

public interface DeptDAO {
	// 조직도 전체 조회
	public List<DeptVO> selectAllDeptList();

	// 부서별 사원 조회
	public List<EmpVO> selectEmpListByDept(int deptNo);

	// 부서 생성
	int insertDept(DeptVO vo);

	// 부서 삭제 전, 해당 부서 사원들 무소속(NULL) 처리
	int updateEmpDeptNull(int deptNo);

	// 부서 삭제
	int deleteDept(int deptNo);
	
	// 부서 이동	
    int updateEmpDept(Map<String, Object> map);

   // 부서 변경 이력 로그 저장
    int insertEditLog(Map<String, Object> map);
    
    //부서장 임명
    public void setDeptManager(DocVO vo);
}