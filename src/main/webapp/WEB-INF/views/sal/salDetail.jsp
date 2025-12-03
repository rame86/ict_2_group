<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%-- <%@ include file="/WEB-INF/views/include/header.jsp" %> --%>

<%
    if (request.getAttribute("menu") == null) {
        request.setAttribute("menu", "salemp");
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>급여 명세서</title>

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" href="/css/salDetail.css">


</head>
<body>

<div id="layoutSidenav">

    <jsp:include page="../common/sidebar.jsp" />

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">

                <h3 class="mt-4">급여 관리</h3>
                <br>
                <h4> 급여 명세서 </h4>

                <div class="content-wrapper">

                    <!-- 🔹 상단 정보 영역 : 지급월 / 지급일 / 사원 기본 정보 + 출력 버튼 -->
                    <div class="info-card">

                        <div class="info-card-header">
                            <div>
                                <span class="info-label">지급월 :  
                                <c:choose>
                                    <c:when test="${not empty sal.yearMonthLabel}">
                                        ${sal.yearMonthLabel}
                                    </c:when>
                                    <c:otherwise>
                                        ${sal.monthAttno}
                                    </c:otherwise>
                                </c:choose></span>
                            </div>
                            <button type="button" class="btn-print" onclick="window.print();">
                                명세서 출력
                            </button>
                        </div>

                        <div class="info-row">
                            <span>
                                <span class="info-label">지급일 :
                                <c:choose>
                                    <c:when test="${not empty sal.yearMonthLabel}">
                                        ${sal.yearMonthLabel} 15일
                                    </c:when>
                                    <c:otherwise>
                                        15일
                                    </c:otherwise>
                                </c:choose> </span> 
                            </span>
                        </div>

                        <div class="info-row">
                            <span>
                                <span class="info-label">사번 :  ${emp.empNo} </span>
                            </span>
                            <span>
                                <span class="info-label">이름 : ${emp.empName} </span> 
                            </span>
                     	
                            <span>
                                <span class="info-label">부서 : ${emp.deptName} </span> 
                            </span>
                            <span>
                                <span class="info-label">재직상태 : ${emp.statusName} </span> 
                            </span>
                        </div>

                    </div>

                    <!-- 🔹 가운데 : 지급 내역 / 공제 내역 두 박스 -->
                    <div class="salary-wrapper">

                        <!-- 지급 내역 -->
                        <div class="salary-box">
                            <h5>지급 내역</h5>
                            <table class="salary-table">
                                <tr>
                                    <th>기본급</th>
                                    <td>
                                        <fmt:formatNumber value="${sal.salBase}" type="number" pattern="#,##0" />원
                                    </td>
                                </tr>
                                <tr>
                                    <th>성과급</th>
                                    <td>
                                        <fmt:formatNumber value="${sal.salBonus}" type="number" pattern="#,##0" />원
                                    </td>
                                </tr>
                                <tr>
                                    <th>추가 수당</th>
                                    <td>
                                        <fmt:formatNumber value="${sal.salPlus}" type="number" pattern="#,##0" />원
                                    </td>
                                </tr>
                                <c:if test="${not empty sal.overtimePay}">
                                    <tr>
                                        <th>초과근무 수당</th>
                                        <td>
                                            <fmt:formatNumber value="${sal.overtimePay}" type="number" pattern="#,##0" />원
                                        </td>
                                    </tr>
                                </c:if>
                            </table>
                        </div>

                        <!-- 공제 내역 -->
                        <div class="salary-box">
                            <h5>공제 내역</h5>
                            <table class="salary-table">
                                <tr>
                                    <th>4대 보험</th>
                                    <td>
                                        <fmt:formatNumber value="${sal.insurance}" type="number" pattern="#,##0" />원
                                    </td>
                                </tr>
                                <tr>
                                    <th>세금</th>
                                    <td>
                                        <fmt:formatNumber value="${sal.tax}" type="number" pattern="#,##0" />원
                                    </td>
                                </tr>
                            </table>
                        </div>

                    </div>

                    <!-- 🔹 하단 : 총 지급액 / 공제 합계 / 실지급액 한 박스 (공제 내역 밑) -->
                    <div class="summary-box">
                        <div class="summary-row">
                            <span class="summary-label">총 지급액</span>
                            <span>
                                <fmt:formatNumber value="${sal.payTotal}" type="number" pattern="#,##0" />원
                            </span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">공제 합계</span>
                            <span>
                                <fmt:formatNumber value="${sal.deductTotal}" type="number" pattern="#,##0" />원
                            </span>
                        </div>
                        <div class="summary-row real-pay-row">
                            <span class="summary-label">실지급액</span>
                            <span class="amount">
                                <fmt:formatNumber value="${sal.realPay}" type="number" pattern="#,##0" />원
                            </span>
                        </div>
                    </div>

                    <!-- 🔹 버튼 영역 -->
                    <div class="btn-area">
                        <button type="button" onclick="history.back();">급여 명세서 목록으로 돌아가기</button>
                    </div>

                </div>

                <jsp:include page="../common/footer.jsp" />

            </div>
        </main>
    </div>
</div>

</body>
</html>