<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setAttribute("menu", "receive");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>approve - receiveList</title>
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
                        <h3 class="mt-4">결재 할 문서</h3><br>
                        
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                결재 할 문서
                            </div>
                            <div class="card-body">
                                <table id="datatablesSimple">
                                    <thead>
                                        <tr>
                                            <th>문서번호</th>
                                            <th>작성날짜</th>
                                            <th>제목</th>
                                            <th>작성자</th>
                                            <th>결재자</th>
                                            <th>진행상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:forEach var="vo" items="${list}">
	                                        <tr>
	                                            <td>${ vo.docNo }</td>
	                                            <td>${ vo.docDate }</td>
	                                            <td>${ vo.docTitle }</td>
	                                            <td>${ vo.writerName }</td>
	                                            <td>
	                                            	${ vo.step1ManagerName }
	                                            	<c:if test="${ not empty vo.step2ManagerName and vo.step1ManagerName != vo.step2ManagerName }">
	                                            		, ${vo.step2ManagerName}
	                                            	</c:if>
	                                            </td>
	                                            <td>${ vo.progressStatus }</td>
	                                        </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
			</main>
			
			<!-- 푸터 -->
			<jsp:include page="../common/footer.jsp" flush="true"/>
				
		</div>
		
	</div>

</body>
</html>