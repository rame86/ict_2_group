<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>급여 관리 (관리자)</title>
</head>
<body>

<h2>급여 관리 (관리자 급여 대장)</h2>

<c:if test="${empty salList}">
    <p>급여 데이터가 아직 없습니다.</p>
</c:if>

<c:if test="${not empty salList}">
    <table border="1" cellspacing="0" cellpadding="5">
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

        <c:forEach var="s" items="${salList}">
            <tr>
                <td>
                    <!-- monthAttno 그대로 보여줘도 되고, yearMonthLabel 있으면 그걸로 -->
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
    </table>
</c:if>

</body>
</html>