<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    /* 도장 이미지 */
    .stamp {
        position: absolute;
        right: 30px;
        top: 30px;
        width: 130px;
        opacity: 0;
        transform: rotate(-20deg) scale(0.3);
        transition: 0.4s ease;
    }
    .stamp.show {
        opacity: 1;
        transform: rotate(-20deg) scale(1);
    }

    /* 결재선 박스 */
    .approval-box {
        padding: 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        background: #f9f9f9;
        margin-top: 20px;
    }

    .approval-title {
        font-weight: bold;
        margin-bottom: 10px;
        font-size: 18px;
    }

    .approval-item {
        display: flex;
        justify-content: space-between;
        padding: 8px 0;
        border-bottom: 1px solid #eee;
    }

    .approval-status {
        font-weight: bold;
    }
    .approved {
        color: green;
    }
    .pending {
        color: #777;
    }
</style>

<div class="container-fluid px-4">

    <h3 class="mt-4 mb-4">문서 상세 보기</h3>

    <div class="card position-relative">

        <!-- 도장 -->
        <img src="/images/stamp.png" id="approveStamp" class="stamp">

        <div class="card-body">

            <!-- 문서 정보 -->
            <table class="table table-bordered">
                <tr>
                    <th style="width: 150px;">문서번호</th>
                    <td>${vo.docNo}</td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td>${vo.docTitle}</td>
                </tr>
                <tr>
                    <th>작성자</th>
                    <td>${vo.writerName}</td>
                </tr>
                <tr>
                    <th>작성일</th>
                    <td>${vo.docDate}</td>
                </tr>
            </table>

            <!-- 문서 내용 -->
            <h5 class="fw-bold mt-4">내용</h5>
            <div class="border rounded p-3" style="white-space: pre-line;">
                ${vo.docContent}
            </div>

            <!-- 결재선 -->
            <div class="approval-box">
                <div class="approval-title">결재선</div>

                <div class="approval-item">
                    <span>1차 결재자: ${vo.step1ManagerName}</span>
                    <span class="approval-status">
                        <c:choose>
                            <c:when test="${vo.step1Status == 'A'}">
                                <span class="approved">승인됨 ✔</span>
                            </c:when>
                            <c:otherwise>
                                <span class="pending">대기중</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="approval-item">
                    <span>2차 결재자: ${vo.step2ManagerName}</span>
                    <span class="approval-status">
                        <c:choose>
                            <c:when test="${vo.step2Status == 'A'}">
                                <span class="approved">승인됨 ✔</span>
                            </c:when>
                            <c:otherwise>
                                <span class="pending">대기중</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <!-- 승인/반려 버튼 -->
            <c:if test="${sessionScope.login.empNo == vo.step1ManagerNo || sessionScope.login.empNo == vo.step2ManagerNo}">
                <div class="mt-4 d-flex justify-content-between align-items-center">
                	<form action="approveDocument" method="post" id="approveForm" class="d-flex">
                		<input type="hidden" name="docNo" value="${ vo.docNo }">
                		<button class="btn btn-success me-2" id="approveBtn" type="button">승인</button>
                    	<button class="btn btn-danger" type="button" data-bs-toggle="modal" data-bs-target="#rejectModal">반려</button>
                	</form>
                	<a href="receiveList" class="btn btn-secondary">목록으로</a>
                </div>
			</c:if>
        </div>
    </div>
</div>


<!-- 🔻 반려 사유 모달 -->
<div class="modal fade" id="rejectModal" tabindex="-1">
    <div class="modal-dialog">
        <form method="post" action="approveDocument" class="modal-content">
            <input type="hidden" name="docNo" value="${ vo.docNo }">
            <div class="modal-header">
                <h5 class="modal-title">반려 사유 입력</h5>
                <button class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <textarea name="rejectReason" class="form-control" rows="5" placeholder="반려 사유를 입력하세요" required></textarea>
            </div>

            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">닫기</button>
                <button class="btn btn-danger" id="rejectBtn">반려하기</button>
            </div>
        </form>
    </div>
</div>


<!-- 🔻 승인 도장 애니메이션 + 자동 전송 -->
<script>

$(document).ready(function(){
	
	$("#approveBtn").on("click", function(){
		
		let stamp = $("#approveStamp");
		let docNo = "${ vo.docNo }";
		
		stamp.addClass("show");
		
		setTimeout(function(){
			
			let postData = {
				docNo : docNo,
				status : "A"
			};
			
			$.ajax({
				url : "approveDocument",
				type : "post",
				data : postData,
				success : function(){
					console.log("승인이 완료되었습니다😍");
					window.location.href = "receiveList";
				},
				error : function(xhr, status, error){
					console.error("AJAX Error:", status, error);
					console.log("서버 통신 중 오류가 발생했습니다.");
                    stamp.removeClass("show");
				}
			});
			
		}, 700);
		
	});
	
	$("#rejectBtn").on("click", function(e){
		
		e.preventDefault();
		
		let form = $(this).closest("form");
		let rejectReason = form.find("textarea[name='rejectReason']").val();
		
		if (!rejectReason || rejectReason.trim() === "") {
	        alert("반려 사유를 입력해 주세요.");
	        return; // AJAX 전송 중단
	    }
		
		let postData = {
				docNo : "${ vo.docNo }",
				status : "R", 
				rejectReason : rejectReason
		};
		
		$.ajax({
			url : "approveDocument",
			type : "post",
			data : postData,
			success : function(){
				alert("반려가 처리되었습니다😭");
				$("#rejectModal").modal("hide"); // 모달 닫기
				window.location.href = "receiveList";
			},
			error : function(xhr, status, error){
				console.error("AJAX Error:", status, error);
				alert("서버 통신 중 오류가 발생했습니다.");
			}
		});
		
	});
	
	// 모달창 초기화
	$('#rejectModal').on('hidden.bs.modal', function () {
		let textarea = $(this).find('textarea[name="rejectReason"]');
		textarea.val('');
		textarea.removeClass('is-invalid');
    });
	
});

</script>