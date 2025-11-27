package com.example.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.ApproveVO;
import com.example.domain.DocVO;

@Repository
public class ApproveDAOImpl implements ApproveDAO {

	@Autowired
	private SqlSessionTemplate sess;
	
	@Override
	public void insertDoc(DocVO vo) {
		sess.insert("com.example.domain.ApproveDAO.insertDoc", vo);
	}

	@Override
	public void insertApprove(ApproveVO vo) {
		sess.insert("com.example.domain.ApproveDAO.insertApprove", vo);
		
	}

}
