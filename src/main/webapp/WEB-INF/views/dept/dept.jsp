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
                                                <div class="org-node ceo" onclick="showDeptModal('${ceo.deptNo}', '${ceo.deptName}')">
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
                                                                <div class="org-node head" onclick="showDeptModal('${sub.deptNo}', '${sub.deptName}')">
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

        // 🔹 [수정 포인트] 사원 클릭 시 /emp/list로 이동하되, empNo 파라미터 전달
        function goToEmployeeMgmt(empId) {
            location.href = `${pageContext.request.contextPath}/emp/list?autoSelectEmpNo=\${empId}`;
        }

        function goToEmployeeMgmtByDept() {
            // 부서별 보기도 동일하게 empList로 가되, 검색 키워드 등을 활용할 수 있음 (여기서는 단순히 이동)
            if (currentDeptId) location.href = `${pageContext.request.contextPath}/emp/list`;
        }
    </script>
</body>
</html>