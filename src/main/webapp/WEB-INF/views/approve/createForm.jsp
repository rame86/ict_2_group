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
					
					<div class="document-selector mb-4">
                        <button class="btn btn-primary document-type-btn" data-doc-type="1" data-doc-name="품의서">품의서</button>
                        <button class="btn btn-outline-secondary document-type-btn" data-doc-type="2" data-doc-name="기획서">기획서</button>
                        <button class="btn btn-outline-secondary document-type-btn" data-doc-type="3" data-doc-name="제안서">제안서</button>
                    </div>
			        
			        <form action="approve-form" method="POST" id="documentForm">
			        	<input type="hidden" name="DocType" id="documentTypeInput" value="1">
						<input type="hidden" name="empNo" value="${ sessionScope.login.empNo }">
						<input type="hidden" name="empNo" value="${ sessionScope.login.gradeNo }">
						<input type="hidden" name="step1ManagerNo" value="${ loginVO.managerEmpNo }">
						<input type="hidden" name="step2ManagerNo" value="${ loginVO.parentDeptNo }">
						
					    <div class="mb-3">
					        <label for="documentTitle" class="form-label fw-bold">문서제목</label>
					        <input type="text" class="form-control" id="documentTitle" name="docTitle" placeholder="제목을 입력하세요" required>
					    </div>
					
					    <div class="mb-3">
					        <label for="draftDate" class="form-label fw-bold">기안일</label>
					        <input type="date" class="form-control" id="draftDate" name="docDate" value="2025-11-27" required>
					    </div>
					    
					    <div class="mb-3">
					        <label for="documentTitle" class="form-label fw-bold">기안자</label>
					        <input type="text" class="form-control" id="documentTitle" name="empName" value="${ sessionScope.login.empName }" readonly>
					    </div>
					    
					     <!-- ▼▼▼ 문서 내용 템플릿 영역 ▼▼▼ -->
		                <div id="templateArea">
		
		                    <!-- 품의서 템플릿 (기본 선택) -->
		                    <div class="doc-template" id="template1">
		                        <label class="form-label fw-bold">내용 (품의서)</label>
		                        <textarea class="form-control" name="docContent" rows="8" placeholder="품의서 내용을 입력하세요." required></textarea>
		                    </div>
		
		                    <!-- 기획서 템플릿 -->
		                    <div class="doc-template d-none" id="template2">
		                        <label class="form-label fw-bold">내용 (기획서)</label>
		                        <textarea class="form-control" name="docContent" rows="8" placeholder="기획 목적, 배경, 일정 등을 작성하세요." required></textarea>
		                    </div>
		
		                    <!-- 제안서 템플릿 -->
		                    <div class="doc-template d-none" id="template3">
		                        <label class="form-label fw-bold">내용 (제안서)</label>
		                        <textarea class="form-control" name="docContent" rows="8" placeholder="제안할 사항을 상세히 입력하세요." required></textarea>
		                    </div>
		
		                </div>
					
					    <div class="mt-4">
					        <button type="submit" class="btn btn-success">문서 제출</button>
					        <button type="reset" class="btn btn-secondary">초기화</button>
					    </div>
			        </form>
			        
				</div>
				<br><br><br>
			</main>
		</div>
	</div>
	
	<script>
		document.addEventListener("DOMContentLoaded", () => {
		    const buttons = document.querySelectorAll(".document-type-btn");
		    const hiddenDocType = document.getElementById("documentTypeInput");
		    const templates = document.querySelectorAll(".doc-template");
	
		    buttons.forEach(btn => {
		        btn.addEventListener("click", () => {
	
		            // 버튼 스타일
		            buttons.forEach(b => b.classList.remove("btn-primary"));
		            buttons.forEach(b => b.classList.add("btn-outline-secondary"));
		            btn.classList.add("btn-primary");
	
		            // DocType 저장
		            const docType = btn.dataset.docType;
		            hiddenDocType.value = docType;
	
		            // 템플릿 전환
		            templates.forEach(tpl => {
		                tpl.classList.add("d-none");
		                tpl.querySelector("textarea").removeAttribute("required");
		            });
	
		            const activeTpl = document.getElementById("template" + docType);
		            activeTpl.classList.remove("d-none");
		            activeTpl.querySelector("textarea").setAttribute("required", "required");
		        });
		    });
		});
	</script>
	
</body>
</html>