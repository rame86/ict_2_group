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

								<!-- =========================
							         상단 묶음: 사진(왼쪽) + 입력(오른쪽)
							         ========================= -->
								<div class="form-top">

									<!-- 왼쪽: 사진 카드 -->
									<div class="photo-wrapper">

										<div class="photo-section-title">
											<span class="badge-dot"></span> 프로필 사진 <span class="sub">업로드
												또는 기본이미지 선택</span>
										</div>
										<div class="photo-complete-badge" style="display: none;">
											<span class="check">✔</span> 설정 완료
										</div>

										<div class="photo-progress">
											<span class="step active">1</span> <span class="line"></span>
											<span class="step">2</span> <span class="line"></span> <span
												class="step">3</span> <span class="label">프로필 설정 </span>
										</div>

										<div class="photo-box" id="empPhotoBox">
											<span id="empPhotoText">PHOTO</span> <img
												id="empPhotoPreview" style="display: none;" alt="사진 미리보기">
										</div>

										<button type="button" id="btnPhotoRemove" class="btn-addr"
											style="display: none;">사진 삭제</button>

										<!-- 실제 파일 선택 input (숨김) -->
										<input type="file" id="empImageFile" name="empImageFile"
											accept="image/*" style="display: none;">

										<!-- 기본이미지 파일명 전송용(hidden) -->
										<input type="hidden" id="defaultImg" name="defaultImg"
											value="">

										<!-- 임의의 사진 설정(남/여 토글 버튼) -->
										<div class="default-photo-row">
											<label class="form-label"
												style="font-size: 12px; font-weight: 800; color: #6B7280;">
												임의의 사진 설정 </label>

											<div class="gender-btns">
												<button type="button" class="gender-btn" data-g="M">남</button>
												<button type="button" class="gender-btn" data-g="F">여</button>
											</div>
										</div>

										<p class="photo-help-text">
											* jpg, jpeg, png, gif 파일만 업로드 가능 <br>(최대 2MB)
										</p>
									</div>
									<!-- /.photo-wrapper -->

									<!-- 오른쪽: 입력 영역 -->
									<div class="form-top-right">

										<div class="hint-banner">
											<span class="hint-ico">i</span> <span><b>* 표시</b>는 필수
												항목입니다.</span>
										</div>

										<!-- 1줄: 사번 / 부서번호 / 부서명 (✅ 여기서 3개 한 줄) -->
										<div class="form-row form-row-3">
											<!-- 사번 -->
											<div class="form-group">
												<label class="form-label">* 사번</label>
												<div class="input-with-status">
													<input type="text" name="empNo" class="form-control"
														placeholder="사번을 입력해주세요 (1000~9999)"> <span
														id="empNoStatus" class="status-icon"></span>
												</div>
												<div class="error-text" data-for="empNo"></div>
											</div>

											<!-- 부서번호 -->
											<div class="form-group">
												<label class="form-label">* 부서번호</label> <input type="text"
													id="deptNoInput" name="deptNo" class="form-control"
													placeholder="부서를 선택하면 자동 입력" readonly>
												<div class="error-text" data-for="deptNo"></div>
											</div>

											<!-- ✅ 부서명(원래 2번째 row에 있던 걸 여기로 이동) -->
											<div class="form-group">
												<label class="form-label">* 부서명</label> <select
													id="deptNameSelect" class="form-select" required>
													<option value="">부서를 선택하세요</option>
													<c:forEach var="dept" items="${deptList}">
														<option value="${dept.deptNo}"
															data-dept-name="${dept.deptName}">
															${dept.deptName}</option>
													</c:forEach>
												</select> <input type="hidden" id="deptNameHidden" name="deptName">
											</div>
										</div>


										<!-- 2줄: 이름 / 주민등록번호 -->
										<div class="form-row">
											<div class="form-group">
												<label class="form-label" for="empName">* 이름</label> <input
													type="text" id="empName" name="empName"
													class="form-control" placeholder="이름을 입력해주세요">
												<div id="empNameError" class="error-text"></div>
											</div>

											<div class="form-group">
												<label class="form-label">주민등록번호</label> <input type="text"
													name="empRegno" class="form-control"
													placeholder="예: 990101-1234567">
												<div class="error-text" data-for="empRegno"></div>
											</div>
										</div>

										<!-- 3줄: 권한등급 / 재직상태 -->
										<div class="form-row">
											<div class="form-group">
												<label class="form-label1">권한등급 (1~6)</label> 
												<select name="gradeNo" class="form-select1">
													<option value="1">1 - 최고관리자</option>
													<option value="2">2 - 관리자</option>
													<option value="3">3 - 사원</option>
													<option value="4">4 - 계약사원</option>
													<option value="5">5 - 인턴/수습</option>
													<option value="6">6 - 기타</option>
												</select> <small class="grade-hint"> <span>※ 재직/파견만
														1~4등급 선택 가능, 인턴/수습은 5등급,</span> <span>휴직·대기·징계·퇴직 등은 6등급으로
														고정됩니다.</span>
												</small>
											</div>

											<div class="form-group">
												<label class="form-label2">재직상태</label>
												<select name="statusNo" class="form-select2">
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

										<!-- ✅ 재직상태 아래: (좌)주소 / (우)연락처+입사일 -->
										<div class="under-status-grid">

											<!-- 좌: 주소 -->
											<div class="addr-block">
												<label class="form-label">주소</label>

												<div class="addr-row">
													<input type="text" id="empPostcode"
														class="form-control addr-postcode" placeholder="우편번호"
														readonly>
													<button type="button" id="btnAddrSearch" class="btn-addr">주소
														검색</button>
												</div>

												<div class="addr-row" style="margin-top: 8px;">
													<input type="text" id="empAddrRoad" class="form-control"
														placeholder="도로명 주소" readonly>
												</div>

												<div class="addr-row" style="margin-top: 8px;">
													<input type="text" id="empAddrDetail" class="form-control"
														placeholder="상세 주소를 입력하세요">
												</div>

												<input type="hidden" name="empAddr" id="empAddrHidden">
											</div>

											<!-- 우: 연락처 + 입사일 (세로) -->
											<div class="contact-date-block">
												<div class="form-group">
													<label class="form-label">연락처</label> <input type="text"
														name="empPhone" class="form-control"
														placeholder="숫자 또는 하이픈(-)만 입력">
													<div class="error-text" data-for="empPhone"></div>
												</div>

												<div class="form-group">
													<label class="form-label">* 입사일</label> <input type="text"
														name="empRegdate" id="empRegdate"
														class="form-control emp-date" placeholder="입사일을 선택하세요">
													<div class="error-text" data-for="empRegdate"></div>
												</div>
											</div>

										</div>

									</div>
									<!-- /.form-top-right -->

								</div>
								<!-- /.form-top -->

								<!-- 버튼 -->
								<div class="button-area">
									<button type="button" id="btnSave" class="btn btn-primary"
										disabled>저장</button>

									<a href="${pageContext.request.contextPath}/emp/list"
										class="btn btn-secondary">목록으로</a>
								</div>

							</form>
						</div>
						<!-- /.emp-new-wrapper -->

					</div>
					<!-- /.emp-list-area -->
				</div>
				<!-- /.container-fluid -->
			</main>
			
			<!-- footer -->
