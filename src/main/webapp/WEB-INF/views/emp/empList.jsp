<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    // 사이드바 메뉴 활성화용
    request.setAttribute("menu", "salemp");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>급여관리 - 사원 목록</title>

    <!-- DataTables CSS -->
    <link rel="stylesheet"
          href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css"/>

    <style>
        .content-wrapper {
            padding: 20px 30px;
        }
        .page-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        table.dataTable tbody tr {
            cursor: pointer;
        }
    </style>
</head>

<body>
    <!-- 상단 헤더 -->
    <jsp:include page="../common/header.jsp" flush="true" />

    <div id="layoutSidenav">
        <!-- 왼쪽 사이드바 -->
        <jsp:include page="../common/sidebar.jsp" flush="true" />

        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4 content-wrapper">

                    <h3 class="mt-4">급여관리</h3>
                    <div class="page-title">사원 목록</div>

                    <!-- 사원 테이블 -->
                    <table id="empTable" class="display" style="width: 100%">
                        <thead>
                        <tr>
                            <th>사번</th>
                            <th>이름</th>
                            <th>부서</th>
                            <th>재직상태</th>
                            <th>입사일</th>
                            <th>연락처</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach var="emp" items="${empList}">
                            <tr data-empno="${emp.empNo}">
                                <td>${emp.empNo}</td>
                                <!-- 이름 칸에만 class 부여 -->
                                <td class="emp-name-cell">${emp.empName}</td>
                                <td>${emp.deptName}</td>
                                <td>${emp.statusName}</td>
                                <td>${emp.empRegdate}</td>
                                <td>${emp.empPhone}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                </div>
            </main>

            <!-- 푸터 -->
            <jsp:include page="../common/footer.jsp" flush="true" />
        </div>
    </div>

    <!-- jQuery & DataTables JS 
         🔹 header.jsp 에서 이미 jQuery를 불러오고 있으면 아래 jQuery는 빼도 돼요 -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script
            src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>

    <script>
        $(function () {

            // ⭐ 이미 초기화된 적이 있으면 다시 초기화하지 않기 → reinitialise 에러 방지
            if (!$.fn.DataTable.isDataTable('#empTable')) {
                const table = $('#empTable').DataTable({
                    language: {
                        "decimal": "",
                        "emptyTable": "사원 정보가 없습니다.",
                        "info": "_TOTAL_명 중 _START_ ~ _END_명 표시",
                        "infoEmpty": "0명",
                        "infoFiltered": "(_MAX_명에서 필터링됨)",
                        "lengthMenu": "페이지당 _MENU_명 보기",
                        "loadingRecords": "로딩 중...",
                        "processing": "처리 중...",
                        "search": "",
                        "zeroRecords": "일치하는 사원이 없습니다.",
                        "paginate": {
                            "first": "처음",
                            "last": "마지막",
                            "next": "다음",
                            "previous": "이전"
                        }
                    },
                    order: [[0, 'asc']]
                });

                // 기본 검색창 placeholder 설정
                $('.dataTables_filter input')
                    .attr('placeholder', '이름 / 부서 / 재직상태 검색');
            }

            // ✅ 이름(두 번째 칸) 클릭 시 급여대장 페이지로 이동
            $('#empTable tbody').on('click', 'td.emp-name-cell', function () {
                const tr = $(this).closest('tr');
                const empNo = tr.data('empno');
                if (!empNo) return;

                location.href = '/sal/list?empNo=' + empNo;
            });
        });
    </script>
</body>
</html>