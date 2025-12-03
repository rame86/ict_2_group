<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setAttribute("menu", "status");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>approve - statusList</title>
<link href="/css/approve-main.css" rel="stylesheet"></link>
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
						<h3 class="mt-4">결재 현황</h3><br>
						
						<div class="row">
							<div class="col-xl-2 col-md-4">
                                <div class="card bg-primary text-white mb-4">
                                	<div class="card-header d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="#">결재 완료 문서</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                    <div class="card-body">승인 완료</div>
                                    <div class="card-body"><h3>${ sendFinishCount }건</h3></div><br>
                                    
                                </div>
                            </div>
                            <div class="col-xl-2 col-md-4">
                                <div class="card bg-warning text-white mb-4">
                                	<div class="card-header d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="#">결재 받을 문서</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                    <div class="card-body">결재 진행중</div>
                                    <div class="card-body"><h3>${ sendWaitCount }건</h3></div><br>
                                    
                                </div>
                            </div>
                            <div class="col-xl-2 col-md-4">
                                <div class="card bg-danger text-white mb-4">
                                	<div class="card-header d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="#">결재 받을 문서</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                    <div class="card-body">결재 반려</div>
                                    <div class="card-body"><h3>${ sendrejectCount }건</h3></div><br>
                                </div>
                            </div>
                            <div class="col-xl-2 col-md-4">
                                <div class="card bg-primary text-white mb-4">
                                	<div class="card-header d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="#">결재 완료 문서</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                    <div class="card-body">결재 완료</div>
                                    <div class="card-body"><h3>${ receiveFinishCount }건</h3></div><br>
                                </div>
                            </div>
                            <div class="col-xl-2 col-md-4">
                                <div class="card bg-warning text-white mb-4">
                                	<div class="card-header d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="#">결재 할 문서</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                    <div class="card-body">결재 대기</div>
                                    <div class="card-body"><h3>${ receiveWaitCount }건</h3></div><br>
                                </div>
                            </div>
                            <div class="col-xl-2 col-md-4">
                                <div class="card bg-success text-white mb-4">
                                	<div class="card-header d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="#">모든 결재 문서</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                    <div class="card-body">전체 합계</div>
                                    <div class="card-body"><h3>${ totalCount }건</h3></div><br>
                                </div>
                            </div>
                        </div>
                        
                        <br>
                        
                        <!-- 테이블 -->
                        <div class="card mb-4 approve-main">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                <a href="receiveList">결재 할 문서</a>
                            </div>
                            <div class="card-body">
                                <table id="tableSimple1">
                                    <thead>
                                        <tr>
                                        	<th>번호</th>
                                            <th>작성날짜</th>
                                            <th>제목</th>
                                            <th>작성자</th>
                                            <th>결재자</th>
                                            <th>진행상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:forEach var="vo" items="${receive}">
	                                        <tr>
	                                            <td>${ vo.docNo }</td>
	                                            <td>${ vo.docDate }</td>
	                                            <td><a href="">${ vo.docTitle }</a></td>
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
                        
                        <div class="card mb-4 approve-main">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                <a href="sendList">결재 받을 문서</a>
                            </div>
                            <div class="card-body">
                                <table id="tableSimple2">
                                    <thead>
                                        <tr>
                                        	<th>번호</th>
                                            <th>작성날짜</th>
                                            <th>제목</th>
                                            <th>결재자</th>
                                            <th>진행상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="vo" items="${ send }">
	                                        <tr>
	                                            <td>${ vo.docNo }</td>
	                                            <td>${ vo.docDate }</td>
	                                            <td><a href="">${ vo.docTitle }</a></td>
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
		
</body>
</html>