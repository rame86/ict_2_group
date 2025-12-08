<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="emp-card">

    <%-- =========================
         1) 보기 모드 (읽기 전용)
       ========================== --%>
    <div class="emp-card-view">

        <div class="emp-card-header">
            <div class="emp-photo-placeholder">
                PHOTO
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

    </div> <%-- 🔹 여기서 emp-card-view 닫기 --%>



    <%-- =========================
         2) 수정 모드 (입력 폼)
         - 처음에는 숨김
       ========================== --%>
    <c:if test="${canModify}">
        <div class="emp-card-edit" style="display:none;">

            <form id="empEditForm">
                <!-- 어떤 직원을 수정하는지 구분용 -->
                <input type="hidden" name="empNo" value="${emp.empNo}"/>

                <div class="emp-card-header">
                    <div class="emp-photo-placeholder">
                        PHOTO
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
                                    ※ 재직/파견만 1~4등급 선택 가능, 인턴/수습은 5등급, <br/>
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
    // 🔹 재직상태/직급번호 규칙 적용 공통 함수
    //   - 인턴/수습(6)  → 직급 5 고정
    //   - 퇴직/휴직/대기/징계(0,2,3,4,5) → 직급 6 고정
    //   - 재직/파견(1,7) → 직급 1~4만 선택 가능, 나머지 비활성화
    function applyStatusGradeRule($form) {
        const status = $form.find('select[name="statusNo"]').val();
        const $grade = $form.find('select[name="gradeNo"]');

        // 기본: select 자체는 활성화, 옵션도 다 활성화
        $grade.prop('disabled', false);
        $grade.find('option').prop('disabled', false);

        // 1) 인턴/수습 (status 6) → 5로 고정, 선택창도 잠금
        if (status === '6') {
            $grade.val('5');
            $grade.prop('disabled', true);
            return;
        }

        // 2) 퇴직/휴직/대기/징계 (0,2,3,4,5) → 6으로 고정
        if (status === '0' || status === '2' || status === '3' ||
            status === '4' || status === '5') {
            $grade.val('6');
            $grade.prop('disabled', true);
            return;
        }

        // 3) 재직 / 파견 (1,7) → 1~4만 허용
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
                $grade.val('3');   // 기본값: 사원
            }
            return;
        }

        // 4) 혹시 정의되지 않은 status 값 → 안전하게 기타(6)로 고정
        $grade.val('6');
        $grade.prop('disabled', true);
    }

    // 🔹 보기 모드 -> 수정 모드
    function enterEmpEditMode() {
        $('.emp-card-view').hide();
        $('.emp-card-edit').show();

        const $form = $('#empEditForm');
        applyStatusGradeRule($form);   // 현재 상태에 맞춰 직급 select 보정
    }

    // 🔹 수정 모드 -> 보기 모드 (값은 그대로, 화면만 전환)
    function cancelEmpEditMode() {
        $('.emp-card-edit').hide();
        $('.emp-card-view').show();
    }

    // 🔹 수정 내용 저장
    function saveEmpEdit() {
        const $form = $('#empEditForm');

        // 저장 직전에 한 번 더 상태/직급 규칙 적용
        applyStatusGradeRule($form);

        const formData = $form.serialize();
        const empNo = $form.find('input[name="empNo"]').val();

        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/emp/update',
            data: formData,
            success: function (result) {
                if (result === 'DENY') {
                    alert('수정 권한이 없습니다.');
                    return;
                }
                if (result === 'OK') {
                    // 카드 부분만 다시 로드해서 최신 데이터로 갱신
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
            error: function (xhr) {
                console.log(xhr);
                alert('저장 중 오류가 발생했습니다.');
            }
        });
    }

    // 🔹 페이지 로드 후 이벤트 바인딩
    $(function () {
        const $editForm = $('#empEditForm');

        // 수정 모드에서 재직상태 변경 시마다 규칙 재적용
        $editForm.on('change', 'select[name="statusNo"]', function () {
            applyStatusGradeRule($editForm);
        });

        // 혹시 처음부터 수정 모드로 열리는 경우 대비해서 한 번 적용
        if ($('.emp-card-edit').is(':visible')) {
            applyStatusGradeRule($editForm);
        }
    });
</script>
