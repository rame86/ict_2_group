package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.SalVO;
import com.example.repository.SalMapper;

@Service
public class SalServiceImpl implements SalService {

    @Autowired
    private SalMapper salMapper;

    @Override
    public List<SalVO> getSalList(String empNo) {

        // "1001" → 1001
        Integer empNoInt = null;
        try {
            empNoInt = Integer.parseInt(empNo);
        } catch (NumberFormatException e) {
            System.out.println("[SalServiceImpl] empNo 파싱 실패: " + empNo);
            return List.of(); // 혹은 Collections.emptyList();
        }

        List<SalVO> list = salMapper.selectSalList(empNoInt);

        for (SalVO vo : list) {
            fillCalculatedFields(vo);
        }
        return list;
    }

    @Override
    public SalVO getSalaryDetail(String empNo, Integer monthAttno) {

        Integer empNoInt = null;
        try {
            empNoInt = Integer.parseInt(empNo);
        } catch (NumberFormatException e) {
            System.out.println("[SalServiceImpl] empNo 파싱 실패(Detail): " + empNo);
            return null;
        }

        SalVO vo = salMapper.selectSalDetail(empNoInt, monthAttno);
        if (vo != null) {
            fillCalculatedFields(vo);
        }
        return vo;
    }

    /** 급여 계산 + yearMonthLabel 세팅 */
    private void fillCalculatedFields(SalVO vo) {
        int base  = n(vo.getSalBase());
        int bonus = n(vo.getSalBonus());
        int plus  = n(vo.getSalPlus());
        int ins   = n(vo.getInsurance());
        int tax   = n(vo.getTax());

        int payTotal    = base + bonus + plus;
        int deductTotal = ins + tax;
        int realPay     = payTotal - deductTotal;

        vo.setPayTotal(payTotal);
        vo.setDeductTotal(deductTotal);

        // DB에서 realPay도 가져오지만, 여기서 다시 한 번 계산해서 맞춰줌
        vo.setRealPay(realPay);

        // monthAttno(202511) → "2025년 11월"
        if (vo.getMonthAttno() != null) {
            String m = vo.getMonthAttno().toString(); // 예: 202511
            if (m.length() == 6) {
                String year  = m.substring(0, 4);
                String month = m.substring(4, 6);
                vo.setYearMonthLabel(year + "년 " + month + "월");
            }
        }
    }

    private int n(Integer v) {
        return v == null ? 0 : v;
    }
}