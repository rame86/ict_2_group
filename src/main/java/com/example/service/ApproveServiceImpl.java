package com.example.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.ApproveVO;
import com.example.domain.DocVO;
import com.example.repository.ApproveDAO;

@Service
public class ApproveServiceImpl implements ApproveService {

	@Autowired
	private ApproveDAO approveDao;
	
	@Override
	public void ApprovalApplication(DocVO dvo, ApproveVO avo) {
		approveDao.insertApprove(avo);
	}

}
