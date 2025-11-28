package com.example.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.LoginVO;
import com.example.domain.MemberSaveVO;
import com.example.domain.MemberVO;

@Repository
public class MemberDAOImpl implements MemberDAO {

	@Autowired
	private SqlSessionTemplate sess;

	// 로그인 아이디 비번 체크
	public LoginVO loginCheck(MemberVO vo) {
		return sess.selectOne("com.example.repository.MemberDAO.loginCheck", vo);
	}

	// 회원가입 상태 확인
	public Integer memberCheck(Long kakaoId) {
		return sess.selectOne("com.example.repository.MemberDAO.memberCheck", kakaoId);
	}

	@Override
	public Long getNextMemberNo() {
		return sess.selectOne("com.example.repository.MemberDAO.getNextMemberNo");

	}

	public Integer memberSave(MemberSaveVO vo) {
		sess.insert("com.example.repository.MemberDAO.insertMember", vo);
		return sess.insert("com.example.repository.MemberDAO.insertKakaoApiLink", vo);

	}

}
