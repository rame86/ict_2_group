package com.example.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.ApproveListVO;
import com.example.domain.ApproveVO;
import com.example.domain.DeptVO;
import com.example.domain.DocVO;

@Repository
public class ApproveDAOImpl implements ApproveDAO {

	@Autowired
	private SqlSessionTemplate sess;
	
	@Override
	public void insertDoc(DocVO vo) {
		sess.insert("com.example.repository.ApproveDAO.insertDoc", vo);
	}

	@Override
	public void insertApprove(ApproveVO vo) {
		sess.insert("com.example.repository.ApproveDAO.insertApprove", vo);
	}

	@Override
	public int selectDocSeqNextVal() {
		return sess.selectOne("com.example.repository.ApproveDAO.selectDocSeqNextVal");
	}

	@Override
	public DeptVO selectManager(int empNo) {
		return sess.selectOne("com.example.repository.ApproveDAO.selectManager", empNo);
	}

	@Override
	public DeptVO selectParentDept(int deptNo) {
		return sess.selectOne("com.example.repository.ApproveDAO.selectParentDept", deptNo);
	}

	@Override
	public List<ApproveListVO> selectSendApproveList(String empNo, Integer limit) {
		Map<String, Object> param = new HashMap<>();
		
		param.put("empNo", empNo);
		param.put("limit", limit);
		
		return sess.selectList("com.example.repository.ApproveDAO.selectSendApproveList", param);
	}
	
	// 편의용
	@Override
	public List<ApproveListVO> selectSendApproveList(String empNo) {
		return selectSendApproveList(empNo, null);
	}

	@Override
	public List<ApproveListVO> selectReceiveApproveList(String empNo, Integer limit) {
		Map<String, Object> param = new HashMap<>();
		
		param.put("empNo", empNo);
		param.put("limit", limit);
		
		return sess.selectList("com.example.repository.ApproveDAO.selectReceiveApproveList", param);
	}
	
	// 편의용
	@Override
	public List<ApproveListVO> selectReceiveApproveList(String empNo) {
		return selectReceiveApproveList(empNo, null);
	}

}
