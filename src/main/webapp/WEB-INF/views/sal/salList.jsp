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

<!-- 외부 CSS로 분리 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/salList.css">

<!-- DataTables CSS (정렬/검색/페이징용) -->
<link rel="stylesheet"
      href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

<!-- jQuery (header.jsp에서 이미 포함돼있으면 이 줄은 빼도 됩니다) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

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
                    <table id="salTable" class="salary-table display">
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

<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<script>
$(function() {

    // 1) DataTables 초기화 (헤더 클릭 정렬 / 검색 / 페이징)
    $('#salTable').DataTable({
        ordering: true,              // 헤더 클릭 정렬
        order: [[0, 'desc']],        // 기본: 지급월 내림차순
        paging: true,
        pageLength: 10,
        lengthChange: false,
        searching: false,             // 검색창 표시
        info: false,
        language: {
            search: "",              // 'Search:' 텍스트 제거
            emptyTable: "급여 정보가 없습니다.",
            paginate: {
                previous: "이전",
                next: "다음"
            }
        }
    });

    // 검색창 placeholder 설정
    $('.dataTables_filter input').attr('placeholder', 'Search...');

    // 2) 지급월(밑줄 링크) 클릭 시 → 급여 명세서 페이지로 이동
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

</body>
</html>
