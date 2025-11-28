package com.example.repository;

import java.util.List;

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
	public List<ApproveListVO> selectSendApproveList(String empNo, Integer limit);
	public List<ApproveListVO> selectSendApproveList(String empNo);
	public List<ApproveListVO> selectReceiveApproveList(String empNo, Integer limit);
	public List<ApproveListVO> selectReceiveApproveList(String empNo);
}
