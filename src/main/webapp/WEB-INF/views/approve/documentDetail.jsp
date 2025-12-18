<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>

    .card-header.table-Header {
        background-color: #f8f9fa;
        font-weight: bold;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 20px;
    }
    
    /* 결재선 디자인 */
    .sign-table {
        border-collapse: collapse;
        text-align: center;
        margin-bottom: 20px;
        float: right; /* 결재선을 우측으로 배치 */
    }
    .sign-table th {
        background: #f8fafc;
        border: 1px solid #dee2e6;
        padding: 5px 12px;
        font-size: 12px;
    }
    .sign-table td {
        border: 1px solid #dee2e6;
        height: 60px;
        width: 80px;
        vertical-align: middle;
    }
    .stamp-circle {
        width: 45px;
        height: 45px;
        border: 2px solid #e2e8f0;
        border-radius: 50%;
        margin: 0 auto;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 12px;
        font-weight: bold;
    }
    .stamp-circle.approved { border-color: #10b981; color: #10b981; }
    .stamp-circle.rejected { border-color: #ef4444; color: #ef4444; }
    .stamp-circle.request { border-color: #1e293b; color: #1e293b; }

    /* 문서 정보 레이아웃 */
    .doc-info-table {
        width: 100%;
        margin-bottom: 20px;
        border: 1px solid #dee2e6;
    }
    .doc-info-table th {
        background-color: #f8f9fa;
        width: 15%;
        padding: 12px;
        border: 1px solid #dee2e6;
        text-align: center;
    }
    .doc-info-table td {
        padding: 12px;
        border: 1px solid #dee2e6;
        background-color: #fff;
    }
    
    .content-box {
        min-height: 300px;
        padding: 15px;
        border: 1px solid #dee2e6;
        background: #fff;
        white-space: pre-wrap;
    }

    .btn-group-custom { display: flex; gap: 5px; }
    
    /* 승인 도장 애니메이션 위치 조정 */
    .big-stamp {
        position: absolute;
        top: 100px;
        right: 150px;
        width: 120px;
        opacity: 0;
        transform: scale(2) rotate(-15deg);
        transition: 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        pointer-events: none;
        z-index: 100;
    }
    .big-stamp.show { opacity: 0.8; transform: scale(1) rotate(-15deg); }
</style>

<div class="container-fluid px-4 detail-container">
    <h3 class="mt-4">결재 문서 상세 보기</h3><br>

    <div class="card mb-4 position-relative">
        <img src="/images/stamp.png" id="approveStamp" class="big-stamp">

        <div class="card-header table-Header">
            <div>
                <i class="fas fa-file-alt me-1"></i> 문서 정보 [cite: 3]
            </div>
            <div class="btn-group-custom">
                <a href="receiveList" class="btn btn-sm btn-secondary"><i class="fas fa-list"></i> 목록으로</a>
                <c:if test="${sessionScope.login.empNo == vo.step1ManagerNo || sessionScope.login.empNo == vo.step2ManagerNo}">
                    <button type="button" class="btn btn-sm btn-success" id="approveBtn"><i class="fas fa-check"></i> 승인</button>
                    <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#rejectModal"><i class="fas fa-times"></i> 반려</button>
                </c:if>
            </div>
        </div>

        <div class="card-body">
            <div class="clearfix">
                <table class="sign-table">
                    <tr>
                        <th>기안</th>
                        <th>1차 결재</th>
                        <th>2차 결재</th>
                    </tr>
                    <tr>
                        <td><div class="stamp-circle request">신청</div></td>
                        <td>
                            <c:choose>
                                <c:when test="${vo.step1Status == 'A'}"><div class="stamp-circle approved">승인</div></c:when>
                                <c:when test="${vo.step1Status == 'R'}"><div class="stamp-circle rejected">반려</div></c:when>
                                <c:otherwise><div class="stamp-circle">대기</div></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${vo.step2Status == 'A'}"><div class="stamp-circle approved">승인</div></c:when>
                                <c:when test="${vo.step2Status == 'R'}"><div class="stamp-circle rejected">반려</div></c:when>
                                <c:otherwise><div class="stamp-circle">대기</div></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr style="font-size: 11px; color: #6c757d;">
                        <td>${vo.writerName}</td>
                        <td>${vo.step1ManagerName}</td>
                        <td>${vo.step2ManagerName}</td>
                    </tr>
                </table>
            </div>

            <table class="doc-info-table">
                <tr>
                    <th>문서번호</th>
                    <td>${vo.docNo}</td>
                    <th>기안일</th>
                    <td>${vo.docDate}</td>
                </tr>
                <tr>
                    <th>기안자</th>
                    <td>${vo.writerName}</td>
                    <th>기안부서</th>
                    <td></td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td colspan="3"><strong>${vo.docTitle}</strong></td>
                </tr>
            </table>

            <div class="form-group">
                <label class="fw-bold mb-2"><i class="fas fa-align-left"></i> 상세 내용</label>
                <div class="content-box">${vo.docContent}</div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="rejectModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">반려 사유 입력</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <textarea id="rejectReason" class="form-control" rows="5" placeholder="반려 사유를 입력하세요"></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-danger" id="rejectBtn">반려하기</button>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function(){
    // 승인 처리 [cite: 65, 68]
    $("#approveBtn").on("click", function(){
        let stamp = $("#approveStamp");
        stamp.addClass("show");
        setTimeout(function(){
            $.ajax({
                url : "approveDocument",
                type : "post",
                data : { docNo : "${ vo.docNo }", status : "A" },
                success : function(){
                    alert("승인이 완료되었습니다.");
                    location.href = "receiveList";
                },
                error : function(){
                    alert("오류 발생");
                    stamp.removeClass("show");
                }
            });
        }, 600);
    });

    // 반려 처리 [cite: 69, 70]
    $("#rejectBtn").on("click", function(){
        let reason = $("#rejectReason").val();
        if(!reason.trim()){ alert("사유를 입력하세요."); return; }
        $.ajax({
            url : "approveDocument",
            type : "post",
            data : { docNo : "${ vo.docNo }", status : "R", rejectReason : reason },
            success : function(){
                alert("반려 처리되었습니다.");
                location.href = "receiveList";
            }
        });
    });
});
</script>