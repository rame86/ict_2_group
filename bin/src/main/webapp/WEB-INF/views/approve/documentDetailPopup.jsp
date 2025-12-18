<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>documentDetailPopup</title>
</head>
<style>
	.doc-wrapper {
		width: 800px;
		height: 1100px;
		margin: 0 auto;
		font-family: "맑은 고딕", sans-serif;
		position: relative;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        overflow: hidden; 
        position: relative;
        border: 1px solid #dee2e6;
	}
	
	.inner-size {
        position: static; 
        top: auto; 
        left: auto;
        margin: 55px 0 0 0;
        transform: scale(0.9); 
        transform-origin: top center;
        width: 100%; 
        height: 100%;
    }
	
	.title {
		text-align: center;
		font-size: 26px;
		font-weight: 700;
		margin-top: 18px;
	}
	
	/* 상단 결재란 박스 */
	.approval-top-table {
		border-collapse: collapse;
		float: right;
		margin-bottom: 20px;
	}
	
	.approval-top-table th, .approval-top-table td {
		border: 1px solid #dee2e6;
		width: 100px;
		height: 40px;
		text-align: center;
		vertical-align: middle;
		font-size: 14px;
	}
	
	.approval-top-table th {
		height: 30px;
	}
	
	/* 문서 정보 */
	table.doc-table {
		width: 100%;
		border-collapse: collapse;
		font-size: 15px;
		margin-top: 70px; /* 결재란과 간격 */
	}
	
	table.doc-table th, table.doc-table td {
		border: 1px solid #dee2e6;
		padding: 10px;
		vertical-align: middle;
	}
	
	table.doc-table th {
		background: rgb(146 168 209);
		width: 150px;
		text-align: center;
		font-weight: bold;
		color: white;
	}
	
	/* 본문 */
	.section-title {
		text-align: center;
		background: rgb(146 168 209);
		border: 1px solid #dee2e6;
		border-bottom: none;
		padding: 8px;
		font-weight: bold;
		color: white;
	}
	
	.doc-content-box {
		height: 510px;
		padding: 20px;
		border: 1px solid #dee2e6;
		background: #fff;
		white-space: pre-line;
		line-height: 1.6;
	}
	
	.bottom-box {
		margin-top: -1px;
		background: rgb(146 168 209);
		border: 1px solid #dee2e6;
		padding: 5px;
		text-align: center;
		font-weight: bold;
		color: white;
	}
	
	.doc-content-box2 {
		height: 163px;
		padding: 20px;
		border: 1px solid #dee2e6;
		background: #fff;
		white-space: pre-line;
		line-height: 1.6;
		border-top: 0;
	}
	
	.bottom-box2{
		border-top: 2px solid #dee2e6;
	}
	
	.box-number-4{
		height : 123px;
	}
