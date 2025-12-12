/* dept.js */

// 전역 변수
let currentDeptId = null; 
let currentDeptName = null;
let currentManagerName = null; 
let currentDeptMembers = []; // 🔹 부서원 목록 저장용 (임명 모달에서 사용)

// DOM 요소
const modal = document.getElementById('deptInfoModal');
const closeModalBtn = document.getElementById('closeModalBtn');
const modalDeptName = document.getElementById('modalDeptName');
const employeeListUl = document.getElementById('employeeList');

/* =========================================
   1. 부서 정보 모달 & 사원 리스트
   ========================================= */

function showDeptModal(deptId, deptName, managerName) {
    currentDeptId = deptId;
    currentDeptName = deptName;
    currentManagerName = managerName; // 없으면 빈 문자열('')이나 null
    
    if(modalDeptName) modalDeptName.textContent = deptName;
    
    // 🔹 [추가] 부서장이 없는 경우 + 관리자 권한이면 '부서장 임명' 버튼 표시
    // 기존 헤더 내용을 초기화 후 다시 그림
    const header = document.querySelector('#deptInfoModal .modal-header-custom');
    let appointBtnHtml = '';
    
    // 부서장이 없고(빈값) && 관리자라면
    if (!currentManagerName && isAdminUser) {
        appointBtnHtml = `
            <button class="btn-xs" style="margin-left:auto; margin-right:10px; background:#fff; color:#4e73df; border:none; border-radius:4px; font-weight:bold; cursor:pointer;" 
                    onclick="openAppointModal()">
                + 부서장 임명
            </button>
        `;
    }

    // 헤더 HTML 재구성 (제목 + 임명버튼 + 닫기버튼)
    header.innerHTML = `
        <h5 style="margin:0;">${deptName}</h5>
        ${appointBtnHtml}
        <span id="closeModalBtn" class="close-btn" onclick="closeModal()">&times;</span>
    `;

    if(modal) {
        modal.style.display = 'block';
        document.body.style.overflow = 'hidden'; 
    }
    
    if(employeeListUl) {
        employeeListUl.innerHTML = '<li style="text-align:center; padding:20px; color:#666;">데이터를 불러오는 중입니다...</li>';
    }
    
    loadEmployeeList(deptId); 
}

function loadEmployeeList(deptId) {
    $.ajax({
        url: contextPath + '/dept/api/employees', 
        type: 'GET',
        data: { deptNo: deptId }, 
        dataType: 'json',
        success: function(data) {
            if(employeeListUl) employeeListUl.innerHTML = ''; 
            
            // 🔹 데이터 저장 (임명 모달 select box 채우기 용도)
            currentDeptMembers = data || [];
            
            if (!data || data.length === 0) {
                if(employeeListUl) employeeListUl.innerHTML = '<li style="text-align:center; padding:20px; color:#888;">소속된 사원이 없습니다.</li>';
                return;
            }

            // 정렬: 부서장 1순위 -> 직급순
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
             
                // 🔹 [수정] 관리자 버튼 생성 로직
                let btnHtml = '';
                if (isAdminUser) {
                    // ⚠️ 조건 추가: 부서장(isManager)이 아닐 때만 버튼 표시
                    if (!isManager) {
                        btnHtml = `
                            <div class="emp-actions">
                                <button class="btn-xs btn-move" onclick="openMoveModal(event, '${emp.empNo}', '${emp.empName}')">이동</button>
                                <button class="btn-xs btn-exclude" onclick="submitExcludeEmp(event, '${emp.empNo}', '${emp.empName}')">제외</button>
                            </div>
                        `;
                    } else {
                        // 부서장은 버튼 대신 뱃지 표시 (선택사항)
                        btnHtml = `<span style="font-size:11px; color:#fff; background:#4e73df; padding:2px 6px; border-radius:4px; margin-left:auto;">MANAGER</span>`;
                    }
                }
                
                let html = `
                    <li class="emp-item" onclick="goToEmployeeMgmt('${emp.empNo}')">
                        <img src="${imgSrc}" class="emp-thumb" alt="프로필">
                        <div class="emp-details">
                            <span class="emp-name" style="${nameStyle}">${emp.empName}</span>
                            <span class="position" style="font-size:12px;">${jobTitle}</span>
                        </div>
                        ${btnHtml}
                    </li>
                `;
                if(employeeListUl) employeeListUl.insertAdjacentHTML('beforeend', html);
            });
        },
        error: function() {
            if(employeeListUl) employeeListUl.innerHTML = '<li style="text-align:center; color:red; padding:20px;">데이터 로드 실패</li>';
        }
    });
}

