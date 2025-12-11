package com.example.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.SalVO;
import com.example.repository.SalMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SalServiceImpl implements SalService {

    @Autowired
    private SalMapper salMapper;

    @Override
    public List<SalVO> getSalList(String empNo) {
        return salMapper.selectSalList(empNo);
    }

    @Override
    public SalVO getSalaryDetail(String empNo, Integer monthAttno) {
        return salMapper.selectSalDetail(empNo, monthAttno);
    }

    @Override
    public int createSalaryByMonth(String month) {

        log.info("============== SAL 생성 시작 ==============");
        log.info("타겟 월(급여 기준월) : {}", month);

        int inserted = salMapper.insertSalaryByMonth(month);

        log.info("SAL INSERT 결과: {} 행 삽입됨", inserted);
        log.info("============== SAL 생성 종료 ==============");
		return inserted;
    }

    @Override
    public List<SalVO> getAdminSalList(Map<String, String> param) {
        return salMapper.getAdminSalList(param);
    }

	@Override
	public void createBaseSalaryForNewEmp(String empNo) throws Exception {
		System.out.println("📌 [Salary] 신규 사원 기본 급여 생성: empNo = " + empNo);
		
	}
}
