<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>@Controller의 메소드 parameter</title>
</head>
<body>
<h1> @Controller의 메소드 parameter 실습 </h1>
<a href="param.do?id=kim&age=20">요청 파라메터 2개</a><br/>

<a href="param.do">요청 파라메터 0 개</a><br/><br/><br/> <!-- 타입 오류 -->


<form action="paramForm.do" method="post">
	id : <input type="text" name="id"><br/>
	name : <input type="text" name="name"><br/>
	<!-- age칸을 지우고 실행한다면 -->
	age: <input type="text" name="age"><br/>
	<input type="submit">
</form>

</body>
</html>