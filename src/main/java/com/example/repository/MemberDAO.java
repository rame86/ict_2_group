package com.example.repository;

import com.example.domain.LoginVO;
import com.example.domain.MemberSaveVO;
import com.example.domain.MemberVO;

public interface MemberDAO {
	public LoginVO loginCheck(MemberVO vo);

	public String memberCheck(String kakaoId);

	public Integer memberSave(MemberSaveVO vo);
	
	public LoginVO kakaoLoginInfo(String kakaId);
}
