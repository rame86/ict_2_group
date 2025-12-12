<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>dept.jsp</title>
<link rel="stylesheet" href="/css/attend.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="#"></script>

</head>
<body>
	<div id="container">
		<h1>부서 관리 조직도</h1>

		<div id="organizationChart">

			<div id="ceoNode" class="org-node" data-dept-id="D001"
				onclick="showDeptModal('D001', '최고 경영진')">
				<div class="profile-pic">
					<img src="db_image_path/ceo.jpg" alt="CEO 사진">
				</div>
				<div class="node-info">
					<div class="position">Position</div>
					<div>Name/Surname</div>
				</div>
			</div>

			<div class="team-row">
				<div id="teamANode" class="org-node" data-dept-id="D100"
					onclick="showDeptModal('D100', 'Team A')">
					<div class="profile-pic">
						<img src="db_image_path/team_a_head.jpg" alt="Team A 팀장 사진">
					</div>
					<div class="node-info">
						<div class="position">Team A Position</div>
						<div>Name/Surname</div>
					</div>
				</div>

				<div id="teamBNode" class="org-node" data-dept-id="D200"
					onclick="showDeptModal('D200', 'Team B')">
					<div class="profile-pic">
						<img src="db_image_path/team_b_head.jpg" alt="Team B 팀장 사진">
					</div>
					<div class="node-info">
						<div class="position">Team B Position</div>
						<div>Name/Surname</div>
					</div>
				</div>

				<div id="teamCNode" class="org-node" data-dept-id="D300"
					onclick="showDeptModal('D300', 'Team C')">
					<div class="profile-pic">
						<img src="db_image_path/team_c_head.jpg" alt="Team C 팀장 사진">
					</div>
					<div class="node-info">
						<div class="position">Team C Position</div>
						<div>Name/Surname</div>
					</div>
				</div>
			</div>

			<div class="team-row" style="margin-top: 15px;">
				<div class="org-node" data-emp-id="E004"
					onclick="goToEmployeeMgmt('E004')">... 사원 1 ...</div>
				<div class="org-node" data-emp-id="E005"
					onclick="goToEmployeeMgmt('E005')">... 사원 2 ...</div>
				<div class="org-node" data-emp-id="E006"
					onclick="goToEmployeeMgmt('E006')">... 사원 3 ...</div>
			</div>

		</div>
		<div id="deptInfoModal">
			<div class="modal-content">
				<span id="closeModalBtn" class="close-btn">&times;</span>
				<h2 id="modalDeptName"></h2>
				<p>부서 상세 정보 (예: 부서장, 연락처, 설명 등) 영역</p>

				<hr>

				<h3>소속 사원 목록</h3>
				<ul id="employeeList">
					<li>클릭 이벤트 후 로딩 대기...</li>
				</ul>

				<button onclick="goToEmployeeMgmtByDept()">사원 관리 페이지로 이동</button>
			</div>
		</div>

	</div>

	<script>
        const modal = document.getElementById('deptInfoModal');
        const closeModalBtn = document.getElementById('closeModalBtn');
        const modalDeptName = document.getElementById('modalDeptName');
        const employeeList = document.getElementById('employeeList');
        let currentDeptId = null; // 현재 모달이 띄워진 부서 ID 저장

        // 1. 조직도 클릭 이벤트 (부서 정보 모달 팝업)
        function showDeptModal(deptId, deptName) {
            currentDeptId = deptId; // 부서 ID 저장
            modalDeptName.textContent = `${deptName} 정보`;
            modal.style.display = 'block';

            // 2. 사원 정보 목록 출력 (Ajax 요청 필요)
            loadEmployeeList(deptId); 
        }

        // 모달 닫기 버튼
        closeModalBtn.onclick = function() {
            modal.style.display = 'none';
        }

        // 모달 외부 클릭 시 닫기
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
        
        // 부서 ID를 기준으로 소속 사원 목록을 DB에서 가져오는 함수 (Ajax/Fetch 사용)
        function loadEmployeeList(deptId) {
            // 실제 구현 시, 이 부분에 Ajax 요청 코드를 작성해야 합니다.
            // 예: fetch('/api/employees?deptId=' + deptId) ...
            
            // 임시 데이터
            const employees = [
                { id: 'E001', name: '김철수' },
                { id: 'E002', name: '이영희' },
                { id: 'E003', name: '박민준' }
            ];

            employeeList.innerHTML = ''; // 기존 목록 초기화
            
            // 목록 출력
            employees.forEach(emp => {
                const li = document.createElement('li');
                li.textContent = emp.name;
                li.setAttribute('data-emp-id', emp.id);
                // 3. 사원 이름 클릭 시 사원 관리 테이블로 이동 및 검색
                li.onclick = () => goToEmployeeMgmt(emp.id); 
                employeeList.appendChild(li);
            });
        }
        
        // 사원 ID를 기준으로 사원 관리 페이지로 이동하며 검색하는 함수
        function goToEmployeeMgmt(empId) {
            // 실제 사원 관리 페이지 URL로 변경해야 합니다.
            // URL 파라미터를 사용하여 검색을 자동 실행
            const employeeMgmtUrl = `/employee/management.jsp?searchType=employeeId&searchValue=${empId}`;
            window.location.href = employeeMgmtUrl;
        }

        // 부서 ID를 기준으로 사원 관리 페이지로 이동하며 해당 부서 전체 검색하는 함수
        function goToEmployeeMgmtByDept() {
            if (currentDeptId) {
                const employeeMgmtUrl = `/employee/management.jsp?searchType=deptId&searchValue=${currentDeptId}`;
                window.location.href = employeeMgmtUrl;
            } else {
                alert('선택된 부서가 없습니다.');
            }
        }

    </script>
	<style>
