package com.example.service;

import java.util.List;
import java.util.Map;

import com.example.domain.SalEditVO;
import com.example.domain.SalVO;

/**
 * 급여 관리 Service
 *
 * - 사원용 급여 조회
 * - 관리자용 급여 관리
 * - 급여 생성 / 수정 / 이력 관리
 *
 * ※ DB 접근은 SalMapper에서 처리하고,
 *    이 Service에서는 "업무 흐름 + 계산 + 트랜잭션"만 담당한다.
 */
public interface SalService {

    /* =========================
     * 사원용 기능
     * ========================= */

    /** 사원 개인 급여 목록 조회 */
    List<SalVO> getSalList(String empNo);

    /** 사원 개인 급여 상세 조회 (월 기준) */
    SalVO getSalaryDetail(String empNo, Integer monthAttno);

    /** 사원 급여 요약 카드 (최근 / 평균 / 누적) */
    Map<String, Object> getEmpSalSummary(String empNo);


    /* =========================
     * 급여 생성
     * ========================= */

    /**
     * 지정 월(YYYY-MM) 기준 급여 일괄 생성
     * - MONTH_ATTEND 기준
     * - 이미 생성된 급여는 제외
     */
    int createSalaryByMonth(String month);

    /**
     * 신규 사원 등록 시 기본 급여 생성용 (확장 대비용)
     * ※ 현재는 구현만 해두고 실제 로직은 미사용
     */
    void createBaseSalaryForNewEmp(String empNo) throws Exception;


    /* =========================
     * 관리자용 기능
     * ========================= */

    /** 관리자 급여 목록 조회 (월/부서/정렬/옵션) */
    List<SalVO> getAdminSalList(Map<String, Object> param);

    /** 관리자 상단 요약 카드 집계 */
    Map<String, Object> getAdminSalSummary(Map<String, Object> param);

    /** SAL_NUM 기준 급여 단건 조회 */
    SalVO getSalDetailBySalNum(int salNum);


    /* =========================
     * 급여 수정 + 이력
     * ========================= */

    /**
     * 관리자 급여 수정 + 이력 저장
     * - SAL 수정
     * - SAL_EDIT 이력 INSERT
     * - 트랜잭션 처리
     */
    void editSalaryWithHistory(int salNum,
                               int salBase, int salBonus, int salPlus, int overtimePay,
                               int insurance, int tax,
                               String reason, String editorEmpNo);

    /** 급여 수정 이력 조회 */
    List<SalEditVO> getEditsBySalNum(int salNum);
}
