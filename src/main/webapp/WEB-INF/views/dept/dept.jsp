<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>부서 조직도</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/dept.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>

<body class="sb-nav-fixed">

    <jsp:include page="../common/header.jsp" flush="true" />

    <div id="layoutSidenav">
        <jsp:include page="../common/sidebar.jsp" flush="true" />

        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">조직도</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item active">Organization Chart</li>
                    </ol>
                    
                    <div class="card mb-4">
                        <div class="card-body">
                            
                            <div class="org-tree">
                                <ul>
                                    <%-- CEO 영역 --%>
                                    <c:forEach var="ceo" items="${deptList}">
                                        <c:if test="${ceo.deptNo == 1001}">
                                            <li>
                                                <div class="org-node ceo" onclick="showDeptModal('${ceo.deptNo}', '${ceo.deptName}')">
                                                    <div class="profile-pic">
                                                        <%-- 🔹 [수정] 이미지 경로 로직 개선 --%>
                                                        <img src="${pageContext.request.contextPath}${not empty ceo.managerImage ? '/upload/emp/' : '/images/'}${not empty ceo.managerImage ? ceo.managerImage : 'default_profile.png'}" 
                                                             alt="CEO">
                                                    </div>
                                                    <span class="dept-name">${ceo.deptName}</span>
                                                    <span class="manager-name">${ceo.managerName}</span>
                                                    <span class="position">CEO</span>
                                                </div>

                                                <ul>
                                                    <%-- CTO 영역 --%>
                                                    <c:forEach var="cto" items="${deptList}">
                                                        <c:if test="${cto.deptNo == 3000}">
                                                            <li>
                                                                <div class="org-node head" onclick="showDeptModal('${cto.deptNo}', '${cto.deptName}')">
                                                                    <div class="profile-pic">
                                                                        <%-- 🔹 [수정] CTO 이미지 경로 --%>
                                                                        <img src="${pageContext.request.contextPath}${not empty cto.managerImage ? '/upload/emp/' : '/images/'}${not empty cto.managerImage ? cto.managerImage : 'default_profile.png'}" 
                                                                             alt="CTO">
                                                                    </div>
                                                                    <span class="dept-name">${cto.deptName}</span>
                                                                    <span class="manager-name">${cto.managerName}</span>
                                                                    <span class="position">CTO</span>
                                                                </div>
                                                
                                                                <ul class="team-grid">
                                                                    <c:forEach var="team" items="${deptList}">
                                                                        <c:if test="${team.parentDeptNo == 3000}">
                                                                            <li>
                                                                                <div class="org-node team" onclick="showDeptModal('${team.deptNo}', '${team.deptName}')">
                                                                                    <span class="dept-name">${team.deptName}</span>
                                                                                    <span class="manager-name">${team.managerName}</span>
                                                                                </div>
                                                                            </li>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </ul>
                                                            </li>
                                                        </c:if>
                                                    </c:forEach>
                                                
                                                    <%-- COO 영역 --%>
                                                    <c:forEach var="coo" items="${deptList}">
                                                        <c:if test="${coo.deptNo == 2000}">
                                                            <li>
                                                                <div class="org-node head" onclick="showDeptModal('${coo.deptNo}', '${coo.deptName}')">
                                                                    <div class="profile-pic">
                                                                        <%-- 🔹 [수정] COO 이미지 경로 --%>
                                                                        <img src="${pageContext.request.contextPath}${not empty coo.managerImage ? '/upload/emp/' : '/images/'}${not empty coo.managerImage ? coo.managerImage : 'default_profile.png'}" 
                                                                             alt="COO">
                                                                    </div>
                                                                    <span class="dept-name">${coo.deptName}</span>
                                                                    <span class="manager-name">${coo.managerName}</span>
                                                                    <span class="position">COO</span>
                                                                </div>
                                                
                                                                <ul class="team-grid">
                                                                    <c:forEach var="team" items="${deptList}">
                                                                        <c:if test="${team.parentDeptNo == 2000}">
                                                                            <li>
                                                                                <div class="org-node team" onclick="showDeptModal('${team.deptNo}', '${team.deptName}')">
                                                                                    <span class="dept-name">${team.deptName}</span>
                                                                                    <span class="manager-name">${team.managerName}</span>
                                                                                </div>
                                                                            </li>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </ul>
                                                            </li>
                                                        </c:if>
                                                    </c:forEach>
                                                
                                                    <%-- CBO 영역 --%>
                                                    <c:forEach var="cbo" items="${deptList}">
                                                        <c:if test="${cbo.deptNo == 4000}">
                                                            <li>
                                                                <div class="org-node head" onclick="showDeptModal('${cbo.deptNo}', '${cbo.deptName}')">
                                                                    <div class="profile-pic">
                                                                        <%-- 🔹 [수정] CBO 이미지 경로 --%>
                                                                        <img src="${pageContext.request.contextPath}${not empty cbo.managerImage ? '/upload/emp/' : '/images/'}${not empty cbo.managerImage ? cbo.managerImage : 'default_profile.png'}" 
                                                                             alt="CBO">
                                                                    </div>
                                                                    <span class="dept-name">${cbo.deptName}</span>
                                                                    <span class="manager-name">${cbo.managerName}</span>
                                                                    <span class="position">CBO</span>
                                                                </div>
                                                
                                                                <ul class="team-grid">
                                                                    <c:forEach var="team" items="${deptList}">
                                                                        <c:if test="${team.parentDeptNo == 4000}">
                                                                            <li>
                                                                                <div class="org-node team" onclick="showDeptModal('${team.deptNo}', '${team.deptName}')">
                                                                                    <span class="dept-name">${team.deptName}</span>
                                                                                    <span class="manager-name">${team.managerName}</span>
                                                                                </div>
                                                                            </li>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </ul>
                                                            </li>
                                                        </c:if>
                                                    </c:forEach>
                                                
                                                </ul>

                                            </li>
                                        </c:if>
                                    </c:forEach>
                                </ul> 
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../common/footer.jsp" flush="true" />
        </div>
    </div>

    <div id="deptInfoModal">
        <div class="modal-content-custom">
            <div class="modal-header-custom">
                <h5 style="margin:0;" id="modalDeptName">부서명</h5>
                <span id="closeModalBtn" class="close-btn">&times;</span>
            </div>
            <div class="modal-body-custom">
                <ul id="employeeList">
                    <li style="text-align:center; padding:20px;">로딩 중...</li>
                </ul>
            </div>
            <button class="btn-manage-custom" onclick="goToEmployeeMgmtByDept()">
                <i class="fas fa-users-cog"></i> 부서원 관리 / 상세 보기
            </button>
        </div>
    </div>

    <script>
        const modal = document.getElementById('deptInfoModal');
        const closeModalBtn = document.getElementById('closeModalBtn');
        const modalDeptName = document.getElementById('modalDeptName');
        const employeeListUl = document.getElementById('employeeList');
        let currentDeptId = null; 

        // 🔹 [추가] JS에서 컨텍스트 경로 사용을 위한 변수
        const contextPath = '${pageContext.request.contextPath}';

        function showDeptModal(deptId, deptName) {
            currentDeptId = deptId;
            modalDeptName.textContent = deptName;
            modal.style.display = 'block';
            document.body.style.overflow = 'hidden'; 
            employeeListUl.innerHTML = '<li style="text-align:center; padding:20px; color:#666;">데이터를 불러오는 중입니다...</li>';
            loadEmployeeList(deptId); 
        }

        function loadEmployeeList(deptId) {
            $.ajax({
                url: contextPath + '/dept/api/employees', 
                type: 'GET',
                data: { deptNo: deptId }, 
                dataType: 'json',
                success: function(data) {
                    employeeListUl.innerHTML = ''; 
                    if (!data || data.length === 0) {
                        employeeListUl.innerHTML = '<li style="text-align:center; padding:20px; color:#888;">소속된 사원이 없습니다.</li>';
                        return;
                    }
                    $.each(data, function(index, emp) {
                        // 🔹 [수정] AJAX에서 이미지 경로를 /upload/emp/ 로 지정
                        let imgSrc = emp.empImage 
                                     ? contextPath + '/upload/emp/' + emp.empImage 
                                     : contextPath + '/images/default_profile.png';
                                     
                        let jobTitle = emp.jobTitle ? emp.jobTitle : '사원';
                        
                        let html = `
                            <li class="emp-item" onclick="goToEmployeeMgmt('\${emp.empNo}')">
                                <img src="\${imgSrc}" class="emp-thumb" alt="프로필">
                                <div class="emp-details">
                                    <span class="emp-name">\${emp.empName}</span>
                                    <span class="position" style="font-size:12px;">\${jobTitle}</span>
                                </div>
                            </li>
                        `;
                        employeeListUl.insertAdjacentHTML('beforeend', html);
                    });
                },
                error: function() {
                    employeeListUl.innerHTML = '<li style="text-align:center; color:red; padding:20px;">데이터 로드 실패</li>';
                }
            });
        }

        function closeModal() {
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }
        closeModalBtn.onclick = closeModal;
        window.onclick = function(event) { if (event.target == modal) closeModal(); }

        function goToEmployeeMgmt(empId) {
            location.href = `${pageContext.request.contextPath}/emp/detail?empNo=\${empId}`;
        }
        function goToEmployeeMgmtByDept() {
            if (currentDeptId) location.href = `${pageContext.request.contextPath}/emp/list?deptNo=\${currentDeptId}`;
        }
    </script>
</body>
</html>