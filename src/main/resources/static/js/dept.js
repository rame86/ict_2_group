/* dept.js - 전체 완성본 */

// 전역 변수 초기화
let currentDeptId = null;
let currentDeptName = null;
let currentManagerName = null;
let currentDeptMembers = [];

// DOM 요소 캐싱
const modal = document.getElementById('deptInfoModal');
const modalDeptName = document.getElementById('modalDeptName');
const employeeListUl = document.getElementById('employeeList');

/* =========================================
   1. 부서 정보 모달 (조회)
   ========================================= */
function showDeptModal(deptId, deptName, managerName) {
    currentDeptId = deptId;
    currentDeptName = deptName;
    currentManagerName = managerName;

    if (modalDeptName) modalDeptName.textContent = deptName;

    const header = document.querySelector('#deptInfoModal .modal-header-custom');
    let appointBtnHtml = '';

    if (!currentManagerName && typeof canCreateAuth !== 'undefined' && canCreateAuth) {
        appointBtnHtml = `
            <button class="btn-xs" style="margin-left:auto; margin-right:10px; background:#fff; color:#4e73df; border:none; border-radius:4px; font-weight:bold; cursor:pointer;" 
                    onclick="openAppointModal()">
                + 부서장 임명
            </button>
        `;
    }

    if (header) {
        header.innerHTML = `
            <h5 style="margin:0;">${deptName}</h5>
            ${appointBtnHtml}
            <span id="closeModalBtn" class="close-btn" onclick="closeModal()">&times;</span>
        `;
    }

    if (modal) {
        modal.style.display = 'block';
        document.body.style.overflow = 'hidden';
    }

    if (employeeListUl) {
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
            if (employeeListUl) employeeListUl.innerHTML = '';
            currentDeptMembers = data || [];

            if (!data || data.length === 0) {
                if (employeeListUl) employeeListUl.innerHTML = '<li style="text-align:center; padding:20px; color:#888;">소속된 사원이 없습니다.</li>';
                return;
            }

            data.sort(function(a, b) {
                if (a.empName === currentManagerName) return -1;
                if (b.empName === currentManagerName) return 1;
                if (a.gradeNo && b.gradeNo) return Number(a.gradeNo) - Number(b.gradeNo);
                return 0;
            });

            $.each(data, function(index, emp) {
                let imgSrc = emp.empImage ? contextPath + '/upload/emp/' + emp.empImage : contextPath + '/images/default_profile.png';
                let jobTitle = emp.jobTitle ? emp.jobTitle : '사원';
                let isManager = (emp.empName === currentManagerName);
                let nameStyle = isManager ? "font-weight:bold; color:#0056b3;" : "";

                let btnHtml = '';

                if (isManager) {
                    if (typeof canCreateAuth !== 'undefined' && canCreateAuth) {
                        btnHtml = `
                            <div class="emp-actions" style="display:flex; align-items:center;">
                                <span style="font-size:11px; color:#fff; background:#4e73df; padding:2px 6px; border-radius:4px; margin-right:5px;">MANAGER</span>
                                <button class="btn-xs" style="background:#e74a3b; color:#fff; border:none; border-radius:4px; padding:2px 6px; cursor:pointer;" 
                                        onclick="submitDismissManager(event, '${emp.empNo}', '${emp.empName}')">
                                    해임
                                </button>
                            </div>
                        `;
                    } else {
                        btnHtml = `<span style="font-size:11px; color:#fff; background:#4e73df; padding:2px 6px; border-radius:4px; margin-left:auto;">MANAGER</span>`;
                    }
                } else {
                    if (typeof canMoveAuth !== 'undefined' && canMoveAuth) {
                        btnHtml = `
                            <div class="emp-actions">
                                <button class="btn-xs btn-move" onclick="openMoveModal(event, '${emp.empNo}', '${emp.empName}')">이동</button>
                                <button class="btn-xs btn-exclude" onclick="submitExcludeEmp(event, '${emp.empNo}', '${emp.empName}')">제외</button>
                            </div>
                        `;
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
                if (employeeListUl) employeeListUl.insertAdjacentHTML('beforeend', html);
            });
        },
        error: function() {
            if (employeeListUl) employeeListUl.innerHTML = '<li style="text-align:center; color:red; padding:20px;">데이터 로드 실패</li>';
        }
    });
}

