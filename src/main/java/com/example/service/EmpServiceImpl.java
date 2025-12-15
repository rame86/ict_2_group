package com.example.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.domain.EmpSearchVO;
import com.example.domain.EmpVO;
import com.example.domain.DocVO;
import com.example.domain.EditVO;
import com.example.repository.EmpMapper;

import lombok.extern.slf4j.Slf4j;

import com.example.repository.EditMapper;
import com.example.repository.EmpDAO;

@Slf4j
@Service
public class EmpServiceImpl implements EmpService {

	@Autowired
	private EmpDAO empDAO;
	
    @Autowired
    private EmpMapper empMapper;

    // ⭐ EDIT 테이블용 Mapper
    @Autowired
    private EditMapper editMapper;

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

    // ⭐ 새로 추가하는 메소드 : 비고 히스토리 1건 INSERT
    @Override
    public void saveEmpEditHistory(String empNo,
                                   LocalDate retireDate,
                                   String eNote,
                                   String writerName) {

        // 1) 화면에서 넘어온 비고 내용 정리
        String finalNote = (eNote != null) ? eNote.trim() : "";

        // 2) 퇴사일이 있고, 아직 '퇴사일 :' 문구가 없으면 자동으로 한 줄 추가
        if (retireDate != null && !finalNote.contains("퇴사일 :")) {
            String retireLine = "퇴사일 : " + retireDate.toString();  // yyyy-MM-dd

            if (finalNote.isEmpty()) {
                finalNote = retireLine;
            } else {
                finalNote = retireLine + "\n" + finalNote;
            }
        }

        // 완전히 비어 있으면 저장 안 함
        if (finalNote.isEmpty()) {
            return;
        }

        // 3) EditVO 만들어서 INSERT (항상 누적)
        EditVO vo = new EditVO();
        vo.setEmpNo(empNo);
        vo.setENote(finalNote);
        vo.setWriter(writerName);   // 예: "홍보경 매니저"

        editMapper.insertEdit(vo);
    }

    /**
     * EDIT 테이블의 이력 전체를 한 문자열로 만들어서 돌려줌
     */
    @Override
    public String getEditNoteHistory(String empNo) {

        List<EditVO> list = editMapper.selectEditListByEmpNo(empNo); // 최신순 정렬
        if (list == null || list.isEmpty()) {
            return "";
        }

        StringBuilder sb = new StringBuilder();

        for (EditVO e : list) {

            String dayStr = (e.getUpdateDay() != null) ? e.getUpdateDay() : "";
            String writer = (e.getWriter() != null) ? e.getWriter() : "";

            // [yyyy-MM-dd / 홍길동] 형식
            sb.append("[")
              .append(dayStr)
              .append(" / ")
              .append(writer)
              .append("]\n");

            // 실제 비고 내용
            if (e.getENote() != null) {
                sb.append(e.getENote().trim());
            }
            sb.append("\n\n"); // 이력 사이 공백 줄
        }

        return sb.toString().trim();
    }

    // 필요하다면 마지막 이력 1건 반환 (안 쓰면 나중에 지워도 됨)
    @Override
    public EditVO getLastEdit(String empNo) {
        return editMapper.selectLastEditByEmpNo(empNo);
    }
    
 // =======================================================================================
 	// setDeptManager()
 	@Transactional
 	public void setEmpJobTitle(DocVO vo) {
 		log.info("[EmpServiceImpl - setDeptManager 요청 받음]"); 		
 		empDAO.setEmpJobTitle(vo);
 				
 	}	
 	// end of setDeptManager()	
 	// =======================================================================================
 	
 	//

    
}
