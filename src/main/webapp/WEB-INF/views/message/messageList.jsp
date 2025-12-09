<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>message - message</title>
</head>
<style>
.card-body, .list-group-item {
    font-size: 0.9rem;
}

.list-group-item h6 {
    font-size: 1rem;
}

.list-group-item p {
    font-size: 0.85rem;
}

.card-body .p-2 {
    font-size: 0.9rem;
}

small {
    font-size: 0.75rem;
}

.profile-img-small {
    width: 45px;
    height: 45px;
    object-fit: cover;
    margin-right: 10px;
}
</style>
<body class="sb-nav-fixed">
	<!-- 헤더 -->
	<jsp:include page="../common/header.jsp" flush="true"/>
	
	<div id="layoutSidenav">
	
		<!-- 사이드 -->
		<jsp:include page="../common/sidebar.jsp" flush="true"/>
		
		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">
					<h3 class="mt-4">쪽지함</h3><br>
					
					<div class="row">
    
				        <div class="col-xl-4 col-lg-5">
				            <div class="card shadow mb-4">
				                <div class="card-header py-3">
				                    <h6 class="m-0 font-weight-bold text-primary">대화 상대 목록</h6>
				                </div>
				                
				                <div class="list-group list-group-flush" style="max-height: 700px; overflow-y: auto;">
    
								    <a href="#" class="list-group-item list-group-item-action active py-3">
								        <div class="d-flex align-items-center">
								            <img src="https://via.placeholder.com/45" class="rounded-circle profile-img-small" alt="프로필">
								            
								            <div class="w-100">
								                <div class="d-flex justify-content-between align-items-start">
								                    <h6 class="mb-0 fw-bold d-flex align-items-center">
								                        김철수 사원
								                        <span class="badge bg-danger unread-count-badge ms-2">2</span>
								                    </h6>
								                    <small class="text-white">방금</small>
								                </div>
								                <p class="mb-0 text-truncate" style="max-width: 90%;">
								                    **[새 메시지]** 결재 서류 확인 부탁드립니다...
								                </p>
								            </div>
								        </div>
								    </a>
								    
								    <a href="#" class="list-group-item list-group-item-action py-3">
								        <div class="d-flex align-items-center">
								            <img src="https://via.placeholder.com/45" class="rounded-circle profile-img-small" alt="프로필">
								            
								            <div class="w-100">
								                <div class="d-flex justify-content-between align-items-start">
								                    <h6 class="mb-0">이영희 대리</h6>
								                    <small class="text-muted">어제</small>
								                </div>
								                <p class="mb-0 text-muted text-truncate" style="max-width: 90%;">
								                    재택 근무 관련 문의 드립니다.
								                </p>
								            </div>
								        </div>
								    </a>
								    
								</div>
				            </div>
				        </div>

				        <div class="col-xl-8 col-lg-7">
				            <div class="card shadow mb-4">
				                <div class="card-header py-3">
				                    <h6 class="m-0 font-weight-bold text-primary">김철수 사원과의 대화</h6>
				                </div>
				                
				                <div class="card-body" style="height: 500px; overflow-y: auto;">
				                    
				                    <div class="d-flex justify-content-start mb-3">
				                        <div class="p-2 border rounded" style="max-width: 60%;">
				                            안녕하세요, 김철수입니다. 결재 서류를 올렸는데 확인 부탁드립니다!
				                            <div class="text-right text-muted small mt-1">오전 10:00</div>
				                        </div>
				                    </div>
				                    
				                    <div class="d-flex justify-content-end mb-3">
				                        <div class="p-2 rounded bg-primary text-white" style="max-width: 60%;">
				                            네, 지금 바로 확인하겠습니다.
				                            <div class="text-left small mt-1" style="color: rgba(255, 255, 255, 0.7);">오전 10:01</div>
				                        </div>
				                    </div>
				
				                    </div>
				
				                <div class="card-footer">
				                    <div class="input-group">
				                        <input type="text" class="form-control" placeholder="메시지를 입력하세요...">
				                        <button class="btn btn-primary" type="button">전송</button>
				                    </div>
				                </div>
				            </div>
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