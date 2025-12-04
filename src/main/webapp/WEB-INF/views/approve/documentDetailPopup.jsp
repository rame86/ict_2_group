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
		width: 800px; /* A4 비율 */
		margin: 0 auto;
		font-family: "맑은 고딕", sans-serif;
	}
	
	.title {
		text-align: center;
		font-size: 26px;
		font-weight: 700;
		margin-top: 40px;
	}
	
	/* 상단 결재란 박스 */
	.approval-top-table {
		border-collapse: collapse;
		float: right;
		margin-bottom: 20px;
	}
	
	.approval-top-table th, .approval-top-table td {
		border: 1px solid #333;
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
		border: 1px solid #999;
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
		border: 1px solid #999;
		border-bottom: none;
		padding: 8px;
		font-weight: bold;
		color: white;
	}
	
	.doc-content-box {
		height: 400px;
		padding: 20px;
		border: 1px solid #999;
		background: #fff;
		white-space: pre-line;
		line-height: 1.6;
	}
	
	.bottom-box {
		margin-top: -1px;
		background: rgb(146 168 209);
		border: 1px solid #999;
		padding: 5px;
		text-align: center;
		font-weight: bold;
		color: white;
	}
	
	.doc-content-box2 {
		height: 90px;
		padding: 20px;
		border: 1px solid #999;
		background: #fff;
		white-space: pre-line;
		line-height: 1.6;
		border-top: 0;
	}
	
	.bottom-box2{
		border-top: 2px solid #999;
	}
</style>
<body>

	<div class="doc-wrapper">

		<div class="title">
			<c:choose>
		        <c:when test="${vo.docType == 1}">품 의 서</c:when>
		        <c:when test="${vo.docType == 2}">기 획 서</c:when>
		        <c:when test="${vo.docType == 3}">제 안 서</c:when>
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
			<tr>
				<th>제목</th>
				<td colspan="3">${vo.docTitle}</td>
			</tr>
		</table>

		<div class="section-title">품의 내용</div>
		<div class="doc-content-box">${vo.docContent}</div>

		<c:choose>
		    <c:when test="${not empty vo.rejectReason}">
		        <div class="bottom-box">반려 사유</div>
		        <div class="doc-content-box2">${vo.rejectReason}</div>
		    </c:when>
		    <c:otherwise>
		        <div class="bottom-box bottom-box2">기타 사항</div>
		        <div class="doc-content-box2"></div>
		    </c:otherwise>
		</c:choose>
	</div>

</body>
</html>