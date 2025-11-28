<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    request.setAttribute("menu", "salemp"); // 사이드바 메뉴 활성화용
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>급여 대장</title>

    <style>
        .content-wrapper {
            padding: 20px 30px;
        }

        .page-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .emp-info {
            font-size: 14px;
            margin-bottom: 15px;
        }

        .emp-info span {
            margin-right: 12px;
        }

        table.salary-list {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
        }

        table.salary-list th,
        table.salary-list td {
            border: 1px solid #ddd;
            padding: 8px 10px;
            font-size: 13px;
            text-align: center;
        }

        table.salary-list th {
            background-color: #fafafa;
            font-weight: 600;
        }

        table.salary-list tbody tr:hover {
            background-color: #f5f5f5;
        }

        a.month-link {
            color: #007bff;
            text-decoration: underline;
            cursor: pointer;
        }

        a.month-link:hover {
            text-decoration: none;
        }
    </style>
</head>

<body>

<!-- 공통 헤더 -->
<jsp:include page="../common/header.jsp" flush="true" />

<div id="layoutSidenav">

    <!-- 사이드바 -->
    <jsp:include page="../common/sidebar.jsp" flush="true" />

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4 content-wrapper">

                <h3 class="mt-4">급여관리</h3>
                <div class="page-title">급여 대장</div>

                <!-- 선택된 사원 정보 -->
                <div class="emp-info">
                    <span>사원명 : <strong>${emp.empName}</strong></span>
                    <span>사번 : <strong>${emp.empNo}</strong></span>
                    <c:if test="${not empty emp.deptName}">
                        <span>부서 : <strong>${emp.deptName}</strong></span>
                    </c:if>
                </div>

                <!-- 급여 요약 리스트 -->
                <table class="salary-list" id="salListTable">
                    <thead>
                        <tr>
                            <th>지급월</th>
                            <th>총지급액</th>
                            <th>공제총액</th>
                            <th>차인지급액</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${summaryList}">
                            <tr data-monthattno="${s.monthAttno}">
                                <td>
                                    <a href="javascript:void(0);" class="month-link">
                                        ${s.yearMonthLabel}
                                    </a>
                                </td>
                                <td>${s.totalPay}</td>
                                <td>${s.deduction}</td>
                                <td>${s.realPay}</td>
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

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
$(function () {
    // 지급월(링크) 클릭 시 → 급여명세서로 이동
    $('#salListTable').on('click', 'a.month-link', function () {
        const tr = $(this).closest('tr');
        const monthAttno = tr.data('monthattno');
        const empNo = "${emp.empNo}";

        if (!monthAttno || !empNo) return;

        location.href = '/sal/detail?empNo=' + encodeURIComponent(empNo)
                      + '&monthAttno=' + monthAttno;
    });
});
</script>

</body>
</html>