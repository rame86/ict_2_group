/* dept.js - Clean & Verified Version */

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

    // 헤더 재구성 (관리자일 경우 '부서장 임명' 버튼 노출)
    const header = document.querySelector('#deptInfoModal .modal-header-custom');
    let appointBtnHtml = '';

    // isAdminUser는 JSP 하단 스크립트에서 정의됨
    if (!currentManagerName && typeof isAdminUser !== 'undefined' && isAdminUser) {
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

            // 부서장 맨 위로, 그 다음 직급순 정렬
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

                // 관리자 권한 버튼 로직
                if (typeof isAdminUser !== 'undefined' && isAdminUser) {
                    if (!isManager) {
                        // 일반 사원: 이동/제외 버튼
                        btnHtml = `
                            <div class="emp-actions">
                                <button class="btn-xs btn-move" onclick="openMoveModal(event, '${emp.empNo}', '${emp.empName}')">이동</button>
                                <button class="btn-xs btn-exclude" onclick="submitExcludeEmp(event, '${emp.empNo}', '${emp.empName}')">제외</button>
                            </div>
                        `;
                    } else {
                        // 부서장: MANAGER 뱃지 + [해임] 버튼
                        btnHtml = `
                            <div class="emp-actions" style="display:flex; align-items:center;">
                                <span style="font-size:11px; color:#fff; background:#4e73df; padding:2px 6px; border-radius:4px; margin-right:5px;">MANAGER</span>
                                <button class="btn-xs" style="background:#e74a3b; color:#fff; border:none; border-radius:4px; padding:2px 6px; cursor:pointer;" 
                                        onclick="submitDismissManager(event, '${emp.empNo}', '${emp.empName}')">
                                    해임
                                </button>
                            </div>
                        `;
                    }
                } else {
                    // 일반 사용자
                    if (isManager) {
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
    location.href = `${contextPath}/emp/list?autoSelectEmpNo=${empId}`;
}

function goToEmployeeMgmtByDept() {
    if (currentDeptName) location.href = `${contextPath}/emp/list?keyword=` + encodeURIComponent(currentDeptName);
    else location.href = `${contextPath}/emp/list`;
}


/* =========================================
   2. 부서장 임명 & 해임 (결재 연동)
   ========================================= */
function openAppointModal() {
    if (!isAdminUser) { alert("권한이 없습니다."); return; }

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
    // type 6: 임명
    openDraftModal(empNo, empInfoText, 6);
}

function submitDismissManager(e, empNo, empName) {
    e.stopPropagation();
    if (!isAdminUser) { alert("권한이 없습니다."); return; }
    if (!confirm(`[${empName}] 님을 부서장에서 해임하시겠습니까?\n결재 기안 창으로 이동합니다.`)) return;

    // type 7: 해임
    openDraftModal(empNo, empName, 7);
}

function openDraftModal(empNo, empName, type) {
    $('#draftTargetEmpNo').val(empNo);
    $('#draftTargetDeptNo').val(currentDeptId);
    $('#draftDeptNo').val(currentDeptId);

    // DocType 설정
    let docTypeInput = $('input[name="DocType"]');
    if (docTypeInput.length > 0) {
        docTypeInput.val(type);
    } else {
        $('#finalApprovalForm').append(`<input type="hidden" name="DocType" value="${type}">`);
    }

    const now = new Date();
    const todayString = now.toISOString().split('T')[0];
    $('#draftDocDate').val(todayString);

    let title = "";
    let content = "";

    if (type === 6) { // 임명
        $('#draftMemo').val(currentDeptName);
        title = `[인사발령] ${currentDeptName} 부서장 임명 건`;
        content = `1. 귀 부서의 무궁한 발전을 기원합니다.\n`
            + `2. 아래와 같이 부서장 임명을 명하고자 하오니 재가 바랍니다.\n\n`
            + `- 부서명 : ${currentDeptName}\n`
            + `- 대상자 : ${empName}\n`
            + `- 발령일 : ${todayString}\n\n`
            + `위와 같이 부서장 임명을 품의합니다.`;
    } else if (type === 7) { // 해임
        $('#draftMemo').val(currentDeptName);
        title = `[인사발령] ${currentDeptName} 부서장 해임 건`;
        content = `1. 귀 부서의 무궁한 발전을 기원합니다.\n`
            + `2. 아래와 같이 부서장 해임을 명하고자 하오니 재가 바랍니다.\n\n`
            + `- 부서명 : ${currentDeptName}\n`
            + `- 대상자 : ${empName}\n`
            + `- 해임일 : ${todayString}\n\n`
            + `위와 같이 부서장 해임을 품의합니다.`;
    }

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
            if (res === "OK" || res.result === "success") {
                alert("결재가 성공적으로 상신되었습니다.");
                closeDraftModal();
                closeModal();
                location.reload();
            } else {
                alert("상신 처리 완료");
                closeDraftModal();
                closeModal();
                location.reload();
            }
        },
        error: function(xhr, status, error) {
            console.error(error);
            alert("서버 통신 오류가 발생했습니다.");
        }
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
    if (!$('input[name="deptNo"]').val() || !$('input[name="deptName"]').val()) {
        alert("부서 번호와 이름은 필수입니다.");
        return;
    }
    $.ajax({
        url: contextPath + '/dept/create',
        type: 'POST',
        data: formData,
        success: function(res) {
            if (res === "OK") { alert("부서 생성됨"); location.reload(); }
            else { alert("생성 실패"); }
        },
        error: function() { alert("오류 발생"); }
    });
}

function submitDeleteDept() {
    const targetDeptNo = $('#deleteDeptSelect').val();
    if (!targetDeptNo) { alert("부서 선택 필요"); return; }
    if (!confirm("삭제하시겠습니까?")) return;

    $.ajax({
        url: contextPath + '/dept/delete',
        type: 'POST',
        data: { deptNo: targetDeptNo },
        success: function(res) {
            if (res === "OK") { alert("삭제됨"); location.reload(); }
            else { alert("삭제 실패"); }
        },
        error: function() { alert("오류 발생"); }
    });
}

// [핵심] 수정 폼 채우기 함수 (여기가 문제였음)
function fillUpdateForm(selectObj) {
    const selectedOption = selectObj.options[selectObj.selectedIndex];
    
    // 선택된 값이 없으면 리셋하고 종료
    if (!selectedOption.value) {
        $('#updateDeptForm')[0].reset();
        return;
    }

    const deptNo = selectedOption.value;
    const name = selectedOption.getAttribute('data-name');
    const parent = selectedOption.getAttribute('data-parent');
    const phone = selectedOption.getAttribute('data-phone');
    const manager = selectedOption.getAttribute('data-manager');

    // 폼에 값 주입
    $('#editDeptNo').val(deptNo);
    $('#editDeptName').val(name);
    $('#editParentDeptNo').val(parent == '0' ? '' : parent);
    $('#editDeptPhone').val(phone === 'null' ? '' : phone);
    $('#editManagerEmpNo').val(manager === '0' || manager === 'null' ? '' : manager);
}

function submitUpdateDept() {
    const deptNo = $('#editDeptNo').val();
    if (!deptNo) {
        alert("수정할 부서를 선택해주세요.");
        return;
    }
    const formData = $('#updateDeptForm').serialize();

    $.ajax({
        url: contextPath + '/dept/update',
        type: 'POST',
        data: formData,
        success: function(res) {
            if (res === "OK") {
                alert("부서 정보가 수정되었습니다.");
                location.reload();
            } else {
                alert("수정 실패");
            }
        },
        error: function() {
            alert("서버 오류 발생");
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
        },
        error: function() { alert("오류"); }
    });
}

/* =========================================
   5. 모달 외부 클릭 닫기
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
        }
    });
}