<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>re/request.jsp</title>
</head>
<body>

<h2>전 화면 form 사용자 입력값{param}</h2>
아이디: ${param.id }
<br>
이름: ${param.name }
<br>
나이: ${param.age }

<hr>
<h2>전 화면 form 사용자 입력값</h2>
아이디: ${memberVO.id }
<br>
이름: ${memberVO.name }
<br>
나이: ${memberVO.age }
<hr>
<h2>전 화면 form 사용자 입력값</h2>
아이디: ${vo.id } vo.id - 아니
<br>
이름: ${vo.name } vo.name - 이게
<br>
나이: ${vo.age } vo.age - 되겠냐고 ㅋㅋ
</body>
</html>