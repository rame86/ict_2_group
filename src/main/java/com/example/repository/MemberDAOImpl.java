package com.example.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.EmpVO;
import com.example.domain.MemberVO;

@Repository
public class MemberDAOImpl implements MemberDAO{
	
	@Autowired
	private SqlSessionTemplate sess;

	@Override
	public EmpVO loginCheck(MemberVO vo) {
		return sess.selectOne("com.example.repository.MemberDAO.loginCheck", vo);
	}

}
