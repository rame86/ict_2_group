package com.example.repository;

import com.example.domain.LoginVO;
import com.example.domain.MemberSaveVO;
import com.example.domain.MemberVO;

public interface MemberDAO {
	public LoginVO loginCheck(MemberVO vo);

	public Integer memberCheck(Long kakaoId);

	public Long getNextMemberNo();
	
	public Integer memberSave(MemberSaveVO vo);
}