</style>
<body>
	<div style="text-align: right; margin-top: 10px;">
	    <button onclick="generatePDF()">문서 PDF 저장 (고화질)</button>
	</div>
	<div class="doc-wrapper">
		<div class="inner-size">

			<div class="title">
				<c:choose>
			        <c:when test="${vo.docType == 1}">품 의 서</c:when>
			        <c:when test="${vo.docType == 2}">기 획 서</c:when>
			        <c:when test="${vo.docType == 3}">제 안 서</c:when>
			        <c:when test="${vo.docType == 4}">휴 가 신 청 서</c:when>
			        <c:otherwise>기타</c:otherwise>
			    </c:choose>
			</div>
	
			<table class="approval-top-table">
				<tr>
					<th>담당자</th>
					<th>담당자</th>
				</tr>
				<tr>
					<td>
				        ${vo.step1ManagerName}<br>
				        <c:choose>
				        	<c:when test="${vo.step1Status == 'W'}">대기</c:when>
				            <c:when test="${vo.step1Status == 'A'}">✔ 승인</c:when>
				            <c:when test="${vo.step1Status == 'R'}">❌ 반려</c:when>
				            <c:otherwise>대기중</c:otherwise>
				        </c:choose>
				    </td>
				    <td>
				        ${vo.step2ManagerName}<br>
				        <c:choose>
				        	<c:when test="${vo.step2Status == 'W'}">대기</c:when>
				            <c:when test="${vo.step2Status == 'A'}">✔ 승인</c:when>
				            <c:when test="${vo.step2Status == 'R'}">❌ 반려</c:when>
				            <c:otherwise>대기중</c:otherwise>
				        </c:choose>
				    </td>
				</tr>
			</table>
	
			<table class="doc-table">
				<tr>
					<th>기안일자</th>
					<td>${vo.docDate}</td>
					<th>문서번호</th>
					<td>${vo.docNo}번</td>
				</tr>
				<tr>
					<th>작성자</th>
					<td>${vo.writerName}</td>
					<th>부서</th>
					<td>${ dept }</td>
				</tr>
				<c:choose>
					<c:when test="${ vo.docType == 4 }">
						<tr>
							<th>제목</th>
							<td>${ vo.docTitle }</td>
							<th>휴가 일수</th>
							<td>${ vo.totalDays }</td>
						</tr>
						<tr>
							<th>휴가 시작일</th>
							<td>${ vo.startDate }</td>
							<th>휴가 종료일</th>
							<td>${ vo.endDate }</td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr>
							<th>제목</th>
							<td colspan="3">${vo.docTitle}</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</table>
	
			<div class="section-title">내용</div>
			<div class="doc-content-box">${vo.docContent}</div>
	
			<c:choose>
			    <c:when test="${not empty vo.rejectReason}">
			        <div class="bottom-box">반려 사유</div>
			        <div class="doc-content-box2">${vo.rejectReason}</div>
			    </c:when>
			    <c:when test="${ vo.docType == 4 }">
			    	<div class="bottom-box">기타 사항</div>
			        <div class="doc-content-box2 box-number-4"></div>
			    </c:when>
			    <c:otherwise>
			        <div class="bottom-box bottom-box2">기타 사항</div>
			        <div class="doc-content-box2"></div>
			    </c:otherwise>
			</c:choose>
			
		</div>
	</div>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
	<script>
	    function generatePDF() {
	        // 1. PDF로 만들 영역 선택 (문서 전체 wrapper)
	        const element = document.querySelector('.doc-wrapper');
	        
	        // 2. html2canvas로 DOM을 캔버스로 렌더링
	        html2canvas(element, { 
	            scale: 2, // 렌더링 해상도를 높여서 깔끔하게 만듭니다.
	            useCORS: true 
	        }).then(function(canvas) {
	            
	            const { jsPDF } = window.jspdf;
	            
	            // 3. 캡처된 이미지의 너비와 높이를 획득
	            const imgWidth = canvas.width;
	            const imgHeight = canvas.height;
	            
	            // 4. PDF 문서 객체 생성 (캡처된 이미지 크기에 맞게 생성)
	            // 'mm' 단위 대신 'pt' (포인트) 단위를 사용하거나, 커스텀 배열 [width, height]를 사용합니다.
	            // 여기서는 'px'와 유사한 'pt' 단위를 사용하여 화면 비율을 그대로 재현합니다.
	            const pdf = new jsPDF('p', 'pt', [imgWidth, imgHeight]); 
	            
	            // 5. 캔버스 이미지를 PNG 데이터로 변환
	            const imgData = canvas.toDataURL('image/png');
	            
	            // 6. PDF에 이미지 추가 (캡처된 크기 그대로)
	            // (0, 0) 위치에 캡처된 원본 크기(imgWidth, imgHeight)로 이미지를 삽입합니다.
	            pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight); 
	            
	            // 7. PDF 파일 저장
	            // 파일명은 vo 객체 정보로 동적 생성합니다.
	            pdf.save('${vo.docTitle}_${vo.docNo}.pdf'); 
	        });
	    }
	</script>
</body>
</html>