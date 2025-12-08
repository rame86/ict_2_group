package com.example.service;

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

    // 🔹 검색 포함 사원 목록
    @Override
    public List<EmpVO> getEmpList(EmpSearchVO search) {
        return empMapper.getEmpList(search);
    }

    // 🔹 사번으로 조회
    @Override
    public EmpVO getEmp(String empNo) {
        return empMapper.getEmp(empNo);
    }

    // 🔹 전체 사원 목록
    @Override
    public List<EmpVO> selectEmpList() {
        return empMapper.selectEmpList();
    }

    // 🔹 인사카드용 상세조회
    @Override
    public EmpVO selectEmpByEmpNo(String empNo) {
        return empMapper.selectEmpByEmpNo(empNo);
    }

    // 🔹 삭제
    @Override
    public int deleteEmp(String empNo) {
        return empMapper.deleteEmp(empNo);
    }

    // 🔹 수정 (status_no / grade_no 규칙 적용 포함)
    @Override
    public int updateEmp(EmpVO vo) {
        applyStatusGradeRule(vo);
        return empMapper.updateEmp(vo);
    }

    // 🔹 등록 (status_no / grade_no 규칙 적용 포함)
    @Override
    public int insertEmp(EmpVO vo) {
        applyStatusGradeRule(vo);
        return empMapper.insertEmp(vo);
    }

    // 🔹 사번 중복 여부
    @Override
    public boolean isEmpNoDuplicate(String empNo) {
        return empMapper.isEmpNoDuplicate(empNo) > 0;
    }

    /**
     * status_no / grade_no 규칙
     *
     *  status_no = 6(인턴/수습) → grade_no = 5
     *  status_no in (0,2,3,4,5) → grade_no = 6
     *  status_no in (1,7)      → grade_no 1~4만 허용, 아니면 3으로 보정
     *  그 외 값                 → 안전하게 6으로 고정
     */
    private void applyStatusGradeRule(EmpVO vo) {
        Integer status = vo.getStatusNo();
        if (status == null) {
            return;
        }

        int s = status.intValue();
        Integer grade = vo.getGradeNo();

        // 인턴/수습
        if (s == 6) {
            vo.setGradeNo(5);
            return;
        }

        // 퇴직/휴직/대기/징계
        if (s == 0 || s == 2 || s == 3 || s == 4 || s == 5) {
            vo.setGradeNo(6);
            return;
        }

        // 재직 / 파견
        if (s == 1 || s == 7) {
            if (grade == null) {
                vo.setGradeNo(3);
            } else {
                int g = grade.intValue();
                if (g < 1 || g > 4) {
                    vo.setGradeNo(3);
                }
            }
            return;
        }

        // 정의 안 된 값은 기타
        vo.setGradeNo(6);
    }
}
