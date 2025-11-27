package com.example.repository;

import com.example.domain.ApproveVO;
import com.example.domain.DocVO;

public interface ApproveDAO {
	void insertDoc(DocVO vo);
	void insertApprove(ApproveVO vo);
}
