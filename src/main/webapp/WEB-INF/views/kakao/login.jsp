<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>카카오 로그인</title>
    <style>
        /* ... CSS 스타일은 login.html에서 복사하여 사용 ... */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f0f2f5;
            font-family: Arial, sans-serif;
        }
        .container {
            text-align: center;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        h2 { margin-bottom: 20px; color: #333; }
        .kakao-btn {
            cursor: pointer;
        }
    </style>
</head>
<body>

<div class="container">
    <h3>소셜 로그인</h3>
    
    <%-- Controller의 @GetMapping("/kakao/login") 주소로 요청 --%>
    <a href="/kakao/login">
        <img class="kakao-btn" 
             src="https://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg" 
             width="222" 
             alt="카카오 로그인 버튼"/>
    </a>
</div>

</body>
</html>