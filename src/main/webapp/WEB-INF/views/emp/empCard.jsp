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
    </div>



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
                        <!-- 이름은 여기서는 읽기 전용으로 두고 싶으면 input 대신 텍스트로 -->
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
                                <!-- 예시: 재직상태는 선택박스로 수정 -->
                                <select name="statusNo">
                                    <option value="1" ${emp.statusNo == 1 ? 'selected' : ''}>재직</option>
                                    <option value="2" ${emp.statusNo == 2 ? 'selected' : ''}>휴직(자발적)</option>
                                    <option value="3" ${emp.statusNo == 3 ? 'selected' : ''}>휴직(병가 등 복지)</option>
                                    <option value="4" ${emp.statusNo == 4 ? 'selected' : ''}>대기</option>
                                    <option value="5" ${emp.statusNo == 5 ? 'selected' : ''}>징계</option>
                                    <option value="6" ${emp.statusNo == 6 ? 'selected' : ''}>인턴/수습</option>
                                    <option value="7" ${emp.statusNo == 7 ? 'selected' : ''}>파견</option>
                                </select>
                            </td>
                            <th>직급번호</th>
                            <td>
                                <!-- 직급번호도 바꾸고 싶으면 input/select, 아니면 readonly -->
                                <input type="text" name="gradeNo" value="${emp.gradeNo}" style="width:80px;">
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
    // 보기 모드 -> 수정 모드
    function enterEmpEditMode() {
        $('.emp-card-view').hide();
        $('.emp-card-edit').show();
    }

    // 수정 모드 -> 보기 모드 (값은 일단 그대로 둠)
    function cancelEmpEditMode() {
        $('.emp-card-edit').hide();
        $('.emp-card-view').show();
    }

    // 저장 버튼 클릭 시 호출
    function saveEmpEdit() {

        // 1) form 데이터 모으기
        let formData = $('#empEditForm').serialize();
        let empNo = $('#empEditForm input[name="empNo"]').val();

        // 2) AJAX로 서버에 업데이트 요청
        $.ajax({
            type: 'POST',
            url: '/emp/update',      // EmpController에서 매핑한 URL
            data: formData,
            success: function (result) {
                // 서버에서 "OK" 등으로 응답했다고 가정
                // 3) 저장 성공 후, 카드 내용을 다시 읽기 모드로 새로고침

                if (typeof EMP_CARD_URL !== 'undefined') {
                    // 목록 화면에서 이미 쓰고 있는 /emp/card URL 상수 재사용
                    $('#emp-detail-card').load(EMP_CARD_URL + '?empNo=' + empNo);
                } else {
                    // 혹시 EMP_CARD_URL이 없다면 그냥 화면만 토글
                    alert('저장되었습니다.');
                    cancelEmpEditMode();
                }
            },
            error: function (xhr) {
                alert('저장 중 오류가 발생했습니다.');
                console.log(xhr);
            }
        });
    }
</script>

