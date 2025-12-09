<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE jsp>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script src="https://code.jquery.com/jquery-3.6.0.js"
	type="text/javascript"></script>
<script src='/js/reply.js' type="text/javascript"></script>
<link rel="stylesheet" href="/css/bodyStyle.css">
<title>getBoardList.jsp</title>
</head>

<body>
	<div>${sessionScope.login.getEmpName()}님 로그인중</div>
	<br>

	<a href='/member/logout'>로그아웃</a>
	<hr />
	<h1>게시글 목록</h1>

	<table border="1">
		<tr>
			<th bgcolor="orange" width="100">번호</th>
			<th bgcolor="orange" width="200">제목</th>
			<th bgcolor="orange" width="150">작성자</th>
			<th bgcolor="orange" width="150">등록일</th>
			<th bgcolor="orange" width="100">조회수</th>
		</tr>

		<!-- ****************************** -->
		<c:forEach items="${boardList }" var="vo">
			<tr>
				<td>${vo.seq }</td>
				<td><a href="getBoard?seq=${vo.seq }">${vo.title}</a></td>
				<td>${vo.writer}</td>
				<td>${vo.regdate}</td>
				<td>${vo.cnt}</td>
			</tr>
		</c:forEach>
		<!-- ****************************** -->
	</table>
	<br>
	<a href="/board/insertBoard">새글 등록</a>
	<br>
	<a href='/member/logout'>로그아웃</a>
</body>

</html>