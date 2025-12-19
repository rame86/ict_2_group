<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 게시판</title>
<style>
/* -------------------- [모달 스타일 리뉴얼] -------------------- */
#boardModal .modal-content {
	border: none;
	border-radius: 15px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
}

#boardModal .modal-header {
	border-bottom: none;
	padding-bottom: 0;
}

#boardModal .modal-body {
	padding: 20px 30px;
}

/* 제목 영역 - 공지는 파란색 포인트 */
.view-title {
	font-size: 1.5rem;
	font-weight: bold;
	color: #333;
	margin-bottom: 15px;
	border-left: 5px solid #0d6efd; 
	padding-left: 15px;
}

/* 작성자 및 날짜 정보 박스 */
.view-info-box {
	background-color: #f8f9fa;
	border-radius: 10px;
	padding: 10px 15px;
	margin-bottom: 20px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	border: 1px solid #e9ecef;
}

.info-item {
	font-size: 0.9rem;
	color: #666;
	display: flex;
	align-items: center;
}

.info-item i {
	margin-right: 5px;
	color: #adb5bd;
}

/* [NEW] 작성자/댓글 프로필 이미지 스타일 */
.writer-profile-img {
	width: 30px;
	height: 30px;
	border-radius: 50%;
	object-fit: cover;
	margin-right: 8px;
	border: 1px solid #dee2e6;
}

.comment-profile-img {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	object-fit: cover;
	margin-right: 15px;
	border: 1px solid #dee2e6;
}

/* 본문 영역 */
.view-content-box {
	min-height: 200px;
	background-color: white;
	padding: 20px;
	border: 1px solid #dee2e6;
	border-radius: 10px;
	box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);
	white-space: pre-wrap;
	line-height: 1.6;
	color: #444;
	margin-bottom: 20px;
}

/* 댓글 영역 스타일 */
.comment-section {
	margin-top: 20px;
	border-top: 1px solid #eee;
	padding-top: 20px;
}