/* 페이지 전체 레이아웃 */
#container {
	font-family: Arial, sans-serif;
	padding: 20px;
}

/* 조직도 영역 스타일링 */
#organizationChart {
	margin: 50px 0;
	text-align: center;
}

/* 개별 조직원/부서 노드 스타일 */
.org-node {
	display: inline-block;
	margin: 0 20px;
	cursor: pointer; /* 클릭 이벤트 시각적 표시 */
	position: relative;
}

/* 사용자 이미지 원형 스타일 */
.profile-pic {
	width: 80px;
	height: 80px;
	border-radius: 50%; /* 원형 */
	overflow: hidden;
	background-color: #f0f8ff; /* 기본 배경색 */
	margin: 0 auto 5px;
	border: 2px solid #a0c4ff;
}

.profile-pic img {
	width: 100%;
	height: 100%;
	object-fit: cover; /* 이미지 비율 유지 */
}

/* 직책/이름 정보 스타일 */
.node-info {
	font-size: 14px;
	color: #333;
	line-height: 1.2;
}

.node-info .position {
	font-weight: bold;
	color: #1e88e5;
}

/* 조직도 연결선 (복잡하므로 간소화하거나 JS/SVG로 처리하는 것을 권장) */
/* 여기서는 간단히 구조만 표현하고, 실제 선은 JS/CSS로 추가 작업 필요 */

/* 팀 레벨 스타일 */
.team-row {
	display: flex;
	justify-content: center;
	margin-top: 30px;
}

/* 부서 정보 모달 스타일 (초기에는 숨김) */
#deptInfoModal {
	display: none; /* JS로 'block' 처리 */
	position: fixed;
	z-index: 1;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
	background-color: #fff;
	margin: 15% auto; /* 화면 중앙 배치 */
	padding: 20px;
	border: 1px solid #888;
	width: 80%;
	max-width: 500px;
	border-radius: 10px;
	position: relative;
}

.close-btn {
	color: #aaa;
	float: right;
	font-size: 28px;
	font-weight: bold;
}

.close-btn:hover, .close-btn:focus {
	color: black;
	text-decoration: none;
	cursor: pointer;
}

/* 사원 목록 영역 (모달 내부에 배치) */
#employeeList {
	list-style: none;
	padding: 0;
	margin-top: 15px;
}

#employeeList li {
	padding: 8px 0;
	border-bottom: 1px dashed #eee;
	cursor: pointer; /* 사원 이름 클릭 시 이동 이벤트 */
	color: #007bff;
}

#employeeList li:hover {
	text-decoration: underline;
}
</style>
</body>
</html>