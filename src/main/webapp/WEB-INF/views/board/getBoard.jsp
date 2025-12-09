<%@ page contentType="text/html; charset=utf-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

		<!DOCTYPE html>

		<html>

		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			<script src="https://code.jquery.com/jquery-3.6.0.js" type="text/javascript"></script>
			<script type="text/javascript">
        // 로그인 ID를 JSP EL을 사용하여 문자열 변수로 만들어 전달
           	 const loginId = '${sessionScope.login.getId()}';
	    	</script>
			<script src='/js/reply.js' type="text/javascript"></script>
			<link rel="stylesheet" href="/css/bodyStyle.css">

			<title>글 상세</title>
		</head>
		<body>
			<div>${sessionScope.login.getName()}님 로그인 중</div>
			<br>
			<a href='/member/logout'>로그아웃</a>
			<hr />
			<h1>글 상세</h1>
			<hr>
			<form action="updateBoard" method="post">
				<!-- 게시글 출력 -->
				<input name="seq" type="hidden" value="${getBoard.SEQ}" />
				<table border="1" cellpadding="0" cellspacing="0">
					<tr>
						<td bgcolor="orange" width="70">제목</td>
						<td align="left"><input name="title" type="text" value="${getBoard.TITLE}" /></td>
					</tr>
					<tr>
						<td bgcolor="orange">작성자</td>
						<td align="left">${getBoard.WRITER}</td>
					</tr>
					<tr>
						<td bgcolor="orange">내용</td>
						<td align="left"><textarea name="content" cols="40" rows="10">${getBoard.CONTENT}</textarea>
						</td>
					</tr>
					<tr>
						<td bgcolor="orange">등록일</td>
						<td align="left">${getBoard.REGDATE}</td>
					</tr>
					<tr>
						<td bgcolor="orange">조회수</td>
						<td align="left">${getBoard.CNT}</td>
					</tr>

					<c:if test="${getBoard.FILENAME != null}">
						<tr>
							<td bgcolor="orange">이미지</td>
							<td align="left"><img src='/files/board/${getBoard.FILENAME}' width='300' /></td>
						</tr>
					</c:if>
					<tr>
						<td colspan="2" align="center"><input type="submit" value="글 수정" /></td>
					</tr>
				</table>
			</form>
			<hr>

			<!-- 댓글목록 -->
			<table id='replyList' border='2'></table>

			<!-- 댓글입력 -->
			<form name='replyFrm' id='replyFrm'>
			
				<input type='hidden' name='bno' id='bno' value='${getBoard.SEQ}'>
				<input type='text' name='replyer' id='replyer' value='${sessionScope.login.getId()}' readonly> <input
					type='text' name='reply' id='reply'> <input type='button' value='댓글추가' id='replyConfirm'>
			</form>

			<a href="insertBoard">글등록</a><br>
			<a href="deleteBoard?seq=${getBoard.SEQ}">글삭제</a><br>
			<a href="getBoardList">글목록</a>
		</body>

		</html>