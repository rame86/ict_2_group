<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="multiInsert.do" method="post">
  <table cellspacing="0" width="600" >
  <caption><h2>List type의 property</h2></caption>
 <tr>
    <th width="100">선택</th>
	<th width="200">아이디</th>
	<th width="200">이름</th>
	<th width="100">나이</th>
 </tr>
 <tr>
    <td align="center"><input type="checkbox" name="list[0].state"></td>
	<td><input type="text" name="list[0].id"></td>
	<td><input type="text" name="list[0].name"></td>
	<td><input type="text" name="list[0].age" value="0"></td>
 </tr>
 <tr>
    <td align="center"><input type="checkbox" name="list[1].state"></td>
	<td><input type="text" name="list[1].id"></td>
	<td><input type="text" name="list[1].name"></td>
	<td><input type="text" name="list[1].age" value="0"></td>
 </tr>

<tr>
    <td align="center"><input type="checkbox" name="list[2].state"></td>
	<td><input type="text" name="list[2].id"></td>
	<td><input type="text" name="list[2].name"></td>
	<td><input type="text" name="list[2].age" value="0"></td>
 </tr>
 
 <tr >
	<td colspan="4" align="center"><input type="submit" value="전송"></td>
	
 </tr>

 </table>
  
</form>


</body>
</html>