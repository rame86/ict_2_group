package com.example.repository;

import java.util.List;

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

    int existsSal(@Param("monthAttno") Integer monthAttno);

    int existsMonthlySalary(@Param("empNo") String empNo,
                            @Param("monthAttno") Integer monthAttno);

    void insertSal(SalVO vo);
}