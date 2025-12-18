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

    /* =========================
     * 사원용 급여 조회
     * ========================= */

    @Override
    public List<SalVO> getSalList(String empNo) {
        return salMapper.selectSalList(empNo);
    }

    @Override
    public SalVO getSalaryDetail(String empNo, Integer monthAttno) {
        return salMapper.selectSalDetail(empNo, monthAttno);
    }

    @Override
    public Map<String, Object> getEmpSalSummary(String empNo) {
        return salMapper.getEmpSalSummary(empNo);
    }

    /* =========================
     * 급여 생성
     * ========================= */

    @Override
    public int createSalaryByMonth(String month) {

        log.info("============== SAL 생성 시작 ==============");
        log.info("급여 생성 대상 월 : {}", month);

        int inserted = salMapper.insertSalaryByMonth(month);

        log.info("SAL INSERT 결과: {}건 생성", inserted);
        log.info("============== SAL 생성 종료 ==============");

        return inserted;
    }

    /**
     * 신규 사원 기본 급여 생성 (확장 대비)
     * 현재는 로그만 남기고 실제 생성 로직은 없음
     */
    @Override
    public void createBaseSalaryForNewEmp(String empNo) throws Exception {
        log.info("📌 [Salary] 신규 사원 기본 급여 생성 요청 - empNo={}", empNo);
        // TODO: 추후 자동 급여 생성 정책 생기면 구현
    }


    /* =========================
     * 관리자용 급여 조회
     * ========================= */

    @Override
    public List<SalVO> getAdminSalList(Map<String, Object> param) {
        return salMapper.getAdminSalList(param);
    }

    @Override
    public Map<String, Object> getAdminSalSummary(Map<String, Object> param) {
        return salMapper.getAdminSalSummary(param);
    }

    @Override
    public SalVO getSalDetailBySalNum(int salNum) {
        return salMapper.selectSalBySalNum(salNum);
    }


    /* =========================
     * 급여 수정 + 이력 관리
     * ========================= */

    /**
     * 급여 수정 + 수정 이력 저장
     *
     * ※ SAL 수정과 SAL_EDIT 이력 저장은
     *    반드시 하나의 트랜잭션으로 처리되어야 함
     */
    @Transactional
    @Override
    public void editSalaryWithHistory(int salNum,
                                      int salBase, int salBonus, int salPlus, int overtimePay,
                                      int insurance, int tax,
                                      String reason, String editorEmpNo) {

        // 1) 수정 전 급여 조회
        SalVO before = salMapper.selectSalBySalNum(salNum);

        // 2) 계산 로직 (Service 책임)
        int payTotal    = salBase + salBonus + salPlus + overtimePay;
        int deductTotal = insurance + tax;
        int realPay     = payTotal - deductTotal;

        // 3) 이력 저장
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

        // 4) 급여 테이블 업데이트
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
    /* =========================
     * 특정 급여(SAL_NUM)에 대한 급여 수정 이력 조회
     * ========================= */
     /* - SAL_EDIT 테이블 조회
     * - 관리자 급여 상세/수정 화면에서 사용
     * - 최신 수정 이력이 위로 오도록 정렬된 목록 반환*/
    @Override
    public List<SalEditVO> getEditsBySalNum(int salNum) {
        return salMapper.selectSalEditsBySalNum(salNum);
    }
}
