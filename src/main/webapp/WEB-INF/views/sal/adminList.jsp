<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
    <title>급여 관리 (관리자)</title>

    <!-- 기존 CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/salDetail.css">

    <!-- DataTables CSS (표 헤더 클릭 정렬용) -->
    <link rel="stylesheet"
          href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

    <style>
        /* ================= 테이블 기본 스타일 ================= */

        table.sal-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        table.sal-table thead th {
            background-color: #f1f1f1;  /* 연한 회색 헤더 */
            border-bottom: 1px solid #ddd;
            padding: 8px 10px;
            text-align: center;
            font-weight: 600;
        }

        table.sal-table tbody td {
            border-bottom: 1px solid #eee;
            padding: 6px 10px;
            text-align: center;
        }

        table.sal-table tbody tr:hover {
            background-color: #fafafa; /* 호버시 약간만 강조 */
        }

        /* DataTables 기본 보더/스트라이프 조정 */
        table.dataTable.no-footer {
            border-bottom: 1px solid #ddd;
        }
        table.dataTable tbody tr:nth-child(odd),
        table.dataTable tbody tr:nth-child(even) {
            background-color: #fff;
        }

        /* ================= 검색창 스타일 ================= */

        .dataTables_filter {
            text-align: right;
            margin-bottom: 5px;
        }

        /* label 글자 (Search:) 스타일 & 숨기기용 */
        .dataTables_filter label {
            font-size: 14px;
            color: #333;
        }
        .dataTables_filter label > span {
            display: none; /* language.search를 ""로 두지만 혹시 남을 경우 대비 */
        }

        /* 실제 검색 input 스타일 */
        .dataTables_filter input {
            border: 1px solid #ccc !important;
            border-radius: 6px !important;
            padding: 8px 12px !important;
            font-size: 14px !important;
            width: 180px !important;
            outline: none !important;
            transition: 0.2s;
        }

        .dataTables_filter input:focus {
            border-color: #888 !important;
            box-shadow: 0 0 3px rgba(0, 0, 0, 0.15);
        }

        /* ================= 페이징 스타일 ================= */

        div.dataTables_wrapper div.dataTables_paginate {
            text-align: right;
            margin-top: 10px;
        }

        /* 페이지 번호(1, 2, 3…) 크기 약간 축소 */
        .dataTables_paginate .paginate_button {
            padding: 0px 6px !important;   /* 좌우 여백 줄이기 */
            margin-left: 2px;
            font-size: 12px !important;    /* 글자 크기 살짝 줄임 */
            height: 26px !important;
            line-height: 26px !important;
        }

        /* ================= 헤더 정렬 화살표 ================= */

        table.dataTable thead .sorting,
        table.dataTable thead .sorting_asc,
        table.dataTable thead .sorting_desc {
            background-image: none;
            position: relative;
        }

        table.dataTable thead .sorting:after,
        table.dataTable thead .sorting_asc:after,
        table.dataTable thead .sorting_desc:after {
            content: "▲▼";
            font-size: 10px;
            color: #999;
            position: absolute;
            right: 6px;
            top: 50%;
            transform: translateY(-50%);
        }

        table.dataTable thead .sorting_asc:after {
            content: "▲";
            color: #666;
        }

        table.dataTable thead .sorting_desc:after {
            content: "▼";
            color: #666;
        }
    </style>
</head>
<body>

<jsp:include page="../common/header.jsp" />

<div id="layoutSidenav">

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

                <%-- 예전 드롭다운 정렬 폼은 이제 필요 없으니 주석 처리
                <form method="get"
                      action="${pageContext.request.contextPath}/sal/admin/list">
                    ...
                </form>
                --%>

                <br />

                <c:if test="${not empty salList}">
                    <!-- DataTables 적용을 위해 id + thead/tbody 구조 사용 -->
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
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty s.yearMonthLabel}">
                                            ${s.yearMonthLabel}
                                        </c:when>
                                        <c:otherwise>
                                            ${s.monthAttno}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${s.empNo}</td>
                                <td>${s.empName}</td>
                                <td>${s.deptName}</td>
                                <td>${s.salBase}</td>
                                <td>${s.salBonus}</td>
                                <td>${s.salPlus}</td>
                                <td>${s.deductTotal}</td>
                                <td>${s.realPay}</td>
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

<!-- jQuery & DataTables JS
     (header.jsp에서 이미 jQuery를 include 했다면 아래 jQuery는 제거해도 됩니다) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<script>
    $(function() {
        var table = $('#salTable').DataTable({
            ordering: true,                     // 헤더 클릭 정렬
            order: [[0, 'desc'], [1, 'asc']],   // 기본: 지급월 ↓, 사번 ↑
            paging: true,
            pageLength: 10,
            lengthChange: false,
            searching: true,                    // 🔍 검색창 표시
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

        // 검색창 placeholder 설정
        $('.dataTables_filter input')
            .attr('placeholder', 'Search...')
    });
</script>

</body>
</html>
