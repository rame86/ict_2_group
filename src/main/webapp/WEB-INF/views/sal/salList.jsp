<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>사원목록</title>

    <!-- DataTables + jQuery (CDN 예시) -->
    <link rel="stylesheet"
          href="https://cdn.datatables.net/1.13.5/css/jquery.dataTables.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.5/js/jquery.dataTables.min.js"></script>

    <style>
        /* 가운데 콘텐츠 영역만 대략 스타일 */
        .content-wrapper {
            padding: 20px 30px;
        }
        .page-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .search-bar {
            margin-bottom: 10px;
        }
        .search-bar input,
        .search-bar select {
            padding: 4px 6px;
            margin-right: 5px;
        }
        table.dataTable tbody tr {
            cursor: pointer;
        }
    </style>

    <script>
        $(function () {

            // DataTable 초기화
            const table = $('#empTable').DataTable({
                language: {
                    "emptyTable":     "조회된 사원 정보가 없습니다.",
                    "info":           "_TOTAL_명 중 _START_ ~ _END_명 표시",
                    "infoEmpty":      "0명",
                    "infoFiltered":   "(_MAX_명에서 필터링됨)",
                    "lengthMenu":     "페이지당 _MENU_명 보기",
                    "loadingRecords": "로딩 중...",
                    "processing":     "처리 중...",
                    "search":         "검색:",
                    "zeroRecords":    "일치하는 사원이 없습니다.",
                    "paginate": {
                        "first":      "처음",
                        "last":       "마지막",
                        "next":       "다음",
                        "previous":   "이전"
                    }
                },
                order: [[0, 'asc']] // 기본 정렬: 사번 오름차순
            });

            // (선택) 위에 있는 검색창으로 DataTables 검색 연동
            $('#keyword').on('keyup', function () {
                table.search(this.value).draw();
            });

            // 행 클릭 시 급여 페이지로 이동 (원하면 사용)
            $('#empTable tbody').on('click', 'tr', function () {
                const empNo = $(this).data('empno');
                if (!empNo) return;
                // TODO: 나중에 급여내역 페이지 URL로 바꾸기
                // 예: location.href = '/salary/list?empNo=' + empNo;
                console.log('clicked empNo = ' + empNo);
            });
        });
    </script>
</head>

<body>
<!-- 여기 위/왼쪽은 공통 include 라고 가정(header, left menu 등) -->

<div class="content-wrapper">
    <!-- 상단 제목 -->
    <div class="page-title">사원 목록</div>

    <!-- 상단 검색 영역 (와이어프레임의 SEARCH 박스 역할) -->
    <div class="search-bar">
        이름/부서/상태 검색:
        <input type="text" id="keyword" placeholder="검색어를 입력하세요.">
        <!-- 필요하면 부서, 재직상태 select 도 추가 가능 -->
        <%-- 
        <select id="deptFilter">
            <option value="">전체 부서</option>
            ...
        </select>
        --%>
    </div>

    <!-- 사원 목록 테이블 -->
    <table id="empTable" class="display" style="width:100%">
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
                <td>${emp.empName}</td>
                <td>${emp.deptName}</td>
                <td>${emp.statusName}</td>
                <td>${emp.empRegdate}</td>
                <td>${emp.empPhone}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>