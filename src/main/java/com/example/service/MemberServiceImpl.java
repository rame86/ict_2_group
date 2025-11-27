package com.example.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.EmpVO;
import com.example.domain.MemberVO;
import com.example.repository.MemberDAO;

@Service
public class MemberServiceImpl implements MemberService{
	
	@Autowired
	MemberDAO memberDao;

	@Override
	public EmpVO loginCheck(MemberVO vo) {
		return memberDao.loginCheck(vo);
	}

}
