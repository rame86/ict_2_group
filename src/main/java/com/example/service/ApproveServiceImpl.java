package com.example.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.domain.ApproveListVO;
import com.example.domain.ApproveVO;
import com.example.domain.DeptVO;
import com.example.domain.DocVO;
import com.example.repository.ApproveDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ApproveServiceImpl implements ApproveService {

	@Autowired
	private ApproveDAO approveDao;
	
	@Override
	@Transactional
	public void ApprovalApplication(DocVO dvo, ApproveVO avo) {
		
		int docNo = approveDao.selectDocSeqNextVal();
		int empNo = avo.getEmpNo();
		
		dvo.setDocNo(docNo);
		approveDao.insertDoc(dvo);
		
		avo.setDocNo(docNo);
		
		DeptVO manager = approveDao.selectManager(empNo);
		avo.setStep1ManagerNo(manager.getManagerEmpNo());
		if(avo.getStep1Status() == null) avo.setStep1Status("W");
		
		int deptNo = Integer.parseInt(manager.getDeptNo());
		System.out.println(deptNo);
		
		DeptVO parent = approveDao.selectParentDept(deptNo);
		if(manager.getDeptNo() == (parent.getParentDeptNo())) {
			avo.setStep2ManagerNo("X");
			avo.setStep2Status("X");
		}else {
			System.out.println(parent.getParentDeptNo());
			avo.setStep2ManagerNo(parent.getParentManagerEmpNo());
			avo.setStep2Status("W");
		}
		
		approveDao.insertApprove(avo);
		
	}

	@Override
	public List<ApproveListVO> selectSendApproveList(String empNo) {
		return approveDao.selectSendApproveList(empNo);
	}

	@Override
	public List<ApproveListVO> selectReceiveApproveList(String empNo) {
		return approveDao.selectReceiveApproveList(empNo);
	}

	@Override
	public Map<String, List<ApproveListVO>> approveStatusList(String empNo, Integer limit) {
		
		List<ApproveListVO> send = approveDao.selectSendApproveList(empNo, limit);
		List<ApproveListVO> receive = approveDao.selectReceiveApproveList(empNo, limit);
		Map<String, List<ApproveListVO>> result = new HashMap<>();
		
		result.put("send", send);
		result.put("receive", receive);
		
		return result;
		
	}

}
