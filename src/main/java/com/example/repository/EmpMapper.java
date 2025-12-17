package com.example.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.domain.EmpSearchVO;
import com.example.domain.EmpVO;
import com.example.domain.LoginVO;
import com.example.domain.MemberVO;

@Mapper
public interface EmpMapper {

    // 검색 포함 목록
    List<EmpVO> getEmpList(EmpSearchVO search);

    // 단건 조회 (기존)
    EmpVO getEmp(String empNo);

    // 로그인 체크 (기존)
    LoginVO loginCheck(MemberVO vo);

    // 전체 목록 (검색 없이)
    List<EmpVO> selectEmpList();

    // 인사카드용 상세
    EmpVO selectEmpByEmpNo(String empNo);

    // 삭제 / 수정 / 등록
    int deleteEmp(String empNo);
    int updateEmp(EmpVO vo);
    int insertEmp(EmpVO vo);

    // 사번 중복 카운트
    int isEmpNoDuplicate(String empNo);
    
    // 알람용
    List<String> selectEmpNoListByDept(String deptNo);
    List<String> selectAllEmpNoList();
    
}