<jsp:include page="../common/footer.jsp" />
		</div>
		<!-- /#layoutSidenav_content -->
	</div>
	<!-- /#layoutSidenav -->

	<!-- 토스트 메시지 -->
	<div id="toast" class="toast"></div>

	<!-- Daum 주소 검색 API -->
	<script
		src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js">
						</script>

	<script>
/* ============================================================
   ✅ empNewForm 최종 JS (검증 + 진행률 + 저장버튼 + 사진 + flatpickr)
   - 진행률(step1~3): 사번/이름/입사일 기준
   - step3 완료 시: step3 "✔" + 사진카드 상단 "설정 완료" 배지 표시
   - 저장 버튼: 필수값 + (사번 중복검사 OK)일 때만 활성화
============================================================ */

(function () {
  const ctx = "${pageContext.request.contextPath}";

  const $form    = $("#empNewForm");
  const $btnSave = $("#btnSave");

  // 진행률(step) & 완료 배지
  const $steps   = $(".photo-progress .step");      // 3개
  const $badge   = $(".photo-complete-badge");      // "설정 완료" 배지

  // 사번 상태 아이콘 span
  const $empNoIcon = $("#empNoStatus");

  // 사진 요소
  const $photoBox       = $("#empPhotoBox");
  const $photoText      = $("#empPhotoText");
  const $photoPreview   = $("#empPhotoPreview");
  const $photoInput     = $("#empImageFile");
  const $btnPhotoRemove = $("#btnPhotoRemove");
  const $genderBtns     = $(".gender-btn");
  const $defaultImg     = $("#defaultImg");

  /* =========================
     공통: 에러 표시/해제
  ========================= */
  function showError(fieldName, message) {
    const $input = $("[name='" + fieldName + "']");
    const $err   = $(".error-text[data-for='" + fieldName + "']");
    $input.removeClass("is-valid").addClass("is-invalid");
    if ($err.length) $err.text(message || "");
  }

  function clearError(fieldName) {
    const $input = $("[name='" + fieldName + "']");
    const $err   = $(".error-text[data-for='" + fieldName + "']");
    $input.removeClass("is-invalid").addClass("is-valid");
    if ($err.length) $err.text("");
  }

  function clearStatus(fieldName) {
    const $input = $("[name='" + fieldName + "']");
    const $err   = $(".error-text[data-for='" + fieldName + "']");
    $input.removeClass("is-valid is-invalid");
    if ($err.length) $err.text("");
  }

  /* =========================
     권한등급 규칙
  ========================= */
  function applyStatusGradeRule() {
    const status = $form.find('select[name="statusNo"]').val();
    const $grade = $form.find('select[name="gradeNo"]');

    $grade.prop("disabled", false);
    $grade.find("option").prop("disabled", false);

    if (status === "6") { // 인턴/수습
      $grade.val("5").prop("disabled", true);
      return;
    }
    if (["0","2","3","4","5"].includes(status)) { // 퇴직/휴직/대기/징계
      $grade.val("6").prop("disabled", true);
      return;
    }
    if (status === "1" || status === "7") { // 재직/파견
      $grade.find("option").each(function () {
        const v = $(this).val();
        $(this).prop("disabled", !["1","2","3","4"].includes(v));
      });
      if (!["1","2","3","4"].includes($grade.val())) $grade.val("3");
      return;
    }

    $grade.val("6").prop("disabled", true);
  }

  /* =========================
     자동 하이픈
  ========================= */
  function autoHyphenRegno(input) {
    let v = input.value.replace(/[^0-9]/g, "");
    if (v.length > 6) v = v.substring(0, 6) + "-" + v.substring(6, 13);
    input.value = v;
  }

  function autoHyphenPhone(input) {
    let v = input.value.replace(/[^0-9]/g, "");

    if (v.startsWith("02")) {
      if (v.length > 2 && v.length <= 5) v = v.slice(0,2) + "-" + v.slice(2);
      else if (v.length > 5 && v.length <= 9) v = v.slice(0,2) + "-" + v.slice(2,5) + "-" + v.slice(5,9);
      else if (v.length > 9) v = v.slice(0,2) + "-" + v.slice(2,6) + "-" + v.slice(6,10);
    } else if (v.length >= 10) {
      if (v.length === 10) v = v.slice(0,3) + "-" + v.slice(3,6) + "-" + v.slice(6,10);
      else v = v.slice(0,3) + "-" + v.slice(3,7) + "-" + v.slice(7,11);
    }

    input.value = v;
  }

  /* =========================
     사번 상태 아이콘
     - 여기 아이콘만 쓰도록 통일(겹침 방지)
  ========================= */
  function setEmpNoStatus(type, message) {
    if (type === "ok") {
      clearError("empNo");
      $empNoIcon.removeClass("error").addClass("ok").text("✔").show();
    } else if (type === "error") {
      showError("empNo", message);
      $empNoIcon.removeClass("ok").addClass("error").text("✖").show();
    } else {
      $empNoIcon.removeClass("ok error").text("").hide();
      clearStatus("empNo");
    }
    updateRequiredUI(); // 사번 OK 여부가 저장 버튼에 영향
  }

  function isEmpNoOk() {
    // 사번이 비어있으면 false, 중복검사 OK(✔)일 때만 true
    const hasValue = $("input[name='empNo']").val().trim().length > 0;
    return hasValue && $empNoIcon.hasClass("ok");
  }

  /* =========================
     필드 검증
  ========================= */
  function validateEmpNoFieldOnlyFormat() {
    const val = $("input[name='empNo']").val().trim();
    if (!val) {
      setEmpNoStatus("error", "사번을 입력하세요.");
      return false;
    }
    if (!/^[0-9]{4}$/.test(val) || Number(val) < 1000 || Number(val) > 9999) {
      setEmpNoStatus("error", "사번은 1000~9999 사이의 네 자리 숫자입니다.");
      return false;
    }
    // 형식 OK → 중복검사에서 ok/error 결정
    setEmpNoStatus("none");
    return true;
  }

  let isComposingName = false;

  function validateEmpNameField() {
    if (isComposingName) return true;

    const $empName = $("#empName");
    const $err = $("#empNameError");

    let v = $empName.val();
    const cleaned = v.replace(/[^가-힣\s]/g, "");
    if (v !== cleaned) { $empName.val(cleaned); v = cleaned; }

    v = v.trim();
    if (!v) {
      $empName.removeClass("is-valid").addClass("is-invalid");
      $err.text("이름을 입력해주세요.");
      return false;
    }
    if (v.length < 2 || !/^[가-힣\s]+$/.test(v)) {
      $empName.removeClass("is-valid").addClass("is-invalid");
      $err.text("이름은 완성된 한글 2자 이상만 입력할 수 있습니다.");
      return false;
    }

    $empName.removeClass("is-invalid").addClass("is-valid");
    $err.text("");
    return true;
  }

  function validateDeptNoField() {
	  const val = $("input[name='deptNo']").val().trim();

	  // 선택 안 함
	  if (!val) {
	    showError("deptNo", "부서명을 선택해서 부서번호를 입력하세요.");
	    return false;
	  }

	  // ✅ 무소속(0) 예외 처리: 통과
	  if (val === "0") {
	    clearError("deptNo");
	    return true;
	  }

	  // 일반 부서는 4자리 숫자만
	  if (!/^[0-9]{4}$/.test(val)) {
	    showError("deptNo", "부서번호는 네 자리 숫자만 가능합니다.");
	    return false;
	  }

	  clearError("deptNo");
	  return true;
	}


  function validateEmpRegdateField() {
    const val = $("input[name='empRegdate']").val().trim();
    if (!val) { showError("empRegdate", "입사일을 선택하세요."); return false; }
    clearError("empRegdate");
    return true;
  }

  function validateEmpRegnoField() {
    const val = $("input[name='empRegno']").val().trim();
    if (!val) { clearStatus("empRegno"); return true; }
    if (!/^[0-9]{6}-[0-9]{7}$/.test(val)) { showError("empRegno", "주민등록번호는 000000-0000000 형식이어야 합니다."); return false; }
    clearError("empRegno");
    return true;
  }

  function validateEmpPhoneField() {
    const val = $("input[name='empPhone']").val().trim();
    if (!val) { clearStatus("empPhone"); return true; }

    const digits = val.replace(/[^0-9]/g, "");
    if (digits.length < 10 || digits.length > 11) {
      showError("empPhone", "연락처는 10~11자리 숫자여야 합니다. (예: 010-1234-5678)");
      return false;
    }
    const pattern = /^(01[0-9]-\d{3,4}-\d{4}|02-\d{3,4}-\d{4})$/;
    if (!pattern.test(val)) { showError("empPhone", "연락처는 010-1234-5678 형식으로 입력해주세요."); return false; }

    clearError("empPhone");
    return true;
  }

  function validateForm() {
    // 사번은 "형식+중복OK"까지 보려면 isEmpNoOk 사용
    const okName = validateEmpNameField();
    const okDept = validateDeptNoField();
    const okDate = validateEmpRegdateField();
    const okReg  = validateEmpRegnoField();
    const okPh   = validateEmpPhoneField();
    const okNo   = isEmpNoOk();

    if (!okNo) showError("empNo", "사번을 확인해주세요."); // 중복OK 아니면 막기
    return okNo && okName && okDept && okDate && okReg && okPh;
  }

  /* =========================
     ✅ 필수 진행률(1~3) + 저장버튼 + step3 체크 + 배지
     - 기준: 사번(중복OK) / 이름 / 입사일
  ========================= */
  function updateRequiredUI() {
    let count = 0;

    // 사번은 "입력됨"이 아니라 "중복검사 OK"일 때만 1개로 인정
    if (isEmpNoOk()) count++;

    if ($("input[name='empName']").val().trim()) count++;
    if ($("input[name='empRegdate']").val().trim()) count++;

    // step 표시
    $steps.removeClass("active");

    // step 텍스트 원복(3이 체크로 바뀐 적 있으면 되돌리기)
    if ($steps.eq(2).text() !== "3") $steps.eq(2).text("3");

    for (let i = 0; i < count; i++) $steps.eq(i).addClass("active");

    // step3 완료 처리
    if (count === 3) {
      $steps.eq(2).addClass("active").text("✔");
      $badge.show();
      $btnSave.prop("disabled", false);
    } else {
      $badge.hide();
      $btnSave.prop("disabled", true);
    }
  }

  /* =========================
     토스트
  ========================= */
  function showToast(message) {
    const toast = document.getElementById("toast");
    if (!toast) return;
    toast.textContent = message;
    toast.classList.add("show");
    setTimeout(() => toast.classList.remove("show"), 2000);
  }

  /* =========================
     주소 검색
  ========================= */
  function openPostcode() {
    new daum.Postcode({
      oncomplete: function(data) {
        let addr = (data.userSelectedType === "R") ? data.roadAddress : data.jibunAddress;

        const extra = [];
        if (data.bname) extra.push(data.bname);
        if (data.buildingName) extra.push(data.buildingName);
        if (extra.length > 0) addr += " (" + extra.join(", ") + ")";

        $("#empPostcode").val(data.zonecode);
        $("#empAddrRoad").val(addr);
        $("#empAddrDetail").val("").focus();
      }
    }).open();
  }

  /* =========================
     사진 UI 리셋
  ========================= */
  function resetPhotoUI() {
    $photoInput.val("");
    $defaultImg.val("");
    $genderBtns.removeClass("active");

    $photoPreview.attr("src","").hide();
    $photoText.show();
    $btnPhotoRemove.hide();
  }

  /* ============================================================
     ✅ 이벤트 바인딩
  ============================================================ */
  $(function () {

    // 초기상태
    $badge.hide();
    $btnSave.prop("disabled", true);

    // 부서 선택 → 부서번호 자동 입력
    $("#deptNameSelect").on("change", function () {
      const $opt = $(this).find("option:selected");
      const val  = $opt.val();

      if (val) {
        $("#deptNoInput").val(val);
        $("#deptNameHidden").val($opt.data("dept-name") || "");
      } else {
        $("#deptNoInput").val("");
        $("#deptNameHidden").val("");
      }
      validateDeptNoField();
    });

    // 상태/등급 규칙
    applyStatusGradeRule();
    $form.on("change", "select[name='statusNo']", applyStatusGradeRule);

    // 주민번호
    $("input[name='empRegno']")
      .on("input", function () { autoHyphenRegno(this); validateEmpRegnoField(); })
      .on("blur", validateEmpRegnoField);

    // 연락처
    $("input[name='empPhone']")
      .on("input", function () { autoHyphenPhone(this); validateEmpPhoneField(); })
      .on("blur", validateEmpPhoneField);

    // 주소 버튼
    $("#btnAddrSearch").on("click", openPostcode);

    // 이름 조합 처리
    $("#empName").on("compositionstart", () => isComposingName = true);
    $("#empName").on("compositionend", () => { isComposingName = false; validateEmpNameField(); updateRequiredUI(); });
    $("input[name='empName']").on("input blur", function (e) {
      if (e.type === "input" && isComposingName) return;
      validateEmpNameField();
      updateRequiredUI();
    });

    // ✅ 사번: 형식검사 + AJAX 중복검사
    let empNoTimer = null;

    $("input[name='empNo']").on("input", function () {
      // 입력 중엔 OK/ERROR 확정하지 말고, 타이머로 중복검사(과다호출 방지)
      clearTimeout(empNoTimer);

      if (!validateEmpNoFieldOnlyFormat()) return;

      const empNo = $(this).val().trim();

      empNoTimer = setTimeout(function () {
        $.get(ctx + "/emp/checkEmpNo", { empNo }, function (result) {
          if (result === "DUP") setEmpNoStatus("error", "이미 사용 중인 사번입니다.");
          else setEmpNoStatus("ok", "");
        });
      }, 250);
    });

    // blur 시엔 바로 검사
    $("input[name='empNo']").on("blur", function () {
      if (!validateEmpNoFieldOnlyFormat()) return;

      const empNo = $(this).val().trim();
      $.get(ctx + "/emp/checkEmpNo", { empNo }, function (result) {
        if (result === "DUP") setEmpNoStatus("error", "이미 사용 중인 사번입니다.");
        else setEmpNoStatus("ok", "");
      });
    });

    // ✅ flatpickr
    flatpickr(".emp-date", {
      locale: { ...flatpickr.l10ns.ko, firstDayOfWeek: 1 },
      dateFormat: "Y-m-d",
      maxDate: "today",
      allowInput: true,
      onChange: function () {
        validateEmpRegdateField();
        updateRequiredUI();
      }
    });

    $("input[name='empRegdate']").on("input blur change", function () {
      validateEmpRegdateField();
      updateRequiredUI();
    });

    // ✅ 진행률 초기 반영
    updateRequiredUI();

    /* =========================
       사진: 클릭 → 업로드
    ========================= */
    $photoBox.on("click", function () { $photoInput.click(); });

    $photoInput.on("change", function (e) {
      const file = e.target.files[0];
      if (!file) return;

      // 업로드 시 기본사진 해제
      $defaultImg.val("");
      $genderBtns.removeClass("active");

      const allowedTypes = ["image/jpeg","image/png","image/gif"];
      const ext = (file.name.split(".").pop() || "").toLowerCase();
      const allowedExt = ["jpg","jpeg","png","gif"];

      if (!allowedTypes.includes(file.type) || !allowedExt.includes(ext)) {
        alert("JPG, JPEG, PNG, GIF 형식의 이미지 파일만 업로드할 수 있습니다.");
        $photoInput.val("");
        return;
      }
      if (file.size > 2 * 1024 * 1024) {
        alert("파일 용량은 최대 2MB까지 업로드할 수 있습니다.");
        $photoInput.val("");
        return;
      }

      const reader = new FileReader();
      reader.onload = function (ev) {
        $photoPreview.attr("src", ev.target.result).show();
        $photoText.hide();
        $btnPhotoRemove.show();
      };
      reader.readAsDataURL(file);
    });

    $btnPhotoRemove.on("click", resetPhotoUI);

    $genderBtns.on("click", function () {
      const $btn = $(this);
      const g = $btn.data("g"); // M/F

      if ($btn.hasClass("active")) {
        resetPhotoUI();
        return;
      }

      $genderBtns.removeClass("active");
      $btn.addClass("active");

      const fileName = (g === "F") ? "default_f.png" : "default_m.png";
      $defaultImg.val(fileName);

      // 업로드 파일 제거
      $photoInput.val("");

      $photoPreview.attr("src", ctx + "/upload/emp/" + fileName).show();
      $photoText.hide();
      $btnPhotoRemove.show();
    });

    /* =========================
       저장
       - disabled면 클릭 자체가 안 되지만,
         혹시 모를 상황 대비로 한 번 더 방어
    ========================= */
    $btnSave.on("click", function () {
      if ($btnSave.prop("disabled")) return;

      applyStatusGradeRule();

      if (!validateForm()) {
        showToast("입력값을 다시 확인해주세요.");
        return;
      }

      // 주소 합치기
      const postcode = $("#empPostcode").val().trim();
      const road     = $("#empAddrRoad").val().trim();
      const detail   = $("#empAddrDetail").val().trim();
      const fullAddr = [postcode ? "(" + postcode + ")" : "", road, detail].filter(Boolean).join(" ");
      $("#empAddrHidden").val(fullAddr);

      // 최종 중복 재확인(안전)
      const empNo = $form.find("input[name='empNo']").val().trim();

      $.get(ctx + "/emp/checkEmpNo", { empNo }, function (checkResult) {
        if (checkResult === "DUP") {
          setEmpNoStatus("error", "이미 사용 중인 사번입니다.");
          $form.find("input[name='empNo']").focus();
          return;
        }

        const formData = new FormData($form[0]);

        $.ajax({
          url: ctx + "/emp/insert",
          type: "POST",
          data: formData,
          processData: false,
          contentType: false,
          success: function (result) {
            if (result === "OK") {
              showToast("사원 등록이 완료되었습니다!");
              setTimeout(() => location.href = ctx + "/emp/list", 1200);
            } else if (result === "DENY") alert("사원 등록 권한이 없습니다.");
            else if (result === "FILE_SIZE") alert("파일 용량은 2MB 이하만 가능합니다.");
            else if (result === "FILE_TYPE") alert("jpg, jpeg, png, gif 파일만 업로드할 수 있습니다.");
            else if (result === "REGDATE_FUTURE") alert("입사일은 미래 날짜로 설정할 수 없습니다.");
            else alert("사원 등록 중 오류가 발생했습니다.");
          },
          error: function () {
            alert("사원 등록 중 서버 오류가 발생했습니다.");
          }
        });
      });
    });

  });
})();
</script>


</body>


</html>
