<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 등록</title>

<jsp:include page="../common/header.jsp" />

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/empNew.css">

</head>
<body>

    <div id="layoutSidenav">
        <jsp:include page="../common/sidebar.jsp" />

        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">

                    <h2 class="mt-4">사원 등록</h2>
                    <div class="emp-new-wrapper">
                        <!-- 🔹 파일 업로드를 위해 enctype 추가 -->
                        <form id="empNewForm"
                              method="post"
                              enctype="multipart/form-data">

                            <!-- 상단 3열: PHOTO / 왼쪽 입력 / 오른쪽 입력 -->
                            <div class="form-top">

                                <!-- PHOTO -->
                                <div class="photo-box" id="photoBox">
                                    <span id="photoText">PHOTO</span>
                                    <img id="photoPreview"
                                         alt="사진 미리보기"
                                         style="display:none; width:100%; height:100%; object-fit:cover; border-radius:16px;">
                                </div>

                                <!-- 실제 파일 선택 input (숨김) -->
                                <input type="file" name="empImageFile" id="empImageFile"
                                       accept="image/*" style="display:none;">

                                <!-- 왼쪽 입력 -->
                                <div>
                                    <div class="form-group">
                                        <label class="form-label"> * 사번</label>
                                        <input type="text" name="empNo" class="form-control"
                                               placeholder="사번을 입력해주세요 (1000~9999)">
                                    </div>

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
                                </div>

                                <!-- 오른쪽 입력 -->
                                <div>
                                    <div class="form-group">
                                        <label class="form-label">* 이름</label>
                                        <input type="text" name="empName" class="form-control"
                                               placeholder="이름을 입력해주세요">
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

                            </div> <!-- /.form-top -->

                            <!-- 하단 전체 폭 입력 -->
                            <div class="full-width">
                                <label class="form-label">연락처</label>
                                <input type="text" name="empPhone" class="form-control"
                                       placeholder="숫자 또는 하이픈(-)만 입력">
                            </div>

                            <div class="full-width">
                                <label class="form-label">이메일</label>
                                <input type="email" name="empEmail" class="form-control"
                                       placeholder="예: example@email.com">
                            </div>

                            <div class="full-width">
                                <label class="form-label">주소</label>
                                <input type="text" name="empAddr" class="form-control"
                                       placeholder="주소를 입력해주세요">
                            </div>

                            <div class="full-width">
                                <label class="form-label">* 부서번호</label>
                                <input type="text" name="deptNo" class="form-control"
                                       placeholder="부서번호(4자리 숫자)">
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
            </main>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        /* ============================================================
           🔹 권한등급 규칙
           ============================================================ */
        function applyStatusGradeRuleForForm($form) {
            const status = $form.find('select[name="statusNo"]').val();
            const $grade = $form.find('select[name="gradeNo"]');

            $grade.prop('disabled', false);
            $grade.find('option').prop('disabled', false);

            // 1) 인턴/수습 → 등급 5 고정
            if (status === '6') {
                $grade.val('5');
                $grade.prop('disabled', true);
                return;
            }

            // 2) 퇴직(0), 휴직/대기/징계(2,3,4,5) → 등급 6 고정
            if (['0','2','3','4','5'].includes(status)) {
                $grade.val('6');
                $grade.prop('disabled', true);
                return;
            }

            // 3) 재직 / 파견 (1,7) → 1~4만 선택 가능
            if (status === '1' || status === '7') {
                $grade.find('option').each(function () {
                    const v = $(this).val();
                    if (['1', '2', '3', '4'].includes(v)) {
                        $(this).prop('disabled', false);
                    } else {
                        $(this).prop('disabled', true);
                    }
                });

                const now = $grade.val();
                if (!['1','2','3','4'].includes(now)) {
                    $grade.val('3');  // 기본값
                }
                return;
            }

            // 기본: 기타
            $grade.val('6');
            $grade.prop('disabled', true);
        }

        /* ============================================================
           🔹 유효성 검사
           ============================================================ */
        function validateForm($form) {

            const empNo    = $form.find("input[name='empNo']").val().trim();
            const empName  = $form.find("input[name='empName']").val().trim();
            const deptNo   = $form.find("input[name='deptNo']").val().trim();
            const empPhone = $form.find("input[name='empPhone']").val().trim();
            const empEmail = $form.find("input[name='empEmail']").val().trim();

            // 1. 사번
            if (!empNo) {
                alert("사번을 입력하세요.");
                $form.find("input[name='empNo']").focus();
                return false;
            }
            if (!/^[0-9]{4}$/.test(empNo) || empNo < 1000 || empNo > 9999) {
                alert("사번은 1000~9999 사이의 네 자리 숫자만 가능합니다.");
                $form.find("input[name='empNo']").focus();
                return false;
            }

            // 2. 이름
            if (!empName || empName.trim() === "") {
                alert("이름을 입력하세요.");
                $form.find("input[name='empName']").focus();
                return false;
            }

            // 3. 부서번호
            if (!deptNo) {
                alert("부서번호를 입력하세요.");
                $form.find("input[name='deptNo']").focus();
                return false;
            }
            if (!/^[0-9]{4}$/.test(deptNo)) {
                alert("부서번호는 네 자리 숫자만 가능합니다.");
                $form.find("input[name='deptNo']").focus();
                return false;
            }

            // 4. 연락처 (선택)
            if (empPhone && !/^[0-9\-]+$/.test(empPhone)) {
                alert("연락처는 숫자와 하이픈(-)만 입력할 수 있습니다.");
                $form.find("input[name='empPhone']").focus();
                return false;
            }

            // 5. 이메일 (선택)
            if (empEmail && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(empEmail)) {
                alert("올바른 이메일 형식이 아닙니다.");
                $form.find("input[name='empEmail']").focus();
                return false;
            }

            return true;
        }

        /* ============================================================
           🔹 저장 버튼 + AJAX 등록
           ============================================================ */
        $(function () {

            const $form = $("#empNewForm");

            /* 🔹 PHOTO 박스 클릭하면 파일 선택창 열기 */
            $("#photoBox").on("click", function () {
                $("#empImageFile").click();
            });

            /* 🔹 파일 선택 시 미리보기 표시 */
            $("#empImageFile").on("change", function (e) {
                const file = e.target.files[0];
                if (!file) {
                    return;
                }

                const reader = new FileReader();
                reader.onload = function (ev) {
                    $("#photoPreview").attr("src", ev.target.result).show();
                    $("#photoText").hide();
                };
                reader.readAsDataURL(file);
            });

            // 처음 로드 시 상태/등급 규칙 적용
            applyStatusGradeRuleForForm($form);

            // 재직상태 변경 시마다 규칙 적용
            $form.on("change", "select[name='statusNo']", function () {
                applyStatusGradeRuleForForm($form);
            });

            // 저장 버튼
            $("#btnSave").click(function () {

                // 상태/등급 규칙 재적용
                applyStatusGradeRuleForForm($form);

                // 1) 기본 유효성 검사
                if (!validateForm($form)) {
                    return;
                }

                // 2) 사번 중복 체크
                const empNo = $form.find("input[name='empNo']").val().trim();

                $.get(
                    "${pageContext.request.contextPath}/emp/checkEmpNo",
                    { empNo: empNo },
                    function (checkResult) {

                        if (checkResult === "DUP") {
                            alert("이미 사용 중인 사번입니다. 다른 사번을 입력하세요.");
                            $form.find("input[name='empNo']").focus();
                            return;
                        }

                        // 3) 중복 아니면 실제 INSERT (파일 포함 → FormData 사용)
                        const formData = new FormData($form[0]);

                        $.ajax({
                            url: "${pageContext.request.contextPath}/emp/insert",
                            type: "POST",
                            data: formData,
                            processData: false,
                            contentType: false,
                            success: function (result) {
                                if (result === "OK") {
                                    alert("사원 등록이 완료되었습니다!");
                                    location.href = "${pageContext.request.contextPath}/emp/list";
                                } else if (result === "DENY") {
                                    alert("사원 등록 권한이 없습니다.");
                                } else {
                                    alert("사원 등록 중 오류가 발생했습니다.");
                                }
                            },
                            error: function () {
                                alert("사원 등록 중 오류가 발생했습니다.");
                            }
                        });
                    }
                );
            });
        });
    </script>

</body>
</html>
