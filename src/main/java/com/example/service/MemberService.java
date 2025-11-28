package com.example.service;


import com.example.domain.LoginVO;
import com.example.domain.MemberSaveVO;
import com.example.domain.MemberVO;

public interface MemberService {
	public LoginVO loginCheck(MemberVO vo);

	public Integer memberCheck(Long kakaoId);
	
	public Long getNextMemberNo();
	
	public Integer memberSave(MemberSaveVO vo);
}
