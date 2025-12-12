<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>부서 조직도</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/attend.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
    /* =========================================
       트리 구조 조직도 전용 스타일
       ========================================= */
    
    .org-chart-container {
        padding: 40px 0;
        display: flex;
        justify-content: center;
        overflow-x: auto; /* 화면 작을 때 스크롤 */
    }

    /* 트리 레이아웃 기본 */
    .tree {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    /* 레벨 1 (CEO) 영역 */
    .level-1 {
        display: flex;
        justify-content: center;
        padding-bottom: 20px;
        position: relative;
    }

    /* CEO 아래 수직선 */
    .level-1::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 50%;
        width: 2px;
        height: 20px;
        background-color: #ccc;
    }

    /* 레벨 2 (본부장급) 컨테이너 - 가로 정렬 */
    .level-2-wrapper {
        display: flex;
        justify-content: center;
        position: relative;
        padding-top: 20px; /* 가로선과의 간격 */
    }

    /* 레벨 2 위의 가로 긴 선 (Branch들을 잇는 선) */
    .level-2-wrapper::before {
        content: '';
        position: absolute;
        top: 0;
        left: 16.66%; /* 첫번째 기둥 중앙 대략적 위치 */
        right: 16.66%; /* 마지막 기둥 중앙 대략적 위치 */
        height: 2px;
        background-color: #ccc;
    }
    
    /* 각 본부(Branch) 영역 */
    .branch {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin: 0 15px; /* 본부 간 간격 */
        position: relative;
        width: 300px; /* 각 본부 너비 고정 (균형 유지를 위해) */
    }

    /* 본부 머리 위 수직선 (가로선과 연결) */
    .branch::before {
        content: '';
        position: absolute;
        top: -20px;
        left: 50%;
        width: 2px;
        height: 20px;
        background-color: #ccc;
    }

    /* 레벨 3 (팀원들) 그리드 영역 */
    .level-3-wrapper {
        display: flex;
        flex-wrap: wrap; /* 2줄로 꺾이게 */
        justify-content: center;
        margin-top: 20px;
        position: relative;
        width: 100%;
    }

    /* 본부장과 팀원 사이 연결선 */
    .level-3-wrapper::before {
        content: '';
        position: absolute;
        top: -20px;
        left: 50%;
        width: 2px;
        height: 20px;
        background-color: #ccc;
    }
    
    /* 가로선 (팀들 머리 위) */
    .level-3-wrapper::after {
        content: '';
        position: absolute;
        top: 0;
        left: 20%; 
        right: 20%;
        height: 2px;
        background-color: #ccc;
    }

    /* =========================================
       노드(카드) 디자인
       ========================================= */
    .org-node {
        background-color: #fff;
        border: 1px solid #e3e6f0;
        border-radius: 12px;
        padding: 15px;
        width: 140px; /* 카드 크기 */
        text-align: center;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        position: relative;
        z-index: 2; /* 선보다 위에 오도록 */
    }

    .org-node:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 15px rgba(0,0,0,0.2);
        border-color: #4e73df;
    }

    /* CEO 스타일 */
    .ceo-node {
        width: 180px;
        height: auto;
        border: 2px solid #f6c23e;
        background-color: #fffdf5;
    }
    .ceo-node .position { color: #d4a017; font-weight: bold; }

    /* 본부장(Level 2) 스타일 */
    .head-node {
        width: 160px;
        border-top: 4px solid #4e73df; /* 파란색 포인트 */
    }
    
    /* 팀(Level 3) 스타일 */
    .team-node {
        margin: 10px; /* 팀 카드 간격 */
        width: 120px;
        font-size: 0.9em;
        position: relative;
    }
    
    /* 팀 노드 위로 올라가는 작은 선 */
    .team-node::before {
        content: '';
        position: absolute;
        top: -12px; /* 위쪽 마진 + 보더 두께 고려 */
        left: 50%;
        width: 2px;
        height: 12px;
        background-color: #ccc;
    }

    /* 프로필 이미지 */
    .profile-pic {
        width: 60px; height: 60px;
        border-radius: 50%;
        overflow: hidden;
        margin: 0 auto 10px;
        border: 2px solid #eaecf4;
        background-color: #fff;
    }
    .profile-pic img { width: 100%; height: 100%; object-fit: cover; }
    
    .ceo-node .profile-pic { width: 80px; height: 80px; border-color: #f6c23e; }

    /* 텍스트 */
    .dept-name { font-weight: 800; color: #333; margin-bottom: 4px; font-size: 15px; }
    .position { font-size: 12px; color: #888; margin-bottom: 2px; }
    .manager-name { font-size: 14px; font-weight: bold; color: #4e73df; }


    /* =========================================
       모달 스타일
       ========================================= */
    #deptInfoModal {
        display: none; position: fixed; z-index: 9999;
        left: 0; top: 0; width: 100%; height: 100%;
        overflow: auto; background-color: rgba(0, 0, 0, 0.6);
        backdrop-filter: blur(2px);
    }
    .modal-content-custom {
        background-color: #fff; margin: 5% auto;
        border-radius: 10px; width: 90%; max-width: 500px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.3); animation: slideDown 0.3s;
    }
    @keyframes slideDown { from {transform: translateY(-50px); opacity: 0;} to {transform: translateY(0); opacity: 1;} }
    .modal-header-custom {
        padding: 15px 20px; background-color: #4e73df; color: white;
        border-top-left-radius: 10px; border-top-right-radius: 10px;
        display: flex; justify-content: space-between; align-items: center;
    }
    .close-btn { cursor: pointer; font-size: 24px; }
    .modal-body-custom { padding: 20px; min-height: 150px;}
    
    /* 리스트 스타일 */
    #employeeList { list-style: none; padding: 0; margin: 0; }
    .emp-item { display: flex; align-items: center; padding: 10px; border-bottom: 1px solid #eee; cursor: pointer; }
    .emp-item:hover { background-color: #f8f9fc; }
    .emp-thumb { width: 45px; height: 45px; border-radius: 50%; margin-right: 15px; border:1px solid #ddd; object-fit: cover;}
    .btn-manage-custom { width: 100%; padding: 12px; background: #4e73df; color: white; border: none; border-bottom-left-radius: 10px; border-bottom-right-radius: 10px; cursor: pointer; font-size: 16px; }
    .btn-manage-custom:hover { background: #2e59d9; }
</style>
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
                            
                            <div class="org-chart-container">
                                <div class="tree">

                                    <div class="level-1">
                                        <c:forEach var="dept" items="${deptList}">
                                            <c:if test="${dept.deptNo == 1001}">
                                                <div class="org-node ceo-node" onclick="showDeptModal('${dept.deptNo}', '${dept.deptName}')">
                                                    <div class="profile-pic">
                                                        <img src="${not empty dept.managerImage ? dept.managerImage : pageContext.request.contextPath.concat('/images/default_profile.png')}" alt="CEO">
                                                    </div>
                                                    <div class="node-info">
                                                        <div class="dept-name">${dept.deptName}</div>
                                                        <div class="manager-name">${dept.managerName}</div>
                                                        <div class="position">CEO</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>

                                    <div class="level-2-wrapper">

                                        <div class="branch">
                                            <c:forEach var="dept" items="${deptList}">
                                                <c:if test="${dept.deptNo == 3000}">
                                                    <div class="org-node head-node" onclick="showDeptModal('${dept.deptNo}', '${dept.deptName}')">
                                                        <div class="profile-pic">
                                                            <img src="${not empty dept.managerImage ? dept.managerImage : pageContext.request.contextPath.concat('/images/default_profile.png')}" alt="CTO">
                                                        </div>
                                                        <div class="node-info">
                                                            <div class="dept-name">${dept.deptName}</div>
                                                            <div class="manager-name">${dept.managerName}</div>
                                                            <div class="position">CTO</div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                            
                                            <div class="level-3-wrapper">
                                                <c:forEach var="sub" items="${deptList}">
                                                    <c:if test="${sub.parentDeptNo == 3000}">
                                                        <div class="org-node team-node" onclick="showDeptModal('${sub.deptNo}', '${sub.deptName}')">
                                                            <div class="dept-name">${sub.deptName}</div>
                                                            <div class="manager-name">${sub.managerName}</div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </div> 
                                        <div class="branch">
                                            <c:forEach var="dept" items="${deptList}">
                                                <c:if test="${dept.deptNo == 2000}">
                                                    <div class="org-node head-node" onclick="showDeptModal('${dept.deptNo}', '${dept.deptName}')">
                                                        <div class="profile-pic">
                                                            <img src="${not empty dept.managerImage ? dept.managerImage : pageContext.request.contextPath.concat('/images/default_profile.png')}" alt="COO">
                                                        </div>
                                                        <div class="node-info">
                                                            <div class="dept-name">${dept.deptName}</div>
                                                            <div class="manager-name">${dept.managerName}</div>
                                                            <div class="position">COO</div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>

                                            <div class="level-3-wrapper">
                                                <c:forEach var="sub" items="${deptList}">
                                                    <c:if test="${sub.parentDeptNo == 2000}">
                                                        <div class="org-node team-node" onclick="showDeptModal('${sub.deptNo}', '${sub.deptName}')">
                                                            <div class="dept-name">${sub.deptName}</div>
                                                            <div class="manager-name">${sub.managerName}</div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="branch">
                                            <c:forEach var="dept" items="${deptList}">
                                                <c:if test="${dept.deptNo == 4000}">
                                                    <div class="org-node head-node" onclick="showDeptModal('${dept.deptNo}', '${dept.deptName}')">
                                                        <div class="profile-pic">
                                                            <img src="${not empty dept.managerImage ? dept.managerImage : pageContext.request.contextPath.concat('/images/default_profile.png')}" alt="CBO">
                                                        </div>
                                                        <div class="node-info">
                                                            <div class="dept-name">${dept.deptName}</div>
                                                            <div class="manager-name">${dept.managerName}</div>
                                                            <div class="position">CBO</div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>

                                            <div class="level-3-wrapper">
                                                <c:forEach var="sub" items="${deptList}">
                                                    <c:if test="${sub.parentDeptNo == 4000}">
                                                        <div class="org-node team-node" onclick="showDeptModal('${sub.deptNo}', '${sub.deptName}')">
                                                            <div class="dept-name">${sub.deptName}</div>
                                                            <div class="manager-name">${sub.managerName}</div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        </div> </div> </div> </div>
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
        // 기존 JS 로직 유지 (AJAX, 모달 등)
        const modal = document.getElementById('deptInfoModal');
        const closeModalBtn = document.getElementById('closeModalBtn');
        const modalDeptName = document.getElementById('modalDeptName');
        const employeeListUl = document.getElementById('employeeList');
        let currentDeptId = null; 

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
                url: '${pageContext.request.contextPath}/dept/api/employees', 
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
                        let imgSrc = emp.empImage ? emp.empImage : '${pageContext.request.contextPath}/images/default_profile.png';
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