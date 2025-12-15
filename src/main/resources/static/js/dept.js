/* dept.js */

// 전역 변수
let currentDeptId = null;
let currentDeptName = null;
let currentManagerName = null;
let currentDeptMembers = [];

// DOM 요소
const modal = document.getElementById('deptInfoModal');
const closeModalBtn = document.getElementById('closeModalBtn');
const modalDeptName = document.getElementById('modalDeptName');
const employeeListUl = document.getElementById('employeeList');

/* 1. 부서 정보 모달 */
function showDeptModal(deptId, deptName, managerName) {
	currentDeptId = deptId;
	currentDeptName = deptName;
	currentManagerName = managerName;

	if (modalDeptName) modalDeptName.textContent = deptName;

	// 헤더 재구성 (임명 버튼 포함)
	const header = document.querySelector('#deptInfoModal .modal-header-custom');
	let appointBtnHtml = '';

	if (!currentManagerName && isAdminUser) {
		appointBtnHtml = `
            <button class="btn-xs" style="margin-left:auto; margin-right:10px; background:#fff; color:#4e73df; border:none; border-radius:4px; font-weight:bold; cursor:pointer;" 
                    onclick="openAppointModal()">
                + 부서장 임명
            </button>
        `;
	}

	header.innerHTML = `
        <h5 style="margin:0;">${deptName}</h5>
        ${appointBtnHtml}
        <span id="closeModalBtn" class="close-btn" onclick="closeModal()">&times;</span>
    `;

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

            // 부서장 맨 위로 정렬
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
                
                // [수정됨] 관리자 권한 버튼 로직
                if (isAdminUser) {
                    if (!isManager) {
                        // 일반 사원: 이동/제외 버튼
                        btnHtml = `
                            <div class="emp-actions">
                                <button class="btn-xs btn-move" onclick="openMoveModal(event, '${emp.empNo}', '${emp.empName}')">이동</button>
                                <button class="btn-xs btn-exclude" onclick="submitExcludeEmp(event, '${emp.empNo}', '${emp.empName}')">제외</button>
                            </div>
                        `;
                    } else {
                        // 부서장: MANAGER 뱃지 + [해임] 버튼 추가
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
                    // 관리자가 아님: 뱃지만 표시
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

function goToEmployeeMgmt(empId) { location.href = `${contextPath}/emp/list?autoSelectEmpNo=${empId}`; }
function goToEmployeeMgmtByDept() {
	if (currentDeptName) location.href = `${contextPath}/emp/list?keyword=` + encodeURIComponent(currentDeptName);
	else location.href = `${contextPath}/emp/list`;
}


/* 2. 부서장 임명 & 기안 모달 연동 */
function openAppointModal() {
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

// [LOG 추가] 버튼 클릭 시 동작 확인
function submitAppointManager() {
    console.log("1. submitAppointManager 호출됨");
    const empNo = $('#appointEmpSelect').val();
    const empInfoText = $('#appointEmpSelect option:selected').text();

    if (!empNo) {
        alert("임명할 사원을 선택해주세요.");
        return;
    }

    closeAppointModal();
    // [수정] type 6 (임명) 전달
    openDraftModal(empNo, empInfoText, 6); 
}
// [신규] 해임 버튼 클릭 시 동작
function submitDismissManager(e, empNo, empName) {
    e.stopPropagation(); // 부모 li 클릭 이벤트(상세보기) 방지
    
    if(!confirm(`[${empName}] 님을 부서장에서 해임하시겠습니까?\n결재 기안 창으로 이동합니다.`)) {
        return;
    }

    // [신규] type 7 (해임) 전달
    openDraftModal(empNo, empName, 7);
}

function openDraftModal(empNo, empName, type) {
    
    // 대상자 및 부서 정보 세팅
    $('#draftTargetEmpNo').val(empNo);
    $('#draftTargetDeptNo').val(currentDeptId); 
    $('#draftDeptNo').val(currentDeptId);
    
    // [중요] DocType 설정 (임명:6, 해임:7)
    // JSP에 <input name="DocType">이 있어야 함. 없으면 동적으로 찾아서 value 변경
    let docTypeInput = $('input[name="DocType"]');
    if(docTypeInput.length > 0) {
        docTypeInput.val(type);
    } else {
        // 만약 input이 없다면 form안에 append (안전장치)
        $('#finalApprovalForm').append(`<input type="hidden" name="DocType" value="${type}">`);
    }

    // 날짜 생성
    const now = new Date();
    const todayString = now.toISOString().split('T')[0]; // YYYY-MM-DD
    $('#draftDocDate').val(todayString);

    let title = "";
    let content = "";

    if (type === 6) {
        // === 부서장 임명 (Type 6) ===
        $('#draftMemo').val(currentDeptName);
        title = `[인사발령] ${currentDeptName} 부서장 임명 건`;
        content = `1. 귀 부서의 무궁한 발전을 기원합니다.\n`
            + `2. 아래와 같이 부서장 임명을 명하고자 하오니 재가 바랍니다.\n\n`
            + `- 부서명 : ${currentDeptName}\n`
            + `- 대상자 : ${empName}\n`
            + `- 발령일 : ${todayString}\n\n`
            + `위와 같이 부서장 임명을 품의합니다.`;

    } else if (type === 7) {
        // === 부서장 해임 (Type 7) ===
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

    // 모달 열기
    $('#approvalDraftModal').show();
}

function closeDraftModal() { $('#approvalDraftModal').hide(); }

// 최종 결재 상신
function submitFinalApproval() {
    if(!confirm("작성된 내용으로 결재를 상신하시겠습니까?")) return;

    const formData = $('#finalApprovalForm').serialize();

    $.ajax({
        url: contextPath + '/approve/approve-ajax', 
        type: 'POST',
        data: formData,
        success: function(res) {

            if(res === "OK" || res.result === "success") { 
                alert("결재가 성공적으로 상신되었습니다.");
                closeDraftModal();
                closeModal(); 
                // 필요 시 페이지 새로고침
                // location.reload();
            } else {
                alert("상신 처리 완료");
                // 성공인데 텍스트가 다른 경우도 있어 창을 닫음
                closeDraftModal();
                closeModal();
            }
        },
        error: function(xhr, status, error) {
            console.error(error);
            alert("서버 통신 오류가 발생했습니다.");
        }
    });
}
/* 3. 부서 생성/삭제 모달 */
function openCreateModal() { $('#deptCreateModal').show(); }
function closeCreateModal() { $('#deptCreateModal').hide(); }
function openDeleteModal() { $('#deptDeleteModal').show(); }
function closeDeleteModal() { $('#deptDeleteModal').hide(); }

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

/* 4. 사원 이동/제외 */
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

/* 5. 모달 외부 클릭 닫기 */
window.onclick = function(event) {
	const infoM = document.getElementById('deptInfoModal');
	const createM = document.getElementById('deptCreateModal');
	const deleteM = document.getElementById('deptDeleteModal');
	const moveM = document.getElementById('deptMoveModal');
	const appointM = document.getElementById('deptAppointModal');
	const draftM = document.getElementById('approvalDraftModal');

	if (event.target == infoM) closeModal();
	if (event.target == createM) closeCreateModal();
	if (event.target == deleteM) closeDeleteModal();
	if (event.target == moveM) closeMoveModal();
	if (event.target == appointM) closeAppointModal();
	if (event.target == draftM) closeDraftModal();
}