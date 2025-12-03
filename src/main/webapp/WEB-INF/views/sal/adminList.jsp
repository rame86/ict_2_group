<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>급여 관리 (관리자)</title>

    <!-- 공통 header (부트스트랩 / jQuery 포함돼 있을 가능성 높음) -->
    <jsp:include page="../common/header.jsp" />

    <!-- 급여 관리자/상세 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/salDetail.css">

    <!-- DataTables CSS -->
    <link rel="stylesheet"
          href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

    <!-- jQuery (header.jsp에 이미 있으면 이 줄은 생략 가능) -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>

<div id="layoutSidenav">

    <!-- 사이드바 -->
    <jsp:include page="../common/sidebar.jsp" />

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">

                <h3 class="mt-4">급여 관리 관리자모드</h3>
                <br>
                <h4>급여 명세서</h4>

                <c:if test="${empty salList}">
                    <p>급여 데이터가 아직 없습니다.</p>
                </c:if>

                <c:if test="${not empty salList}">
                    <!-- 상단: 월별 필터 + DataTables 검색창 들어올 자리 -->
                    <div class="sal-top-bar">
                        <!-- 왼쪽: 지급월 필터 -->
                        <form id="monthFilterForm"
                              method="get"
                              action="${pageContext.request.contextPath}/sal/admin/list">
                            <input type="month" name="month"
                                   value="${searchMonth}">
                            <button type="submit" class="btn btn-primary btn-sm">
                                검색
                            </button>
                        </form>

                        <!-- 오른쪽: Search... 위치 (DataTables filter가 JS로 옮겨짐) -->
                        <div class="sal-top-right">
                            <!-- JS에서 .dataTables_filter를 이 안으로 append -->
                        </div>
                    </div>

                    <!-- 급여 리스트 테이블 -->
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
                                <!-- 지급월: yearMonthLabel 있으면 그거, 없으면 SAL_DATE 포맷 또는 MONTH_ATTNO -->
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
                </c:if>

                <jsp:include page="../common/footer.jsp" />
            </div>
        </main>
    </div>
</div>

<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<script>
    $(function () {

        // DataTables 초기화
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

</body>
</html>
