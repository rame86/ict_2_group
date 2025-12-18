<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<link href="https://cdn.jsdelivr.net/npm/suit-font/dist/suit.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/all.min.css">
<style>
    body { font-family: 'SUIT', sans-serif; }
    
    /* 도장 애니메이션 (기존 위치 유지) */
    .stamp {
        position: absolute;
        right: 40px;
        top: 40px;
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

    /* 패딩 및 간격 최적화 (createForm 기준) */
    .detail-body {
        padding: 2.5rem !important; /* 전체적인 내부 간격을 넓힘 [cite: 221] */
    }

    .form-group-row {
        display: flex;
        align-items: center;
        margin-bottom: 1.5rem; /* 요소 간 간격 확대 [cite: 187] */
        width: 100%;
    }
    .info-item {
        display: flex;
        align-items: center;
        flex: 1;
    }
    .label-box {
        width: 110px; /* 라벨 너비 최적화 [cite: 189] */
        font-size: 0.9rem;
        font-weight: 700;
        color: #4a5568;
        flex-shrink: 0;
    }
    .input-box { flex: 1; position: relative; }

    .input-custom {
        width: 100%;
        padding: 0.5rem 0.8rem;
        font-size: 0.9rem;
        border: 1px solid #d1d9e6;
        border-radius: 8px;
        background-color: #f8f9fc;
        color: #333;
        border: none; /* 선을 없애 더 깔끔하게 처리 가능 */
    }
    
    .textarea-custom {
        width: 100%;
        min-height: 350px;
        padding: 1.5rem;
        border: 1px solid #d1d9e6;
        border-radius: 8px;
        resize: none;
        font-size: 0.95rem; /* createForm 기준 [cite: 196] */
        line-height: 1.7;
        background-color: #fff;
        outline: none;
    }

    /* 콤팩트한 결재 진행 상황 (가로 배치) */
    .compact-approval {
        display: flex;
        gap: 20px;
        padding: 10px 15px;
        background: #f1f4f8;
        border-radius: 8px;
        font-size: 0.85rem;
        margin-bottom: 1.5rem;
    }
    .status-badge {
        font-weight: 700;
        margin-left: 5px;
    }
    .text-ok { color: #1cc88a; }
    .text-wait { color: #858796; }
    .text-no { color: #e74a3b; }

    /* 파일 미리보기 영역 */
    .preview-card {
        border: 1px solid #d1d9e6;
        border-radius: 8px;
        background-color: #f8f9fc;
        padding: 20px;
        height: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }
    .preview-img {
        max-width: 100%;
        max-height: 450px;
        border-radius: 6px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
</style>

<div class="container-fluid px-4">
    <h3 class="mt-4 mb-4">문서 상세 보기</h3>

    <div class="card position-relative">
        <svg id="approveStamp" class="stamp" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
            <circle cx="50" cy="50" r="45" fill="none" stroke="#e74c3c" stroke-width="5"/>
            <circle cx="50" cy="50" r="38" fill="none" stroke="#e74c3c" stroke-width="2" stroke-dasharray="4 2"/>
            <text x="50" y="58" font-family="'Malgun Gothic', sans-serif" font-size="24" fill="#e74c3c" text-anchor="middle" font-weight="bold">승인</text>
        </svg>

        <div class="card-body detail-body">
            <div class="row">
                <div class="col-xl-8 col-lg-7">
                    
                    <div class="form-group-row">
                        <div class="info-item">
                            <div class="label-box">문서 제목</div>
                            <div class="input-box">
                                <span class="input-custom d-block fw-bold">${vo.docTitle}</span>
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
                                        <a href="/approve/download?changeName=${vo.changeName}&originName=${vo.originName}" class="text-primary fw-bold text-decoration-none small">
                                            <i class="fas fa-download me-1"></i>${vo.originName}
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">없음</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="compact-approval">
                        <span class="fw-bold"><i class="fas fa-tasks me-2"></i>결재 상황:</span>
                        <span>
                            1차(${vo.step1ManagerName}) 
                            <c:choose>
                                <c:when test="${vo.step1Status == 'A'}"><span class="status-badge text-ok">승인 ✔</span></c:when>
                                <c:when test="${vo.step1Status == 'R'}"><span class="status-badge text-no">반려 ✘</span></c:when>
                                <c:otherwise><span class="status-badge text-wait">대기</span></c:otherwise>
                            </c:choose>
                        </span>
                        <span class="text-muted mx-2">|</span>
                        <span>
                            2차(${vo.step2ManagerName}) 
                            <c:choose>
                                <c:when test="${vo.step2Status == 'A'}"><span class="status-badge text-ok">승인 ✔</span></c:when>
                                <c:when test="${vo.step2Status == 'R'}"><span class="status-badge text-no">반려 ✘</span></c:when>
                                <c:otherwise><span class="status-badge text-wait">대기</span></c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="mt-4">
                        <div class="label-box mb-2">상세 내용</div>
                        <textarea class="textarea-custom" readonly>${vo.docContent}</textarea>
                    </div>

                    <div class="d-flex justify-content-center gap-3 mt-4 pt-4 border-top">
                        <c:if test="${sessionScope.login.empNo == vo.step1ManagerNo || sessionScope.login.empNo == vo.step2ManagerNo}">
                            <form action="approveDocument" method="post" id="approveForm" class="d-flex gap-2">
                                <input type="hidden" name="docNo" value="${ vo.docNo }">
                                <button class="btn btn-success px-5 fw-bold" id="approveBtn" type="button" style="border-radius:8px;">승인</button>
                                <button class="btn btn-danger px-5 fw-bold" type="button" data-bs-toggle="modal" data-bs-target="#rejectModal" style="border-radius:8px;">반려</button>
                            </form>
                        </c:if>
                        <a href="receiveList" class="btn btn-secondary px-4 fw-bold" style="border-radius:8px;">목록으로</a>
                    </div>
                </div>

                <div class="col-xl-4 col-lg-5 mt-4 mt-lg-0">
                    <div class="label-box mb-2"><i class="fas fa-image me-2"></i>파일 미리보기</div>
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
                                <i class="fas fa-folder-open fa-4x text-gray-200"></i>
                                <p class="mt-3 text-muted small">첨부파일 없음</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="rejectModal" tabindex="-1">
    <div class="modal-dialog">
        <form method="post" action="approveDocument" class="modal-content">
            <input type="hidden" name="docNo" value="${ vo.docNo }">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">반려 사유 입력</h5>
                <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <textarea name="rejectReason" class="form-control" rows="5" placeholder="반려 사유를 입력하세요" required></textarea>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">취소</button>
                <button class="btn btn-danger" id="rejectBtn">반려 확정</button>
            </div>
        </form>
    </div>
</div>

<script>
$(document).ready(function(){
    $("#approveBtn").on("click", function(){
        $("#approveStamp").addClass("show");
        setTimeout(function(){
            $.ajax({
                url : "approveDocument", type : "post",
                data : { docNo : "${vo.docNo}", status : "A" },
                success : function(){ alert("승인 완료!"); window.location.href = "receiveList"; },
                error : function(){ alert("오류 발생"); $("#approveStamp").removeClass("show"); }
            });
        }, 700);
    });
    
    $("#rejectBtn").on("click", function(e){
        e.preventDefault();
        const reason = $("textarea[name='rejectReason']").val();
        if(!reason.trim()){ alert("사유를 입력하세요."); return; }
        $.ajax({
            url : "approveDocument", type : "post",
            data : { docNo : "${vo.docNo}", status : "R", rejectReason : reason },
            success : function(){ alert("반려 완료"); window.location.href = "receiveList"; },
            error : function(){ alert("오류 발생"); }
        });
    });
});
</script>