<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setAttribute("menu", "finish");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>approve - sendList</title>
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
                        <h3 class="mt-4">결재 완료 문서</h3><br>
                        
                        <div class="card mb-4">
                            <div class="card-header table-Header">
                                <i class="fas fa-table me-1"></i>
                                결재 한 문서
                            </div>
                            <div class="card-body">
                                <table id="datatablesSimple" class="display">
                                    <thead>
                                        <tr>
                                            <th>문서번호</th>
                                            <th>작성날짜</th>
                                            <th>제목</th>
                                            <th>결재자</th>
                                            <th>진행상태</th>
                                        </tr>
                                    </thead>
                                    <tfoot>
								        <tr>
								            <th>문서번호</th> 
								            <th>작성날짜</th>
								            <th>제목</th>
								            <th>결재자</th>
								            <th>진행상태</th>
								        </tr>
								    </tfoot>
                                    <tbody>
                                    	<c:forEach var="vo" items="${ receiveList }">
	                                        <tr>
	                                            <td>${ vo.docNo }</td>
	                                            <td>${ vo.docDate }</td>
	                                            <td><a href="#" onclick="openDocDetail('${ vo.docNo }'); return false;"> ${ vo.docTitle }</a></td>
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
                        
                        <div class="card mb-4">
                            <div class="card-header table-Header">
                                <i class="fas fa-table me-1"></i>
                                결재 받은 문서
                            </div>
                            <div class="card-body">
                                <table id="datatablesSimpleR" class="display">
                                    <thead>
                                        <tr>
                                            <th>문서번호</th>
                                            <th>작성날짜</th>
                                            <th>제목</th>
                                            <th>결재자</th>
                                            <th>진행상태</th>
                                        </tr>
                                    </thead>
                                    <tfoot>
								        <tr>
								            <th>문서번호</th> 
								            <th>작성날짜</th>
								            <th>제목</th>
								            <th>결재자</th>
								            <th>진행상태</th>
								        </tr>
								    </tfoot>
                                    <tbody>
                                    	<c:forEach var="vo" items="${ sendList }">
	                                        <tr>
	                                            <td>${ vo.docNo }</td>
	                                            <td>${ vo.docDate }</td>
	                                            <td><a href="#" onclick="openDocDetail('${ vo.docNo }'); return false;"> ${ vo.docTitle }</a></td>
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
			function openDocDetail(docNo) {
			    const url = "documentDetailPopup?docNo=" + docNo;
			    const options = "width=900,height=1200,top=20,left=500,scrollbars=yes,resizable=yes";
			    window.open(url, "documentDetailPopup", options);
			}
		</script>
		
</body>

</html>