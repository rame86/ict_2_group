<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* =========================================
       1. 기본 스타일 (라이트 모드 Default)
       ========================================= */
    .feature-title { font-weight: 700; color: #495057; margin-top: 15px; margin-bottom: 8px; display: flex; align-items: center; border-bottom: 1px solid #dee2e6; padding-bottom: 5px; }
    .feature-title i { margin-right: 8px; color: #6c757d; }
    
    .feature-list { padding-left: 0; list-style: none; font-size: 0.95rem; color: #444; margin-bottom: 15px; }
    .feature-list > li { padding: 4px 0; padding-left: 20px; position: relative; font-weight: 500;}
    .feature-list > li::before { content: "•"; position: absolute; left: 5px; color: #adb5bd; font-weight: bold; }

    .sub-list { list-style: none; padding-left: 10px; margin-top: 3px; font-size: 0.9rem; color: #666; font-weight: normal; }
    .sub-list li { padding-left: 15px; position: relative; margin-bottom: 2px; }
    .sub-list li::before { content: "└"; position: absolute; left: 0; color: #ced4da; font-size: 0.8rem; }

    /* 뱃지 */
    .badge-admin { font-size: 0.7rem; background-color: #ffe5e5; color: #c92a2a; border: 1px solid #ffc9c9; margin-left: 5px; border-radius: 4px; padding: 1px 5px; vertical-align: middle; }
    .badge-super-admin { font-size: 0.7rem; background-color: #e5dbff; color: #5f3dc4; border: 1px solid #d0bfff; margin-left: 5px; border-radius: 4px; padding: 1px 5px; vertical-align: middle; }

    /* =========================================
       2. 다크 모드 감지 (@media)
       ========================================= */
    @media (prefers-color-scheme: dark) {
        /* 모달 전체 */
        .modal-content { background-color: #121212 !important; color: #e0e0e0 !important; border: 1px solid #333 !important; }
        .modal-header, .modal-footer { border-color: #333 !important; background-color: #121212 !important; }
        .modal-body { background-color: #121212 !important; }
        .btn-close { filter: invert(1); }

        /* 아코디언 (부트스트랩 아코디언 다크모드 커스텀) */
        .accordion-item { background-color: #1e1e1e !important; border-color: #333 !important; color: #fff !important; }
        .accordion-button { background-color: #1e1e1e !important; color: #fff !important; box-shadow: none !important; }
        .accordion-button:not(.collapsed) { background-color: #2c2c2c !important; color: #fff !important; }
        .accordion-button::after { filter: invert(1); } /* 화살표 아이콘 흰색으로 */

        /* 내부 텍스트 */
        .feature-title { color: #fff !important; border-bottom-color: #444 !important; }
        .feature-list { color: #d0d0d0 !important; }
        .sub-list { color: #aaa !important; }
        .text-muted { color: #999 !important; } /* 작은 설명 텍스트 */

        /* 뱃지 색상 미세 조정 (너무 쨍하지 않게) */
        .badge-admin { background-color: #4a1b1b !important; color: #ffadad !important; border-color: #662222 !important; }
        .badge-super-admin { background-color: #2b1b4a !important; color: #d0bfff !important; border-color: #442266 !important; }
    }
</style>

<div class="modal fade" id="developerInfoModal" tabindex="-1" aria-labelledby="developerInfoModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title" id="developerInfoModalLabel">
                    <i class="fas fa-laptop-code me-2"></i> ICT Group 2 Middle Project
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body bg-light">
                <div class="accordion" id="devAccordion">
                    
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="headingOne">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                <strong>이우람</strong> <span class="text-muted ms-2 small">- 근태, 부서, 게시판 담당</span>
                            </button>
                        </h2>
                        <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#devAccordion">
                            <div class="accordion-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="feature-title"><i class="far fa-clock"></i> 근태 관리</div>
                                        <ul class="feature-list">
                                            <li>출근, 퇴근 타임 스탬프</li>
                                            <li>그래프형 주간/월간 근무시간 조회</li>
                                            <li>캘린더형 근무현황 조회</li>
                                            <li>총 근무시간 조회 (정규+추가)</li>
                                            <li>휴가신청 결재 상신</li>
                                            <li>출퇴근 시간 정정신청 결재 상신</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="feature-title"><i class="far fa-building"></i> 부서 관리</div>
                                        <ul class="feature-list">
                                            <li>부서별 부서장 및 부서원 조회</li>
                                            <li>관리자 기능 <span class="badge-admin">관리자</span>
                                                <ul class="sub-list">
                                                    <li>부서원 상세정보 조회</li>
                                                    <li>부서 연락처 조회</li>
                                                </ul>
                                            </li>
                                            <li>인사 권한 기능 <span class="badge-super-admin">인사부서장</span>
                                                <ul class="sub-list">
                                                    <li>부서장 임명 결재 상신</li>
                                                    <li>사원 부서 이전</li>
                                                    <li>부서 생성/삭제 (부서원 무소속 처리)</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-12">
                                        <div class="feature-title"><i class="far fa-comments"></i> 게시판 (공지/자유)</div>
                                        <ul class="feature-list d-flex flex-wrap gap-4">
                                            <li style="width: 45%;">공지사항
                                                <ul class="sub-list">
                                                    <li>조회 및 등록/수정 <span class="badge-admin">관리자</span></li>
                                                </ul>
                                            </li>
                                            <li style="width: 45%;">자유 게시판
                                                <ul class="sub-list">
                                                    <li>조회 및 등록/수정</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item">
                        <h2 class="accordion-header" id="headingTwo">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                <strong>정보경</strong> <span class="text-muted ms-2 small">- 사원, 급여 관리 담당</span>
                            </button>
                        </h2>
                        <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#devAccordion">
                            <div class="accordion-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="feature-title"><i class="far fa-id-card"></i> 사원 관리</div>
                                        <ul class="feature-list">
                                            <li>사원 현 상황 및 전체 목록 조회</li>
                                            <li>검색 (이름/부서/직급/사번)</li>
                                            <li>사원 등록/수정/삭제 <span class="badge-admin">관리자</span>
                                                <ul class="sub-list">
                                                    <li>부서 선택 시 번호/권한 자동 선택</li>
                                                    <li>주소 검색 API 연동</li>
                                                    <li>유효성 검사 및 사진 처리</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="feature-title"><i class="fas fa-file-invoice-dollar"></i> 급여 관리</div>
                                        <ul class="feature-list">
                                            <li>본인 급여 조회 (월별/평균/누적)</li>
                                            <li>급여 명세
                                                <ul class="sub-list">
                                                    <li>상세내역 및 명세서 출력</li>
                                                    <li>지급/공제비율 그래프 확인</li>
                                                </ul>
                                            </li>
                                            <li>전체 급여 관리 <span class="badge-admin">관리자</span>
                                                <ul class="sub-list">
                                                    <li>전체 사원 급여 조회/수정</li>
                                                    <li>엑셀 다운로드</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item">
                        <h2 class="accordion-header" id="headingThree">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                <strong>전환희</strong> <span class="text-muted ms-2 small">- 전자결재, 메시지, 알림 담당</span>
                            </button>
                        </h2>
                        <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#devAccordion">
                            <div class="accordion-body">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="feature-title"><i class="fas fa-file-signature"></i> 전자결재</div>
                                    </div>
                                    <div class="col-md-6">
                                        <ul class="feature-list">
                                            <li>결재 현황 (Dashboard)
                                                <ul class="sub-list">
                                                    <li>진행/대기 문서 카운트 & 최근 5건 조회</li>
                                                    <li>바로가기 링크 연동</li>
                                                </ul>
                                            </li>
                                            <li>결재 프로세스
                                                <ul class="sub-list">
                                                    <li>결재 할 문서: 승인(다음 단계)/반려(사유 입력)</li>
                                                    <li>결재 받을 문서: 대기/반려 리스트</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <ul class="feature-list">
                                            <li>문서 관리
                                                <ul class="sub-list">
                                                    <li>결재 완료(한/받은) 문서 보관함</li>
                                                    <li>문서 작성 및 결재선 자동 지정</li>
                                                    <li>작성/완료 시 실시간 알림 발송</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <hr class="my-2">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="feature-title"><i class="far fa-envelope"></i> 메시지 (쪽지)</div>
                                        <ul class="feature-list">
                                            <li>실시간 헤더 알림 및 대화</li>
                                            <li>대화 목록 및 사용자 추가</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="feature-title"><i class="far fa-bell"></i> 알림 센터</div>
                                        <ul class="feature-list">
                                            <li>결재 요청 실시간 알림</li>
                                            <li>전체 알림 히스토리 확인</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>