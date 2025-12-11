<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 등록</title>

<!-- 공통 헤더 -->
<jsp:include page="../common/header.jsp" />

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.13/themes/airbnb.css">

<!-- flatpickr JS -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

<!-- 한글 로케일 -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>

<!-- 폰트 -->
<link href="https://cdn.jsdelivr.net/npm/suit-font/dist/suit.min.css"
      rel="stylesheet">

<!-- 사원등록 전용 CSS -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/empNew.css">

</head>
<body>

<div id="layoutSidenav">
    <jsp:include page="../common/sidebar.jsp" />

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">

                <div class="emp-list-area">

                    <div class="page-header">
                        <h3 class="mt-4">사원 등록</h3>
                    </div>

                    <div class="emp-new-wrapper">
                        <form id="empNewForm" method="post" enctype="multipart/form-data">

                            <!-- 상단 묶음: 사진 + 오른쪽 입력 -->
                            <div class="form-top">

                                <!-- 사진 + 삭제 버튼 -->
                                <div class="photo-wrapper">
                                    <div class="photo-box" id="empPhotoBox">
                                        <span id="empPhotoText">PHOTO</span>
                                        <img id="empPhotoPreview" style="display:none;" alt="사진 미리보기">
                                    </div>

                                    <button type="button" id="btnPhotoRemove"
                                            class="btn-addr"
                                            style="display:none;">사진 삭제</button>

                                    <!-- 실제 파일 선택 input (숨김) -->
                                    <input type="file" id="empImageFile" name="empImageFile"
                                           accept="image/*" style="display:none;">

                                    <!-- 안내 문구 -->
                                    <p class="photo-help-text">
                                        * jpg, jpeg, png, gif 파일만 업로드 가능 (최대 2MB)
                                    </p>
                                </div>

                                <!-- 오른쪽 입력 전체 -->
                                <div class="form-top-right">

                                    <!-- 1줄: 사번 / 부서번호 / 부서명 -->
                                    <div class="form-row">
                                        <!-- 사번 -->
                                        <div class="form-group">
                                            <label class="form-label">* 사번</label>
                                            <div class="input-with-status">
                                                <input type="text"
                                                       name="empNo"
                                                       class="form-control"
                                                       placeholder="사번을 입력해주세요 (1000~9999)">
                                                <span id="empNoStatus" class="status-icon"></span>
                                            </div>
                                            <div class="error-text" data-for="empNo"></div>
                                        </div>

                                        <!-- 부서번호 -->
                                        <div class="form-group">
                                            <label class="form-label">* 부서번호</label>
                                            <input type="text"
                                                   id="deptNoInput"
                                                   name="deptNo"
                                                   class="form-control"
                                                   placeholder="부서를 선택하면 자동 입력"
                                                   readonly>
                                            <div class="error-text" data-for="deptNo"></div>
                                        </div>

                                        <!-- 부서명 -->
                                        <div class="form-group">
                                            <label class="form-label">* 부서명</label>
                                            <select id="deptNameSelect" class="form-select" required>
                                                <option value="">부서를 선택하세요</option>
                                                <c:forEach var="dept" items="${deptList}">
                                                    <option value="${dept.deptNo}"
                                                            data-dept-name="${dept.deptName}">
                                                        ${dept.deptName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <input type="hidden" id="deptNameHidden" name="deptName">
                                        </div>
                                    </div>

                                    <!-- 2줄: 이름 / 주민등록번호 -->
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label" for="empName">* 이름</label>
                                            <input type="text"
                                                   id="empName"
                                                   name="empName"
                                                   class="form-control"
                                                   placeholder="이름을 입력해주세요">
                                            <div id="empNameError" class="error-text"></div>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">주민등록번호</label>
                                            <input type="text"
                                                   name="empRegno"
                                                   class="form-control"
                                                   placeholder="예: 990101-1234567">
                                            <div class="error-text" data-for="empRegno"></div>
                                        </div>
                                    </div>

                                    <!-- 3줄: 권한등급 / 재직상태 -->
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label">권한등급 (1~6)</label>
                                            <select name="gradeNo" class="form-select">
                                                <option value="1">1 - 최고관리자</option>
                                                <option value="2">2 - 관리자</option>
                                                <option value="3">3 - 사원</option>
                                                <option value="4">4 - 계약사원</option>
                                                <option value="5">5 - 인턴/수습</option>
                                                <option value="6">6 - 기타</option>
                                            </select>
                                            <small class="text-muted">
                                                ※ 재직/파견만 1~4등급 선택 가능, 인턴/수습은 5등급,<br>
                                                휴직·대기·징계·퇴직 등은 6등급으로 고정됩니다.
                                            </small>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">재직상태</label>
                                            <select name="statusNo" class="form-select">
                                                <option value="1">재직</option>
                                                <option value="7">파견</option>
                                                <option value="2">휴직(자발적)</option>
                                                <option value="3">휴직(병가 등 복지)</option>
                                                <option value="4">대기</option>
                                                <option value="5">징계</option>
                                                <option value="6" selected>인턴/수습</option>
                                                <option value="0">퇴직</option>
                                            </select>
                                        </div>
                                    </div>

                                </div>
                                <!-- /.form-top-right -->

                            </div>
                            <!-- /.form-top -->

                            <!-- 하단 1줄: 입사일 / 연락처 -->
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">* 입사일</label>
                                    <input type="text"
                                           name="empRegdate"
                                           id="empRegdate"
                                           class="form-control emp-date"
                                           placeholder="입사일을 선택하세요">
                                    <div class="error-text" data-for="empRegdate"></div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">연락처</label>
                                    <input type="text"
                                           name="empPhone"
                                           class="form-control"
                                           placeholder="숫자 또는 하이픈(-)만 입력">
                                    <div class="error-text" data-for="empPhone"></div>
                                </div>
                            </div>

                            <!-- 주소 -->
                            <div class="full-width">
                                <label class="form-label">주소</label>

                                <div class="addr-row">
                                    <input type="text"
                                           id="empPostcode"
                                           class="form-control addr-postcode"
                                           placeholder="우편번호"
                                           readonly>
                                    <button type="button"
                                            id="btnAddrSearch"
                                            class="btn-addr">주소 검색</button>
                                </div>

                                <div class="addr-row" style="margin-top:8px;">
                                    <input type="text"
                                           id="empAddrRoad"
                                           class="form-control"
                                           placeholder="도로명 주소"
                                           readonly>
                                </div>

                                <div class="addr-row" style="margin-top:8px;">
                                    <input type="text"
                                           id="empAddrDetail"
                                           class="form-control"
                                           placeholder="상세 주소를 입력하세요">
                                </div>

                                <input type="hidden" name="empAddr" id="empAddrHidden">
                            </div>

                            <!-- 버튼 -->
                            <div class="button-area">
                                <button type="button" id="btnSave" class="btn btn-primary">저장</button>
                                <a href="${pageContext.request.contextPath}/emp/list"
                                   class="btn btn-secondary">목록으로</a>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- 토스트 메시지 -->
<div id="toast" class="toast"></div>

<!-- Daum 주소 검색 API -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
/* ============================================================
   공통: 에러 표시 / 해제
   ============================================================ */
function showError(fieldName, message) {
    const $input = $("[name='" + fieldName + "']");
    const $err   = $(".error-text[data-for='" + fieldName + "']");
    $input.removeClass("is-valid").addClass("is-invalid");
    if ($err.length) {
        $err.text(message || "");
    }
}

function clearError(fieldName) {
    const $input = $("[name='" + fieldName + "']");
    const $err   = $(".error-text[data-for='" + fieldName + "']");
    $input.removeClass("is-invalid").addClass("is-valid");
    if ($err.length) {
        $err.text("");
    }
}

function clearStatus(fieldName) {
    const $input = $("[name='" + fieldName + "']");
    const $err   = $(".error-text[data-for='" + fieldName + "']");
    $input.removeClass("is-valid is-invalid");
    if ($err.length) {
        $err.text("");
    }
}

/* ============================================================
   권한등급 규칙
   ============================================================ */
function applyStatusGradeRuleForForm($form) {
    const status = $form.find('select[name="statusNo"]').val();
    const $grade = $form.find('select[name="gradeNo"]');

    $grade.prop('disabled', false);
    $grade.find('option').prop('disabled', false);

    // 인턴/수습 → 등급 5 고정
    if (status === '6') {
        $grade.val('5');
        $grade.prop('disabled', true);
        return;
    }

    // 퇴직/휴직/대기/징계 → 6 고정
    if (['0','2','3','4','5'].includes(status)) {
        $grade.val('6');
        $grade.prop('disabled', true);
        return;
    }

    // 재직/파견 → 1~4만 선택
    if (status === '1' || status === '7') {
        $grade.find('option').each(function () {
            const v = $(this).val();
            $(this).prop('disabled', !['1','2','3','4'].includes(v));
        });

        const now = $grade.val();
        if (!['1','2','3','4'].includes(now)) {
            $grade.val('3');
        }
        return;
    }

    // 기본
    $grade.val('6');
    $grade.prop('disabled', true);
}

/* ============================================================
   자동 하이픈
   ============================================================ */
function autoHyphenRegno(input) {
    let v = input.value.replace(/[^0-9]/g, '');
    if (v.length > 6) {
        v = v.substring(0, 6) + '-' + v.substring(6, 13);
    }
    input.value = v;
}

function autoHyphenPhone(input) {
    let v = input.value.replace(/[^0-9]/g, '');

    if (v.startsWith('02')) {
        if (v.length > 2 && v.length <= 5) {
            v = v.slice(0,2) + '-' + v.slice(2);
        } else if (v.length > 5 && v.length <= 9) {
            v = v.slice(0,2) + '-' + v.slice(2,5) + '-' + v.slice(5,9);
        } else if (v.length > 9) {
            v = v.slice(0,2) + '-' + v.slice(2,6) + '-' + v.slice(6,10);
        }
    } else if (v.length >= 10) {
        if (v.length === 10) {
            v = v.slice(0,3) + '-' + v.slice(3,6) + '-' + v.slice(6,10);
        } else {
            v = v.slice(0,3) + '-' + v.slice(3,7) + '-' + v.slice(7,11);
        }
    }
    input.value = v;
}

/* ============================================================
   사번 상태 아이콘 제어
   ============================================================ */
function setEmpNoStatus(type, message) {
    const $icon = $("#empNoStatus");

    if (type === "ok") {
        clearError("empNo");
        $icon.removeClass("error")
             .addClass("ok")
             .text("✔")
             .show();
    } else if (type === "error") {
        showError("empNo", message);
        $icon.removeClass("ok")
             .addClass("error")
             .text("✖")
             .show();
    } else {
        $icon.removeClass("ok error")
             .text("")
             .hide();
    }
}

/* ============================================================
   필드별 검증 함수
   ============================================================ */
function validateEmpNoField() {
    const val = $("input[name='empNo']").val().trim();

    if (!val) {
        setEmpNoStatus("error", "사번을 입력하세요.");
        return false;
    }

    if (!/^[0-9]{4}$/.test(val) || Number(val) < 1000 || Number(val) > 9999) {
        setEmpNoStatus("error", "사번은 1000~9999 사이의 네 자리 숫자입니다.");
        return false;
    }

    // 형식만 우선 OK, 실제 중복 여부는 AJAX에서 결정
    setEmpNoStatus("none");
    return true;
}

// 이름 입력 중 한글 조합 상태 플래그
let isComposingName = false;

function validateEmpNameField() {
    if (isComposingName) {
        return true;
    }
    const $empName   = $('#empName');
    const $nameError = $('#empNameError');

    let v = $empName.val();

    const cleaned = v.replace(/[^가-힣\s]/g, '');
    if (v !== cleaned) {
        $empName.val(cleaned);
        v = cleaned;
    }

    v = v.trim();
    const isOnlyKorean = /^[가-힣\s]+$/.test(v);

    if (!v) {
        $empName.removeClass('is-valid').addClass('is-invalid');
        $nameError.text('이름을 입력해주세요.');
        return false;
    }
    if (v.length < 2 || !isOnlyKorean) {
        $empName.removeClass('is-valid').addClass('is-invalid');
        $nameError.text('이름은 완성된 한글 2자 이상만 입력할 수 있습니다.');
        return false;
    }

    $empName.removeClass('is-invalid').addClass('is-valid');
    $nameError.text('');
    return true;
}

function validateDeptNoField() {
    const val = $("input[name='deptNo']").val().trim();
    if (!val) {
        showError("deptNo", "부서명을 선택해서 부서번호를 입력하세요.");
        return false;
    }
    if (!/^[0-9]{4}$/.test(val)) {
        showError("deptNo", "부서번호는 네 자리 숫자만 가능합니다.");
        return false;
    }
    clearError("deptNo");
    return true;
}

function validateEmpRegdateField() {
    const val = $("input[name='empRegdate']").val().trim();
    if (!val) {
        showError("empRegdate", "입사일을 선택하세요.");
        return false;
    }
    clearError("empRegdate");
    return true;
}

function validateEmpRegnoField() {
    const val = $("input[name='empRegno']").val().trim();
    if (!val) {
        clearStatus("empRegno");
        return true;
    }
    if (!/^[0-9]{6}-[0-9]{7}$/.test(val)) {
        showError("empRegno", "주민등록번호는 000000-0000000 형식이어야 합니다.");
        return false;
    }
    clearError("empRegno");
    return true;
}

function validateEmpPhoneField() {
    const val = $("input[name='empPhone']").val().trim();
    if (!val) {
        clearStatus("empPhone");
        return true;
    }

    const digits = val.replace(/[^0-9]/g, '');
    if (digits.length < 10 || digits.length > 11) {
        showError("empPhone", "연락처는 10~11자리 숫자여야 합니다. (예: 010-1234-5678)");
        return false;
    }

    const pattern = /^(01[0-9]-\d{3,4}-\d{4}|02-\d{3,4}-\d{4})$/;
    if (!pattern.test(val)) {
        showError("empPhone", "연락처는 010-1234-5678 형식으로 입력해주세요.");
        return false;
    }

    clearError("empPhone");
    return true;
}

/* ============================================================
   전체 폼 검증
   ============================================================ */
function validateForm() {
    const ok1 = validateEmpNoField();
    const ok2 = validateEmpNameField();
    const ok3 = validateDeptNoField();
    const ok4 = validateEmpRegdateField();
    const ok5 = validateEmpRegnoField();
    const ok6 = validateEmpPhoneField();
    return ok1 && ok2 && ok3 && ok4 && ok5 && ok6;
}

/* ============================================================
   토스트 메시지
   ============================================================ */
function showToast(message) {
    const toast = document.getElementById('toast');
    if (!toast) return;

    toast.textContent = message;
    toast.classList.add('show');

    setTimeout(function () {
        toast.classList.remove('show');
    }, 2000);
}

/* ============================================================
   주소 검색
   ============================================================ */
function openPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {

            let addr = '';
            if (data.userSelectedType === 'R') {
                addr = data.roadAddress;
            } else {
                addr = data.jibunAddress;
            }

            const extra = [];
            if (data.bname)        extra.push(data.bname);
            if (data.buildingName) extra.push(data.buildingName);
            if (extra.length > 0) {
                addr += ' (' + extra.join(', ') + ')';
            }

            $('#empPostcode').val(data.zonecode);
            $('#empAddrRoad').val(addr);

            $('#empAddrDetail').val('').focus();
        }
    }).open();
}

