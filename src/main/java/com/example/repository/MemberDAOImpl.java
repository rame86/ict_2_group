package com.example.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.MemberVO;

@Repository
public class MemberDAOImpl implements MemberDAO{
	
	@Autowired
	SqlSessionTemplate sess;

	@Override
	public MemberVO loginCheck(MemberVO vo) {
		return sess.selectOne("com.example.domain.MemberVO.loginCheck", vo);
	}

}
