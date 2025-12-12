<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원관리</title>

<jsp:include page="../common/header.jsp" />

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<link href="https://cdn.jsdelivr.net/npm/suit-font/dist/suit.min.css" rel="stylesheet">
<link rel="stylesheet" href="/css/empList.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">
<script src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>

<script>
    const EMP_CARD_URL = "<c:url value='/emp/card' />";
</script>

<script>
    $(document).ready(function () {

        /* 1) DataTables 기본 설정 */
        const table = $('#empTable').DataTable({
            pageLength   : 10,
            lengthChange : false,
            info         : false,
            searching    : true,
            ordering     : true,
            order        : [[0, 'asc']], // 사번순 정렬
            dom          : 't<"dt-bottom"p>',
            language     : { "zeroRecords": "일치하는 사원이 없습니다.", "paginate": { "next": "다음", "previous": "이전" } }
        });

        /* 2) 페이지네이션 위치 이동 */
        const pagination = $('#empTable_wrapper .dt-bottom');
        $('.emp-pagination-container').append(pagination);

        /* 3) 검색창 연동 */
        $('.emp-search-form').on('submit', function (e) {
            e.preventDefault();
            const keyword = $.trim($('input[name="keyword"]').val());
            table.search(keyword).draw();
            table.one('draw', function () {
                $('#empTable tbody tr.emp-row').removeClass('selected');
            });
            if (keyword === "") {
                $("#emp-detail-card").hide().empty();
                $("#emp-detail-placeholder").show();
            }
        });

        /* 4) 행 클릭 → AJAX 로드 */
        $('#empTable tbody').on('click', 'tr.emp-row', function () {
            let empNo = $(this).data("empno");
            $(".emp-row").removeClass("selected");
            $(this).addClass("selected");

            $.ajax({
                url  : EMP_CARD_URL,
                type : "get",
                data : { empNo: empNo },
                success: function (html) {
                    $("#emp-detail-placeholder").hide();
                    $("#emp-detail-card").show().html(html);
                },
                error: function () {
                    alert("인사카드를 불러오는 중 오류가 발생했습니다.");
                }
            });
        });

        /* =========================================================
           🔹 [추가] 조직도에서 넘어왔을 때 자동 선택 로직
           ========================================================= */
        const urlParams = new URLSearchParams(window.location.search);
        const autoSelectEmpNo = urlParams.get('autoSelectEmpNo');

        if (autoSelectEmpNo) {
            // 1. 해당 사번으로 테이블 검색 (필터링)
            table.search(autoSelectEmpNo).draw();

            // 2. 검색 결과가 그려진 후 첫 번째 행 자동 클릭
            // (DataTables는 draw가 동기적으로 처리되지만 DOM 반영 보장을 위해 약간의 딜레이나 콜백이 안전할 수 있음. 보통은 바로 실행됨)
            const targetRow = $('#empTable tbody tr.emp-row').first();
            
            if (targetRow.length > 0) {
                // 검색창에도 사번 표시 (선택사항)
                $('input[name="keyword"]').val(autoSelectEmpNo);
                
                // 클릭 트리거
                targetRow.trigger('click');
            }
        }
    });
</script>


</head>

<body>

