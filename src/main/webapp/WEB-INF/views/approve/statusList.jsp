<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setAttribute("menu", "status");
%>

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
						
							<div class="col-xl-2 col-md-4">
                                <div class="card bg-primary text-white mb-4">
                                	<div class="card-header">
                                        <a class="small text-white  d-flex align-items-center justify-content-between" href="finishList">
                                        결재 받은 문서<div class="small text-white"><i class="fas fa-angle-right"></i></div></a>
                                    </div>
                                    
                                    <div class="card-body">승인 완료</div>
                                    <div class="card-body clickable" onclick="openDocumentListModal(event, '결재 받은 문서', 'finishList', '결재 완료된 문서');"><h3>${ sendFinishCount }건</h3></div><br>
                                </div>
                            </div>
                            
                            <div class="col-xl-2 col-md-4">
                                <div class="card bg-warning text-white mb-4">
                                	<div class="card-header d-flex align-items-center justify-content-between">
                                        <a class="small text-white d-flex align-items-center justify-content-between w-100" href="sendList">
                                        결재 받을 문서<div class="small text-white"><i class="fas fa-angle-right"></i></div></a>
                                    </div>
                                    
                                    <div class="card-body">결재 진행중</div>
                                    <div class="card-body clickable" onclick="openDocumentListModal(event, '결재 받을 문서', 'waitList', '결재 진행중인 문서');"><h3>${ sendWaitCount }건</h3></div><br>
                                </div>
                            </div>
                            
                            <div class="col-xl-2 col-md-4">
                                <div class="card bg-danger text-white mb-4">
                                	<div class="card-header d-flex align-items-center justify-content-between">
                                        <a class="small text-white d-flex align-items-center justify-content-between w-100" href="finishList">
                                        결재 받은 문서<div class="small text-white"><i class="fas fa-angle-right"></i></div></a>
                                    </div>
                                    <div class="card-body">결재 반려</div>
                                    <div class="card-body clickable" onclick="openDocumentListModal(event, '결재 받은 문서', 'rejectList', '결재 반려된 문서');"><h3>${ sendrejectCount }건</h3></div><br>
                                </div>
                            </div>
                            
                            <div class="col-xl-2 col-md-4">
                                <div class="card bg-primary text-white mb-4">
                                	<div class="card-header d-flex align-items-center justify-content-between">
                                        <a class="small text-white d-flex align-items-center justify-content-between w-100" href="finishList">
                                        결재 완료 문서<div class="small text-white"><i class="fas fa-angle-right"></i></div></a>
                                    </div>
                                    <div class="card-body">결재 완료</div>
                                    <div class="card-body clickable" onclick="openDocumentListModal(event, '결재 한 문서', 'receiveFinish', '결재 승인한 문서');"><h3>${ receiveFinishCount }건</h3></div><br>
                                </div>
                            </div>
                            
                            <div class="col-xl-2 col-md-4">
                                <div class="card bg-warning text-white mb-4">
                                	<div class="card-header d-flex align-items-center justify-content-between">
                                        <a class="small text-white d-flex align-items-center justify-content-between w-100" href="receiveList">
                                        결재 할 문서<div class="small text-white"><i class="fas fa-angle-right"></i></div></a>
                                        
                                    </div>
                                    <div class="card-body">결재 대기</div>
                                    <div class="card-body clickable" onclick="openDocumentListModal(event, '결재 할 문서', 'receiveWait', '결재 대기중인 문서');"><h3>${ receiveWaitCount }건</h3></div><br>
                                </div>
                            </div>
                            
                            <div class="col-xl-2 col-md-4">
                                <div class="card bg-success text-white mb-4">
                                	<div class="card-header d-flex align-items-center justify-content-between">
                                        <div class="small text-white">모든 결재 문서</div>
                                        <div class="small text-white"></div>
                                    </div>
                                    <div class="card-body">전체 합계</div>
                                    <div class="card-body"><h3>${ totalCount }건</h3></div><br>
                                </div>
                            </div>
                        </div>
                        
                        <br>
                        
                        <!-- 테이블 -->
                        <div class="card mb-4 approve-main">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                <a href="receiveList">결재 할 문서</a>
                            </div>
                            <div class="card-body">
                                <table id="tableSimple1">
                                    <thead>
                                        <tr>
                                        	<th>번호</th>
                                            <th>작성날짜</th>
                                            <th>제목</th>
                                            <th>작성자</th>
                                            <th>결재자</th>
                                            <th>진행상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:forEach var="vo" items="${receive}">
	                                        <tr>
	                                            <td>${ vo.docNo }</td>
	                                            <td>${ vo.docDate }</td>
	                                            <td><a href="#" onclick="openDocDetail('${ vo.docNo }'); return false;"> ${ vo.docTitle }</a></td>
	                                            <td>${ vo.writerName }</td>
												<td>
	                                            	<c:choose>
												        <c:when test="${ not empty vo.step1ManagerName }">
												            ${ vo.step1ManagerName }, ${ vo.step2ManagerName }
												        </c:when>
												        <c:otherwise>
												            ${ vo.step2ManagerName }
												        </c:otherwise>
												    </c:choose>
	                                            </td>
	                                            <td>${ vo.progressStatus }</td>
	                                        </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <div class="card mb-4 approve-main">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                <a href="sendList">결재 받을 문서</a>
                            </div>
                            <div class="card-body">
                                <table id="tableSimple2">
                                    <thead>
                                        <tr>
                                        	<th>번호</th>
                                            <th>작성날짜</th>
                                            <th>제목</th>
                                            <th>결재자</th>
                                            <th>진행상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="vo" items="${ send }">
	                                        <tr>
	                                            <td>${ vo.docNo }</td>
	                                            <td>${ vo.docDate }</td>
	                                            <td><a href="#" onclick="openDocDetail('${ vo.docNo }'); return false;"> ${ vo.docTitle }</a></td>
												<td>
	                                            	<c:choose>
												        <c:when test="${ not empty vo.step1ManagerName }">
												            ${ vo.step1ManagerName }, ${ vo.step2ManagerName }
												        </c:when>
												        <c:otherwise>
												            ${ vo.step2ManagerName }
												        </c:otherwise>
												    </c:choose>
	                                            </td>
	                                            <td>${ vo.progressStatus }</td>
	                                        </tr>
                                        </c:forEach>
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
		
		<div class="modal fade" id="documentListModal" tabindex="-1" aria-labelledby="documentListModalLabel" aria-hidden="true">
		    <div class="modal-dialog modal-xl">
		        <div class="modal-content">
		            
		            <div class="modal-header table-Header">
		                <h5 class="modal-title" id="documentListModalTitle"></h5>
		                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		            </div>
		            
		            <div class="modal-body">

		           		<div class="card mb-4">
		           			<div class="card-header" id="modalSubTitle">
                                <i class="fas fa-table me-1"></i>
                                결재 완료 문서
                            </div>
		           			
		           			<div class="card-body">
		           			
				                <table class="table table-striped table-hover table-bordered">
				                    <thead>
				                        <tr>
				                            <th>번호</th>
				                            <th>작성날짜</th>
				                            <th>제목</th>
				                            <th>결재자</th>
				                            <th>진행상태</th>
				                        </tr>
				                    </thead>
				                    <tbody id="documentListTableBody"></tbody>
				                </table>
			                </div>
			                
		                </div>
		            </div>
		            
		        </div>
		    </div>
		</div>

	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script>
		// 문서 상세 팝업
		function openDocDetail(docNo) {
			const url = "documentDetailPopup?docNo=" + docNo;
			const options = "width=900,height=1200,top=20,left=600,scrollbars=yes,resizable=yes";
			window.open(url, "documentDetailPopup", options);
		}
		
		// 모달 창
		$(function() {
			
		    const $documentListModal = $('#documentListModal');
		    const $modalTitle = $('#documentListModalTitle');
		    const $tbody = $('#documentListTableBody'); // 테이블 본체 ID
		    const $cardHeaderSubtitle = $('#modalSubTitle');
		    
		    // 1. 문서 리스트 모달을 여는 핵심 함수
		    window.openDocumentListModal = function(event, title, status, subtitle) {
		        
		        event.stopPropagation();
		        event.preventDefault();
		        
		        // 모달 제목 업데이트
		        $modalTitle.text(title);
		        $cardHeaderSubtitle.text(subtitle);
		        
		        // 로딩 중 메시지 표시
		        $tbody.html('<tr><td colspan="5" class="text-center">데이터를 불러오는 중...</td></tr>');

		        // 2. AJAX 통신 시작 (jQuery.ajax)
		        $.ajax({
		            url: '/approve/simpleList', // 👈 이 주소로 서버 요청
		            method: 'GET',
		            dataType: 'json',
		            data: { status: status }, // FINISH, ACTIVE 등의 상태 코드를 전달
		            
		            success: function(response) {
		                const documentList = response.documentList || []; 
		                let tableRowsHtml = ''; // <tr> 태그 문자열을 담을 변수
		                
		                if (documentList.length > 0) {
		                    
		                    $.each(documentList, function(index, vo) {
		                        // 결재자 이름 처리
		                        let managers = vo.step2ManagerName || '';
		                        if (vo.step1ManagerName) {
		                            managers = vo.step1ManagerName + (managers ? ', ' + managers : '');
		                        }
		                        
		                        // ✨ 순수 HTML <tr>과 <td> 태그를 직접 생성 ✨
		                        tableRowsHtml += '<tr>';
		                        tableRowsHtml += '<td>' + vo.docNo + '</td>';
		                        tableRowsHtml += '<td>' + vo.docDate + '</td>';
		                        // 제목 셀은 상세 팝업 링크로 만듭니다.
		                        tableRowsHtml += '<td><a href="#" onclick="openDocDetail(\'' + vo.docNo + '\'); return false;">' + vo.docTitle + '</a></td>';
		                        tableRowsHtml += '<td>' + managers + '</td>';
		                        tableRowsHtml += '<td>' + vo.progressStatus + '</td>';
		                        tableRowsHtml += '</tr>';
		                    });

		                } else {
		                    // 데이터가 없을 경우 표시할 메시지
		                    tableRowsHtml = '<tr><td colspan="5" class="text-center">조회된 문서가 없습니다.</td></tr>';
		                }
		                
		                // 3. 완성된 HTML을 tbody에 바로 주입합니다.
		                $tbody.html(tableRowsHtml);
		            },
		            
		            error: function(xhr, status, error) {
		                console.error("문서 리스트 로딩 오류:", error, "HTTP Code:", xhr.status); 
		                $tbody.html('<tr><td colspan="5" class="text-center text-danger">데이터를 불러오는 중 오류가 발생했습니다. (Code: ' + xhr.status + ')</td></tr>');
		            },
		            
		            complete: function() {
		                // 4. AJAX 통신 완료 후 모달 띄우기
		                $documentListModal.modal('show');
		            }
		        });
		    };
		});
	</script>
	<style>
		.modal-body table thead th {
			font-size: 0.875rem;
		    font-weight: bold;
		}
		
		.modal-body .table {
		    margin-bottom: 0;
		}
		
		#documentListTableBody {
		    font-size: 0.875rem; 
		}
		
		.clickable{
			cursor : pointer;
		}
		
		.clickable:hover {
		    color : #dee2e6;
		    transition: background-color 0.2s ease;
		}
	</style>
</body>
</html>