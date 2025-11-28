package com.example.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.LoginVO;
import com.example.domain.MemberSaveVO;
import com.example.domain.MemberVO;
import com.example.repository.MemberDAO;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	MemberDAO memberDao;

	public LoginVO loginCheck(MemberVO vo) {
		return memberDao.loginCheck(vo);
	}

	public String memberCheck(String kakaoId) {
		return memberDao.memberCheck(kakaoId);
	}

	@Override
	public Long getNextMemberNo() {

		return memberDao.getNextMemberNo();
	}

	public Integer memberSave(MemberSaveVO vo) {
		return memberDao.memberSave(vo);
	}

	public LoginVO kakaoLoginInfo(String kakaId) {
		return memberDao.kakaoLoginInfo(kakaId);

	}
}
