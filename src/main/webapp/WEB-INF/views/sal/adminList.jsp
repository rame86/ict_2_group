<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>급여 관리 (관리자)</title>

    <%-- 공통 header (부트스트랩 / jQuery 포함) --%>
    <jsp:include page="../common/header.jsp" />

    <%-- 급여 관리자/상세 공통 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/salDetail.css">

    <%-- DataTables CSS --%>
    <link rel="stylesheet"
          href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

    <%-- jQuery (header.jsp에 이미 있으면 생략 가능) --%>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>

<div id="layoutSidenav">

    <%-- 사이드바 --%>
    <jsp:include page="../common/sidebar.jsp" />

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">

                <h3 class="mt-4">급여 관리 관리자모드</h3>
                <br>
                <h4>급여 명세 목록</h4>
				
                <%-- 🔹 상단: 월별 필터 + (DataTables 검색창 자리) --%>
                <div class="sal-top-bar">
                    <%-- 왼쪽: 지급월 필터 --%>
                    <form id="monthFilterForm"
                          method="get"
                          action="${pageContext.request.contextPath}/sal/admin/list">
                        <input type="month" name="month"
                               value="${searchMonth}">
                        <button type="submit" class="btn btn-primary btn-sm">
                            검색
                        </button>
                    </form>

                    <%-- 오른쪽: Search... 위치 (DataTables filter가 JS에서 이동됨) --%>
                    <div class="sal-top-right">
                        <%-- JS에서 .dataTables_filter 를 이 안으로 append --%>
                    </div>
                </div>

                <%-- 🔹 데이터 유무에 따라 분기 --%>
                <c:choose>

                    <%-- ✅ 데이터가 있을 때: 테이블 출력 --%>
                    <c:when test="${not empty salList}">
                        <table id="salTable" class="sal-table display">
                            <thead>
                            <tr>
                                <th>지급월</th>
                                <th>사번</th>
                                <th>이름</th>
                                <th>부서</th>
                                <th>기본급</th>
                                <th>상여</th>
                                <th>기타수당</th>
                                <th>공제합계</th>
                                <th>실지급액</th>
                                <th>자세히</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:forEach var="s" items="${salList}">
                                <tr>
                                    <td>${s.yearMonthLabel}</td>
                                    <td>${s.empNo}</td>
                                    <td>${s.empName}</td>
                                    <td>${s.deptName}</td>
                                    <td>
                                        <fmt:formatNumber value="${s.salBase}" type="number" pattern="#,##0"/>원
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${s.salBonus}" type="number" pattern="#,##0"/>원
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${s.salPlus}" type="number" pattern="#,##0"/>원
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${s.deductTotal}" type="number" pattern="#,##0"/>원
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${s.realPay}" type="number" pattern="#,##0"/>원
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/sal/admin/detail?empNo=${s.empNo}&monthAttno=${s.monthAttno}">
                                            보기
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>

                    <%-- ❗ 데이터가 없을 때: 메시지만 표시 (검색창은 그대로 유지) --%>
                    <c:otherwise>
                        <p class="text-muted mt-3">
                            선택한 월의 급여 데이터가 아직 없습니다.
                        </p>
                    </c:otherwise>

                </c:choose>

               

            </div>
        </main>
         <jsp:include page="../common/footer.jsp" />
    </div>
</div>

<%-- DataTables JS --%>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<%-- 🔹 salList가 있을 때만 DataTables 초기화 --%>
<c:if test="${not empty salList}">
<script>
    $(function () {

        var table = $('#salTable').DataTable({
            ordering: true,                     // 헤더 클릭 정렬
            order: [[0, 'desc'], [1, 'asc']],   // 기본: 지급월 ↓, 사번 ↑
            paging: true,
            pageLength: 10,
            lengthChange: false,
            searching: true,                    // Search... 표시
            info: false,
            columnDefs: [
                { orderable: false, targets: -1 }   // 마지막 열(자세히)은 정렬 X
            ],
            language: {
                search: "",   // 'Search:' 글자 제거
                emptyTable: "표시할 급여 데이터가 없습니다.",
                paginate: {
                    previous: "이전",
                    next: "다음"
                }
            }
        });

        // DataTables가 만든 검색창(.dataTables_filter)을 우리가 만든 오른쪽 상단 박스로 이동
        var filter = $('#salTable_wrapper .dataTables_filter');
        filter.appendTo('.sal-top-right');
        filter.addClass('sal-search-box');

        // 검색 input placeholder 설정
        $('.dataTables_filter input')
            .attr('placeholder', 'Search...');
    });
</script>
</c:if>

</body>
</html>
