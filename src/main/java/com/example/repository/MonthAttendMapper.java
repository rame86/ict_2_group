package com.example.repository;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.example.domain.MonthAttendVO;

@Mapper
public interface MonthAttendMapper {

    // 사원 한 명의 월 근태 목록
    List<MonthAttendVO> getMonthAttendList(@Param("empNo") String empNo);

    // 사원 한 명의 특정 월 근태 1건
    MonthAttendVO getMonthAttend(@Param("empNo") String empNo,
                                 @Param("monthAttno") Integer monthAttno);

    // 🔹 targetMonth(YYYY-MM) 기준으로 MONTH_ATTEND 생성
    int insertMonthAttendByMonth(@Param("targetMonth") String targetMonth);
}
