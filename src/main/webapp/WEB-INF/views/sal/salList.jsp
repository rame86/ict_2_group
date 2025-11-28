<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
    if (request.getAttribute("menu") == null) {
        request.setAttribute("menu", "salemp");
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>급여 명세서 목록</title>

<!-- 공통 헤더 -->
<jsp:include page="../common/header.jsp" />

<style>
    .content-wrapper {
        padding: 20px 30px;
    }

    .page-title {
        font-size: 20px;
        font-weight: 600;
        margin-bottom: 15px;
    }

    .emp-info-box {
        margin-bottom: 15px;
        padding: 10px 15px;
        border-radius: 6px;
        background-color: #f8f9fa;
        font-size: 14px;
    }

    .emp-info-box span {
        margin-right: 12px;
    }

    table.salary-table {
        width: 100%;
        border-collapse: collapse;
    }

    table.salary-table th,
    table.salary-table td {
        border: 1px solid #dee2e6;
        padding: 8px 10px;
        text-align: center;
    }

    table.salary-table thead {
        background-color: #f1f1f1;
    }

    /* 지급월 링크 스타일 */
    .month-link {
        text-decoration: underline;
        color: #0d6efd;
        cursor: pointer;
    }

    .text-muted {
        color: #6c757d;
    }
</style>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
$(function() {

    // 지급월(밑줄 링크) 클릭 시 → 급여 명세서 페이지로 이동
    $("#salTable").on("click", "a.month-link", function(e) {
        e.preventDefault();

        const empNo      = $(this).data("empno");
        const monthAttno = $(this).data("monthattno");

        if (!empNo || !monthAttno) return;

        location.href = "/sal/detail?empNo=" + encodeURIComponent(empNo)
                      + "&monthAttno=" + encodeURIComponent(monthAttno);
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
                <h4> 급여 명세서 목록 </h4>

                <div class="content-wrapper">

                    <!-- 사원 기본정보 표시 -->
                    <div class="emp-info-box">
                        <span><strong>사번</strong> : ${emp.empNo}</span>
                        <span><strong>이름</strong> : ${emp.empName}</span>
                        <span><strong>부서</strong> : ${emp.deptName}</span>
                        <span><strong>재직상태</strong> : ${emp.statusName}</span>
                    </div>

                    <!-- 급여 리스트 테이블 -->
                    <table id="salTable" class="salary-table">
                        <thead>
                            <tr>
                                <th>지급월</th>
                                <th>총 지급액</th>
                                <th>공제 총액</th>
                                <th>실 지급액</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty salList}">
                                <tr>
                                    <td colspan="4" class="text-muted">
                                        급여 정보가 없습니다.
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="sal" items="${salList}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty sal.yearMonthLabel}">
                                                <a href="#"
                                                   class="month-link"
                                                   data-empno="${sal.empNo}"
                                                   data-monthattno="${sal.monthAttno}">
                                                    ${sal.yearMonthLabel}
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="#"
                                                   class="month-link"
                                                   data-empno="${sal.empNo}"
                                                   data-monthattno="${sal.monthAttno}">
                                                    ${sal.monthAttno}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${sal.payTotal}" type="number" pattern="#,##0" />원
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${sal.deductTotal}" type="number" pattern="#,##0" />원
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${sal.realPay}" type="number" pattern="#,##0" />원
                                    </td>
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