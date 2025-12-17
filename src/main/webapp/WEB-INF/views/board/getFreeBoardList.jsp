<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>getFreeBoardList.jsp - 자유 게시판</title>
<style>
/* -------------------- [공통 모달 스타일] -------------------- */
/* 모든 모달의 공통 스타일: 자유 게시판의 기본 색상으로 통일 */
#boardModal .modal-header, #writeModal .modal-header, #modifyModal .modal-header {
	background-color: #F7CAC9; /* 자유 게시판 기본 색상 */
	color: white; [cite: 2]
	border-bottom: 1px solid #F7CAC9;
	font-weight: bold;
}

#boardModal .modal-body {
	white-space: pre-wrap;
	text-align: left;
}

/* 게시판 타입에 따른 #boardModal 헤더 오버라이드 */
#boardModal.global-freeBoard .modal-header { /* 전체 게시판 (bg-dark) */
	background-color: #F7CAC9; /* Dark color */
	border-bottom: 1px solid #F7CAC9;
}

#boardModal.dept-freeBoard .modal-header { /* 부서 게시판 (bg-secondary) */
	background-color: #6C757D; /* Secondary color (회색) */
	border-bottom: 1px solid #6C757D;
}

.card-header.bg-pink {
    background-color: #F7CAC9 !important;
    border-bottom: 1px solid #F7CAC9 !important;
    color: white !important; /* 글자색 하얗게 */
}
</style>
</head>