/* ============================================================
   초기 설정 & 이벤트 바인딩
   ============================================================ */
$(function () {

    const $form = $("#empNewForm");

    /* 부서 선택 시 부서번호 자동 입력 */
    const $deptSelect     = $("#deptNameSelect");
    const $deptNoInput    = $("#deptNoInput");
    const $deptNameHidden = $("#deptNameHidden");

    $deptSelect.on("change", function () {
        const $opt = $(this).find("option:selected");
        const val  = $opt.val();

        if (val) {
            $deptNoInput.val(val);
            if ($deptNameHidden.length) {
                $deptNameHidden.val($opt.data("dept-name"));
            }
        } else {
            $deptNoInput.val("");
            if ($deptNameHidden.length) {
                $deptNameHidden.val("");
            }
        }
        validateDeptNoField();
    });

    // 처음 로드 시 상태/등급 규칙 적용
    applyStatusGradeRuleForForm($form);

    // 재직상태 변경 시마다 규칙 적용
    $form.on("change", "select[name='statusNo']", function () {
        applyStatusGradeRuleForForm($form);
    });

    // 주민등록번호 실시간
    $("input[name='empRegno']")
        .on("input", function () {
            autoHyphenRegno(this);
            validateEmpRegnoField();
        })
        .on("blur", validateEmpRegnoField);

    // 연락처 실시간
    $("input[name='empPhone']")
        .on("input", function () {
            autoHyphenPhone(this);
            validateEmpPhoneField();
        })
        .on("blur", validateEmpPhoneField);

    // 주소 검색 버튼
    $("#btnAddrSearch").click(function () {
        openPostcode();
    });

    // 🔹 사번 입력 시 형식검사 + AJAX 중복검사 + 아이콘 표시
    $("input[name='empNo']").on("input blur", function () {

        const empNo = $(this).val().trim();

        // 기본 형식검사
        if (!validateEmpNoField()) {
            return;
        }

        if (!/^[0-9]{4}$/.test(empNo)) {
            return;
        }

        $.get(
            "${pageContext.request.contextPath}/emp/checkEmpNo",
            { empNo: empNo },
            function (result) {
                if (result === "DUP") {
                    setEmpNoStatus("error", "이미 사용 중인 사번입니다.");
                } else {
                    setEmpNoStatus("ok", "");
                }
            }
        );
    });

    // 저장 버튼
    $("#btnSave").click(function () {

        applyStatusGradeRuleForForm($form);

        if (!validateForm()) {
            showToast("입력값을 다시 확인해주세요.");
            return;
        }

        // 주소 합치기
        const postcode = $('#empPostcode').val().trim();
        const road     = $('#empAddrRoad').val().trim();
        const detail   = $('#empAddrDetail').val().trim();

        const fullAddr = [postcode ? '(' + postcode + ')' : '', road, detail]
            .filter(Boolean)
            .join(' ');

        $('#empAddrHidden').val(fullAddr);

        // 사번 중복 체크 (최종 확인)
        const empNo = $form.find("input[name='empNo']").val().trim();

        $.get(
            "${pageContext.request.contextPath}/emp/checkEmpNo",
            { empNo: empNo },
            function (checkResult) {

                if (checkResult === "DUP") {
                    setEmpNoStatus("error", "이미 사용 중인 사번입니다.");
                    $form.find("input[name='empNo']").focus();
                    return;
                }

                // 중복 아니면 실제 INSERT (파일 포함 → FormData)
                const formData = new FormData($form[0]);

                $.ajax({
                    url: "${pageContext.request.contextPath}/emp/insert",
                    type: "POST",
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (result) {
                        if (result === "OK") {
                            showToast("사원 등록이 완료되었습니다!");
                            setTimeout(function () {
                                location.href = "${pageContext.request.contextPath}/emp/list";
                            }, 1200);

                        } else if (result === "DENY") {
                            alert("사원 등록 권한이 없습니다.");

                        } else if (result === "FILE_SIZE") {
                            alert("파일 용량은 2MB 이하만 가능합니다.");

                        } else if (result === "FILE_TYPE") {
                            alert("jpg, jpeg, png, gif 파일만 업로드할 수 있습니다.");

                        } else if (result === "REGDATE_FUTURE") {
                            alert("입사일은 미래 날짜로 설정할 수 없습니다.");

                        } else {
                            alert("사원 등록 중 오류가 발생했습니다.");
                        }
                    },
                    error: function () {
                        alert("사원 등록 중 서버 오류가 발생했습니다.");
                    }
                });
            }
        );
    });

    // 이름 한글 조합 감지
    const $empName   = $('#empName');

    $empName.on('compositionstart', function () {
        isComposingName = true;
    });

    $empName.on('compositionend', function () {
        isComposingName = false;
        validateEmpNameField();
    });

    $("input[name='empName']").on("input blur", function (e) {
        if (e.type === 'input' && isComposingName) return;
        validateEmpNameField();
    });

    $("input[name='empRegdate']").on("blur", validateEmpRegdateField);
});

