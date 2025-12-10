<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>getBoardList.jsp</title>
</head>
<script type="text/javascript">
document.querySelectorAll('#datatablesSimple tbody tr').length</script>
<body class="sb-nav-fixed">

	<!-- 헤더 -->
	<jsp:include page="../common/header.jsp" flush="true"/>
	
	<div id="layoutSidenav">
	
		<!-- 사이드 -->
		<jsp:include page="../common/sidebar.jsp" flush="true"/>
		
		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">
                        <h3 class="mt-4">자유게</h3><br>
                        
                        <div class="card mb-4">
                            <div class="card-header table-Header">
                                <i class="fas fa-table me-1"></i>
                                적나라한 게시판
                            </div>
                            <div class="card-body">
                                <table id="datatablesSimple" class="display">
                                    <thead>
                                        <tr>
                                            <th>글번호</th>
                                            <th>글제목</th>
                                            <th>작성자</th>
                                            <th>작성시간</th>
                                            <th>조회수</th>
                                        </tr>
                                    </thead>
                                    <tfoot>
								        <tr>
								            <th>글번호</th>
                                            <th>글제목</th>
                                            <th>작성자</th>
                                            <th>작성시간</th>
                                            <th>조회수</th>
								        </tr>
								    </tfoot>
                                    <tbody>
                                    	<c:forEach var="vo" items="${ freeBoardList }">
	                                        <tr>
	                                            <td>${ vo.boardNo }</td>
	                                            <td>${ vo.boardTitle }</td>
	                                            <td><a href="#" onclick="openDocDetail('${ vo.empNo }'); return false;"> ${ vo.empNo }</a></td>
	                                            <td>${ vo.boardDate }</td>
	                                            <td>${ vo.boardCnt }</td>
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