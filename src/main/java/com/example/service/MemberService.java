package com.example.service;

import com.example.domain.LoginVO;
import com.example.domain.MemberSaveVO;
import com.example.domain.MemberVO;

public interface MemberService {
	public LoginVO loginCheck(MemberVO vo);

	public String memberCheck(String kakaoId);

	public String empNoCheck(String empNo);

	public Integer memberSave(MemberSaveVO vo);

	public LoginVO kakaoLoginInfo(String kakaId);

	
	

}