<body class="sb-nav-fixed">

	<jsp:include page="../common/header.jsp" flush="true" />

	<div id="layoutSidenav">

		<jsp:include page="../common/sidebar.jsp" flush="true" />

		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">

					<h1 class="mt-4">자유 게시판</h1>

					<%-- 글쓰기 버튼 --%>
					<div class="d-flex justify-content-end mb-3">
						<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#writeModal">
							<i class="fas fa-pen me-1"></i> 새 글 작성
						</button>
					</div>

					<div class="card mb-4">
						<div class="card-header bg-pink text-white">
							<i class="fas fa-globe me-1"></i> <strong>전체 자유 게시판</strong>
						</div>
						<div class="card-body">
							<table id="datatablesGlobal" class="table table-striped table-hover">
								<thead>
									<tr>
										<th>No</th>
										<th style="width: 50%;">제목</th>
										<th>작성자</th>
										<th>작성일</th>
										<th>조회수</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="vo" items="${ freeBoardList }">
										<c:if test="${vo.deptNo == 0}">
											<tr>
												<td>${ vo.boardNo }</td>
												<td>
													<span class="badge bg-danger me-2">전체</span>
													<a href="#" class="text-decoration-none text-dark" 
													   data-bs-toggle="modal" data-bs-target="#boardModal" 
													   data-no="${ vo.boardNo }" data-title="<c:out value='${vo.boardTitle}'/>" 
													   data-type="global-free"> 
													   ${ vo.boardTitle }
													</a>
												</td>
												<td>${ vo.boardWriter }</td>
												<td>${ vo.boardDate }</td>
												<td>${ vo.boardCnt }</td>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>

					<div class="card mb-4">
						<div class="card-header bg-secondary text-white">
							<i class="fas fa-comments me-1"></i> <strong>${sessionScope.login.deptName} 및 하위부서 자유 게시판</strong>
						</div>
						<div class="card-body">
							<table id="datatablesDept" class="table table-hover">
								<thead>
									<tr>
										<th>No</th>
										<th style="width: 50%;">제목</th>
										<th>작성자</th>
										<th>작성일</th>
										<th>조회수</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="vo" items="${ freeBoardList }">
										<c:if test="${vo.deptNo != 0}">
											<tr>
												<td>${ vo.boardNo }</td>
												<td>
													<span class="badge bg-secondary text-white me-2">${vo.deptName}</span> 
													<a href="#" class="text-decoration-none text-dark" 
													   data-bs-toggle="modal" data-bs-target="#boardModal" 
													   data-no="${ vo.boardNo }" data-title="<c:out value='${vo.boardTitle}'/>" 
													   data-type="dept-free"> 
													   ${ vo.boardTitle }
													</a>
												</td>
												<td>${ vo.boardWriter }</td>
												<td>${ vo.boardDate }</td>
												<td>${ vo.boardCnt }</td>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div class="modal fade" id="writeModal" tabindex="-1" aria-hidden="true">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title">새 글 작성</h5>
								<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<form action="/board/insertFreeBoard" method="post">
								<div class="modal-body">
									<div class="mb-3">
										<label class="form-label fw-bold">작성자</label> 
										<input type="text" class="form-control" name="boardWriter" value="${ sessionScope.login.empName }" readonly> 
										<input type="hidden" name="empNo" value="${ sessionScope.login.empNo }">
									</div>
									<div class="mb-3">
										<label class="form-label fw-bold">게시 대상</label> 
										<select class="form-select" name="deptNo">
											<option value="${sessionScope.login.deptNo}" selected>🏢 부서 게시판 (${sessionScope.login.deptName})</option>
											<option value="0">🌐 전체 게시판 (모든 직원)</option>
										</select>
									</div>
									<div class="mb-3">
										<label class="form-label fw-bold">제목</label> 
										<input type="text" class="form-control" name="boardTitle" required>
									</div>
									<div class="mb-3">
										<label class="form-label fw-bold">내용</label>
										<textarea class="form-control" name="boardContent" rows="10" required></textarea>
									</div>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
									<button type="submit" class="btn btn-primary">작성</button>
								</div>
							</form>
						</div>
					</div>
				</div>

				<div class="modal fade" id="modifyModal" tabindex="-1" aria-hidden="true">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title">게시글 수정</h5>
								<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<form action="/board/insertFreeBoard" method="post" id="modifyForm">
								<div class="modal-body">
									<input type="hidden" name="boardNo" id="modifyBoardNo"> 
									<input type="hidden" name="deptNo" id="modifyDeptNo">
									
									<div class="mb-3">
										<label class="form-label fw-bold">제목</label> 
										<input type="text" class="form-control" id="modifyTitle" name="boardTitle" required>
									</div>
									<div class="mb-3">
										<label class="form-label fw-bold">내용</label>
										<textarea class="form-control" id="modifyContent" name="boardContent" rows="10" required></textarea>
									</div>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
									<button type="submit" class="btn btn-primary">수정 완료</button>
								</div>
							</form>
						</div>
					</div>
				</div>

				<div class="modal fade" id="boardModal" tabindex="-1" aria-hidden="true">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title">게시글 상세</h5>
								<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<div class="modal-body" style="min-height: 200px;">
								<span id="modalContentText" style="display: block;"></span>
							</div>
							<div class="modal-footer">
								<input type="hidden" id="currentBoardNo">
								<button type="button" class="btn btn-warning text-white" id="btnModify" style="display:none;">수정</button>
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
							</div>
						</div>
					</div>
				</div>

			</main>
			<jsp:include page="../common/footer.jsp" flush="true" />
		</div>
	</div>

	<script>
		var LOGIN_EMP_NO = "${sessionScope.login.empNo}";
		
		// DataTables 초기화
		window.addEventListener('DOMContentLoaded', event => {
			const datatablesGlobal = document.getElementById('datatablesGlobal');
			if (datatablesGlobal) {
				new simpleDatatables.DataTable(datatablesGlobal);
			}
			
			const datatablesDept = document.getElementById('datatablesDept');
			if (datatablesDept) {
				new simpleDatatables.DataTable(datatablesDept);
			}
		});

		$(document).ready(function() {
			var $boardModal = $('#boardModal');
			var $btnModify = $('#btnModify');
			var $modifyForm = $('#modifyForm');

			// 상세보기 모달 OPEN
			$boardModal.on('show.bs.modal', function(event) {
				var button = $(event.relatedTarget);
				var boardNo = button.data('no');
				var title = button.data('title');
				var type = button.data('type'); 

				// 모달 헤더 색상 변경
				$boardModal.removeClass('global-free dept-free').addClass(type + 'Board');
				
				$boardModal.find('.modal-title').text(title);
				$boardModal.find('#modalContentText').text('내용 로딩중...');
				$btnModify.hide(); 

				$.ajax({
					url : '/board/getContentFreeBoard',
					type : 'POST',
					data : { boardNo : boardNo },
					dataType : 'json',
					success : function(response) {
						if (response && response.boardContent) {
							$boardModal.find('#modalContentText').text(response.boardContent);
							
							// 작성자 본인 여부 확인
							if (LOGIN_EMP_NO && LOGIN_EMP_NO == response.empNo) {
								$btnModify.show();
								$('#currentBoardNo').val(boardNo);
								$btnModify.data('title', title);
								$btnModify.data('content', response.boardContent);
								$btnModify.data('deptno', response.deptNo); 
							}
						}
					},
					error : function() {
						$boardModal.find('#modalContentText').text('오류 발생');
					}
				});
			});

			// 수정 버튼 클릭 -> 수정 모달 OPEN
			$btnModify.on('click', function() {
				bootstrap.Modal.getInstance($boardModal[0]).hide();

				var boardNo = $('#currentBoardNo').val();
				var title = $(this).data('title');
				var content = $(this).data('content');
				var deptNo = $(this).data('deptno');

				$('#modifyBoardNo').val(boardNo);
				$('#modifyTitle').val(title);
				$('#modifyContent').val(content);
				$('#modifyDeptNo').val(deptNo);

				new bootstrap.Modal($('#modifyModal')[0]).show();
			});
		});
	</script>
</body>
</html>