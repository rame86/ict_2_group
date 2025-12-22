package com.example.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.domain.MemberSaveVO;
import com.example.domain.MemberVO;
import com.example.repository.MemberDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    MemberDAO memberDao;


    public LoginVO loginCheck(MemberVO vo) {
        return memberDao.loginCheck(vo);
    }


    public String memberCheck(String kakaoId) {
        return memberDao.memberCheck(kakaoId);
    }


    public String empNoCheck(EmpVO vo) {  
    	return memberDao.empNoCheck(vo);
    }

    
    public Integer memberSave(MemberSaveVO vo) {
        log.info("MemberService - memberSave 요청: " + vo.toString());

        // 카카오 ID 연동 요청인 경우 (kakaoId가 존재할 때)
        if (vo.getKakaoId() != null && !vo.getKakaoId().isEmpty()) {
            
            // 1. 비밀번호 검증을 위해 MemberVO 객체 생성
            MemberVO checkVO = new MemberVO();
            checkVO.setEmpNo(vo.getEmpNo());
            checkVO.setEmpPass(vo.getEmpPass()); // 사용자가 입력한 비밀번호

            // 2. DB 정보와 대조 (사번&비번 확인)
            LoginVO loginResult = memberDao.loginCheck(checkVO);

            if (loginResult != null) {
                // 3. 비밀번호가 일치하면 -> 카카오 ID만 업데이트 (비밀번호 변경 X)
                log.info("memberSave] - 비밀번호 검증 성공. 카카오 계정 연동을 진행.");
                return memberDao.updateKakaoId(vo);
            } else {
                // 비밀번호 불일치
                log.info("memberSave] - 비밀번호 검증 실패. 연동 중단.");
                return 0; 
            }
        } 
        
        // 카카오 연동이 아닌 일반 신규 가입
        return memberDao.memberSave(vo);
    }


    public LoginVO kakaoLoginInfo(String kakaId) {
        return memberDao.kakaoLoginInfo(kakaId);
    }

}