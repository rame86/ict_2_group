<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<link href="https://cdn.jsdelivr.net/npm/suit-font/dist/suit.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/all.min.css">
<style>
    /* 카드 및 헤더 스타일 */
    .card {
        border-radius: 12px;
        border: 1px solid rgba(0, 0, 0, 0.17);
        box-shadow: 0 0.15rem 1.75rem 0 rgba(33, 40, 50, 0.08);
        background-color: #fff;
    }
    
    .unified-card-header {
        padding: 1rem 1.5rem;
        background-color: #92A8D1;
        border-bottom: 1px solid #f1f4f8;
        font-weight: 700;
        color: #FFFFFF;
        border-radius: 12px 12px 0 0;
    }
    
    /* 도장 애니메이션 */
    .stamp {
        position: absolute;
        right: 40px;
        top: 65px;
        width: 120px;
        opacity: 0;
        transform: rotate(-20deg) scale(0.3);
        transition: 0.4s ease;
        z-index: 20;
        pointer-events: none;
    }
    .stamp.show {
        opacity: 1;
        transform: rotate(-20deg) scale(1);
    }

    .detail-body {
        padding: 2.5rem !important;
    }

    .form-group-row {
        display: flex;
        align-items: center;
        margin-bottom: 1.5rem;
        width: 100%;
    }
    .info-item {
        display: flex;
        align-items: center;
        flex: 1;
    }
    .label-box {
        width: 110px;
        font-size: 0.9rem;
        font-weight: 700;
        color: #4a5568;
        flex-shrink: 0;
    }
    
    .input-box { flex: 1; position: relative; }

    .input-custom {
        width: 100%;
        padding: 0.6rem 1rem;
        font-size: 0.9rem;
        border: 1px solid #d1d9e6;
        border-radius: 8px;
        background-color: #fff;
        transition: 0.2s;
        color: #333;
    }
    
    .textarea-custom {
        width: 100%;
        min-height: 350px;
        padding: 1.5rem;
        border: 1px solid #d1d9e6;
        border-radius: 8px;
        resize: none;
        font-size: 0.95rem;
        line-height: 1.7;
        background-color: #fff;
        outline: none;
        overflow-y: auto;
        white-space: pre-wrap;
    }

    /* ✅ 수정된 결재 프로세스 라인 (3단계 및 동그란 테두리 적용) */
    .approval-flow-container {
        display: flex;
        align-items: center;
        width: 100%;
        padding: 15px 0;
        border-radius: 12px;
    }
    .approval-step {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 8px;
        min-width: 100px;
    }
    .step-title {
        font-size: 0.8rem;
        font-weight: 700;
        color: #adb5bd;
    }
    .step-circle {
        width: 70px;
        height: 70px;
        border-radius: 50%;
        border: 2px solid #d1d9e6;
        background-color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        color: #4a5568;
        font-size: 0.8rem;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }
    .status-text {
        font-size: 0.8rem;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 3px;
    }

    /* 긴 화살표 구현 (CSS 직접 그림) */
    .long-arrow {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 10px;
        position: relative;
        height: 20px;
    }
    .long-arrow::before {
        content: "";
        width: 100%;
        height: 1px;
        border-top: 1px dashed #cbd5e0;
    }
    .long-arrow::after {
        content: "";
        width: 8px;
        height: 8px;
        border-top: 2px solid #cbd5e0;
        border-right: 2px solid #cbd5e0;
        transform: rotate(45deg);
        position: absolute;
        right: 0;
        background: transparent;
    }

    .text-wait { color: #858796; }
    .text-ok { color: #1cc88a; }
    .text-no { color: #e74a3b; }

    /* 파일 미리보기 및 버튼 영역 */
    .preview-card {
        border: 1px solid #d1d9e6;
        border-radius: 8px;
        background-color: #f8f9fc;
        padding: 20px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 493px;
    }
    .preview-img {
        max-width: 100%;
        max-height: 200px;
        border-radius: 6px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    
    .action-buttons-wrapper {
        margin-top: 1.5rem;
        padding-top: 1.5rem;
        border-top: 1px solid #f1f4f8;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    .left-section{
    	padding-right : 2.5rem;
    }
    .preivew-box2{
    	width : 120px;
    }
    
    .btn-reset-custom {
        background-color: #fff;
        border: 1px solid #d1d5db;
        color: #4b5563;
        padding: 0.6rem 2.5rem;
        font-size: 0.9rem;
        font-weight: 600;
        border-radius: 8px;
        transition: 0.2s;
    }
    
    .btn-submit-custom {
        background-color: #4e73df;
        border: 1px solid #4e73df;
        color: #fff;
        padding: 0.6rem 3.5rem;
        font-size: 0.9rem;
        font-weight: 700;
        border-radius: 8px;
        box-shadow: 0 4px 6px -1px rgba(78, 115, 223, 0.2);
        transition: 0.2s;
    }
</style>

<div class="container-fluid px-4">
    <h3 class="mt-4">문서 상세 보기</h3>
	<br>
    <div class="card position-relative">
        <div class="unified-card-header">
            <i class="fas fa-file-alt me-2"></i>결재 문서 상세 정보
        </div>

        <svg id="approveStamp" class="stamp" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
            <circle cx="50" cy="50" r="45" fill="none" stroke="#e74c3c" stroke-width="5"/>
            <circle cx="50" cy="50" r="38" fill="none" stroke="#e74c3c" stroke-width="2" stroke-dasharray="4 2"/>
            <text x="50" y="58" font-family="'Malgun Gothic', sans-serif" font-size="24" fill="#e74c3c" text-anchor="middle" font-weight="bold">승인</text>
        </svg>

        <div class="card-body detail-body">
            <div class="row">
                <div class="col-xl-8 col-lg-7 left-section">
                    <div class="form-group-row">
                        <div class="info-item">
                            <div class="label-box">문서 제목</div>
                            <div class="input-box">
                                <span class="input-custom d-block">${vo.docTitle}</span>
                            </div>
                        </div>
                        <div class="info-item ms-4">
                            <div class="label-box">기안자</div>
                            <div class="input-box">
                                <span class="input-custom d-block">${vo.writerName}</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group-row">
                        <div class="info-item">
                            <div class="label-box">기안일</div>
                            <div class="input-box">
                                <span class="input-custom d-block">${vo.docDate}</span>
                            </div>
                        </div>
                        <div class="info-item ms-4">
                            <div class="label-box">첨부 파일</div>
                            <div class="input-box">
                                <c:choose>
                                    <c:when test="${not empty vo.originName}">
                                    <span class="input-custom d-block">
                                        <a href="/approve/download?changeName=${vo.changeName}&originName=${vo.originName}" class="text-primary fw-bold text-decoration-none small">
                                            <i class="fas fa-download me-1"></i>${vo.originName}
                                        </a>
                                    </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="input-custom d-block">없음</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="approval-flow-container">
                        <div class="label-box">결재 현황</div>
                        
                        <div class="approval-step">
                            <span class="step-title">기안</span>
                            <div class="step-circle">${vo.writerName}</div>
                            <div class="status-text text-ok"><i class="fas fa-pen-nib"></i> 기안완료</div>
                        </div>

                        <div class="long-arrow"></div>

                        <div class="approval-step">
                            <span class="step-title">1차 결재자</span>
                            <div class="step-circle">${vo.step1ManagerName}</div>
                            <div class="status-text">
                                <c:choose>
                                    <c:when test="${vo.step1Status == 'A'}"><span class="text-ok"><i class="fas fa-check-circle"></i> 승인</span></c:when>
                                    <c:when test="${vo.step1Status == 'R'}"><span class="text-no"><i class="fas fa-times-circle"></i> 반려</span></c:when>
                                    <c:otherwise><span class="text-wait"><i class="fas fa-clock"></i> 대기</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="long-arrow"></div>

                        <div class="approval-step">
                            <span class="step-title">2차 결재자</span>
                            <div class="step-circle">${vo.step2ManagerName}</div>
                            <div class="status-text">
                                <c:choose>
                                    <c:when test="${vo.step2Status == 'A'}"><span class="text-ok"><i class="fas fa-check-circle"></i> 승인</span></c:when>
                                    <c:when test="${vo.step2Status == 'R'}"><span class="text-no"><i class="fas fa-times-circle"></i> 반려</span></c:when>
                                    <c:otherwise><span class="text-wait"><i class="fas fa-clock"></i> 대기</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4">
                        <div class="textarea-custom">${vo.docContent}</div>
                    </div>
                </div>

                <div class="col-xl-4 col-lg-5 mt-4 mt-lg-0">
                    <div class="label-box mb-2 preivew-box2"><i class="fas fa-image me-2"></i>파일 미리보기</div>
                    <div class="preview-card">
                        <c:choose>
                            <c:when test="${not empty vo.originName}">
                                <c:set var="fileExt" value="${fn:toLowerCase(fn:substringAfter(vo.changeName, '.'))}" />
                                <c:if test="${fileExt == 'jpg' || fileExt == 'jpeg' || fileExt == 'png' || fileExt == 'gif'}">
                                    <img src="/upload/approve/${vo.changeName}" class="preview-img" alt="미리보기">
                                </c:if>
                                <c:if test="${!(fileExt == 'jpg' || fileExt == 'jpeg' || fileExt == 'png' || fileExt == 'gif')}">
                                    <i class="fas fa-file-alt fa-4x text-gray-300"></i>
                                    <p class="mt-3 text-muted small">미리보기를 지원하지 않는 형식</p>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-folder-open fa-2x text-gray-200"></i>
                                <p class="mt-3 text-muted small">첨부파일 없음</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="action-buttons-wrapper">
                        <c:if test="${sessionScope.login.empNo == vo.step1ManagerNo || sessionScope.login.empNo == vo.step2ManagerNo}">
                            <div class="d-flex gap-2">
                                <button class="btn btn-submit-custom flex-fill fw-bold py-2" id="approveBtn" type="button">승인</button>
                                <button class="btn btn-submit-custom flex-fill fw-bold py-2" type="button" data-bs-toggle="modal" data-bs-target="#rejectModal">반려</button>
                            </div>
                        </c:if>
                        <a href="/approve/receiveList" class="btn btn-reset-custom w-100 py-2">목록으로 이동</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

	<div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="rejectModalLabel">반려 사유 입력</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <textarea name="rejectReason" class="form-control" rows="5" placeholder="반려 사유를 입력하세요" required></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-danger" id="rejectBtn">반려 확정</button>
                </div>
            </div>
        </div>
    </div>

<script>
$(document).ready(function(){
    $("#approveBtn").on("click", function(){
        $("#approveStamp").addClass("show");
        setTimeout(function(){
            $.ajax({
                url : "/approve/approveDocument", type : "post",
                data : { docNo : "${vo.docNo}", status : "A" },
                success : function(){ alert("승인 완료!"); window.location.href = "/approve/receiveList"; },
                error : function(){ alert("오류 발생"); $("#approveStamp").removeClass("show"); }
            });
        }, 700);
    });
    
    $("#rejectBtn").on("click", function(e){
        e.preventDefault();
        const reason = $("textarea[name='rejectReason']").val();
        if(!reason.trim()){ alert("사유를 입력하세요."); return; }
        $.ajax({
            url : "/approve/approveDocument", type : "post",
            data : { docNo : "${vo.docNo}", status : "R", rejectReason : reason },
            success : function(){ alert("반려 완료"); window.location.href = "/approve/receiveList"; },
            error : function(){ alert("오류 발생"); }
        });
    });
});
</script>