function closeModal() {
    if(modal) modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

function goToEmployeeMgmt(empId) {
    location.href = `${contextPath}/emp/list?autoSelectEmpNo=${empId}`;
}

function goToEmployeeMgmtByDept() {
    if (currentDeptName) {
        location.href = `${contextPath}/emp/list?keyword=` + encodeURIComponent(currentDeptName);
    } else {
        location.href = `${contextPath}/emp/list`;
    }
}


/* =========================================
   2. 부서장 임명 (전자결재 연동)
   ========================================= */

// 임명 모달 열기
function openAppointModal() {
    // 1. 셀렉트 박스 초기화
    const select = document.getElementById('appointEmpSelect');
    select.innerHTML = '<option value="">사원을 선택하세요</option>';
    
    // 2. 현재 부서원들로 옵션 채우기
    if (currentDeptMembers && currentDeptMembers.length > 0) {
        currentDeptMembers.forEach(emp => {
            // 이미 부서장인 사람은 제외(어차피 없겠지만)
            let option = document.createElement('option');
            option.value = emp.empNo;
            option.text = `${emp.empName} (${emp.jobTitle || '사원'})`;
            select.appendChild(option);
        });
    } else {
        let option = document.createElement('option');
        option.text = "부서원이 없습니다.";
        option.disabled = true;
        select.appendChild(option);
    }

    $('#deptAppointModal').show();
}

function closeAppointModal() {
    $('#deptAppointModal').hide();
}

// 결재 요청 전송 (Form Submit)
function submitAppointManager() {
    const empNo = $('#appointEmpSelect').val();
    
    if (!empNo) {
        alert("임명할 사원을 선택해주세요.");
        return;
    }

    if (!confirm("선택한 사원을 부서장으로 임명하는 결재를 진행하시겠습니까?")) {
        return;
    }

    // 1. 폼 데이터 세팅
    $('#apprEmpNo').val(empNo);
    $('#apprDeptNo').val(currentDeptId);

    // 2. 성공 메시지 표시
    alert("결재 기안 페이지로 이동합니다.");

    // 3. 모달 닫기
    closeAppointModal();
    closeModal(); // 부서 정보 모달도 닫기

    // 4. 폼 전송 (화면 이동)
    $('#approveRequestForm').submit();
}


/* =========================================
   3. 부서 생성 / 삭제 모달
   ========================================= */

function openCreateModal() { $('#deptCreateModal').show(); }
function closeCreateModal() { $('#deptCreateModal').hide(); }

function openDeleteModal() { $('#deptDeleteModal').show(); }
function closeDeleteModal() { $('#deptDeleteModal').hide(); }

function submitCreateDept() {
    const formData = $('#createDeptForm').serialize();
    if(!$('input[name="deptNo"]').val() || !$('input[name="deptName"]').val()) {
        alert("부서 번호와 이름은 필수입니다.");
        return;
    }
    $.ajax({
        url: contextPath + '/dept/create',
        type: 'POST',
        data: formData,
        success: function(res) {
            if(res === "OK") {
                alert("부서가 생성되었습니다.");
                location.reload(); 
            } else {
                alert("부서 생성 실패 (중복된 번호 등 확인 필요)");
            }
        },
        error: function() { alert("서버 오류 발생"); }
    });
}

function submitDeleteDept() {
    const targetDeptNo = $('#deleteDeptSelect').val();
    if(!targetDeptNo) {
        alert("삭제할 부서를 선택해주세요.");
        return;
    }
    if(!confirm("정말로 삭제하시겠습니까?\n해당 부서원은 모두 무소속이 됩니다.")) {
        return;
    }
    $.ajax({
        url: contextPath + '/dept/delete',
        type: 'POST',
        data: { deptNo: targetDeptNo },
        success: function(res) {
            if(res === "OK") {
                alert("부서가 삭제되고 부서원들이 무소속 처리되었습니다.");
                location.reload();
            } else if (res === "PROTECTED") {
                alert("해당 부서는 핵심 조직이므로 삭제할 수 없습니다.");
            } else {
                alert("부서 삭제 실패");
            }
        },
        error: function() { alert("서버 오류 발생"); }
    });
}


/* =========================================
   4. 사원 이동 / 제외 기능
   ========================================= */

function submitExcludeEmp(e, empNo, empName) {
    e.stopPropagation(); 
    if(!confirm(`[${empName}] 사원을 현재 부서에서 제외하시겠습니까?\n(부서 없음 상태로 변경됩니다)`)) {
        return;
    }
    ajaxChangeDept(empNo, 0); 
}

function openMoveModal(e, empNo, empName) {
    e.stopPropagation(); 
    $('#moveTargetName').text(`대상자: ${empName}`);
    $('#moveTargetEmpNo').val(empNo);
    $('#deptMoveModal').show();
}

function closeMoveModal() {
    $('#deptMoveModal').hide();
}

function submitMoveEmp() {
    const empNo = $('#moveTargetEmpNo').val();
    const newDeptNo = $('#moveDeptSelect').val();

    if(newDeptNo == currentDeptId) {
        alert("현재 부서와 동일합니다.");
        return;
    }
    ajaxChangeDept(empNo, newDeptNo);
}

function ajaxChangeDept(empNo, newDeptNo) {
    $.ajax({
        url: contextPath + '/dept/moveEmp',
        type: 'POST',
        data: { empNo: empNo, newDeptNo: newDeptNo },
        success: function(res) {
            if(res === "OK") {
                alert("처리되었습니다.");
                closeMoveModal();
                loadEmployeeList(currentDeptId); 
            } else if(res === "NO_AUTH") {
                alert("권한이 없습니다.");
            } else {
                alert("처리 실패");
            }
        },
        error: function() { alert("서버 오류 발생"); }
    });
}

// 모달 외부 클릭 시 닫기
window.onclick = function(event) {
    const infoM = document.getElementById('deptInfoModal');
    const createM = document.getElementById('deptCreateModal');
    const deleteM = document.getElementById('deptDeleteModal');
    const moveM = document.getElementById('deptMoveModal');
    const appointM = document.getElementById('deptAppointModal'); // 추가됨
    
    if (event.target == infoM) closeModal();
    if (event.target == createM) closeCreateModal();
    if (event.target == deleteM) closeDeleteModal();
    if (event.target == moveM) closeMoveModal();
    if (event.target == appointM) closeAppointModal();
}