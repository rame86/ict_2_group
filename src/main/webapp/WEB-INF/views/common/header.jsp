<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<meta name="description" content="" />
	<meta name="author" content="" />
	<title>PeopleSync</title>
	<link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
	<link href="/css/styles.css" rel="stylesheet" />
	<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="/js/scripts.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
	<script src="/js/datatables-simple-demo.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
	<link href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />
	<script src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
	<script src="/js/header-notification.js"></script>
</head>
	<c:if test="${not empty sessionScope.login}">
		<input type="hidden" id="sessionEmp" value="${sessionScope.login}">
	</c:if>
	<body class="sb-nav-fixed">
		<script src="/js/websocket.js"></script>
		<script>
			const currentEmpNoFromJSP = '${ sessionScope.login.empNo }';
			connectSocket();
			$(document).ready(function() {
				updateSidebarBadge();
		        
		        // 전자결재 사이드바 알람
				$("#collapseApproval").on('show.bs.collapse', function () {});
		    }); 
		</script>
		<input type="hidden" id="sessionEmpNo" value="${login.empNo}">
        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <!-- Navbar Brand-->
            <a class="navbar-brand ps-3" href="/index.html">PEOPLE CYNC</a>
            <!-- Sidebar Toggle-->
            <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i class="fas fa-bars"></i></button>
            <!-- Navbar Search-->
            <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
                <div class="input-group">
                    <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch" />
                    <button class="btn btn-primary" id="btnNavbarSearch" type="button"><i class="fas fa-search"></i></button>
                </div>
            </form>
            
            <!-- Navbar-->
            <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
            
            	<li class="nav-item dropdown">
                    <a class="nav-link" id="alertsDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-bell fa-fw"></i>
                        <span class="badge rounded-pill badge-notification bg-warning" id="alertBadge">0</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="alertsDropdown">
                        <li><h6 class="dropdown-header">새로운 알림</h6></li>
                        <li><a class="dropdown-item" href="#">알림 없음</a></li>
                        <li><hr class="dropdown-divider" /></li>
                        <li><a class="dropdown-item text-secondary" href="#!">모든 알림 보기</a></li>
                    </ul>
                </li>
                
                <li class="nav-item dropdown">
                    <a class="nav-link" id="messagesDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                         <i class="fas fa-envelope fa-fw"></i> 
                        <span class="badge rounded-pill badge-notification bg-danger" id="messageBadge">0</span> 
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end p-0 shadow border-0" 
				        aria-labelledby="messagesDropdown" style="width: 300px;"> 
				        
				        <li><h6 class="dropdown-header text-center py-3 bg-primary text-white border-0 rounded-top">
				            MESSAGE CENTER
				        </h6></li>
				        
				        <div id="latestMessagesContainer" class="list-group list-group-flush"> 
				            
				            <a class="list-group-item list-group-item-action d-flex align-items-start py-3" href="/message/messageList">
				                
				                <div class="me-3" style="width: 40px; height: 40px;">
				                    <img class="rounded-circle w-100 h-100" src="/img/profile_placeholder.png" alt="프로필">
				                    </div>
				                
				                <div class="w-100">
				                    <div class="small text-gray-500 mb-1">Emily Fowler · 58m</div>
				                    <div class="fw-bold text-truncate" style="max-width: 250px;">Hi there! I am wondering if you ...</div>
				                </div>
				            </a>
				            </div>
				        
				        <li><hr class="dropdown-divider my-0" /></li>
				        <li><a class="dropdown-item text-center small text-gray-500 py-2" href="/message/messageList">Read More Messages</a></li>
				    </ul>
                </li>
            	
                <li class="nav-item dropdown ps-3 border-left">
                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="#!">Settings</a></li>
                        <li><a class="dropdown-item" href="#!">Activity Log</a></li>
                        <li><hr class="dropdown-divider" /></li>
                        <li><a href="/kakao/logout" class="dropdown-item" style="color: #EAA8B3; font-weight: bold;">로그아웃</a></li>
                    </ul>
                </li>
                
            </ul>
            
        </nav>

</body>
</html>