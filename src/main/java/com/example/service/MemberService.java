package com.example.service;


import com.example.domain.LoginVO;
import com.example.domain.MemberVO;

public interface MemberService {
	public LoginVO loginCheck(MemberVO vo);

}
