package com.example.repository;

import com.example.domain.LoginVO;
import com.example.domain.MemberVO;

public interface MemberDAO {
	public LoginVO loginCheck(MemberVO vo);

}
