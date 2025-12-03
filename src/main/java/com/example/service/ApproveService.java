package com.example.service;

import java.util.List;
import java.util.Map;

import com.example.domain.ApproveListVO;
import com.example.domain.ApproveVO;
import com.example.domain.DocVO;

public interface ApproveService {
	public void ApprovalApplication(DocVO dvo, ApproveVO avo);
	public Map<String, List<ApproveListVO>> selectReceiveApproveList(String empNo);
	public List<ApproveListVO> selectWaitingReceiveList(String empNo);
	public List<ApproveListVO> selectFinishReceiveList(String empNo);
	public Map<String, List<ApproveListVO>> selectSendApproveList(String empNo);
	public Map<String, List<ApproveListVO>> approveStatusList(String empNo, Integer limit);
	public DocVO selectDocNo(Integer docNo);
	public void approveDocument(Integer docNo, String status, Integer empNo, String rejectReason);
	public Map<String, Integer> getSendCount(String empNo);
}
