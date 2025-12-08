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
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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
                            <div class="card-header table-Header">
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
	                                            <td><a href="#" class="documentDetail" data-docno="${ vo.docNo }">${ vo.docTitle }</a></td>
	                                            <td>${ vo.writerName }</td>
	                                            <td>
	                                            	<c:choose>
												        <c:when test="${ not empty vo.step1ManagerName }">
												            ${ vo.step1ManagerName }, ${ vo.step2ManagerName }
												        </c:when>
												        <c:otherwise>
												            ${ vo.step2ManagerName }
												        </c:otherwise>
												    </c:choose>
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
	
	<script>
		$(function(){
			$(".documentDetail").on("click", function(e){
				e.preventDefault();
				
				let docNo = $(this).data("docno");
				
				$.ajax({
					url : "documentDetail",
					data : { docNo : docNo },
					type : "get",
					success : function(html){
						$("#layoutSidenav_content").html(html);
						window.scrollTo(0, 0)
					},
					error : function(){
						alert("문서 상세 로딩 중 오류");
					}
				});
				
			});
		});
	</script>

</body>
</html>