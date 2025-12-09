<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="emp-card">

    <%-- =========================
         1) 보기 모드 (읽기 전용)
       ========================== --%>
    <div class="emp-card-view">

        <div class="emp-card-header">
            <div class="emp-photo-placeholder" >
                <c:choose>
                    <c:when test="${not empty emp.empImage}">
                        <img src="${pageContext.request.contextPath}/upload/emp/${emp.empImage}"
                             alt="${emp.empName}"
                             style="width:100%; height:100%; object-fit:cover; border-radius:16px;">
                    </c:when>
                    <c:otherwise>
                        PHOTO
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="emp-basic-info">
                <h3>${emp.empName}</h3>
                <p>/ 직급번호: ${emp.gradeNo}</p>
                <p>사번 : ${emp.empNo}</p>
                <p>입사일 : ${emp.empRegdate}</p>
            </div>
        </div>

        <hr />

        <div class="emp-card-body">
            <table class="emp-card-table">
                <tr>
                    <th>재직상태</th>
                    <td>${emp.statusName}</td>
                    <th>직급번호</th>
                    <td>${emp.gradeNo}</td>
                </tr>
                <tr>
                    <th>연락처</th>
                    <td>${emp.empPhone}</td>
                    <th>이메일</th>
                    <td>${emp.empEmail}</td>
                </tr>
                <tr>
                    <th>주소</th>
                    <td colspan="3">${emp.empAddr}</td>
                </tr>
            </table>
        </div>

        <%-- 관리 등급(1,2)에게만 수정/삭제 버튼 노출 --%>
        <c:if test="${canModify}">
            <div class="emp-card-actions">
                <button type="button"
                        class="emp-btn emp-btn-edit"
                        onclick="enterEmpEditMode()">
                    수정
                </button>

                <button type="button"
                        class="emp-btn emp-btn-delete"
                        onclick="deleteEmp('${emp.empNo}')">
                    삭제
                </button>
            </div>
        </c:if>
    </div>



    <%-- =========================
         2) 수정 모드 (입력 폼)
         - 처음에는 숨김
       ========================== --%>
    <c:if test="${canModify}">
        <div class="emp-card-edit" style="display:none;">

            <form id="empEditForm"
                  method="post"
                  enctype="multipart/form-data">
                <!-- 어떤 직원을 수정하는지 구분용 -->
                <input type="hidden" name="empNo" value="${emp.empNo}"/>

                <!-- 🔹 기존 이미지 파일명 보관 -->
                <input type="hidden" name="oldEmpImage" value="${emp.empImage}" />

                <div class="emp-card-header">

                    <!-- 🔹 사진 수정 가능 영역 -->
                    <div class="emp-photo-placeholder" id="empEditPhotoBox">
                        <c:choose>
                            <c:when test="${not empty emp.empImage}">
                                <img id="empEditPhotoPreview"
                                     src="${pageContext.request.contextPath}/upload/emp/${emp.empImage}"
                                     alt="${emp.empName}"
                                     style="width:100%; height:100%; object-fit:cover; border-radius:16px;">
                            </c:when>
                            <c:otherwise>
                                <span id="empEditPhotoText">PHOTO</span>
                                <img id="empEditPhotoPreview"
                                     style="display:none; width:100%; height:100%; object-fit:cover; border-radius:16px;"
                                     alt="사진 미리보기">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 실제 파일 선택 input (숨김) -->
                    <input type="file" name="empImageFile" id="empEditImageFile"
                           accept="image/*" style="display:none;">

                    <div class="emp-basic-info">
                        <h3>${emp.empName}</h3>
                        <p>/ 직급번호: ${emp.gradeNo}</p>
                        <p>사번 : ${emp.empNo}</p>
                        <p>입사일 : ${emp.empRegdate}</p>
                    </div>
                </div>

                <hr />

                <div class="emp-card-body">
                    <table class="emp-card-table">
                        <tr>
                            <th>재직상태</th>
                            <td>
                                <select name="statusNo">
                                    <option value="1" ${emp.statusNo == 1 ? 'selected' : ''}>재직</option>
                                    <option value="7" ${emp.statusNo == 7 ? 'selected' : ''}>파견</option>
                                    <option value="2" ${emp.statusNo == 2 ? 'selected' : ''}>휴직(자발적)</option>
                                    <option value="3" ${emp.statusNo == 3 ? 'selected' : ''}>휴직(병가 등 복지)</option>
                                    <option value="4" ${emp.statusNo == 4 ? 'selected' : ''}>대기</option>
                                    <option value="5" ${emp.statusNo == 5 ? 'selected' : ''}>징계</option>
                                    <option value="6" ${emp.statusNo == 6 ? 'selected' : ''}>인턴/수습</option>
                                    <option value="0" ${emp.statusNo == 0 ? 'selected' : ''}>퇴직</option>
                                </select>
                            </td>
                            <th>직급번호</th>
                            <td>
                                <select name="gradeNo">
                                    <option value="1" ${emp.gradeNo == 1 ? 'selected' : ''}>1 - 최고관리자</option>
                                    <option value="2" ${emp.gradeNo == 2 ? 'selected' : ''}>2 - 관리자</option>
                                    <option value="3" ${emp.gradeNo == 3 ? 'selected' : ''}>3 - 사원</option>
                                    <option value="4" ${emp.gradeNo == 4 ? 'selected' : ''}>4 - 계약사원</option>
                                    <option value="5" ${emp.gradeNo == 5 ? 'selected' : ''}>5 - 인턴/수습</option>
                                    <option value="6" ${emp.gradeNo == 6 ? 'selected' : ''}>6 - 기타</option>
                                </select>
                                <br/>
                                <small class="text-muted">
                                    ※ 재직/파견만 1~4등급 선택 가능, 인턴/수습은 5등급,
                                       휴직·대기·징계·퇴직 등은 6등급으로 고정됩니다.
                                </small>
                            </td>
                        </tr>
                        <tr>
                            <th>연락처</th>
                            <td>
                                <input type="text" name="empPhone" value="${emp.empPhone}" style="width:100%;">
                            </td>
                            <th>이메일</th>
                            <td>
                                <input type="text" name="empEmail" value="${emp.empEmail}" style="width:100%;">
                            </td>
                        </tr>
                        <tr>
                            <th>주소</th>
                            <td colspan="3">
                                <input type="text" name="empAddr" value="${emp.empAddr}" style="width:100%;">
                            </td>
                        </tr>
                    </table>
                </div>
            </form>

            <div class="emp-card-actions">
                <button type="button"
                        class="emp-btn emp-btn-edit"
                        onclick="saveEmpEdit()">
                    저장
                </button>

                <button type="button"
                        class="emp-btn emp-btn-delete"
                        onclick="cancelEmpEditMode()">
                    취소
                </button>
            </div>
        </div>
    </c:if>

