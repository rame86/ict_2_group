<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* 모달 내부 디자인 */
    .developer-section { margin-bottom: 1.5rem; }
    .feature-title {
        font-weight: 700; color: #495057; margin-top: 10px; margin-bottom: 5px;
        display: flex; align-items: center;
    }
    .feature-title i { margin-right: 8px; color: #6c757d; }
    .feature-list {
        padding-left: 0; list-style: none; font-size: 0.95rem; color: #555;
    }
    .feature-list li { padding: 3px 0; padding-left: 24px; position: relative; }
    .feature-list li::before {
        content: "•"; position: absolute; left: 8px; color: #adb5bd;
    }
    /* 뱃지 커스텀 */
    .badge-admin {
        font-size: 0.75rem; background-color: #ffe5e5; color: #c92a2a;
        border: 1px solid #ffc9c9; margin-left: 5px; border-radius: 4px; padding: 2px 6px;
    }
    .badge-super-admin {
        font-size: 0.75rem; background-color: #e5dbff; color: #5f3dc4;
        border: 1px solid #d0bfff; margin-left: 5px; border-radius: 4px; padding: 2px 6px;
    }
</style>

<footer class="py-4 bg-light mt-auto">
    <div class="container-fluid px-4">
        <div class="d-flex align-items-center justify-content-between small">
            <div class="text-muted">Copyright &copy; ICT Group Two Middle Project</div>
            <div>
                <a href="#" class="text-decoration-none" data-bs-toggle="modal" data-bs-target="#developerInfoModal">
                    <i class="fas fa-code"></i> 개발자 정보
                </a> 
                &middot; 
                <a href="#" class="text-decoration-none">Terms & Conditions</a>
            </div>
        </div>
    </div>
</footer>

<div class="modal fade" id="developerInfoModal" tabindex="-1" aria-labelledby="developerInfoModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title" id="developerInfoModalLabel">
                    <i class="fas fa-laptop-code me-2"></i> 프로젝트 개발팀 소개
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
                                    <div class="col-md-6 mb-3">
                                        <div class="feature-title"><i class="far fa-clock"></i> 근태 관리</div>
                                        <ul class="feature-list">
                                            <li>출/퇴근 타임 스탬프 기록</li>
                                            <li>주간/월간 근무시간 그래프 시각화</li>
                                            <li>캘린더형 근무 현황(FullCalendar)</li>
                                            <li>정규/초과 근무시간 자동 계산</li>
                                            <li>휴가 및 근태 정정 결재 상신</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <div class="feature-title"><i class="far fa-building"></i> 부서 관리</div>
                                        <ul class="feature-list">
                                            <li>부서별 조직도 및 구성원 조회</li>
                                            <li>부서 연락처 조회 <span class="badge-admin">관리자</span></li>
                                            <li>부서원 상세정보 열람 <span class="badge-admin">관리자</span></li>
                                            <li>부서장 임명 및 해임 <span class="badge-super-admin">인사부서장</span></li>
                                            <li>부서 생성/삭제 및 인사이동 <span class="badge-super-admin">인사부서장</span></li>
                                        </ul>
                                    </div>
                                </div>
                                <hr class="my-2">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="feature-title"><i class="far fa-comments"></i> 커뮤니티</div>
                                        <ul class="feature-list d-flex flex-wrap gap-4">
                                            <li>공지사항 조회 및 관리 <span class="badge-admin">관리자</span></li>
                                            <li>자유게시판 CRUD (작성/수정/삭제)</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item">
                        <h2 class="accordion-header" id="headingTwo">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                <strong>정보경</strong> <span class="text-muted ms-2 small">- 사원 관리 담당</span>
                            </button>
                        </h2>
                        <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#devAccordion">
                            <div class="accordion-body">
                                <div class="feature-title"><i class="far fa-id-card"></i> 사원 관리</div>
                                <ul class="feature-list">
                                    <li>신규 사원 등록 및 계정 생성</li>
                                    <li>사원 정보 수정 및 프로필 관리</li>
                                    <li>사원 조회 및 검색 기능</li>
                                    <li>퇴사 처리 및 계정 비활성화</li>
                                </ul>
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