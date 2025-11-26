<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>approve - statusList</title>
<link href="/css/approve-main.css" rel="stylesheet"></link>
</head>
<body class="sb-nav-fixed">
	<!-- 헤더 -->
	<jsp:include page="../common/header.jsp" flush="true"/>
	
	<div id="layoutSidenav">
		
		<!-- 사이드 -->
		<jsp:include page="../common/sidebar.jsp" flush="true"/>
		
			<div id="layoutSidenav_content">
				<main>
					<div class="container-fluid px-4">
						<h3 class="mt-4">결재 현황</h3><br>
						
						<div class="row">
							<div class="col-xl-3 col-md-6">
                                <div class="card bg-primary text-white mb-4">
                                    <div class="card-body">결재 완료</div>
                                    <div class="card-body"><h3>4건</h3></div><br>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="#">자세히 보기</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-warning text-white mb-4">
                                    <div class="card-body">결재 진행중</div>
                                    <div class="card-body"><h3>4건</h3></div><br>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="#">자세히 보기</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-danger text-white mb-4">
                                    <div class="card-body">결재 반려</div>
                                    <div class="card-body"><h3>4건</h3></div><br>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="#">자세히 보기</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-success text-white mb-4">
                                    <div class="card-body">승인할 문서</div>
                                    <div class="card-body"><h3>4건</h3></div><br>
                                    <div class="card-footer d-flex align-items-center justify-content-between">
                                        <a class="small text-white stretched-link" href="#">자세히 보기</a>
                                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                    </div>
                                </div>
                            </div>
                        </div><br>
                        
                        <!-- 테이블 -->
                        <div class="card mb-4 approve-main">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                <a href="receiveList">결재 받을 문서</a>
                            </div>
                            <div class="card-body">
                                <table id="tableSimple1">
                                    <thead>
                                        <tr>
                                            <th>작성날짜</th>
                                            <th>제목</th>
                                            <th>작성자</th>
                                            <th>결재자</th>
                                            <th>진행상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Tiger Nixon</td>
                                            <td>System Architect</td>
                                            <td>Edinburgh</td>
                                            <td>61</td>
                                            <td>2011/04/25</td>
                                        </tr>
                                        <tr>
                                            <td>Garrett Winters</td>
                                            <td>Accountant</td>
                                            <td>Tokyo</td>
                                            <td>63</td>
                                            <td>2011/07/25</td>
                                        </tr>
                                        <tr>
                                            <td>Ashton Cox</td>
                                            <td>Junior Technical Author</td>
                                            <td>San Francisco</td>
                                            <td>66</td>
                                            <td>2009/01/12</td>
                                        </tr>
                                        <tr>
                                            <td>Cedric Kelly</td>
                                            <td>Senior Javascript Developer</td>
                                            <td>Edinburgh</td>
                                            <td>22</td>
                                            <td>2012/03/29</td>
                                        </tr>
                                        <tr>
                                            <td>Airi Satou</td>
                                            <td>Accountant</td>
                                            <td>Tokyo</td>
                                            <td>33</td>
                                            <td>2008/11/28</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <div class="card mb-4 approve-main">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                <a href="sendList">결재 할 문서</a>
                            </div>
                            <div class="card-body">
                                <table id="tableSimple2">
                                    <thead>
                                        <tr>
                                            <th>작성날짜</th>
                                            <th>제목</th>
                                            <th>작성자</th>
                                            <th>결재자</th>
                                            <th>진행상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Tiger Nixon</td>
                                            <td>System Architect</td>
                                            <td>Edinburgh</td>
                                            <td>61</td>
                                            <td>2011/04/25</td>
                                        </tr>
                                        <tr>
                                            <td>Garrett Winters</td>
                                            <td>Accountant</td>
                                            <td>Tokyo</td>
                                            <td>63</td>
                                            <td>2011/04/25</td>
                                        </tr>
                                        <tr>
                                            <td>Ashton Cox</td>
                                            <td>Junior Technical Author</td>
                                            <td>San Francisco</td>
                                            <td>66</td>
                                            <td>2009/01/12</td>
                                        </tr>
                                        <tr>
                                            <td>Cedric Kelly</td>
                                            <td>Senior Javascript Developer</td>
                                            <td>Edinburgh</td>
                                            <td>22</td>
                                            <td>2012/03/29</td>
                                        </tr>
                                        <tr>
                                            <td>Airi Satou</td>
                                            <td>Accountant</td>
                                            <td>Tokyo</td>
                                            <td>33</td>
                                            <td>2008/11/28</td>
                                        </tr>
                                    </tbody>
                                </table>
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