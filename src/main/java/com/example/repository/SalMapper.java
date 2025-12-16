package com.example.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.domain.SalEditVO;
import com.example.domain.SalVO;

@Mapper
public interface SalMapper {

    // 사원 본인 급여 목록
    List<SalVO> selectSalList(@Param("empNo") String empNo);

    // 급여 상세
    SalVO selectSalDetail(@Param("empNo") String empNo,
                          @Param("monthAttno") Integer monthAttno);

    // 월별 급여 존재 여부(옵션)
    int existsSal(@Param("monthAttno") Integer monthAttno);

    // 사원+월별 급여 존재 여부(옵션)
    int existsMonthlySalary(@Param("empNo") String empNo,
                            @Param("monthAttno") Integer monthAttno);

    // 급여 1건 수동 삽입(필요 시)
    int insertSal(SalVO vo);

    // 관리자 기본 목록(구버전)
    List<SalVO> selectAdminSalList(Map<String, String> param);

    // 🔹 MONTH_ATTEND 기준 일괄 급여 생성
    int insertSalaryByMonth(String targetMonth);

    // 🔹 관리자용 정렬/월필터 급여 목록
    List<SalVO> getAdminSalList(Map<String, Object> param);

    Map<String, Object> getAdminSalSummary(Map<String, Object> param);
    
    Map<String, Object> getEmpSalSummary(String empNo);

	int updateSalaryByAdmin(SalVO sal);


    // ===== 🔹 여기부터 새로 추가 =====

    /** SAL_NUM 기준 급여 1건 조회 (정정용 before 값) */
    SalVO selectSalBySalNum(int salNum);

    /** 급여 정정 이력 저장 */
    int insertSalEdit(SalEditVO edit);

    /** 급여 정정 이력 조회 (상세 하단 표시용) */
    List<SalEditVO> selectSalEditsBySalNum(int salNum);

}