</div>

<script>
    // 🔹 재직상태/직급번호 규칙 (등록폼이랑 동일)
    function applyStatusGradeRule($form) {
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
                $(this).prop('disabled', !['1','2','3','4'].includes(v));
            });
            const now = $grade.val();
            if (!['1','2','3','4'].includes(now)) {
                $grade.val('3');
            }
            return;
        }

        // 기본: 기타 → 6등급 고정
        $grade.val('6');
        $grade.prop('disabled', true);
    }

    // 보기 모드 -> 수정 모드
    function enterEmpEditMode() {
        $('.emp-card-view').hide();
        $('.emp-card-edit').show();

        const $form = $('#empEditForm');
        applyStatusGradeRule($form);
        
        // 🔹 수정 모드로 들어왔을 때만 손가락 커서 활성화
        $('#empEditPhotoBox').css('cursor', 'pointer');
    }

    // 수정 모드 -> 보기 모드
    function cancelEmpEditMode() {
        $('.emp-card-edit').hide();
        $('.emp-card-view').show();
    }

    // 🔹 사진 클릭 시 파일 선택창
    $(function () {
        const $form = $('#empEditForm');

        $('#empEditPhotoBox').on('click', function () {
            $('#empEditImageFile').click();
        });

        $('#empEditImageFile').on('change', function (e) {
            const file = e.target.files[0];
            if (!file) return;

            const reader = new FileReader();
            reader.onload = function (ev) {
                $('#empEditPhotoPreview')
                    .attr('src', ev.target.result)
                    .show();
                $('#empEditPhotoText').hide();
            };
            reader.readAsDataURL(file);
        });

        // 상태 변경 시 규칙 적용
        $form.on('change', 'select[name="statusNo"]', function () {
            applyStatusGradeRule($form);
        });

        // 혹시 수정 모드로 바로 들어온 경우
        if ($('.emp-card-edit').is(':visible')) {
            applyStatusGradeRule($form);
        }
    });

    // 🔹 저장 (파일 포함 → FormData 사용)
    function saveEmpEdit() {
        const $form = $('#empEditForm');
        applyStatusGradeRule($form);

        const empNo = $form.find('input[name="empNo"]').val();
        const formData = new FormData($form[0]);

        $.ajax({
            type        : 'POST',
            url         : '${pageContext.request.contextPath}/emp/update',
            data        : formData,
            processData : false,
            contentType : false,
            success     : function (result) {
                if (result === 'DENY') {
                    alert('수정 권한이 없습니다.');
                    return;
                }
                if (result === 'OK') {
                    // 카드 다시 로드 (상위 JSP에서 EMP_CARD_URL과 #emp-detail-card 정의해둔 경우)
                    if (typeof EMP_CARD_URL !== 'undefined') {
                        $('#emp-detail-card').load(EMP_CARD_URL + '?empNo=' + empNo);
                    } else {
                        alert('저장되었습니다.');
                        location.reload();
                    }
                } else {
                    alert('사원 수정 중 오류가 발생했습니다.');
                }
            },
            error       : function () {
                alert('저장 중 오류가 발생했습니다.');
            }
        });
    }
</script>
