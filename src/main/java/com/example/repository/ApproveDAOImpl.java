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

import lombok.extern.slf4j.Slf4j;

@Slf4j
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
	
	// TEST
	@Override
	public List<ApproveListVO> selectSendApproveList(Map<String, Object> param) {
		return sess.selectList("com.example.repository.ApproveDAO.selectSendApproveList", param);
	}
	
	// 결재 받을 문서 TEST
	@Override
	public List<ApproveListVO> selectReceiveApproveList(Map<String, Object> param) {
		return sess.selectList("com.example.repository.ApproveDAO.selectReceiveApproveList", param);
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
	public DocVO selectDocNo(int docNo) {
		return sess.selectOne("com.example.repository.ApproveDAO.selectDocNo", docNo);
	}

	@Override
	public void updateApproveStatus(Map<String, Object> param) {
		sess.update("com.example.repository.ApproveDAO.updateApproveStatus", param);
	}

	@Override
	public void updateRejectStatus(Map<String, Object> param) {
		sess.update("com.example.repository.ApproveDAO.updateRejectStatus", param);
	}

	@Override
	public List<ApproveListVO> selectWaitingReceiveListLimit(Map<String, Object> param) {
		return sess.selectList("com.example.repository.ApproveDAO.selectWaitingReceiveListLimit", param);
	}

	@Override
	public List<Map<String, Object>> countSendApproveStatus(String empNo) {
		return sess.selectList("com.example.repository.ApproveDAO.countSendApproveStatus", empNo);
	}

	// 최신알람(결재해야될것)
	@Override
	public List<ApproveListVO> selectWaitingApproveAlerts(Map<String, Object> param) {
		return sess.selectList("com.example.repository.ApproveDAO.selectWaitingApproveAlerts", param);
	}

	// 최신알람(결재받은것)
	@Override
	public List<ApproveListVO> selectSendStatusChangeAlerts(Map<String, Object> param) {
		return sess.selectList("com.example.repository.ApproveDAO.selectSendStatusChangeAlerts", param);
	}

}
