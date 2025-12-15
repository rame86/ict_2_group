<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>부서 조직도</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/dept.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>

<body class="sb-nav-fixed">

	<jsp:include page="../common/header.jsp" flush="true" />

	<div id="layoutSidenav">
		<jsp:include page="../common/sidebar.jsp" flush="true" />

		<div id="layoutSidenav_content">
			<main>
				<div class="container-fluid px-4">
					<h1 class="mt-4">조직도</h1>
					<ol class="breadcrumb mb-4">
						<li class="breadcrumb-item active">Organization Chart</li>
					</ol>

					<div class="card mb-4">
						<div class="card-body">
							<div class="org-tree">
								<ul>
									<c:forEach var="ceo" items="${deptList}">
										<c:if test="${ceo.deptNo == 1001}">
											<li>
												<div
													class="org-node ceo ${sessionScope.login.deptNo == ceo.deptNo ? 'my-dept' : ''}"
													onclick="showDeptModal('${ceo.deptNo}', '${ceo.deptName}', '${ceo.managerName}')">
													<div class="profile-pic">
														<img
															src="${pageContext.request.contextPath}${not empty ceo.managerImage ? '/upload/emp/' : '/images/'}${not empty ceo.managerImage ? ceo.managerImage : 'default_profile.png'}"
															alt="CEO">
													</div>
													<span class="dept-name">${ceo.deptName}</span> <span
														class="manager-name">${ceo.managerName}</span> <span
														class="position">CEO</span>
												</div>

												<ul>
													<c:forEach var="sub" items="${deptList}">
														<c:if
															test="${sub.parentDeptNo == 1001 && sub.deptNo != 1001}">
															<li>
																<div
																	class="org-node head ${sessionScope.login.deptNo == sub.deptNo ? 'my-dept' : ''}"
																	onclick="showDeptModal('${sub.deptNo}', '${sub.deptName}', '${sub.managerName}')">
																	<div class="profile-pic">
																		<img
																			src="${pageContext.request.contextPath}${not empty sub.managerImage ? '/upload/emp/' : '/images/'}${not empty sub.managerImage ? sub.managerImage : 'default_profile.png'}"
																			alt="Manager">
																	</div>
																	<span class="dept-name">${sub.deptName}</span> <span
																		class="manager-name">${sub.managerName}</span> <span
																		class="position">${sub.deptName}장</span>
																</div>

																<ul class="team-grid">
																	<c:forEach var="team" items="${deptList}">
																		<c:if test="${team.parentDeptNo == sub.deptNo}">
																			<li>
																				<div
																					class="org-node team ${sessionScope.login.deptNo == team.deptNo ? 'my-dept' : ''}"
																					onclick="showDeptModal('${team.deptNo}', '${team.deptName}', '${team.managerName}')">
																					<span class="dept-name">${team.deptName}</span> <span
																						class="manager-name">${team.managerName}</span>
																				</div>
																			</li>
																		</c:if>
																	</c:forEach>
																</ul>
															</li>
														</c:if>
													</c:forEach>
												</ul>

											</li>
										</c:if>
									</c:forEach>
								</ul>
							</div>

						</div>
					</div>
				</div>
			</main>
			<jsp:include page="../common/footer.jsp" flush="true" />
		</div>
	</div>

	<div id="deptInfoModal" class="modal-custom">
		<div class="modal-content-custom">
			<div class="modal-header-custom" style="background-color: #4e73df;">
				<h5 style="margin: 0;" id="modalDeptName">부서명</h5>
				<span id="closeModalBtn" class="close-btn">&times;</span>
			</div>
			<div class="modal-body-custom">
				<ul id="employeeList">
					<li style="text-align: center; padding: 20px;">로딩 중...</li>
				</ul>
			</div>

			<c:choose>
				<c:when test="${isAdmin}">
					<button class="btn-manage-custom"
						onclick="goToEmployeeMgmtByDept()">
						<i class="fas fa-users-cog"></i> 부서원 관리 / 상세 보기
					</button>
				</c:when>
				<c:otherwise>
					<button class="btn-manage-custom" disabled
						style="background-color: #ccc; cursor: not-allowed; border-color: #bbb; color: #666;">
						<i class="fas fa-lock"></i> 관리 권한 없음
					</button>
				</c:otherwise>
			</c:choose>

		</div>
	</div>

	<c:if test="${isAdmin}">
		<div class="admin-action-area">
			<button class="btn-float btn-create" onclick="openCreateModal()">
				<i class="fas fa-plus"></i> 부서 생성
			</button>
			<button class="btn-float btn-delete" onclick="openDeleteModal()">
				<i class="fas fa-trash"></i> 부서 삭제
			</button>
		</div>
	</c:if>

	<div id="deptCreateModal" class="modal-custom">
		<div class="modal-content-custom">
			<div class="modal-header-custom modal-header-create">
				<h5>새 부서 생성</h5>
				<span onclick="closeCreateModal()" class="close-btn">&times;</span>
			</div>
			<div class="modal-body-custom">
				<form id="createDeptForm">
					<div class="form-group">
						<label for="deptNoInput">부서 번호 (숫자)</label> <input type="number"
							id="deptNoInput" name="deptNo" placeholder="예: 5000" required>
					</div>
					<div class="form-group">
						<label for="deptNameInput">부서 이름</label> <input type="text"
							id="deptNameInput" name="deptName" placeholder="예: 신규사업팀"
							required>
					</div>
					<div class="form-group">
						<label for="parentDeptNoInput">상위 부서 번호</label> <input
							type="number" id="parentDeptNoInput" name="parentDeptNo"
							placeholder="예: 1001 (CEO직속)">
					</div>
					<div class="form-group">
						<label for="managerEmpNoInput">부서장 사번</label> <input type="text"
							id="managerEmpNoInput" name="managerEmpNo" placeholder="(선택)">
					</div>
					<button type="button" class="btn-manage-custom btn-create-submit"
						onclick="submitCreateDept()">
						<i class="fas fa-check"></i> 생성하기
					</button>
				</form>
			</div>
		</div>
	</div>

	<div id="deptDeleteModal" class="modal-custom">
		<div class="modal-content-custom">
			<div class="modal-header-custom modal-header-delete">
				<h5>부서 삭제</h5>
				<span onclick="closeDeleteModal()" class="close-btn">&times;</span>
			</div>
			<div class="modal-body-custom">
				<div class="warning-text">
					<i class="fas fa-exclamation-triangle"></i> <span>주의: 삭제 시
						해당 부서원들은 모두 '무소속' 처리됩니다. 이 작업은 되돌릴 수 없습니다.</span>
				</div>
				<div class="form-group">
					<label for="deleteDeptSelect">삭제할 부서 선택</label> <select
						id="deleteDeptSelect" name="deptNo">
						<option value="">부서를 선택하세요</option>
						<c:forEach var="d" items="${deptList}">
							<c:if test="${d.deptNo != 1001}">
								<option value="${d.deptNo}">${d.deptName}(${d.deptNo})</option>
							</c:if>
						</c:forEach>
					</select>
				</div>
				<button type="button" class="btn-manage-custom btn-delete-submit"
					onclick="submitDeleteDept()">
					<i class="fas fa-trash"></i> 삭제하기
				</button>
			</div>
		</div>
	</div>

	<div id="deptMoveModal" class="modal-custom">
		<div class="modal-content-custom" style="max-width: 350px;">
			<div class="modal-header-custom" style="background: #36b9cc;">
				<h5 style="margin: 0;">부서 이동</h5>
				<span onclick="closeMoveModal()" class="close-btn">&times;</span>
			</div>
			<div class="modal-body-custom">
				<p id="moveTargetName"
					style="font-weight: bold; margin-bottom: 10px;"></p>
				<input type="hidden" id="moveTargetEmpNo">

				<div class="form-group">
					<label>이동할 부서 선택</label> <select id="moveDeptSelect">
						<c:forEach var="d" items="${deptList}">
							<option value="${d.deptNo}">${d.deptName}(${d.deptNo})</option>
						</c:forEach>
					</select>
				</div>
				<button type="button" class="btn-manage-custom"
					style="background: #36b9cc;" onclick="submitMoveEmp()">이동
					확인</button>
			</div>
		</div>
	</div>

	<div id="deptAppointModal" class="modal-custom">
		<div class="modal-content-custom" style="max-width: 350px;">
			<div class="modal-header-custom" style="background: #4e73df;">
				<h5 style="margin: 0;">부서장 임명 결재</h5>
				<span onclick="closeAppointModal()" class="close-btn">&times;</span>
			</div>
			<div class="modal-body-custom">
				<p style="margin-bottom: 15px; font-size: 14px; color: #555;">
					현재 부서장이 공석입니다.<br> 부서원으로 임명할 사원을 선택해주세요.
				</p>

				<div class="form-group">
					<label>임명할 사원 선택</label> <select id="appointEmpSelect">
						<option value="">사원을 선택하세요</option>
					</select>
				</div>
				<button type="button" class="btn-manage-custom"
					style="background: #4e73df;" onclick="submitAppointManager()">
					<i class="fas fa-file-signature"></i> 결재 기안 작성
				</button>
			</div>
		</div>
	</div>

	<div id="approvalDraftModal" class="modal-custom">
		<div class="modal-content-custom" style="max-width: 600px;">
			<div class="modal-header-custom" style="background: #4e73df;">
				<h5 style="margin: 0;">
					<i class="fas fa-file-alt"></i> 기안서 작성
				</h5>
				<span onclick="closeDraftModal()" class="close-btn">&times;</span>
			</div>
			<div class="modal-body-custom">
				<form id="finalApprovalForm">
					<input type="hidden" name="empNo"
						value="${sessionScope.login.empNo}"> <input type="hidden"
						name="deptNo" id="draftDeptNo"> <input type="hidden"
						name="DocType" value="6"> <input type="hidden"
						name="step1ManagerNo" value="${sessionScope.login.managerEmpNo}">
					<input type="hidden" name="step2ManagerNo"
						value="${sessionScope.login.parentDeptNo}"> <input
						type="hidden" name="targetEmpNo" id="draftTargetEmpNo"> <input
						type="hidden" name="targetDeptNo" id="draftTargetDeptNo"> <input
						type="hidden" name="memo" id="draftMemo"> <input
						type="hidden" name="docDate" id="draftDocDate">

					<div class="form-group">
						<label>제목</label> <input type="text" id="draftTitle"
							name="DocTitle" class="form-control"
							style="width: 100%; padding: 8px; margin-bottom: 10px;" readonly>
					</div>

					<div class="form-group">
						<label>내용</label>
						<textarea id="draftContent" name="docContent" rows="10"
							style="width: 100%; padding: 8px; resize: none;"></textarea>
					</div>

					<div style="text-align: right; margin-top: 15px;">
						<button type="button" class="btn-manage-custom"
							style="background: #6c757d; border: none;"
							onclick="closeDraftModal()">취소</button>
						<button type="button" class="btn-manage-custom"
							style="background: #4e73df;" onclick="submitFinalApproval()">
							<i class="fas fa-paper-plane"></i> 기안 상신
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>

<script>
    // JSP(서버) 데이터 -> JS 변수 변환
    const contextPath = '${pageContext.request.contextPath}';
    
    /* [중요] EL 표현식은 반드시 한 줄에 공백 없이 작성해야 합니다. */
    const isAdminUser = ${isAdmin != null ? isAdmin : false};
    
    console.log("현재 접속자 관리자 권한 여부:", isAdminUser); // 콘솔에서 확인 가능하도록 로그 추가
</script>
<script src="${pageContext.request.contextPath}/js/dept.js"></script>
</body>
</html>