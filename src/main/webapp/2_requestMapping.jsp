<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> Method 방식과 URL 인자</title>
</head>
<body>
<h1>RequestMapping 실습</h1>
<a href="re/a.do">요청1</a><p/>
<a href="re/b.do">요청2</a><p/>
<a href="re/c.do?id=kim">요청3</a><p/>
<a href="re/c.do">요청4</a><p/>

<h2> get 구분</h2>
<form action="re/request.do" method="get">
	id : <input type="text" name="id"><br/>
	name : <input type="text" name="name"><br/>
	age: <input type="text" name="age"><br/>
	<input type="submit">
</form>


<h2> post 구분</h2>
<form action="re/request.do" method="post">
	id : <input type="text" name="id"><br/>
	name : <input type="text" name="name"><br/>
	age: <input type="text" name="age"><br/>
	<input type="submit">
</form>

</body>
</html>
