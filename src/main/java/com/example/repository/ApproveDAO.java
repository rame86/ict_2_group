package com.example.repository;

import java.util.List;
import java.util.Map;

import com.example.domain.ApproveListVO;
import com.example.domain.ApproveVO;
import com.example.domain.DeptVO;
import com.example.domain.DocVO;

public interface ApproveDAO {
	public void insertDoc(DocVO vo);
	public void insertApprove(ApproveVO vo);
	public int selectDocSeqNextVal();
	public DeptVO selectManager(int empNo);
	public DeptVO selectParentDept(int deptNo);
	public List<ApproveListVO> selectReceiveApproveList(Map<String, Object> pram);
	public List<ApproveListVO> selectSendApproveList(Map<String, Object> param);
	public List<ApproveListVO> selectSendApproveList(String empNo, Integer limit);
	public List<ApproveListVO> selectSendApproveList(String empNo);
	public List<ApproveListVO> selectWaitingReceiveListLimit(Map<String, Object> param);
	public DocVO selectDocNo(int docNo);
	public void updateApproveStatus(Map<String, Object> param);
	public void updateRejectStatus(Map<String, Object> param);
	public List<Map<String, Object>> countSendApproveStatus(String empNo);
	public List<ApproveListVO> selectWaitingApproveAlerts(Map<String, Object> param);
	public List<ApproveListVO> selectSendStatusChangeAlerts(Map<String, Object> param);
}
