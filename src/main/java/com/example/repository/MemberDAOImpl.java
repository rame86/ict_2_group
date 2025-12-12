package com.example.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.domain.MemberSaveVO;
import com.example.domain.MemberVO;


import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class MemberDAOImpl implements MemberDAO {

	@Autowired
	private SqlSessionTemplate sess;

	// 로그인 아이디 비번 체크
	public LoginVO loginCheck(MemberVO vo) {
		return sess.selectOne("com.example.repository.MemberDAO.loginCheck", vo);
	}

	// 회원가입 상태 확인
	public String memberCheck(String kakaoId) {
		return sess.selectOne("com.example.repository.MemberDAO.KakaoMemberCheck", kakaoId);
	}

	// emp넘버 조회
	public String empNoCheck(EmpVO vo) {
	    log.info("empNoCheck 요청받음 :" + vo.toString());

	    // 기본값 "3": 사원정보 불일치 (사번+이름으로 조회된 결과가 없음)
	    String result = "3"; 
	    
	    // 카카오 로그인 체크용 (필요하다면 유지)
	    String kakaoId = vo.getKakaoId();

	    // 1. 사번과 이름으로 조회
	    EmpVO selectVO = sess.selectOne("com.example.repository.MemberDAO.empNoCheck", vo);

	    // 2. 조회 결과가 있다면 (사번과 이름이 일치함)
	    if (selectVO != null) {
	        
	        // 이메일 정보 가져오기
	        String empEmail = selectVO.getEmpEmail();
	        
	        log.info("조회된 이메일: " + empEmail);

	        // 3. 가입 여부 체크 로직
	        // 이메일이 null이 아니고, 빈 문자열("")도 아니라면 -> 이미 가입된 사람
	        if (empEmail != null && !empEmail.trim().isEmpty()) {
	            result = "2"; // "이미 가입된 사원입니다."
	        } else {
	            result = "1"; // "가입 가능합니다." (이메일이 없음)
	        }

	        // 카카오톡 연동 로직 (기존 로직 유지)
	        if (kakaoId != null) {
	            result = "4"; 
	        }
	    }

	    log.info("최종 결과 코드: " + result);
	    return result;
	}

	public Integer memberSave(MemberSaveVO vo) {
		return sess.insert("com.example.repository.MemberDAO.insertMember", vo);

	}

	public LoginVO kakaoLoginInfo(String kakaId) {
		return sess.selectOne("com.example.repository.MemberDAO.kakaoLoginInfo", kakaId);
	}
}