<div id="layoutSidenav">

    <!-- 왼쪽 사이드바 -->
    <jsp:include page="../common/sidebar.jsp" />

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">

                <div class="content-wrapper">

                    <!-- 🔹 왼쪽 전체 영역 (제목 + 목록 + 요약) -->
                    <div class="emp-list-area">

                        <!-- 1) 제목 + 밑줄 -->
                        <div class="page-header">
                            <h1 class="page-title">사원 목록</h1>
                        </div>

                        <!-- 2) 데이터 요약 (전체/재직/휴직/퇴직 수) -->
                        <c:set var="totalCount"   value="${fn:length(empList)}" />
                        <c:set var="activeCount"  value="0" />
                        <c:set var="leaveCount"   value="0" />
                        <c:set var="retiredCount" value="0" />

                        <c:forEach var="e" items="${empList}">
                            <c:choose>
                                <%-- 재직 / 파견 --%>
                                <c:when test="${e.statusNo == 1 or e.statusNo == 7}">
                                    <c:set var="activeCount" value="${activeCount + 1}" />
                                </c:when>
                                <%-- 휴직(자발적, 복지) --%>
                                <c:when test="${e.statusNo == 2 or e.statusNo == 3}">
                                    <c:set var="leaveCount" value="${leaveCount + 1}" />
                                </c:when>
                                <%-- 퇴직 --%>
                                <c:when test="${e.statusNo == 0}">
                                    <c:set var="retiredCount" value="${retiredCount + 1}" />
                                </c:when>
                            </c:choose>
                        </c:forEach>

                        <div class="emp-summary-bar">
                            <span class="emp-summary-item">
                                전체 사원 <strong>${totalCount}</strong>명
                            </span>
                            <span class="emp-summary-item emp-summary-active">
                                재직 <strong>${activeCount}</strong>명
                            </span>
                            <span class="emp-summary-item emp-summary-leave">
                                휴직 <strong>${leaveCount}</strong>명
                            </span>
                            <span class="emp-summary-item emp-summary-retired">
                                퇴직 <strong>${retiredCount}</strong>명
                            </span>
                        </div>

                        <!-- ============================
                             전체 화면 좌/우 분할 구조
                             ============================ -->
                        <div class="emp-wrapper">

                            <!-- 🔹 왼쪽 : 사원 목록 카드 -->
                            <div class="emp-list-card">

                                <!-- 검색창 -->
                                <div class="search-area">
                                    <form class="emp-search-form">
                                        <input type="text" name="keyword"
                                               placeholder="이름 / 부서 / 직급 / 사번 검색">
                                        <button type="submit">SEARCH</button>
                                    </form>
                                </div>

									<!-- 사원 목록 테이블 -->
									<div class="emp-card">
										<table id="empTable" class="emp-table" style="width: 100%;">

											<colgroup>
												<col style="width: 15%;"><!-- 사원번호 -->
												<col style="width: 20%;"><!-- 부서명 -->
												<col style="width: 20%;"><!-- 직급 -->
												<col style="width: 25%;"><!-- 재직상태 -->
												<col style="width: 20%;"><!-- 이름 -->
											</colgroup>

											<thead>
												<tr>
													<th>사원번호</th>
													<th>부서명</th>
													<th>직급</th>
													<th>재직상태</th>
													<th>이름</th>
												</tr>
											</thead>

											<tbody>
												<c:forEach var="emp" items="${empList}">
													<%-- 상태별 배지 클래스 결정 --%>
													<c:set var="statusClass" value="status-etc" />
													<c:choose>
														<c:when test="${emp.statusNo == 1 or emp.statusNo == 7}">
															<c:set var="statusClass" value="status-active" />
														</c:when>
														<c:when test="${emp.statusNo == 0}">
															<c:set var="statusClass" value="status-retired" />
														</c:when>
														<c:when test="${emp.statusNo == 2 or emp.statusNo == 3}">
															<c:set var="statusClass" value="status-leave" />
														</c:when>
														<c:when test="${emp.statusNo == 6}">
															<c:set var="statusClass" value="status-intern" />
														</c:when>
													</c:choose>

													<tr class="emp-row" data-empno="${emp.empNo}">
														<!-- 1) 사원번호 -->
														<td>${emp.empNo}</td>

														<!-- 2) 부서명 -->
														<td>${emp.deptName}</td>

														<!-- 3) 직급 -->
														<td>${emp.gradeName}</td>

														<!-- 4) 재직상태 배지 -->
														<td><span class="status-badge ${statusClass}">
																${emp.statusName} </span></td>

														<!-- 5) 이름 + 아바타 -->
														<td>
															<div class="emp-name-cell">
																<div class="emp-avatar">
																	<c:choose>
																		<%-- 사진이 있으면 사진 사용 --%>
																		<c:when test="${not empty emp.empImage}">
																			<img
																				src="${pageContext.request.contextPath}/upload/emp/${emp.empImage}"
																				alt="${emp.empName}">
																		</c:when>
																		<%-- 없으면 이름 첫 글자 --%>
																		<c:otherwise>
																			<c:out value="${fn:substring(emp.empName, 0, 1)}" />
																		</c:otherwise>
																	</c:choose>
																</div>
																<span class="emp-name-text">${emp.empName}</span>
															</div>
														</td>
													</tr>
												</c:forEach>

												<c:if test="${empty empList}">
													<tr class="emp-empty-row">
														<td colspan="5">조회된 사원 정보가 없습니다.</td>
													</tr>
												</c:if>
											</tbody>
										</table>
									</div>

									<!-- DataTables 페이지네이션 삽입 공간 -->
                                <div class="emp-pagination-container"></div>

                            </div>
                            <!-- end emp-list-card -->

                            <!-- 🔹 오른쪽 : 인사카드 영역 -->
                            <div class="emp-detail-area">
                                <div id="emp-detail-placeholder">
                                    왼쪽 목록에서 사원을 선택하면<br>
                                    이 영역에 인사카드가 표시됩니다.
                                </div>

                                <div id="emp-detail-card" style="display: none;">
                                    <!-- AJAX로 empCard.jsp 내용이 여기 삽입됨 -->
                                </div>
                            </div>

                        </div>
                        <!-- end emp-wrapper -->

                    </div>
                    <!-- end emp-list-area -->

                </div>
                <!-- end content-wrapper -->
             

            </div>
				<script>
					$(window).on('resize', function() {
						$('#empTable').DataTable().columns.adjust();
					});
				</script>
			</main>

        <!-- 푸터 -->
        <jsp:include page="../common/footer.jsp" />
    </div>


</div>

</body>
</html>
