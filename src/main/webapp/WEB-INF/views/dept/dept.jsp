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
                                    <c:forEach var="ceo" items="${deptList}">
                                        <c:if test="${ceo.deptNo == 1001}">
                                            <li>
                                                <%-- 🔹 CEO 노드: 내 부서 체크 --%>
                                                <div class="org-node ceo ${sessionScope.login.deptNo == ceo.deptNo ? 'my-dept' : ''}" 
                                                     onclick="showDeptModal('${ceo.deptNo}', '${ceo.deptName}', '${ceo.managerName}')">
                                                    <div class="profile-pic">
                                                        <img src="${pageContext.request.contextPath}${not empty ceo.managerImage ? '/upload/emp/' : '/images/'}${not empty ceo.managerImage ? ceo.managerImage : 'default_profile.png'}" 
                                                             alt="CEO">
                                                    </div>
                                                    <span class="dept-name">${ceo.deptName}</span>
                                                    <span class="manager-name">${ceo.managerName}</span>
                                                    <span class="position">CEO</span>
                                                </div>

                                                <ul>
                                                    <c:forEach var="sub" items="${deptList}">
                                                        <c:if test="${sub.parentDeptNo == 1001 && sub.deptNo != 1001}">
                                                            <li>
                                                                <%-- 🔹 부서장(Head) 노드: 내 부서 체크 --%>
                                                                <div class="org-node head ${sessionScope.login.deptNo == sub.deptNo ? 'my-dept' : ''}" 
                                                                     onclick="showDeptModal('${sub.deptNo}', '${sub.deptName}', '${sub.managerName}')">
                                                                    <div class="profile-pic">
                                                                         <img src="${pageContext.request.contextPath}${not empty sub.managerImage ? '/upload/emp/' : '/images/'}${not empty sub.managerImage ? sub.managerImage : 'default_profile.png'}" 
                                                                              alt="Manager">
                                                                    </div>
                                                                    <span class="dept-name">${sub.deptName}</span>
                                                                    <span class="manager-name">${sub.managerName}</span>
                                                                    <span class="position">${sub.deptName}장</span>
                                                                </div>
                                                                
                                                                <ul class="team-grid">
                                                                    <c:forEach var="team" items="${deptList}">
                                                                        <c:if test="${team.parentDeptNo == sub.deptNo}">
                                                                            <li>
                                                                                <%-- 🔹 팀(Team) 노드: 내 부서 체크 --%>
                                                                                <div class="org-node team ${sessionScope.login.deptNo == team.deptNo ? 'my-dept' : ''}" 
                                                                                     onclick="showDeptModal('${team.deptNo}', '${team.deptName}', '${team.managerName}')">
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
            
            <c:choose>
                <c:when test="${not empty sessionScope.login and (sessionScope.login.gradeNo eq '1' or sessionScope.login.gradeNo eq '2')}">
                    <button class="btn-manage-custom" onclick="goToEmployeeMgmtByDept()">
                        <i class="fas fa-users-cog"></i> 부서원 관리 / 상세 보기
                    </button>
                </c:when>
                <c:otherwise>
                    <button class="btn-manage-custom" disabled style="background-color: #ccc; cursor: not-allowed; border-color: #bbb; color: #666;">
                        <i class="fas fa-lock"></i> 관리 권한 없음
                    </button>
                </c:otherwise>
            </c:choose>

        </div>
    </div>

    <script>
        const modal = document.getElementById('deptInfoModal');
        const closeModalBtn = document.getElementById('closeModalBtn');
        const modalDeptName = document.getElementById('modalDeptName');
        const employeeListUl = document.getElementById('employeeList');
        
        let currentDeptId = null; 
        let currentDeptName = null;
        let currentManagerName = null; 

        const contextPath = '${pageContext.request.contextPath}';

        function showDeptModal(deptId, deptName, managerName) {
            currentDeptId = deptId;
            currentDeptName = deptName;
            currentManagerName = managerName; 
            
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

                    // 부서장 맨 위로 정렬
                    data.sort(function(a, b) {
                        if (a.empName === currentManagerName) return -1;
                        if (b.empName === currentManagerName) return 1;
                        if (a.gradeNo && b.gradeNo) {
                            return Number(a.gradeNo) - Number(b.gradeNo);
                        }
                        return 0;
                    });

                    $.each(data, function(index, emp) {
                        let imgSrc = emp.empImage 
                                     ? contextPath + '/upload/emp/' + emp.empImage 
                                     : contextPath + '/images/default_profile.png';
                        let jobTitle = emp.jobTitle ? emp.jobTitle : '사원';
                        
                        let isManager = (emp.empName === currentManagerName);
                        let nameStyle = isManager ? "font-weight:bold; color:#0056b3;" : "";

                        let html = `
                            <li class="emp-item" onclick="goToEmployeeMgmt('\${emp.empNo}')">
                                <img src="\${imgSrc}" class="emp-thumb" alt="프로필">
                                <div class="emp-details">
                                    <span class="emp-name" style="\${nameStyle}">\${emp.empName} \${isManager ? '(부서장)' : ''}</span>
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
            location.href = `${pageContext.request.contextPath}/emp/list?autoSelectEmpNo=\${empId}`;
        }

        function goToEmployeeMgmtByDept() {
            if (currentDeptName) {
                location.href = `${pageContext.request.contextPath}/emp/list?keyword=` + encodeURIComponent(currentDeptName);
            } else {
                location.href = `${pageContext.request.contextPath}/emp/list`;
            }
        }
    </script>
</body>
</html>