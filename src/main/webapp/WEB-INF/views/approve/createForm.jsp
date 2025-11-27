<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setAttribute("menu", "create");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>approve - createForm</title>
</head>
<body class="sb-nav-fixed">

	<!-- 헤더 -->
	<jsp:include page="../common/header.jsp" flush="true"/>
	
	<div id="layoutSidenav">
	
		<!-- 사이드 -->
		<jsp:include page="../common/sidebar.jsp" flush="true"/>
		
		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">
					<h3 class="mt-4">문서 작성 하기</h3><br>
					
					<div class="document-selector">
			        <button class="btn btn-primary active">품의서</button>
			        <button class="btn btn-outline-secondary">기획서</button>
			        <button class="btn btn-outline-secondary">제안서</button>
			        </div>
			        
			        <form action="approve-form" method="POST">
			        	<input type="hidden" name="DocType" id="documentTypeInput" value="1">
						<input type="hidden" name="empNo" value="${ sessionScope.login.empNo }">
						<input type="hidden" name="empNo" value="${ sessionScope.login.gradeNo }">
						
					    <div class="mb-3">
					        <label for="documentTitle" class="form-label fw-bold">문서제목</label>
					        <input type="text" class="form-control" id="documentTitle" name="DocTitle" placeholder="제목을 입력하세요" required>
					    </div>
					
					    <div class="mb-3">
					        <label for="draftDate" class="form-label fw-bold">기안일</label>
					        <input type="date" class="form-control" id="draftDate" name="DocDate" value="2025-11-27" required>
					    </div>
					    
					    <div class="mb-3">
					        <label for="documentTitle" class="form-label fw-bold">기안자</label>
					        <input type="text" class="form-control" id="documentTitle" name="" value="${ sessionScope.login.empName }" readonly>
					    </div>
					
					    <div class="mb-3">
					        <label for="documentContent" class="form-label fw-bold">내용</label>
					        <textarea class="form-control" id="documentContent" name="DocContent" rows="8" placeholder="문서의 상세 내용을 입력하세요." required></textarea>
					    </div>
					
					    <div class="mt-4">
					        <button type="submit" class="btn btn-success">문서 제출</button>
					        <button type="reset" class="btn btn-secondary">초기화</button>
					    </div>
			        </form>
			        
				</div>
			</main>
		</div>
	</div>
</body>
</html>