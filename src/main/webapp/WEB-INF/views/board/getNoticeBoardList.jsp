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

/* getBoardList.jsp 상단 <style> 태그 내부에 추가 */
#boardModal .modal-body {
	/* 기존 스타일 유지 */
	white-space: pre-wrap;
	/* 텍스트 왼쪽 정렬 강제 지정 */
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
								<div class="modal-body" style="white-space: pre-wrap; text-align: left;">
									<div class="mb-3">
										<label for="writer" class="form-label">작성자</label> <input
											type="text" class="form-control" id="writer"
											name="noticeWriter" value="${ sessionScope.login.empName }"
											readonly> <input type="hidden" name="empNo"
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
											name="noticeWriter" value="${ sessionScope.login.empName }"
											readonly> <input type="hidden" name="empNo"
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
							<div class="modal-body"
								style="white-space: pre-wrap; text-align: left;">
								<span id="modalContentText" style="display: block; text-align: left;"></span>
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
		document
				.addEventListener(
						'DOMContentLoaded',
						function() {
							var boardModal = document
									.getElementById('boardModal');
							var btnModify = document
									.getElementById('btnModify');

							// 등록/작성 폼 요소 가져오기
							var writeForm = document
									.querySelector('#writeModal form');
							// 수정 폼 요소 가져오기 (이미 id="modifyForm"이 부여되어 있음)
							var modifyForm = document
									.getElementById('modifyForm');

							// -------------------------------------------------------------
							// 3. 등록 폼 제출 시 확인창 띄우기
							// -------------------------------------------------------------
							writeForm.addEventListener('submit',
									function(event) {
										// 폼의 기본 제출 동작을 막음
										event.preventDefault();

										// 사용자에게 확인 메시지 표시
										if (confirm('새 공지를 작성하시겠습니까?')) {
											// '확인'을 눌렀을 경우, 폼을 실제로 제출
											this.submit();
										}
										// '취소'를 누르면 아무 동작도 하지 않고 폼 제출이 취소됨
									});

							// -------------------------------------------------------------
							// 4. 수정 폼 제출 시 확인창 띄우기
							// -------------------------------------------------------------
							modifyForm.addEventListener('submit', function(
									event) {
								// 폼의 기본 제출 동작을 막음
								event.preventDefault();

								// 사용자에게 확인 메시지 표시
								if (confirm('공지 내용을 수정하시겠습니까?')) {
									// '확인'을 눌렀을 경우, 폼을 실제로 제출
									this.submit();
								}
								// '취소'를 누르면 아무 동작도 하지 않고 폼 제출이 취소됨
							});

							// -------------------------------------------------------------
							// 기존 상세/수정 모달 로직 (1, 2번 로직)
							// -------------------------------------------------------------

							// 1. 글 상세 보기 모달이 열릴 때 데이터 설정
							boardModal
									.addEventListener(
											'show.bs.modal',
											function(event) {
												var button = event.relatedTarget;

												// 글 목록에서 전달된 데이터 가져오기
												var noticeNo = button
														.getAttribute('data-no');
												var title = button
														.getAttribute('data-title');
												var content = button
														.getAttribute('data-content');

												// 상세 모달에 데이터 표시
												boardModal
														.querySelector('.modal-title').textContent = title;
												boardModal
														.querySelector('#modalContentText').textContent = content;

												// (관리자 권한이 있는 경우) 수정 버튼을 위해 글 번호와 내용들을 저장
												if (btnModify) {
													document
															.getElementById('currentNoticeNo').value = noticeNo; // 글 번호 저장
													btnModify
															.setAttribute(
																	'data-title',
																	title);
													btnModify.setAttribute(
															'data-content',
															content);
												}
											});

							// 2. 수정 버튼을 클릭했을 때 수정 모달 띄우기
							if (btnModify) {
								btnModify
										.addEventListener(
												'click',
												function() {
													// 1) 상세 모달 닫기
													var boardModalInstance = bootstrap.Modal
															.getInstance(boardModal);
													boardModalInstance.hide();

													// 2) 수정 모달에 데이터 채우기
													var noticeNo = document
															.getElementById('currentNoticeNo').value;
													var title = btnModify
															.getAttribute('data-title');
													var content = btnModify
															.getAttribute('data-content');

													document
															.getElementById('modifyNoticeNo').value = noticeNo;
													document
															.getElementById('modifyTitle').value = title;
													document
															.getElementById('modifyContent').value = content;

													// 3) 수정 모달 띄우기
													var modifyModal = new bootstrap.Modal(
															document
																	.getElementById('modifyModal'));
													modifyModal.show();
												});
							}
						});
	</script>
</body>

</html>