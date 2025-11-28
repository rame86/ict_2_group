package com.example.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.domain.MonthAttendVO;

@Mapper
public interface MonthAttendMapper {

    // 특정 사원의 특정 월 근무 요약 조회
    MonthAttendVO getMonthAttend(
        @Param("empNo") int empNo,
        @Param("monthAttno") int monthAttno
    );
    // 사원의 월별 근무 전체 조회
    List<MonthAttendVO> getMonthAttendList(String empNo);

    // (상세용) 월별 근무 1건 조회
    MonthAttendVO getMonthAttend(@Param("empNo") String empNo,
                                 								@Param("monthAttno") Integer monthAttno);
    
}