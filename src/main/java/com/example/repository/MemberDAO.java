package com.example.repository;

import com.example.domain.EmpVO;
import com.example.domain.MemberVO;

public interface MemberDAO {
	public EmpVO loginCheck(MemberVO vo);

}
