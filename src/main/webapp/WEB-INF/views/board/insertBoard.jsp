<%@ page contentType="text/html; charset=UTF-8" %>
	<!DOCTYPE>
	<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<script src="https://code.jquery.com/jquery-3.6.0.js" type="text/javascript"></script>
		<script src='/js/reply.js' type="text/javascript"></script>
		<link rel="stylesheet" href="/css/bodyStyle.css">

		<title>새글등록</title>
	</head>

	<body>

		<h3>새글 등록하기</h3>
		<hr>

		<!-- FileUpload 필수 속성  method='post' enctype="multipart/form-data" -->
		<form action="saveBoard" method='post' enctype="multipart/form-data">
			<table border="1">
				<tr>
					<td bgcolor="orange" width="70">제목</td>
					<td align="left">
						<input type="text" name="title" />
					</td>
				</tr>
				<tr>
					<td bgcolor="orange">작성자</td>
					<td align="left">
						<input type="text" name="writer" size="10" value="${sessionScope.login.getName()}" readonly />
					</td>
				</tr>
				<tr>
					<td bgcolor="orange">내용</td>
					<td align="left">
						<textarea name="content" cols="40" rows="10"></textarea>
					</td>
				</tr>
				<!-- 파일등록 -->
				<tr>
					<td>파일</td>
					<td><input type='file' name='file' /></td>
				</tr>

				<tr>
					<td colspan="2" align="center">
						<input type="submit" value=" 새글 등록 " />
					</td>
				</tr>
			</table>
		</form>
		<form action="getBoardList" method="post">
			<button type="submit">
				게시글 보기
			</button>
		</form>

		<hr>

	</body>

	</html>