.comment-card {
	background-color: #fcfcfc;
	border: 1px solid #f1f1f1;
	border-radius: 8px;
	padding: 10px;
	margin-bottom: 10px;
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

					<h1 class="mt-4">공지 게시판</h1>

					<%-- 글쓰기 버튼: 권한이 있는 사용자(3등급 이내)만 노출 --%>
					<c:if test="${canWriteNotice}">
						<div class="d-flex justify-content-end mb-3">
							<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#writeModal">
								<i class="fas fa-pen me-1"></i> 새 공지 작성
							</button>
						</div>
					</c:if>

					<%-- 전체 공지사항 카드 --%>
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
												       data-writer="<c:out value='${vo.noticeWriter}'/>" 
												       data-date="${ vo.noticeDate }" 
												       data-type="global-notice"> 
												       ${ vo.noticeTitle } 
												    </a>
												
												    <%-- 댓글 갯수 표시 --%>
												    <c:if test="${vo.replyCnt > 0}">
												    	<span class="text-danger fw-bold ms-1" style="font-size: 0.9rem;">
												    		[${vo.replyCnt}]
												    	</span>
												    </c:if>
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

					<%-- 부서 공지사항 카드 --%>
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
													   data-writer="<c:out value='${vo.noticeWriter}'/>" 
													   data-date="${ vo.noticeDate }" 
													   data-type="dept-notice"> 
													   ${ vo.noticeTitle } 
													</a>
													
													<%-- 댓글 갯수 표시 --%>
												    <c:if test="${vo.replyCnt > 0}">
												    	<span class="text-danger fw-bold ms-1" style="font-size: 0.9rem;">
												    		[${vo.replyCnt}]
												    	</span>
												    </c:if>
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

				<%-- 글쓰기 모달 --%>
				<div class="modal fade" id="writeModal" tabindex="-1" aria-hidden="true">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header bg-dark text-white">
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
									
									<%-- 게시 대상 선택: 1,2등급(canWriteGlobal)일 때만 전체 공지 옵션 표시 --%>
									<div class="mb-3">
										<label class="form-label fw-bold">게시 대상 선택</label> 
										<select class="form-select" name="deptNo">
											<c:choose>
												<c:when test="${canWriteGlobal}">
													<option value="0" class="text-danger fw-bold">📢 전체 공지 (전 직원)</option>
													<option value="${sessionScope.login.deptNo}" selected>🏢 부서 공지 (${sessionScope.login.deptName})</option>
												</c:when>
												<c:otherwise>
													<%-- 3등급은 부서 공지 고정 --%>
													<option value="${sessionScope.login.deptNo}" selected>🏢 부서 공지 (${sessionScope.login.deptName})</option>
												</c:otherwise>
											</c:choose>
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

				<%-- 수정 모달 --%>
				<div class="modal fade" id="modifyModal" tabindex="-1" aria-hidden="true">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header bg-warning text-white">
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

				<%-- 상세보기 모달 (댓글 + 삭제 기능 포함) --%>
				<div class="modal fade" id="boardModal" tabindex="-1" aria-hidden="true">
					<div class="modal-dialog modal-lg modal-dialog-scrollable">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<div class="modal-body">

								<div class="view-title" id="modalTitleText">공지사항 제목</div>

								<div class="view-info-box">
									<span class="info-item"> 
										<img id="modalWriterImg" src="" class="writer-profile-img" alt="작성자">
										<span id="modalWriterText">작성자</span>
									</span> 
									<span class="info-item"> 
										<i class="far fa-clock"></i> <span id="modalDateText">2024-00-00</span>
									</span>
								</div>

								<div id="modalContentText" class="view-content-box">내용 로딩중...</div>

								<div class="d-flex justify-content-between align-items-center mt-4">
									<%-- 댓글 토글 버튼 --%>
									<button class="btn btn-outline-secondary" type="button" id="btnToggleComment" data-bs-toggle="collapse" data-bs-target="#collapseComments" aria-expanded="false" aria-controls="collapseComments">
										<i class="far fa-comment-dots me-1"></i> 댓글
									</button>

									<div>
										<input type="hidden" id="currentNoticeNo">
										
										<%-- 삭제 버튼과 폼 (JS로 제어) --%>
										<form action="/board/deleteNoticeBoard" method="post" id="deleteForm" style="display:inline;">
                                            <input type="hidden" name="noticeNo" id="deleteNoticeNo">
                                            <button type="button" class="btn btn-danger text-white" id="btnDelete" style="display: none;">
                                                <i class="fas fa-trash-alt me-1"></i> 삭제
                                            </button>
                                        </form>

										<button type="button" class="btn btn-warning text-white" id="btnModify" style="display: none;">
											<i class="fas fa-edit me-1"></i> 수정
										</button>
										<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
									</div>
								</div>

								<div class="collapse comment-section" id="collapseComments">
									<div class="d-flex mb-3">
										<div class="flex-shrink-0 me-2">
											<img id="myCommentProfileImg" src="${pageContext.request.contextPath}/images/default_profile.png" class="comment-profile-img" alt="나">
										</div>
										<div class="flex-grow-1">
											<input type="text" id="replyInput" class="form-control" placeholder="댓글을 입력하세요...">
										</div>
										<button type="button" id="btnReplySubmit" class="btn btn-primary ms-2">등록</button>
									</div>

									<div class="comment-list-container">
										</div>
								</div>

							</div>
						</div>
					</div>
				</div>

			</main>
			<jsp:include page="../common/footer.jsp" flush="true" />
		</div>
	</div>

	<script>
		// 전역 변수
		var LOGIN_EMP_NO = "${sessionScope.login.empNo}";
		var DEFAULT_IMG = "${pageContext.request.contextPath}/images/default_profile.png"; 
		
		// DataTables 초기화
		window.addEventListener('DOMContentLoaded', event => {
			const datatablesGlobal = document.getElementById('datatablesGlobal');
			if (datatablesGlobal) new simpleDatatables.DataTable(datatablesGlobal);
			
			const datatablesDept = document.getElementById('datatablesDept');
			if (datatablesDept) new simpleDatatables.DataTable(datatablesDept);
		});

		$(document).ready(function() {
			var $boardModal = $('#boardModal');
			var $btnModify = $('#btnModify');
			var $btnDelete = $('#btnDelete'); // 삭제 버튼
			var $modifyForm = $('#modifyForm');

			// 1. 내 프로필 사진 로드 (댓글 입력창 옆)
			if(LOGIN_EMP_NO) {
				$.ajax({
					url: '${pageContext.request.contextPath}/emp/myInfo', 
					type: 'GET',
					success: function(htmlData) {
						var $temp = $('<div>').html(htmlData);
						var imgSrc = $temp.find('.emp-photo-placeholder img').attr('src');
						if(imgSrc) {
							$('#myCommentProfileImg').attr('src', imgSrc);
						}
					}
				});
			}

			// [자동 실행 로직] 알림 타고 들어왔을 때
			var targetNoticeNo = "${targetNoticeNo}"; 

			if (targetNoticeNo && targetNoticeNo !== "") {
				setTimeout(function() {
					loadNoticeDetailDirectly(targetNoticeNo);
				}, 300);
			}

			function loadNoticeDetailDirectly(noticeNo) {
				$.ajax({
					url : '/board/getContentNoticeBoard',
					type : 'POST',
					data : { noticeNo : noticeNo },
					dataType : 'json',
					success : function(response) {
						if (response && response.noticeContent) {
							// 모달 텍스트 세팅
							$boardModal.find('#modalTitleText').text(response.noticeTitle);
							$boardModal.find('#modalWriterText').text(response.noticeWriter);
							$boardModal.find('#modalDateText').text(response.noticeDate || '-'); 
							$boardModal.find('#modalContentText').text(response.noticeContent);
							
							// [NEW] 작성자 이미지 세팅
							var writerImg = response.empImage; 
							if(writerImg) {
								$boardModal.find('#modalWriterImg').attr('src', '${pageContext.request.contextPath}/upload/emp/' + writerImg);
							} else {
								$boardModal.find('#modalWriterImg').attr('src', DEFAULT_IMG);
							}
							
							// 댓글창 초기화 및 번호 세팅
							$('#collapseComments').collapse('hide');
							$('#currentNoticeNo').val(noticeNo);
							$('#btnToggleComment').html('<i class="far fa-comment-dots me-1"></i> 댓글');
							
							// 수정/삭제 권한 체크
							$btnModify.hide();
							$btnDelete.hide();

							var loginGrade = "${sessionScope.login.gradeNo}";
							var loginName = "${sessionScope.login.empName}";
							
							// 관리자(등급<=2) 이거나 작성자 본인이면 수정/삭제 가능 -> 로직 단순화: 3등급(관리자) 이하거나 본인이면
							if (loginGrade <= 3 || loginName == response.noticeWriter) {
								$btnModify.show();
								$btnModify.data('title', response.noticeTitle);
								$btnModify.data('content', response.noticeContent);
								$btnModify.data('deptno', response.deptNo);
								
								$btnDelete.show(); // 삭제 버튼 보이기
							}
							
							new bootstrap.Modal(document.getElementById('boardModal')).show();
							// 모달 뜨면서 댓글 로드
							loadReplies(noticeNo);
						} else {
							alert("삭제되었거나 존재하지 않는 게시글입니다.");
						}
					},
					error : function() {
						console.log("공지사항 로딩 실패");
					}
				});
			}

			// [일반 실행 로직] 목록에서 클릭 시
			$boardModal.on('show.bs.modal', function(event) {
				var button = $(event.relatedTarget);
				if (!button || button.length === 0) return;

				var noticeNo = button.data('no');
				var title = button.data('title');
				var writer = button.data('writer'); 
				var date = button.data('date');

				// UI 기본 세팅
				$boardModal.find('#modalTitleText').text(title);
				$boardModal.find('#modalWriterText').text(writer);
				$boardModal.find('#modalDateText').text(date);
				$boardModal.find('#modalContentText').text('내용 로딩중...');
				
				// 이미지 초기화
				$boardModal.find('#modalWriterImg').attr('src', DEFAULT_IMG);
				
				$('#collapseComments').collapse('hide');
				$('#currentNoticeNo').val(noticeNo);
				$('#btnToggleComment').html('<i class="far fa-comment-dots me-1"></i> 댓글');

				$btnModify.hide(); 
				$btnDelete.hide(); // 초기화

				$.ajax({
					url : '/board/getContentNoticeBoard',
					type : 'POST',
					data : { noticeNo : noticeNo },
					dataType : 'json',
					success : function(response) {
						if (response && response.noticeContent) {
							$boardModal.find('#modalContentText').text(response.noticeContent);
							// [NEW] 작성자 이미지 교체
							var writerImg = response.empImage; 
							if(writerImg) {
								$boardModal.find('#modalWriterImg').attr('src', '${pageContext.request.contextPath}/upload/emp/' + writerImg);
							}
							
							// 권한 체크: 3등급 이하(관리자급) 이거나 작성자 본인이면 수정/삭제 버튼 노출
							if ("${sessionScope.login.gradeNo}" <= 3 ||
								"${sessionScope.login.empName}" == response.noticeWriter) {
								
								$btnModify.show();
								$btnModify.data('title', title);
								$btnModify.data('content', response.noticeContent);
								$btnModify.data('deptno', response.deptNo); 
								
								$btnDelete.show(); // 삭제 버튼 보이기
							}
						}
					},
					error : function() {
						$boardModal.find('#modalContentText').text('오류 발생');
					}
				});
			});

			// 모달이 완전히 열렸을 때 댓글 목록 자동 로드
			$boardModal.on('shown.bs.modal', function() {
				var noticeNo = $('#currentNoticeNo').val();
				if(noticeNo) {
					loadReplies(noticeNo);
				}
			});

			// 수정 버튼 클릭 -> 수정 모달 OPEN
			$btnModify.on('click', function() {
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

			// 삭제 버튼 클릭 이벤트
            $btnDelete.on('click', function() {
                if(confirm("정말 이 공지사항을 삭제하시겠습니까?\n포함된 댓글도 모두 삭제됩니다.")) {
                    var noticeNo = $('#currentNoticeNo').val();
                    $('#deleteNoticeNo').val(noticeNo);
                
                    $('#deleteForm').submit();
                }
            });
		});
		
		// -----------------------------------------------------------
		// 댓글 관련 함수들
		// -----------------------------------------------------------

		// 댓글 목록 로드 함수
	    function loadReplies(no) {
	        $.ajax({
	            url: '/replies/list',
	            type: 'GET',
	            data: { noticeNo: no },
	            dataType: 'json', 
	            success: function(list) {
		      
		        	let totalCount = list ? list.length : 0;
		        	$('#btnToggleComment').html('<i class="far fa-comment-dots me-1"></i> 댓글 (' + totalCount + ')');
		        	
	                let html = '';
	                if(list.length === 0){
	                    html = '<p class="text-center text-muted my-3">작성된 댓글이 없습니다.</p>';
	  
	                } else {
	                    list.forEach(reply => {
	                        let date = new Date(reply.replyCreatedAt);
	                        let dateStr = date.toISOString().split('T')[0] + " " + date.toTimeString().split(' ')[0].substring(0,5);
			            	let writerName = reply.replyWriterName ? reply.replyWriterName : reply.replyWriterEmpNo;
			            	let writerJob = reply.replyWriterJob ? reply.replyWriterJob : '';
			            	let writerDisplay = writerName + (writerJob ? ' (' + writerJob + ')' : '');
			            	
			            	// [NEW] 댓글 작성자 이미지
			            	let replyImgSrc = DEFAULT_IMG;
			            	if(reply.replyWriterImage) {
                                replyImgSrc = '${pageContext.request.contextPath}/upload/emp/' + reply.replyWriterImage;
							}
			            	
	                        html += '<div class="comment-card" id="reply-' + reply.replyNo + '">';
                            // [NEW] 댓글 레이아웃 (flex)
                            html += '  <div class="d-flex">';
                            // 1. 프로필 이미지
                            html += '    <div class="flex-shrink-0">';
                            html += '      <img src="' + replyImgSrc + '" class="comment-profile-img" alt="프로필">';
                            html += '    </div>';
                            
                            // 2. 내용
                            html += '    <div class="flex-grow-1">';
                            html += '      <div class="d-flex justify-content-between align-items-center">';
                            html += '        <strong class="text-dark">' + writerDisplay + '</strong>';
                            html += '        <small class="text-muted">' + dateStr + '</small>';
                            html += '      </div>';
	                        html += '      <p class="mb-0 mt-1 text-secondary small">' + reply.replyContent + '</p>';
	                        // 로그인 사번과 일치하면 삭제 버튼 표시
	                        if (LOGIN_EMP_NO == reply.replyWriterEmpNo) {
	                            html += '  <div class="mt-1 text-end">';
	                            html += '    <button class="btn btn-sm btn-link text-danger p-0" onclick="deleteReply(' + reply.replyNo + ')">삭제</button>';
	                            html += '  </div>';
	                        }
	                        html += '    </div>';
                            // end flex-grow-1
                            html += '  </div>';
                            // end d-flex
	                        html += '</div>';
	                        // end comment-card
	                    });
					}
	                $('.comment-list-container').html(html);
				},
	            error: function(err){
	                console.log("댓글 로드 실패", err);
				}
	        });
	    }

	    // 댓글 등록 버튼 클릭
	    $('#btnReplySubmit').on('click', function() {
	        let content = $('#replyInput').val();
	        let noticeNo = $('#currentNoticeNo').val();

	        if(!content.trim()) {
	            alert("댓글 내용을 입력하세요.");
	            return;
	        }

	        let sendData = {
	            replyContent: content,
	            noticeNo: noticeNo 
	        };

	        $.ajax({
	            url: '/replies/insert',
	            type: 'POST',
	            contentType: 'application/json',
	            data: JSON.stringify(sendData),
	      
	            success: function(res) {
	                if(res === "success") {
	                    $('#replyInput').val(''); // 입력창 초기화
	                    loadReplies(noticeNo);    // 목록 갱신
	                } else {
	      
	                    alert("댓글 등록에 실패했습니다.");
	                }
	            },
	            error: function(err) {
	                console.log("에러 발생", err);
	            }
	        });
	    
		});

	    // 댓글 삭제 함수
	    window.deleteReply = function(replyNo) {
	        if(!confirm("정말 삭제하시겠습니까?")) return;
			$.ajax({
	            url: '/replies/delete',
	            type: 'POST',
	            data: { replyNo: replyNo },
	            success: function(res) {
	                if(res === "success") {
	                    let noticeNo = $('#currentNoticeNo').val();
	  
	                   loadReplies(noticeNo);
	                } else {
	                    alert("삭제 실패");
	                }
	            }
	        });
		};
	</script>
</body>
</html>