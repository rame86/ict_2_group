package com.example.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.EmpSearchVO;
import com.example.domain.EmpVO;
import com.example.repository.EmpMapper;

@Service
public class EmpServiceImpl implements EmpService {

    @Autowired
    private EmpMapper empMapper;

    // 🔹 검색 포함 사원 목록 조회
    @Override
    public List<EmpVO> getEmpList(EmpSearchVO search) {
        return empMapper.getEmpList(search);
    }

    // 🔹 사번으로 사원 1명 조회
    @Override
    public EmpVO getEmp(String empNo) {
        return empMapper.getEmp(empNo);
    }

    // 🔹 전체 사원 목록 조회
    @Override
    public List<EmpVO> selectEmpList() {
        return empMapper.selectEmpList();
    }

    // 🔹 인사카드용 상세 조회
    @Override
    public EmpVO selectEmpByEmpNo(String empNo) {
        return empMapper.selectEmpByEmpNo(empNo);
    }

    // 🔹 사원 삭제
    @Override
    public int deleteEmp(String empNo) {
        return empMapper.deleteEmp(empNo);
    }

    // 🔹 사원 정보 수정
    @Override
    public int updateEmp(EmpVO vo) {
        // ✅ status_no / grade_no 동기화
        syncStatusAndGrade(vo);
        return empMapper.updateEmp(vo);
    }

    // 🔹 사원 등록
    @Override
    public int insertEmp(EmpVO vo) {

        // 1) status_no / grade_no 동기화
        syncStatusAndGrade(vo);

        // 2) 비밀번호 기본값 (예: 비워두면 사번으로)
        if (vo.getEmpPass() == null || vo.getEmpPass().isBlank()) {
            vo.setEmpPass(vo.getEmpNo());
        }

        // 3) 입사일(EMP_REGDATE) 기본값: 비어 있으면 오늘 날짜로
        if (vo.getEmpRegdate() == null || vo.getEmpRegdate().isBlank()) {
            String today = LocalDate.now()
                    .format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            vo.setEmpRegdate(today);   // "2025-12-09" 같은 형식
        }

        return empMapper.insertEmp(vo);
    }

   
 // 등급/상태 동기화 로직 - 최종본
    private void syncStatusAndGrade(EmpVO vo) {

        Integer status = vo.getStatusNo();
        if (status == null) {
            return;
        }

        Integer grade = vo.getGradeNo();

        // 1) 인턴/수습 (status 6) → grade 5 고정
        if (status == 6) {
            vo.setGradeNo(5);
            return;
        }

        // 2) 퇴직(0), 휴직/대기/징계(2,3,4,5) → grade 6 고정
        if (status == 0 || status == 2 || status == 3 || status == 4 || status == 5) {
            vo.setGradeNo(6);
            return;
        }

        // 3) 재직 / 파견 (1,7) → 1~4만 허용, 잘못된 값이면 기본 3(사원)
        if (status == 1 || status == 7) {
            if (grade == null || grade < 1 || grade > 4) {
                vo.setGradeNo(3);   // 기본: 사원
            }
            return;
        }

        // 4) 혹시 정의되지 않은 status 값이 들어온 경우 안전하게 6으로
        vo.setGradeNo(6);
    }
}
