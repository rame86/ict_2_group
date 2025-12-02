package com.example.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.domain.SalVO;

@Mapper
public interface SalMapper {

    /** 급여 대장: 사원 한 명의 월별 급여 목록 */
	List<SalVO> selectSalList(@Param("empNo") String empNo);

    /** 급여 명세서: 사원 한 명 + 특정 월 급여 상세 */
    SalVO selectSalDetail(@Param("empNo") String empNo,
                          				@Param("monthAttno") Integer monthAttno);
    
 //  해당 월에 급여가 있는지 (옵션)
    int existsSal(@Param("monthAttno") Integer monthAttno);
    
 // 사원+월 기준 급여 존재 여부 (옵션)
    int existsMonthlySalary(@Param("empNo") String empNo,
                            				@Param("monthAttno") Integer monthAttno);
 // 급여 등록
    void insertSal(SalVO vo);
    
    // 🔹 관리자용 급여 대장 조회
    List<SalVO> selectAdminSalList(Map<String, String> param);
   
}