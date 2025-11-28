package com.example.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.EmpVO;
import com.example.domain.MonthAttendVO;
import com.example.domain.SalSummaryVO;
import com.example.domain.SalVO;
import com.example.repository.EmpMapper;
import com.example.repository.MonthAttendMapper;

@Service
public class SalServiceImpl implements SalService {

    @Autowired
    private EmpMapper empMapper;

    @Autowired
    private MonthAttendMapper monthAttendMapper;

    @Override
    public List<SalSummaryVO> getSalarySummaryList(String empNo) {

        EmpVO emp = empMapper.getEmp(empNo);
        int baseSal = n(emp.getBaseSal());

        List<MonthAttendVO> monthList = monthAttendMapper.getMonthAttendList(empNo);
        List<SalSummaryVO> result = new ArrayList<>();

        for (MonthAttendVO m : monthList) {
            double overtimeHours = m.getOvertime() == null ? 0.0 : m.getOvertime();

            // 기본급
            int salBase = baseSal;

            // 초과근무 수당 예시: (기본급 / 209시간) * 1.5 * 초과시간
            double baseHourly = (baseSal == 0) ? 0.0 : baseSal / 209.0;
            int salPlus = (int)Math.round(baseHourly * 1.5 * overtimeHours);

            // 성과급은 일단 0
            int salBonus = 0;

            // 공제 (예시 비율)
            int insurance = (int)Math.round(salBase * 0.045);
            int tax       = (int)Math.round(salBase * 0.033);

            int totalPay  = salBase + salBonus + salPlus;
            int deduction = insurance + tax;
            int realPay   = totalPay - deduction;

            SalSummaryVO s = new SalSummaryVO();
            s.setMonthAttno(m.getMonthAttno());
            s.setYearMonthLabel(formatYearMonth(m.getMonthAttno()));
            s.setTotalPay(totalPay);
            s.setDeduction(deduction);
            s.setRealPay(realPay);

            result.add(s);
        }

        return result;
    }

    @Override
    public SalVO getSalaryDetail(String empNo, Integer monthAttno) {

        EmpVO emp = empMapper.getEmp(empNo);
        MonthAttendVO m = monthAttendMapper.getMonthAttend(empNo, monthAttno);

        int baseSal = n(emp.getBaseSal());
        double overtimeHours = (m == null || m.getOvertime() == null)
                ? 0.0 : m.getOvertime();

        double baseHourly = (baseSal == 0) ? 0.0 : baseSal / 209.0;
        int salPlus = (int)Math.round(baseHourly * 1.5 * overtimeHours);
        int salBonus = 0;

        int insurance = (int)Math.round(baseSal * 0.045);
        int tax       = (int)Math.round(baseSal * 0.033);

        SalVO vo = new SalVO();
        vo.setEmpNo(empNo);
        vo.setMonthAttno(monthAttno);
        vo.setSalBase(baseSal);
        vo.setSalBonus(salBonus);
        vo.setSalPlus(salPlus);
        vo.setInsurance(insurance);
        vo.setTax(tax);

        int totalPay = baseSal + salBonus + salPlus;
        int realPay  = totalPay - (insurance + tax);
        vo.setRealpay(realPay);

        // salDate는 일단 null 또는 "2025-11-30" 같은 기본값으로 세팅해도 됨
        // 필요하면 MonthAttendVO에 기준일 컬럼 추가해서 쓰기

        return vo;
    }

    private int n(Integer v) {
        return v == null ? 0 : v;
    }

    private String formatYearMonth(Integer monthAttno) {
        // monthAttno가 202511 형태일 때
        if (monthAttno == null) return "";
        String s = monthAttno.toString();
        if (s.length() != 6) return s;
        String year  = s.substring(0, 4);
        String month = s.substring(4, 6);
        return year + "년 " + Integer.parseInt(month) + "월";
    }

	@Override
	public List<SalVO> getSalList(int empNo) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public SalVO getSalDetail(int salNum) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void generateMonthlySalary(String empNo, int monthAttno, String salDate) {
		// TODO Auto-generated method stub
		
	}
}