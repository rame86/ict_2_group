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

    @Override
    public List<EmpVO> getEmpList(EmpSearchVO search) {

        List<EmpVO> list = empMapper.selectEmpList(search);

        // gradeNo → gradeName 변환
        if (list != null) {
            for (EmpVO emp : list) {
                emp.setGradeName(convertGrade(emp.getGradeNo()));
            }
        }

        return list;
    }

    @Override
    public EmpVO getEmp(String empNo) {
        return empMapper.getEmp(empNo);
    }

    @Override
    public List<EmpVO> selectEmpList() {
        EmpSearchVO search = new EmpSearchVO(); // 전체 조회
        return getEmpList(search);              // gradeName 세팅 포함
    }

    // gradeNo → gradeName 변환
    private String convertGrade(Integer gradeNo) {
        if (gradeNo == null) return "-";

        switch (gradeNo) {
            case 1: return "최고관리자";
            case 2: return "관리자";
            case 3:
            case 4: return "직원";
            case 5: return "인턴";

            default: return "기타";
        }
    }
}
