package com.example.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


import com.example.domain.LoginVO;
import com.example.domain.MemberVO;

@Repository
public class MemberDAOImpl implements MemberDAO{
	
	@Autowired
	private SqlSessionTemplate sess;

	// 로그인 아이디 비번 체크
	public LoginVO loginCheck(MemberVO vo) {
		return sess.selectOne("com.example.repository.MemberDAO.loginCheck", vo);
	}
	
	// 회원가입 상태 확인
	@Override
	public Integer memberCheck(Long kakaoId) {
		return sess.selectOne("com.example.repository.MemberDAO.memberCheck", kakaoId);
	}

}
