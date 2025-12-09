package com.example.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.domain.MemberSaveVO;
import com.example.domain.MemberVO;

import jakarta.servlet.http.HttpSession;
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

		String result = "3";
		String kakaoId = vo.getKakaoId();
		EmpVO selectVO = sess.selectOne("com.example.repository.MemberDAO.empNoCheck", vo);

		if (selectVO != null) {

			String empEmail = selectVO.getEmpEmail();

			result = "1";
			log.info("empEmail 내용 : " + empEmail);
			if (!empEmail.equals("null")) {
				result = "2";
			}

			if (kakaoId != null) {
				result = "4";

			}
		}
		log.info(result);
		return result;
	}

	public Integer memberSave(MemberSaveVO vo) {
		return sess.insert("com.example.repository.MemberDAO.insertMember", vo);

	}

	public LoginVO kakaoLoginInfo(String kakaId) {
		return sess.selectOne("com.example.repository.MemberDAO.kakaoLoginInfo", kakaId);
	}
}