function closeModal() {
    if (modal) modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

function goToEmployeeMgmt(empId) {
    if (typeof canViewAuth !== 'undefined' && canViewAuth) {
        location.href = `${contextPath}/emp/list?autoSelectEmpNo=${empId}`;
    }
}

function goToEmployeeMgmtByDept() {
    if (typeof canViewAuth !== 'undefined' && canViewAuth) {
        if (currentDeptName) location.href = `${contextPath}/emp/list?keyword=` + encodeURIComponent(currentDeptName);
        else location.href = `${contextPath}/emp/list`;
    } else {
         alert("조회 권한이 없습니다.");
    }
}

/* =========================================
   2. 부서장 임명 & 해임 (결재 연동)
   ========================================= */
function openAppointModal() {
    if (!canCreateAuth) { alert("권한이 없습니다."); return; }
    const select = document.getElementById('appointEmpSelect');
    select.innerHTML = '<option value="">사원을 선택하세요</option>';

    if (currentDeptMembers && currentDeptMembers.length > 0) {
        currentDeptMembers.forEach(emp => {
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

function closeAppointModal() { $('#deptAppointModal').hide(); }

function submitAppointManager() {
    const empNo = $('#appointEmpSelect').val();
    const empInfoText = $('#appointEmpSelect option:selected').text();
    if (!empNo) { alert("임명할 사원을 선택해주세요."); return; }
    closeAppointModal();
    openDraftModal(empNo, empInfoText, 6);
}

function submitDismissManager(e, empNo, empName) {
    e.stopPropagation();
    if (!canCreateAuth) { alert("권한이 없습니다."); return; }
    if (!confirm(`[${empName}] 님을 부서장에서 해임하시겠습니까?\n결재 기안 창으로 이동합니다.`)) return;
    openDraftModal(empNo, empName, 7);
}

function openDraftModal(empNo, empName, type) {
    $('#draftTargetEmpNo').val(empNo);
    $('#draftTargetDeptNo').val(currentDeptId);
    let docTypeInput = $('input[name="DocType"]');
    if (docTypeInput.length > 0) docTypeInput.val(type);
    else $('#finalApprovalForm').append(`<input type="hidden" name="DocType" value="${type}">`);

    const now = new Date();
    const todayString = now.toISOString().split('T')[0];
    $('#draftDocDate').val(todayString);

    let title = (type === 6) ? `[인사발령] ${currentDeptName} 부서장 임명 건` : `[인사발령] ${currentDeptName} 부서장 해임 건`;
    let content = `1. 귀 부서의 무궁한 발전을 기원합니다.\n2. 아래와 같이 부서장 ${type === 6 ? '임명' : '해임'}을 명하고자 하오니 재가 바랍니다.\n\n- 부서명 : ${currentDeptName}\n- 대상자 : ${empName}\n- ${type === 6 ? '발령일' : '해임일'} : ${todayString}\n\n위와 같이 부서장 ${type === 6 ? '임명' : '해임'}을 품의합니다.`;

    $('#draftTitle').val(title);
    $('#draftContent').val(content);
    $('#approvalDraftModal').show();
}

function closeDraftModal() { $('#approvalDraftModal').hide(); }

function submitFinalApproval() {
    if (!confirm("작성된 내용으로 결재를 상신하시겠습니까?")) return;
    const formData = $('#finalApprovalForm').serialize();
    $.ajax({
        url: contextPath + '/approve/approve-ajax',
        type: 'POST',
        data: formData,
        success: function(res) {
            alert("결재가 상신되었습니다.");
            location.reload();
        },
        error: function() { alert("서버 통신 오류"); }
    });
}

/* =========================================
   3. 부서 생성 / 삭제 / 수정 (관리자)
   ========================================= */
function openCreateModal() { $('#deptCreateModal').show(); }
function closeCreateModal() { $('#deptCreateModal').hide(); }

function openDeleteModal() { $('#deptDeleteModal').show(); }
function closeDeleteModal() { $('#deptDeleteModal').hide(); }

function openUpdateModal() { $('#deptUpdateModal').show(); }
function closeUpdateModal() { $('#deptUpdateModal').hide(); }

function submitCreateDept() {
    const formData = $('#createDeptForm').serialize();
    $.ajax({
        url: contextPath + '/dept/create',
        type: 'POST',
        data: formData,
        success: function(res) {
            if (res === "OK") { alert("부서 생성됨"); location.reload(); }
            else { alert("생성 실패"); }
        }
    });
}

// [수정] 부서 삭제 시 안전장치 강화
function submitDeleteDept() {
    const select = document.getElementById('deleteDeptSelect');
    const targetDeptNo = select.value;
    if (!targetDeptNo) { alert("부서 선택 필요"); return; }

    // 1. [핵심] 클라이언트 측 안전장치 체크
    const selectedOption = select.options[select.selectedIndex];
    const managerNo = selectedOption.getAttribute('data-manager');

    if (managerNo && managerNo !== '0' && managerNo !== 'null' && managerNo !== '') {
        alert("해당 부서에 부서장이 임명되어 있습니다.\n부서장을 먼저 해임한 후 삭제해 주세요.");
        return;
    }

    if (!confirm("정말 이 부서를 삭제하시겠습니까?\n해당 부서원들은 '무소속' 처리됩니다.")) return;

    $.ajax({
        url: contextPath + '/dept/delete',
        type: 'POST',
        data: { deptNo: targetDeptNo },
        success: function(res) {
            if (res === "OK") { alert("부서가 삭제되었습니다."); location.reload(); }
            else if (res === "HAS_MANAGER") { alert("서버 확인 결과: 부서장이 존재하여 삭제할 수 없습니다."); }
            else if (res === "PROTECTED") { alert("핵심 부서는 삭제할 수 없습니다."); }
            else { alert("삭제 실패 또는 권한 없음"); }
        },
        error: function() { alert("오류 발생"); }
    });
}

function fillUpdateForm(selectObj) {
    const selectedOption = selectObj.options[selectObj.selectedIndex];
    if (!selectedOption.value) { $('#updateDeptForm')[0].reset(); return; }
    $('#editDeptNo').val(selectedOption.value);
    $('#editDeptName').val(selectedOption.getAttribute('data-name'));
    $('#editParentDeptNo').val(selectedOption.getAttribute('data-parent') == '0' ? '' : selectedOption.getAttribute('data-parent'));
    $('#editDeptPhone').val(selectedOption.getAttribute('data-phone') === 'null' ? '' : selectedOption.getAttribute('data-phone'));
    $('#editManagerEmpNo').val(selectedOption.getAttribute('data-manager') === '0' || selectedOption.getAttribute('data-manager') === 'null' ? '' : selectedOption.getAttribute('data-manager'));
}

function submitUpdateDept() {
    const formData = $('#updateDeptForm').serialize();
    $.ajax({
        url: contextPath + '/dept/update',
        type: 'POST',
        data: formData,
        success: function(res) {
            if (res === "OK") { alert("정보 수정됨"); location.reload(); }
            else { alert("수정 실패"); }
        }
    });
}

/* =========================================
   4. 사원 이동/제외
   ========================================= */
function submitExcludeEmp(e, empNo, empName) {
    e.stopPropagation();
    if (!confirm(`[${empName}] 제외하시겠습니까?`)) return;
    ajaxChangeDept(empNo, 0);
}

function openMoveModal(e, empNo, empName) {
    e.stopPropagation();
    $('#moveTargetName').text(`대상자: ${empName}`);
    $('#moveTargetEmpNo').val(empNo);
    $('#deptMoveModal').show();
}
function closeMoveModal() { $('#deptMoveModal').hide(); }

function submitMoveEmp() {
    const empNo = $('#moveTargetEmpNo').val();
    const newDeptNo = $('#moveDeptSelect').val();
    if (newDeptNo == currentDeptId) { alert("같은 부서입니다."); return; }
    ajaxChangeDept(empNo, newDeptNo);
}

function ajaxChangeDept(empNo, newDeptNo) {
    $.ajax({
        url: contextPath + '/dept/moveEmp',
        type: 'POST',
        data: { empNo: empNo, newDeptNo: newDeptNo },
        success: function(res) {
            if (res === "OK") { alert("처리됨"); closeMoveModal(); loadEmployeeList(currentDeptId); }
            else { alert("권한 없음/실패"); }
        }
    });
}

/* =========================================
   5. 모달 외부 클릭 닫기 (스크롤 잠금 해제 포함)
   ========================================= */
window.onclick = function(event) {
    const modalIds = [
        'deptInfoModal', 'deptCreateModal', 'deptDeleteModal', 
        'deptMoveModal', 'deptAppointModal', 'approvalDraftModal', 
        'deptUpdateModal'
    ];
    
    modalIds.forEach(id => {
        const modalEl = document.getElementById(id);
        if (event.target === modalEl) {
            modalEl.style.display = 'none';
            // [중요] 배경 클릭으로 닫을 때도 반드시 스크롤을 활성화합니다.
            document.body.style.overflow = 'auto'; 
        }
    });
}