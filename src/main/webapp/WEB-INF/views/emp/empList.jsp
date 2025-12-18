<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원관리</title>

<jsp:include page="../common/header.jsp" />

<!-- ✅ 안정화: jQuery는 DataTables보다 먼저 로드 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<link href="https://cdn.jsdelivr.net/npm/suit-font/dist/suit.min.css" rel="stylesheet">

<!-- ✅ 안정화: 컨텍스트 경로가 붙는 환경에서도 깨지지 않게 c:url 사용 -->
<link rel="stylesheet" href="<c:url value='/css/empList.css'/>">

<link rel="stylesheet" href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">
<script src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>

<script>
  // ✅ 안정화: URL은 서버 컨텍스트를 반영한 c:url로 고정
  const EMP_CARD_URL = "<c:url value='/emp/card' />";
</script>

<script>
$(document).ready(function () {

  /* =========================================================
     ✅ 안정화 0) empList가 null인 상황 방어용 (JSP에서 한 번 더 안전장치)
     - Controller에서 empList를 빈 리스트로 내려주는 게 베스트지만,
       JSP에서도 empty 체크로 "요약 계산"이 깨지지 않도록 방어합니다.
  ========================================================= */
  const hasList = ${empty empList ? "false" : "true"};

  /* =========================================================
     ✅ 안정화 1) DataTables 중복 초기화 방지
     - 같은 페이지에서 스크립트가 다시 실행되거나
       부분 로딩/리렌더링이 걸리면 DataTable 재초기화 오류가 날 수 있어요.
  ========================================================= */
  let table;

  if ($.fn.dataTable.isDataTable('#empTable')) {
    table = $('#empTable').DataTable();
  } else {
    table = $('#empTable').DataTable({
      pageLength   : 10,
      lengthChange : false,
      info         : false,
      searching    : true,
      ordering     : true,
      order        : [[0, 'asc']],           // 사번순 정렬
      dom          : 't<"dt-bottom"p>',      // 표 + 아래 페이지네이션만
      language     : {
        zeroRecords: "일치하는 사원이 없습니다.",
        paginate   : { next: "다음", previous: "이전" }
      }
    });
  }

  /* =========================================================
     ✅ 안정화 2) 페이지네이션 위치 이동
     - DataTables가 만든 하단 영역을 우리가 만든 컨테이너에 붙입니다.
     - 이미 붙어있다면 중복 append 방지
  ========================================================= */
  const pagination = $('#empTable_wrapper .dt-bottom');
  if ($('.emp-pagination-container .dt-bottom').length === 0) {
    $('.emp-pagination-container').append(pagination);
  }

  /* =========================================================
     ✅ 안정화 3) 검색창 연동 (submit 기반)
     - 빈 값이면 상세영역을 초기화하고 placeholder 노출
     - draw 이후 selected 표시도 정리
  ========================================================= */
  $('.emp-search-form').on('submit', function (e) {
    e.preventDefault();

    const keyword = $.trim($('input[name="keyword"]').val() || "");
    table.search(keyword).draw();

    // draw가 끝난 뒤 선택 효과 정리
    table.one('draw', function () {
      $('#empTable tbody tr.emp-row').removeClass('selected');
    });

    // 검색어가 비었으면 상세영역 초기화
    if (keyword === "") {
      $("#emp-detail-card").hide().empty();
      $("#emp-detail-placeholder").show();
    }
  });

  /* =========================================================
     ✅ 안정화 4) 행 클릭 → AJAX 로드
     - data-empno가 없는 행(빈 결과 행 등) 클릭 방지
     - 중복 클릭 시에도 안전하도록 처리
  ========================================================= */
  $('#empTable tbody').on('click', 'tr.emp-row', function () {

    const empNo = $(this).data("empno");
    if (!empNo) return; // ✅ 안전장치

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
     ✅ 안정화 5) URL 파라미터 처리
     - keyword 파라미터가 있으면 자동 검색
     - autoSelectEmpNo가 있으면 검색 후 "첫 번째 결과 emp-row" 자동 클릭
     - draw 완료 이후에 클릭해야 실패가 없습니다.
  ========================================================= */
  const urlParams = new URLSearchParams(window.location.search);
  const autoSelectEmpNo = urlParams.get('autoSelectEmpNo');
  const keywordParam    = urlParams.get('keyword');

  if (keywordParam) {
    $('input[name="keyword"]').val(keywordParam);
    table.search(keywordParam).draw();

    // 검색 후 결과가 없으면 상세영역 초기화
    table.one('draw', function () {
      const hasRow = $('#empTable tbody tr.emp-row').length > 0;
      if (!hasRow) {
        $("#emp-detail-card").hide().empty();
        $("#emp-detail-placeholder").show();
      }
    });
  }
  else if (autoSelectEmpNo) {

    // 검색 실행
    table.search(autoSelectEmpNo).draw();

    // ✅ draw 이후에 첫 번째 실제 emp-row를 찾아 클릭(안정화 핵심)
    table.one('draw', function () {
      const targetRow = $('#empTable tbody tr.emp-row').first();
      if (targetRow.length > 0) {
        targetRow.trigger('click');
      } else {
        $("#emp-detail-card").hide().empty();
        $("#emp-detail-placeholder").show();
      }
    });
  }

  /* =========================================================
     ✅ 안정화 6) 리사이즈 시 컬럼 폭 조정
     - wrapper가 좌/우 분할이라 창 크기 바뀌면 열 폭이 깨질 수 있어요.
  ========================================================= */
  $(window).on('resize', function() {
    // 이미 초기화 되어 있으므로 바로 adjust
    table.columns.adjust();
  });

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

            <!-- 1) 제목 -->
            <div class="page-header">
              <h1 class="page-title">사원 목록</h1>
            </div>
				 <div class="page-title-line"></div>
            <!-- =========================================================
                 ✅ 안정화: 요약 계산
                 - empList가 비어있을 수도 있으므로 empty 방어
                 - (컨트롤러에서 empList를 항상 내려주면 더 좋음)
            ========================================================= -->
            <c:set var="totalCount" value="${empty empList ? 0 : fn:length(empList)}" />
            <c:set var="activeCount"  value="0" />
            <c:set var="leaveCount"   value="0" />
            <c:set var="retiredCount" value="0" />

            <c:if test="${not empty empList}">
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
            </c:if>

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
                  <table id="empTable" class="emp-table" style="width:100%;">

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
                      <c:choose>

                       <%-- ✅ 목록이 비었을 때 --%>
                        <c:when test="${empty empList}">
                          <tr class="emp-empty-row">
                            <td colspan="5">조회된 사원 정보가 없습니다.</td>
                          </tr>
                        </c:when>

                       <%-- ✅ 정상 데이터 출력 --%>
                        <c:otherwise>
                          <c:forEach var="emp" items="${empList}">
                             <%-- 상태별 배지 클래스 --%>
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
                              <td>${emp.empNo}</td>
                              <td>${emp.deptName}</td>
                              <td>${emp.gradeName}</td>

                              <td>
                                <span class="status-badge ${statusClass}">
                                  ${emp.statusName}
                                </span>
                              </td>

                              <td>
                                <div class="emp-name-cell">
                                  <div class="emp-avatar">
                                    <c:choose>
                                      <%-- ✅ 사진 있으면 표시 --%>
                                      <c:when test="${not empty emp.empImage}">
                                        <img
                                          src="${pageContext.request.contextPath}/upload/emp/${emp.empImage}"
                                          alt="${emp.empName}"
                                          onerror="this.style.display='none'; this.parentNode.textContent='${fn:substring(emp.empName,0,1)}';">
                                      </c:when>
                                      <%-- ✅ 없으면 이름 첫 글자 --%>
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
                        </c:otherwise>

                      </c:choose>
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

                <div id="emp-detail-card" style="display:none;">
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
    </main>

    <!-- 푸터 -->
    <jsp:include page="../common/footer.jsp" />
  </div>

</div>
</body>
</html>
