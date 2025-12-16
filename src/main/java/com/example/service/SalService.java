package com.example.service;

import java.util.List;
import java.util.Map;

import com.example.domain.SalEditVO;
import com.example.domain.SalVO;

public interface SalService {

    // 사원용 급여 목록
    List<SalVO> getSalList(String empNo);

    // 급여 상세
    SalVO getSalaryDetail(String empNo, Integer monthAttno);

    // 🔹 지정 월(YYYY-MM) 기준 급여 생성
    int createSalaryByMonth(String month);

    // 관리자용 급여 목록 (월 필터 + 정렬)
    List<SalVO> getAdminSalList(Map<String, Object> param);

	void createBaseSalaryForNewEmp(String empNo)throws Exception;
	
	Map<String, Object> getAdminSalSummary(Map<String, Object> param);
	
	Map<String, Object> getEmpSalSummary(String empNo);

	SalVO getSalDetailBySalNum(int salNum);

	void editSalaryWithHistory(int salNum,
	                           int salBase, int salBonus, int salPlus, int overtimePay,
	                           int insurance, int tax,
	                           String reason, String editorEmpNo);

	List<SalEditVO> getEditsBySalNum(int salNum); // (선택)

}
