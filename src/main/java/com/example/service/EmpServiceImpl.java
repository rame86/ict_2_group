package com.example.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.domain.DocVO;
import com.example.domain.EditVO;
import com.example.domain.EmpSearchVO;
import com.example.domain.EmpVO;
import com.example.repository.EditMapper;
import com.example.repository.EmpMapper;
import com.example.repository.EmpDAO;

import lombok.extern.slf4j.Slf4j;

/**
 * EmpServiceImpl
 * -------------------------------------------------
 * EmpService 구현체
 *
 * ✔ 재직상태/권한등급 규칙을 Service 레벨에서 강제
 * ✔ 사원 비고(Edit) 이력 누적 관리
 * ✔ EmpMapper(MyBatis) 기준 구현
 *
 * ⚠ EmpDAO 관련
 * - EmpDAO는 팀 내 다른 구현 방식으로 존재
 * - 본 구현에서는 사용하지 않으며,
 *   향후 구조 통합 시 제거 또는 분리 예정
 */
@Slf4j
@Service
public class EmpServiceImpl implements EmpService {

    /* =====================================================
       Repository / Mapper
       ===================================================== */

    @Autowired
    private EmpMapper empMapper;

    @Autowired
    private EditMapper editMapper;

    @Autowired
    private EmpDAO empDAO; 
    // ⚠ 현재 ServiceImpl에서는 사용하지 않음
    // (팀 내 DAO 방식 구현과의 공존 상태)

    /* =====================================================
       사원 조회
       ===================================================== */

    @Override
    public List<EmpVO> getEmpList(EmpSearchVO search) {
        return empMapper.getEmpList(search);
    }

    @Override
    public EmpVO getEmp(String empNo) {
        return empMapper.getEmp(empNo);
    }

    @Override
    public List<EmpVO> selectEmpList() {
        return empMapper.selectEmpList();
    }

    @Override
    public EmpVO selectEmpByEmpNo(String empNo) {
        return empMapper.selectEmpByEmpNo(empNo);
    }

    /* =====================================================
       사원 삭제 / 수정 / 등록
       ===================================================== */

    @Override
    public int deleteEmp(String empNo) {
        // ⚠ 사원 삭제 시 사진 파일, 급여/근태 등
        // 연관 데이터 처리는 Controller 또는 상위 로직에서 선처리
        return empMapper.deleteEmp(empNo);
    }

    @Override
    public int updateEmp(EmpVO vo) {
        applyStatusGradeRule(vo);
        return empMapper.updateEmp(vo);
    }

    @Override
    public int insertEmp(EmpVO vo) {
        applyStatusGradeRule(vo);
        return empMapper.insertEmp(vo);
    }

    @Override
    public boolean isEmpNoDuplicate(String empNo) {
        return empMapper.isEmpNoDuplicate(empNo) > 0;
    }

    /* =====================================================
       재직상태 / 권한등급 규칙 (중앙 집중 관리)
       ===================================================== */

    /**
     * 재직상태(statusNo) ↔ 권한등급(gradeNo) 규칙
     *
     *  statusNo = 6 (인턴/수습)        → gradeNo = 5
     *  statusNo = 0,2,3,4,5 (퇴직/휴직 등) → gradeNo = 6
     *  statusNo = 1,7 (재직/파견)      → gradeNo 1~4만 허용
     *  그 외 값                         → gradeNo = 6
     */
    private void applyStatusGradeRule(EmpVO vo) {
        Integer status = vo.getStatusNo();
        if (status == null) return;

        Integer grade = vo.getGradeNo();

        switch (status) {
            case 6: // 인턴/수습
                vo.setGradeNo(5);
                break;

            case 0: case 2: case 3: case 4: case 5: // 퇴직/휴직/대기/징계
                vo.setGradeNo(6);
                break;

            case 1: case 7: // 재직 / 파견
                if (grade == null || grade < 1 || grade > 4) {
                    vo.setGradeNo(3); // 기본 사원
                }
                break;

            default:
                vo.setGradeNo(6);
        }
    }

    /* =====================================================
       사원 비고(Edit) 이력 관리
       ===================================================== */

    @Override
    public void saveEmpEditHistory(String empNo,
                                   LocalDate retireDate,
                                   String eNote,
                                   String writerName) {

        String finalNote = (eNote != null) ? eNote.trim() : "";

        // 퇴사일 자동 문구 추가
        if (retireDate != null && !finalNote.contains("퇴사일 :")) {
            String retireLine = "퇴사일 : " + retireDate;
            finalNote = finalNote.isEmpty()
                    ? retireLine
                    : retireLine + "\n" + finalNote;
        }

        if (finalNote.isEmpty()) return;

        EditVO vo = new EditVO();
        vo.setEmpNo(empNo);
        vo.setENote(finalNote);
        vo.setWriter(writerName);

        editMapper.insertEdit(vo);
    }

    @Override
    public String getEditNoteHistory(String empNo) {
        List<EditVO> list = editMapper.selectEditListByEmpNo(empNo);
        if (list == null || list.isEmpty()) return "";

        StringBuilder sb = new StringBuilder();
        for (EditVO e : list) {
            sb.append("[")
              .append(e.getUpdateDay() != null ? e.getUpdateDay() : "")
              .append(" / ")
              .append(e.getWriter() != null ? e.getWriter() : "")
              .append("]\n");

            if (e.getENote() != null) {
                sb.append(e.getENote().trim());
            }
            sb.append("\n\n");
        }
        return sb.toString().trim();
    }

    @Override
    public EditVO getLastEdit(String empNo) {
        return editMapper.selectLastEditByEmpNo(empNo);
    }

    /* =====================================================
       조직/직책 연계
       ===================================================== */

    @Override
    @Transactional
    public void setEmpJobTitle(DocVO vo) {
        log.info("[EmpServiceImpl] setEmpJobTitle 호출 - 부서/직책 일괄 처리");
        // 실제 로직은 Doc/Dept 모듈에서 처리
    }
}