/* ============================================================
   사진 업로드 / 삭제
   ============================================================ */
$(function () {

    const $photoBox       = $('#empPhotoBox');
    const $photoText      = $('#empPhotoText');
    const $photoPreview   = $('#empPhotoPreview');
    const $photoInput     = $('#empImageFile');
    const $btnPhotoRemove = $('#btnPhotoRemove');

    // 사진 박스 클릭 → 파일 선택창
    $photoBox.on('click', function () {
        $photoInput.click();
    });

    // 사진 선택 시 검증 + 미리보기
    $photoInput.on('change', function (e) {
        const file = e.target.files[0];
        if (!file) return;

        const allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
        const ext          = (file.name.split('.').pop() || '').toLowerCase();
        const allowedExt   = ['jpg', 'jpeg', 'png', 'gif'];

        if (!allowedTypes.includes(file.type) || !allowedExt.includes(ext)) {
            alert('JPG, JPEG, PNG, GIF 형식의 이미지 파일만 업로드할 수 있습니다.');
            $photoInput.val('');
            return;
        }

        const maxSize = 2 * 1024 * 1024; // 2MB
        if (file.size > maxSize) {
            alert('파일 용량은 최대 2MB까지 업로드할 수 있습니다.');
            $photoInput.val('');
            return;
        }

        const reader = new FileReader();
        reader.onload = function (ev) {
            $photoPreview.attr('src', ev.target.result).show();
            $photoText.hide();
            $btnPhotoRemove.show();
        };
        reader.readAsDataURL(file);
    });

    // 사진 삭제
    $btnPhotoRemove.on('click', function () {
        $photoInput.val('');
        $photoPreview.attr('src', '').hide();
        $photoText.show();
        $btnPhotoRemove.hide();
    });
});
</script>

<script>
document.addEventListener('DOMContentLoaded', function () {
    flatpickr(".emp-date", {
        locale: {
            ...flatpickr.l10ns.ko,
            firstDayOfWeek: 1
        },
        dateFormat: "Y-m-d",
        maxDate: "today",
        allowInput: true
    });
});
</script>

<!-- footer -->
<jsp:include page="../common/footer.jsp" />
</body>
</html>
