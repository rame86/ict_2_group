package com.example.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.domain.SalEditVO;
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
    public List<SalVO> getAdminSalList(Map<String, Object> param) {
        return salMapper.getAdminSalList(param);
    }

	@Override
	public void createBaseSalaryForNewEmp(String empNo) throws Exception {
		System.out.println("📌 [Salary] 신규 사원 기본 급여 생성: empNo = " + empNo);
		
	}

	@Override
	public Map<String, Object> getAdminSalSummary(Map<String, Object> param) {
		
		return salMapper.getAdminSalSummary(param);
	}

	@Override
	public Map<String, Object> getEmpSalSummary(String empNo) {
				return salMapper.getEmpSalSummary(empNo);
	}

	@Transactional
	@Override
	public void editSalaryWithHistory(int salNum,
	                                  int salBase, int salBonus, int salPlus, int overtimePay,
	                                  int insurance, int tax,
	                                  String reason, String editorEmpNo) {

	    SalVO before = salMapper.selectSalBySalNum(salNum);

	    int payTotal = salBase + salBonus + salPlus + overtimePay;
	    int deductTotal = insurance + tax;
	    int realPay = payTotal - deductTotal;

	    // 이력 저장
	    SalEditVO edit = new SalEditVO();
	    edit.setSalNum(salNum);
	    edit.setEditBy(editorEmpNo);
	    edit.setEditReason(reason);

	    edit.setBeforeBase(before.getSalBase());
	    edit.setAfterBase(salBase);
	    edit.setBeforeBonus(before.getSalBonus());
	    edit.setAfterBonus(salBonus);
	    edit.setBeforePlus(before.getSalPlus());
	    edit.setAfterPlus(salPlus);
	    edit.setBeforeOt(before.getOvertimePay());
	    edit.setAfterOt(overtimePay);

	    edit.setBeforeIns(before.getInsurance());
	    edit.setAfterIns(insurance);
	    edit.setBeforeTax(before.getTax());
	    edit.setAfterTax(tax);

	    edit.setBeforePayTotal(before.getPayTotal());
	    edit.setAfterPayTotal(payTotal);
	    edit.setBeforeDeduct(before.getDeductTotal());
	    edit.setAfterDeduct(deductTotal);
	    edit.setBeforeRealPay(before.getRealPay());
	    edit.setAfterRealPay(realPay);

	    salMapper.insertSalEdit(edit);

	    // SAL 업데이트
	    SalVO after = new SalVO();
	    after.setSalNum(salNum);
	    after.setSalBase(salBase);
	    after.setSalBonus(salBonus);
	    after.setSalPlus(salPlus);
	    after.setOvertimePay(overtimePay);
	    after.setInsurance(insurance);
	    after.setTax(tax);
	    after.setPayTotal(payTotal);
	    after.setDeductTotal(deductTotal);
	    after.setRealPay(realPay);

	    salMapper.updateSalaryByAdmin(after);
	}

	@Override
	public SalVO getSalDetailBySalNum(int salNum) {
	    return salMapper.selectSalBySalNum(salNum);
	}

	@Override
	public List<SalEditVO> getEditsBySalNum(int salNum) {
	    return salMapper.selectSalEditsBySalNum(salNum);
	}

}
