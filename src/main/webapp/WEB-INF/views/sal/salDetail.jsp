<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    request.setAttribute("menu", "salemp");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>급여 명세서</title>

    <style>
        .content-wrapper {
            padding: 20px 30px;
        }

        .page-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .emp-summary {
            font-size: 14px;
            margin-bottom: 15px;
        }

        .emp-summary span {
            margin-right: 12px;
        }

        .pay-header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .btn-download {
            padding: 6px 12px;
            font-size: 13px;
        }

        .pay-layout {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
        }

        .pay-left {
            flex: 1 1 55%;
        }

        .pay-right {
            flex: 1 1 40%;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .pay-box {
            background: #ffffff;
            border-radius: 10px;
            border: 1px solid #e0e0e0;
            padding: 16px 18px;
        }

        .pay-box-title {
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .pay-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .pay-table th,
        .pay-table td {
            padding: 4px 2px;
        }

        .pay-table th {
            text-align: left;
            width: 60%;
            color: #555;
        }

        .pay-table td {
            text-align: right;
        }

        .pay-total-row {
            border-top: 1px solid #ddd;
            margin-top: 6px;
            padding-top: 4px;
            font-weight: 600;
        }

        .pay-total-label {
            text-align: left;
        }

        .pay-total-value {
            text-align: right;
        }

        .realpay-box {
            background: #fff7f0;
        }

        .realpay-amount {
            font-size: 20px;
            font-weight: 700;
            text-align: right;
            margin-top: 8px;
        }

        .muted {
            color: #888;
        }
    </style>
</head>

<body>

<jsp:include page="../common/header.jsp" flush="true"/>

<div id="layoutSidenav">

    <jsp:include page="../common/sidebar.jsp" flush="true"/>

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4 content-wrapper">

                <h3 class="mt-4">급여관리</h3>
                <div class="page-title">급여 명세서</div>

                <!-- 사원+지급 정보 -->
                <div class="emp-summary">
                    <span>사원명 : <strong>${emp.empName}</strong></span>
                    <span>사번 : <strong>${emp.empNo}</strong></span>
                    <c:if test="${not empty emp.deptName}">
                        <span>부서 : <strong>${emp.deptName}</strong></span>
                    </c:if>
                    <br/>
                    <span>지급월 :
                        <strong>${sal.monthAttno}</strong>
                    </span>
                    <span>지급일 :
                        <strong>${sal.salDate}</strong>
                    </span>
                </div>

                <div class="pay-header-row">
                    <div class="muted">
                        ※ 기본급, 공제 비율 등은 서비스 로직에서 계산된 값입니다.
                    </div>
                    <button type="button" class="btn btn-outline-secondary btn-download" id="btnPdf">
                        PDF 다운로드
                    </button>
                </div>

                <!-- 본문 -->
                <div class="pay-layout">

                    <!-- 지급 내역 -->
                    <div class="pay-left">
                        <div class="pay-box">
                            <div class="pay-box-title">지급 내역</div>

                            <table class="pay-table">
                                <tbody>
                                <tr>
                                    <th>기본급</th>
                                    <td>${sal.salBase}</td>
                                </tr>
                                <tr>
                                    <th>성과급</th>
                                    <td>${sal.salBonus}</td>
                                </tr>
                                <tr>
                                    <th>초과 근무 수당</th>
                                    <td>${sal.salPlus}</td>
                                </tr>
                                </tbody>
                            </table>

                            <hr/>

                            <table class="pay-table">
                                <tbody>
                                <tr class="pay-total-row">
                                    <th class="pay-total-label">지급액 합계</th>
                                    <td class="pay-total-value">
                                        ${sal.salBase + sal.salBonus + sal.salPlus}
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- 공제 / 실지급 -->
                    <div class="pay-right">

                        <!-- 공제 내역 -->
                        <div class="pay-box">
                            <div class="pay-box-title">공제 내역</div>

                            <table class="pay-table">
                                <tbody>
                                <tr>
                                    <th>4대 보험</th>
                                    <td>${sal.insurance}</td>
                                </tr>
                                <tr>
                                    <th>세금</th>
                                    <td>${sal.tax}</td>
                                </tr>
                                </tbody>
                            </table>

                            <hr/>

                            <table class="pay-table">
                                <tbody>
                                <tr class="pay-total-row">
                                    <th class="pay-total-label">공제 합계</th>
                                    <td class="pay-total-value">
                                        ${sal.insurance + sal.tax}
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- 기타 및 실지급액 -->
                        <div class="pay-box realpay-box">
                            <div class="pay-box-title">기타 금액 및 실지급액</div>

                            <table class="pay-table">
                                <tbody>
                                <tr>
                                    <th>기타 수당</th>
                                    <td>0</td>
                                </tr>
                                <tr>
                                    <th>기타 공제</th>
                                    <td>0</td>
                                </tr>
                                </tbody>
                            </table>

                            <hr/>

                            <div class="realpay-amount">
                                실지급액 :
                                <span>${sal.realPay}</span>
                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </main>

        <jsp:include page="../common/footer.jsp" flush="true"/>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
$(function () {
    $('#btnPdf').click(function () {
        alert('PDF 다운로드는 나중에 구현해도 돼요 🙂');
    });
});
</script>

</body>
</html>