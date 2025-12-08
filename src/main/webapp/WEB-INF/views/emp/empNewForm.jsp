<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 등록</title>

<jsp:include page="../common/header.jsp" />

<!-- 필요하면 별도 CSS 연결 -->
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
                        <form id="empNewForm">

                            <!-- 상단 3열: PHOTO / 왼쪽 입력 / 오른쪽 입력 -->
                            <div class="form-top">

                                <!-- PHOTO -->
                                <div class="photo-box">PHOTO</div>

                                <!-- 왼쪽 입력 -->
                                <div>
                                    <div class="form-group">
                                        <label class="form-label">사번</label>
                                        <input type="text"
                                            name="empNo" class="form-control">
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">권한등급 (1~5)</label>
                                        <select name="gradeNo" class="form-select">
                                           <option value="1">1 - 최고관리자</option>
												    <option value="2">2 - 관리자</option>
												    <option value="3">3 - 사원</option>
												    <option value="4">4 - 계약사원</option>
												    <option value="5">5 - 인턴/수습</option>
												    <option value="6">6 - 기타</option>
                                        </select>
                                        <small class="text-muted">
                                            ※ 재직/파견만 1~4등급 선택 가능, 인턴/수습은 5등급, <br/>
    											휴직·대기·징계·퇴직 등은 6등급으로 고정됩니다.
                                        </small>
                                    </div>
                                </div>

                                <!-- 오른쪽 입력 -->
                                <div>
                                    <div class="form-group">
                                        <label class="form-label">이름</label>
                                        <input type="text"
                                            name="empName" class="form-control">
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">재직상태</label>
                                        <select name="statusNo" class="form-select">
                                            <option value="1">재직</option>
                                            <option value="7">파견</option>
                                            <option value="2">휴직(자발적)</option>
                                            <option value="3">휴직(병가)</option>
                                            <option value="4">대기</option>
                                            <option value="5">징계</option>
                                            <option value="6">인턴/수습</option>
                                            <option value="0">퇴직</option>
                                        </select>
                                    </div>
                                </div>

                            </div>
                            <!-- /.form-top -->

                            <!-- 하단 전체 폭 입력 -->
                            <div class="full-width">
                                <label class="form-label">연락처</label>
                                <input type="text"
                                    name="empPhone" class="form-control">
                            </div>

                            <div class="full-width">
                                <label class="form-label">이메일</label>
                                <input type="email"
                                    name="empEmail" class="form-control">
                            </div>

                            <div class="full-width">
                                <label class="form-label">주소</label>
                                <input type="text"
                                    name="empAddr" class="form-control">
                            </div>

                            <div class="full-width">
                                <label class="form-label">부서번호</label>
                                <input type="text"
                                    name="deptNo" class="form-control">
                            </div>

                            <!-- 버튼 -->
                            <div class="button-area">
                                <button type="button" id="btnSave" class="btn btn-primary">저장</button>
                                <a href="${pageContext.request.contextPath}/emp/list"
                                    class="btn btn-secondary">목록으로</a>
                            </div>

                        </form>

                    </div>
            </main>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
 // 🔹 재직상태/등급 연동 공통 함수 (등록/수정 폼 양쪽에서 사용)
    function syncStatusAndGradeForForm($form) {
        const status = $form.find('select[name="statusNo"]').val();
        const $grade = $form.find('select[name="gradeNo"]');

        // 기본: 모든 옵션 활성화
        $grade.prop('disabled', false);
        $grade.find('option').prop('disabled', false);

        // 1) 인턴/수습 (status 6) → grade 5 고정
        if (status === '6') {
            $grade.val('5');
            $grade.find('option').not('[value="5"]').prop('disabled', true);
            return;
        }

        // 2) 퇴직(0), 휴직/대기/징계(2,3,4,5) → grade 6 고정
        if (status === '0' || status === '2' || status === '3' ||
            status === '4' || status === '5') {
            $grade.val('6');
            $grade.find('option').not('[value="6"]').prop('disabled', true);
            return;
        }

        // 3) 재직 / 파견 (1,7) → 1~4만 허용, 나머지 비활성화
        if (status === '1' || status === '7') {
            $grade.find('option').each(function () {
                const v = $(this).val();
                if (v === '1' || v === '2' || v === '3' || v === '4') {
                    $(this).prop('disabled', false);
                } else {
                    $(this).prop('disabled', true);
                }
            });
            const current = $grade.val();
            if (!(current === '1' || current === '2' || current === '3' || current === '4')) {
                $grade.val('3'); // 기본: 사원
            }
            return;
        }

        // 혹시 모르는 값은 안전하게 기타(6)
        $grade.val('6');
        $grade.find('option').not('[value="6"]').prop('disabled', true);
    }

 
        $(function () {
            // 페이지 로드 시 한 번 적용
            syncStatusAndGradeForForm();

            // 재직상태 변경 시마다 등급 옵션 재조정
            $('select[name="statusNo"]').on('change', function () {
                syncStatusAndGradeForForm();
            });

            // 🔹 Ajax로 /emp/insert 호출 (update/delete와 방식 통일)
            $("#btnSave").click(function () {
                let formData = $("#empNewForm").serialize();

                $.post(
                    "${pageContext.request.contextPath}/emp/insert",
                    formData,
                    function (result) {
                        if (result === "OK") {
                            alert("사원 등록이 완료되었습니다.");
                            location.href = "${pageContext.request.contextPath}/emp/list";
                        } else if (result === "DENY") {
                            alert("사원 등록 권한이 없습니다.");
                        } else {
                            alert("사원 등록 중 오류가 발생했습니다.");
                        }
                    }
                );
            });
        });
    </script>
</body>
</html>
