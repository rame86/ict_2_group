<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
request.setAttribute("menu", "salemp");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>급여관리</title>



<!-- 공통 헤더 -->
<jsp:include page="../common/header.jsp" />

<!-- DataTables CSS -->
<link rel="stylesheet"
      href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>

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

    /* DataTables 검색 박스 스타일 */
    .dataTables_filter input {
        width: 250px !important;
        padding: 6px;
    }
</style>

<script>
$(document).ready(function() {

    // 🔥 DataTable 초기화 — 중복 초기화 방지
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

    // 🔥 placeholder 적용
    $('.dataTables_filter input').attr("placeholder", "이름 / 부서 / 재직상태 검색");

    // 🔥 사원 이름 클릭 시 급여대장(salList.jsp)로 이동
    $("#empTable tbody").on("click", "td.emp-name-cell", function () {
        const tr = $(this).closest("tr");
        const empNo = tr.data("empno");

        if (!empNo) return;

        // 사원목록 → 급여대장 이동
        location.href = "/sal/list?empNo=" + empNo;
    });
});
</script>

</head>

<body>

<div id="layoutSidenav">
    
    <!-- 사이드바 -->
    <jsp:include page="../common/sidebar.jsp" />

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">

                <h3 class="mt-4">급여 관리</h3>
                <br>
                <h4> 사원목록 </h4>

                <div class="content-wrapper">

                    <!-- 사원 목록 테이블 -->
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

                                    <!-- 🔥 이름 셀만 클릭 가능 -->
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

                <!-- 푸터 -->
                <jsp:include page="../common/footer.jsp" />

            </div>
        </main>
    </div>

</div>

</body>
</html>