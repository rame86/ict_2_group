package com.example.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.domain.EmpVO;
import com.example.domain.SalVO;

@Mapper
public interface SalMapper {

    // 사원 정보 가져오기
    EmpVO getEmp(int empNo);

    // 해당 사원의 급여 리스트 조회
    List<SalVO> selectSalList(int empNo);

    // 특정 월 급여가 이미 생성됐는지 확인
    Integer existsSal(@Param("monthAttno") int monthAttno);

    // 새로운 급여 등록
    int insertSal(SalVO vo);

	SalVO getSalDetail(int salNum);

	int existsMonthlySalary(int empNo, int monthAttno);


}