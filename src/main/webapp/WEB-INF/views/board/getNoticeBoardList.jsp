<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>getNoticeBoardList.jsp - 공지 게시판</title>
<style>
/* -------------------- [공통 모달 스타일] -------------------- */
#boardModal .modal-header, #writeModal .modal-header, #modifyModal .modal-header
	{
	background-color: #92a8d1;
	color: white;
	border-bottom: 1px solid #A8C7F7;
	font-weight: bold;
}

#boardModal .modal-body {
	white-space: pre-wrap;
	text-align: left;
}

#boardModal.global-notice .modal-header { /* 전체 공지 (bg-dark) */
	background-color: #92a8d1; /* Dark color */
	border-bottom: 1px solid #92a8d1;
}

#boardModal.dept-notice .modal-header { /* 부서 공지 (bg-secondary) */
	background-color: #6C757D; /* Secondary color (회색) */
	border-bottom: 1px solid #6C757D;
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

					<h1 class="mt-4">공지 게시판</h1>

					<%-- 글쓰기 버튼 (권한 체크: gradeNo가 2 이하일 때만 등, 필요시 수정) --%>
					<div class="d-flex justify-content-end mb-3">
						<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#writeModal">
							<i class="fas fa-pen me-1"></i> 새 공지 작성
						</button>
					</div>

					<div class="card mb-4">
						<div class="card-header bg-dark text-white">
							<i class="fas fa-bullhorn me-1"></i> <strong>전체 공지사항</strong>
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
									<c:forEach var="vo" items="${ noticeBoardList }">
										<c:if test="${vo.deptNo == 0}">
											<tr>
												<td>${ vo.noticeNo }</td>
												<td>
													<span class="badge bg-danger me-2">전체</span>
													<a href="#" class="text-decoration-none text-dark fw-bold" 
													   data-bs-toggle="modal" 
													   data-bs-target="#boardModal" 
													   data-no="${ vo.noticeNo }" 
													   data-title="<c:out value='${vo.noticeTitle}'/>" 
													   data-type="global-notice"> 
													   ${ vo.noticeTitle }
													</a>
												</td>
												<td>${ vo.noticeWriter }</td>
												<td>${ vo.noticeDate }</td>
												<td>${ vo.noticeCnt }</td>
											</tr>
										</c:if>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>

					<div class="card mb-4">
						<div class="card-header bg-secondary text-white">
							<i class="fas fa-building me-1"></i> <strong>${sessionScope.login.deptName} 및 하위부서 공지사항</strong>
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
									<c:forEach var="vo" items="${ noticeBoardList }">
										<c:if test="${vo.deptNo != 0}">
											<tr>
												<td>${ vo.noticeNo }</td>
												<td>
													<span class="badge bg-secondary text-white me-2">${vo.deptName}</span> 
													<a href="#" class="text-decoration-none text-dark" 
													   data-bs-toggle="modal" 
													   data-bs-target="#boardModal" 
													   data-no="${ vo.noticeNo }" 
													   data-title="<c:out value='${vo.noticeTitle}'/>" 
													   data-type="dept-notice"> 
													   ${ vo.noticeTitle }
													</a>
												</td>
												<td>${ vo.noticeWriter }</td>
												<td>${ vo.noticeDate }</td>
												<td>${ vo.noticeCnt }</td>
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
								<h5 class="modal-title">새 공지 작성</h5>
								<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<form action="/board/insertNoticeBoard" method="post">
								<div class="modal-body">
									<div class="mb-3">
										<label class="form-label fw-bold">작성자</label> 
										<input type="text" class="form-control" name="noticeWriter" value="${ sessionScope.login.empName }" readonly> 
										<input type="hidden" name="empNo" value="${ sessionScope.login.empNo }">
									</div>
									<div class="mb-3">
										<label class="form-label fw-bold">게시 대상 선택</label> 
										<select class="form-select" name="deptNo">
											<option value="0" class="text-danger fw-bold">📢 전체 공지 (전 직원)</option>
											<option value="${sessionScope.login.deptNo}" selected>🏢 부서 공지 (${sessionScope.login.deptName})</option>
										</select>
									</div>
									<div class="mb-3">
										<label class="form-label fw-bold">제목</label> 
										<input type="text" class="form-control" name="noticeTitle" required>
									</div>
									<div class="mb-3">
										<label class="form-label fw-bold">내용</label>
										<textarea class="form-control" name="noticeContent" rows="10" required></textarea>
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
								<h5 class="modal-title">공지 수정</h5>
								<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<form action="/board/insertNoticeBoard" method="post" id="modifyForm">
								<div class="modal-body">
									<input type="hidden" name="noticeNo" id="modifyNoticeNo"> 
									<input type="hidden" name="deptNo" id="modifyDeptNo">
									
									<div class="mb-3">
										<label class="form-label fw-bold">제목</label> 
										<input type="text" class="form-control" id="modifyTitle" name="noticeTitle" required>
									</div>
									<div class="mb-3">
										<label class="form-label fw-bold">내용</label>
										<textarea class="form-control" id="modifyContent" name="noticeContent" rows="10" required></textarea>
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
								<h5 class="modal-title">공지 상세</h5>
								<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<div class="modal-body" style="min-height: 200px;">
								<span id="modalContentText" style="display: block;"></span>
							</div>
							<div class="modal-footer">
								<input type="hidden" id="currentNoticeNo">
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
		// DataTables 초기화 (기존 유지)
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

			// ============================================================
			// ⭐ [추가] 1. 알림을 타고 들어왔을 때 자동 실행 로직
			// ============================================================
			var targetNoticeNo = "${targetNoticeNo}"; // Controller에서 넘겨준 글 번호

			if (targetNoticeNo && targetNoticeNo !== "") {
				// 페이지 로딩 후 0.3초 뒤에 실행 (데이터 테이블 로딩 등 고려)
				setTimeout(function() {
					loadNoticeDetailDirectly(targetNoticeNo);
				}, 300);
			}

			// 알림으로 들어왔을 때 모달을 띄워주는 전용 함수
			function loadNoticeDetailDirectly(noticeNo) {
				$.ajax({
					url : '/board/getContentNoticeBoard',
					type : 'POST',
					data : { noticeNo : noticeNo },
					dataType : 'json',
					success : function(response) {
						if (response && response.noticeContent) {
							// 1. 헤더 색상 결정 (deptNo가 0이면 global, 아니면 dept)
							var typeClass = (response.deptNo == 0) ? 'global-notice' : 'dept-notice';
							$boardModal.removeClass('global-notice dept-notice').addClass(typeClass);

							// 2. 내용 채우기
							$boardModal.find('.modal-title').text(response.noticeTitle);
							$boardModal.find('#modalContentText').text(response.noticeContent);
							
							// 3. 수정 버튼 권한 체크 및 데이터 바인딩
							$btnModify.hide();
							var loginGrade = "${sessionScope.login.gradeNo}";
							var loginName = "${sessionScope.login.empName}";

							if (loginGrade <= 2 || loginName == response.noticeWriter) {
								$btnModify.show();
								$('#currentNoticeNo').val(noticeNo);
								$btnModify.data('title', response.noticeTitle);
								$btnModify.data('content', response.noticeContent);
								$btnModify.data('deptno', response.deptNo);
							}
							
							// 4. 모달 강제로 띄우기
							new bootstrap.Modal(document.getElementById('boardModal')).show();
						} else {
							alert("삭제되었거나 존재하지 않는 게시글입니다.");
						}
					},
					error : function() {
						console.log("공지사항 로딩 실패");
					}
				});
			}
			// ============================================================


			// [기존 유지] 목록에서 클릭해서 모달 열 때 (show.bs.modal 이벤트)
			$boardModal.on('show.bs.modal', function(event) {
				var button = $(event.relatedTarget);
				
				// ⭐ [수정] 알림으로 자동 실행될 때는 relatedTarget이 없으므로 중단
				if (!button || button.length === 0) return;

				var noticeNo = button.data('no');
				var title = button.data('title');
				var type = button.data('type'); 

				// 모달 헤더 색상 변경
				$boardModal.removeClass('global-notice dept-notice').addClass(type);
				
				$boardModal.find('.modal-title').text(title);
				$boardModal.find('#modalContentText').text('내용 로딩중...');
				$btnModify.hide(); 

				$.ajax({
					url : '/board/getContentNoticeBoard',
					type : 'POST',
					data : { noticeNo : noticeNo },
					dataType : 'json',
					success : function(response) {
						if (response && response.noticeContent) {
							$boardModal.find('#modalContentText').text(response.noticeContent);
							
							if ("${sessionScope.login.gradeNo}" <= 2 || "${sessionScope.login.empName}" == response.noticeWriter) {
								$btnModify.show();
								$('#currentNoticeNo').val(noticeNo);
								$btnModify.data('title', title);
								$btnModify.data('content', response.noticeContent);
								$btnModify.data('deptno', response.deptNo); 
							}
						}
					},
					error : function() {
						$boardModal.find('#modalContentText').text('오류 발생');
					}
				});
			});

			// [기존 유지] 수정 버튼 클릭 -> 수정 모달 OPEN
			$btnModify.on('click', function() {
				// 상세 모달 닫기 (jQuery 방식 대신 bootstrap 인스턴스 사용 권장)
				var boardModalEl = document.getElementById('boardModal');
				var modalInstance = bootstrap.Modal.getInstance(boardModalEl);
				if(modalInstance) modalInstance.hide();

				var noticeNo = $('#currentNoticeNo').val();
				var title = $(this).data('title');
				var content = $(this).data('content');
				var deptNo = $(this).data('deptno');

				$('#modifyNoticeNo').val(noticeNo);
				$('#modifyTitle').val(title);
				$('#modifyContent').val(content);
				$('#modifyDeptNo').val(deptNo);

				new bootstrap.Modal(document.getElementById('modifyModal')).show();
			});
		});
	</script>
</body>
</html>