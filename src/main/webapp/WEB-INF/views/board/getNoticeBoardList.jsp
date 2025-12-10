<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>getBoardList.jsp - 공지 게시판 목록</title>
<style>
/* -------------------- [공통 모달: 상세 보기(boardModal)] -------------------- */
#boardModal .modal-header {
	background-color: #92a8d1;
	color: white;
	border-bottom: 1px solid #A8C7F7;
	font-weight: bold;
}
/* ... (나머지 boardModal 스타일 생략) ... */

/* -------------------- [글쓰기/수정 모달 공통 스타일] -------------------- */
#writeModal .modal-header, #modifyModal .modal-header {
	background-color: #92a8d1;
	color: white;
	border-bottom: 1px solid #46b8da;
	font-weight: bold;
}

#writeModal .modal-body label, #modifyModal .modal-body label {
	font-weight: bold;
	margin-bottom: 5px;
}

/* 🚨 수정됨: 공지 내용 모달의 텍스트 왼쪽 정렬 (가운데 정렬 문제 해결) */
#boardModal .modal-body {
	white-space: pre-wrap;
	text-align: left;
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

					<h3 class="mt-4">공지 게시판</h3>
					<br>

					<div class="card mb-4">
						<div class="card-header table-Header">
							<i class="fas fa-table me-1"></i> 전체공지 게시판
						</div>

						<div class="card-body">
							<table id="datatablesSimple" class="display">
								<thead>
									<tr>
										<th>글번호</th>
										<th>글제목</th>
										<th>작성자</th>
										<th>작성시간</th>
										<th>조회수</th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th>글번호</th>
										<th>글제목</th>
										<th>작성자</th>
										<th>작성시간</th>
										<th>조회수</th>
									</tr>
								</tfoot>
								<tbody>
									<c:forEach var="vo" items="${ noticeBoardList }">
										<tr>
											<td>${ vo.noticeNo }</td>
											<td><a href="#" data-bs-toggle="modal"
												data-bs-target="#boardModal" data-no="${ vo.noticeNo }"
												data-title="<c:out value='${vo.noticeTitle}'/>"
												data-content="<c:out value='${vo.noticeContent}'/>"> ${ vo.noticeTitle }
											</a></td>
											<td><a href="#">${ vo.noticeWriter }</a></td>
											<td>${ vo.noticeDate }</td>
											<td>${ vo.noticeCnt }</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<c:if
								test="${not empty sessionScope.login && sessionScope.login.gradeNo >= 2}">
								<div style="text-align: left; margin-top: 10px;">
									<a href="#" class="btn btn-primary" data-bs-toggle="modal"
										data-bs-target="#writeModal">글쓰기</a>
								</div>
							</c:if>
						</div>
					</div>
				</div>

				<div class="modal fade" id="writeModal" tabindex="-1"
					aria-labelledby="writeModalLabel" aria-hidden="true">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="writeModalLabel">새 공지 작성</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal"
									aria-label="Close"></button>
							</div>

							<form action="/board/insertNoticeBoard" method="post">
								<div class="modal-body">
									<div class="mb-3">
										<label for="writer" class="form-label">작성자</label> <input
											type="text" class="form-control" id="writer"
											name="noticeWriter" value="${ sessionScope.login.empName }">
										<input type="hidden" name="empNo"
											value="${ sessionScope.login.empNo }">
									</div>
									<div class="mb-3">
										<label for="title" class="form-label">공지 제목</label> <input
											type="text" class="form-control" id="title"
											name="noticeTitle" required>
									</div>
									<div class="mb-3">
										<label for="content" class="form-label">공지 내용</label>
										<textarea class="form-control" id="content"
											name="noticeContent" rows="10" required></textarea>
									</div>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary"
										data-bs-dismiss="modal">취소</button>
									<button type="submit" class="btn btn-primary">작성</button>
								</div>
							</form>
						</div>
					</div>
				</div>

				<div class="modal fade" id="modifyModal" tabindex="-1"
					aria-labelledby="modifyModalLabel" aria-hidden="true">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="modifyModalLabel">공지 수정</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal"
									aria-label="Close"></button>
							</div>

							<form action="/board/insertNoticeBoard" method="post"
								id="modifyForm">
								<div class="modal-body">
									<input type="hidden" name="noticeNo" id="modifyNoticeNo">

									<div class="mb-3">
										<label for="modifyWriter" class="form-label">작성자</label> <input
											type="text" class="form-control" id="modifyWriter"
											name="noticeWriter" value="${ sessionScope.login.empName }">
										<input type="hidden" name="empNo"
											value="${ sessionScope.login.empNo }">
									</div>

									<div class="mb-3">
										<label for="modifyTitle" class="form-label">공지 제목</label> <input
											type="text" class="form-control" id="modifyTitle"
											name="noticeTitle" required>
									</div>

									<div class="mb-3">
										<label for="modifyContent" class="form-label">공지 내용</label>
										<textarea class="form-control" id="modifyContent"
											name="noticeContent" rows="10" required></textarea>
									</div>

								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary"
										data-bs-dismiss="modal">취소</button>
									<button type="submit" class="btn btn-primary">수정 완료</button>
								</div>
							</form>
						</div>
					</div>
				</div>

				<div class="modal fade" id="boardModal" tabindex="-1"
					aria-labelledby="boardModalLabel" aria-hidden="true">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="boardModalLabel">글 제목</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal"
									aria-label="Close"></button>
							</div>
							<div class="modal-body">
								<span id="modalContentText" style="display: block;"></span>
							</div>
							<div class="modal-footer">
								<c:if
									test="${not empty sessionScope.login && sessionScope.login.gradeNo >= 2}">
									<input type="hidden" id="currentNoticeNo">
									<button type="button" class="btn btn-primary me-2"
										id="btnModify">수정</button>
								</c:if>
								<button type="button" class="btn btn-secondary"
									data-bs-dismiss="modal">닫기</button>
							</div>
						</div>
					</div>
				</div>
			</main>

			<jsp:include page="../common/footer.jsp" flush="true" />
		</div>
	</div>

	<script>
		$(document).ready(
				function() {

					var $boardModal = $('#boardModal');
					var $btnModify = $('#btnModify');
					var $writeForm = $('#writeModal form');
					var $modifyForm = $('#modifyForm');

					// -------------------------------------------------------------
					// 등록 폼 제출 시 확인창 띄우기 (jQuery Submit Event)
					// -------------------------------------------------------------
					$writeForm.on('submit', function(event) {
						event.preventDefault(); // 폼의 기본 제출 동작을 막음

						if (confirm('새 공지를 작성하시겠습니까?')) {
							// '확인'을 눌렀을 경우, 폼을 실제로 제출
							this.submit();
						}
					});

					// -------------------------------------------------------------
					// 수정 폼 제출 시 확인창 띄우기 (jQuery Submit Event)
					// -------------------------------------------------------------
					$modifyForm.on('submit', function(event) {
						event.preventDefault(); // 폼의 기본 제출 동작을 막음

						if (confirm('공지 내용을 수정하시겠습니까?')) {
							// '확인'을 눌렀을 경우, 폼을 실제로 제출
							this.submit();
						}
					});

					// -------------------------------------------------------------
					// 1. 글 상세 보기 모달이 열릴 때 데이터 설정
					// -------------------------------------------------------------
					$boardModal.on('show.bs.modal', function(event) {
						var button = $(event.relatedTarget);

						// 글 목록에서 전달된 데이터 가져오기
						var noticeNo = button.data('no');
						var title = button.data('title');
						// var content = button.data('content'); // 기존: 내용 미리 가져오기 (삭제)

						// 상세 모달에 제목 표시
						$boardModal.find('.modal-title').text(title);
						$boardModal.find('#modalContentText').text(
								'내용을 불러오는 중...'); // 로딩 메시지

						// Controller로 AJAX 요청 (noticeNo를 이용해 내용 조회)
						$.ajax({
							url : '/board/getContentNoticeBoard',
							type : 'POST',
							data : {
								noticeNo : noticeNo
							},
							dataType : 'json', // Controller가 JSON을 반환한다고 가정
							success : function(response) {
								// Controller에서 받은 데이터 (response) 처리
								if (response && response.noticeContent) {
									var content = response.noticeContent;

									// 모달 내용 업데이트
									$boardModal.find('#modalContentText').text(
											content);

									// (관리자 권한이 있는 경우) 수정 버튼을 위해 글 번호와 내용들을 저장
									if ($btnModify.length) {
										$('#currentNoticeNo').val(noticeNo); // 글 번호 저장
										$btnModify.data('title', title);
										$btnModify.data('content', content); // AJAX로 가져온 내용 저장
									}
								} else {
									$boardModal.find('#modalContentText').text(
											'내용을 가져오지 못했습니다.');
								}
							},
							error : function(xhr, status, error) {
								console.error("AJAX Error:", status, error);
								$boardModal.find('#modalContentText').text(
										'데이터 로드 중 오류가 발생했습니다.');
							}
						});

					});

					// -------------------------------------------------------------
					// 수정 버튼을 클릭했을 때 수정 모달 띄우기 (jQuery Click Event)
					// -------------------------------------------------------------
					$btnModify.on('click', function() {
						var $this = $(this);

						// 1) 상세 모달 닫기
						var boardModalInstance = bootstrap.Modal
								.getInstance($boardModal[0]);
						boardModalInstance.hide();

						// 2) 수정 모달에 데이터 채우기
						var noticeNo = $('#currentNoticeNo').val();
						var title = $this.data('title');
						var content = $this.data('content');

						$('#modifyNoticeNo').val(noticeNo);
						$('#modifyTitle').val(title);
						$('#modifyContent').val(content);

						// 3) 수정 모달 띄우기
						var modifyModal = new bootstrap.Modal(
								$('#modifyModal')[0]);
						modifyModal.show();
					});
				});
	</script>
</body>

</html>