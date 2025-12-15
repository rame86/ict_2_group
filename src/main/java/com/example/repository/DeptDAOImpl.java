package com.example.repository;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.DeptVO;
import com.example.domain.DocVO;
import com.example.domain.EmpVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class DeptDAOImpl implements DeptDAO {

	@Autowired
	private SqlSessionTemplate sess;

	private static final String NAMESPACE = "com.example.repository.DeptDAO";

	public List<DeptVO> selectAllDeptList() {
		return sess.selectList(NAMESPACE+".selectAllDeptList");
	}

	public List<EmpVO> selectEmpListByDept(int deptNo) {
		return sess.selectList(NAMESPACE+".selectEmpListByDept", deptNo);
	}

	// 부서서 생성
	public int insertDept(DeptVO vo) {
		// XML id="insertDept" 호출
		return sess.insert(NAMESPACE + ".insertDept", vo);
	}

	// 부서 삭제 전 사원 업데이트

	public int updateEmpDeptNull(int deptNo) {
		// XML id="updateEmpDeptNull" 호출
		return sess.update(NAMESPACE + ".updateEmpDeptNull", deptNo);
	}

	// 부서 삭제	
	public int deleteDept(int deptNo) {
		// XML id="deleteDept" 호출
		return sess.delete(NAMESPACE + ".deleteDept", deptNo);
	}
	
	// 사원 부서 이동
    @Override
    public int updateEmpDept(Map<String, Object> map) {
        // XML id="updateEmpDept" 호출
        return sess.update(NAMESPACE + ".updateEmpDept", map);
    }

    // 변경 이력 로그 저장
    @Override
    public int insertEditLog(Map<String, Object> map) {
        // XML id="insertEditLog" 호출
        return sess.insert(NAMESPACE + ".insertEditLog", map);
    }
    
	// =======================================================================================
	// setDeptManager()
	public void setDeptManager(DocVO vo) {
		log.info("[DeptDAO - setDeptManager 요청 받음]");
		sess.update("com.example.repository.DeptDAO.setDeptManager", vo);
	}
	// end of setDeptManager()
	// =======================================================================================
    
}