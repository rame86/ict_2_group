package com.example.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.domain.MonthAttendVO;

@Mapper   // 이미 @MapperScan("com.example.repository")를 쓰고 있다면 생략해도 됨
public interface MonthAttendMapper {

    // 1. targetMonth(YYYY-MM)에 대한 월근태 생성 (INSERT)
    int insertMonthAttendByMonth(@Param("targetMonth") String targetMonth);

    // 2. 해당 월 데이터 존재 여부 확인
    int existsMonthAttend(@Param("targetMonth") String targetMonth);

    // 3. 특정 사번 + 월급여번호 1건 조회
    MonthAttendVO getMonthAttendOne(
            @Param("empNo") String empNo,
            @Param("monthAttno") Long monthAttno
    );

    // 4. 특정 월 전체 조회
    List<MonthAttendVO> selectMonthAttend(@Param("targetMonth") String targetMonth);
}
