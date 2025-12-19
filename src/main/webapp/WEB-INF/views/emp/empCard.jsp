<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="emp-card" id="empCardRoot">

	<%-- =========================================================
       1) 보기 모드 (읽기 전용)
       - 이미지 onerror 대비
       - textarea 공백/줄바꿈 섞임 방지(한 줄로 출력)
     ========================================================= --%>
	<div class="emp-card-view">

		<div class="emp-card-header">
			<div class="emp-photo-placeholder">
				<c:choose>
					<c:when test="${not empty emp.empImage}">
						<img
							src="${pageContext.request.contextPath}/upload/emp/${emp.empImage}"
							alt="${emp.empName}"
							style="width: 100%; height: 100%; object-fit: cover; border-radius: 16px;"
							onerror="this.onerror=null; this.style.display='none'; this.parentNode.textContent='PHOTO';" />
					</c:when>
					<c:otherwise>
            PHOTO
          </c:otherwise>
				</c:choose>
			</div>

			<div class="emp-basic-info">
				<h3>
					<c:out value="${emp.empName}" />
				</h3>
				<p>
					/ 직급번호:
					<c:out value="${emp.gradeNo}" />
				</p>
				<p>
					사번 :
					<c:out value="${emp.empNo}" />
				</p>
				<p>
					입사일 :
					<c:out value="${emp.empRegdate}" />
				</p>
			</div>
		</div>

		<hr />

		<div class="emp-card-body">
			<table class="emp-card-table">
				<colgroup>
					<col class="col-label">
					<col class="col-value">
					<col class="col-label">
					<col class="col-value col-value-wide">
				</colgroup>

				<tr>
					<th>재직상태</th>
					<td><c:out value="${emp.statusName}" /></td>
					<th>직급번호</th>
					<td><c:out value="${emp.gradeNo}" /></td>
				</tr>

				<tr>
					<th>연락처</th>
					<td><c:out value="${emp.empPhone}" /></td>
					<th>이메일</th>
					<td><c:out value="${emp.empEmail}" /></td>
				</tr>

				<tr>
					<th>주소</th>
					<td colspan="3"><c:out value="${emp.empAddr}" /></td>
				</tr>

				<%-- 비고 (조회 전용) --%>
				<tr>
					<th>비고</th>
					<td colspan="3"><textarea class="emp-note-view" rows="10"
							style="width: 100%; resize: vertical;" readonly><c:out
								value="${editNoteHistory}" /></textarea></td>
				</tr>
			</table>
		</div>

		<%-- 관리자만 수정/삭제 노출 --%>
		<c:if test="${canModify or canDelete}">
			<div class="emp-card-actions">

				<c:if test="${canModify}">
					<button type="button" class="emp-btn emp-btn-edit"
						onclick="enterEmpEditMode()">수정</button>
				</c:if>

				<c:if test="${canDelete}">
					<button type="button" class="emp-btn emp-btn-delete"
						onclick="deleteEmp('<c:out value="${emp.empNo}"/>')">삭제</button>
				</c:if>

			</div>
		</c:if>

	</div>


	<%-- =========================================================
       2) 수정 모드 (입력 폼)
       - 처음엔 숨김
       - retireDateRow/retireDate는 "카드 내부 스코프"로만 조작하도록 JS에서 처리
     ========================================================= --%>
	<c:if test="${canModify}">
		<div class="emp-card-edit" style="display: none;">

			<form id="empEditForm" method="post" enctype="multipart/form-data">
				<input type="hidden" name="empNo" value="${emp.empNo}" /> <input
					type="hidden" name="oldEmpImage" value="${emp.empImage}" />

				<div class="emp-card-header">

					<%-- 사진 수정 가능 영역 --%>
					<div class="emp-photo-placeholder" id="empEditPhotoBox">
						<c:choose>
							<c:when test="${not empty emp.empImage}">
								<img id="empEditPhotoPreview"
									src="${pageContext.request.contextPath}/upload/emp/${emp.empImage}"
									alt="${emp.empName}"
									style="width: 100%; height: 100%; object-fit: cover; border-radius: 16px;"
									onerror="this.onerror=null; this.style.display='none'; document.getElementById('empEditPhotoText').style.display='block';" />
								<span id="empEditPhotoText" style="display: none;">PHOTO</span>
							</c:when>
							<c:otherwise>
								<span id="empEditPhotoText">PHOTO</span>
								<img id="empEditPhotoPreview"
									style="display: none; width: 100%; height: 100%; object-fit: cover; border-radius: 16px;"
									alt="사진 미리보기" />
							</c:otherwise>
						</c:choose>
					</div>

					<%-- 실제 파일 선택 input (숨김) --%>
					<input type="file" name="empImageFile" id="empEditImageFile"
						accept="image/*" style="display: none;">

					<div class="emp-basic-info">
						<h3>
							<c:out value="${emp.empName}" />
						</h3>
						<p>
							/ 직급번호:
							<c:out value="${emp.gradeNo}" />
						</p>
						<p>
							사번 :
							<c:out value="${emp.empNo}" />
						</p>
						<p>
							입사일 :
							<c:out value="${emp.empRegdate}" />
						</p>
					</div>
				</div>

				<hr />

				<div class="emp-card-body">
					<table class="emp-card-table">
						<tr>
							<th>재직상태</th>
							<td><select name="statusNo">
									<option value="1"
										${String.valueOf(emp.statusNo).trim() eq '1' ? 'selected' : ''}>재직</option>
									<option value="7"
										${String.valueOf(emp.statusNo).trim() eq '7' ? 'selected' : ''}>파견</option>
									<option value="2"
										${String.valueOf(emp.statusNo).trim() eq '2' ? 'selected' : ''}>휴직(자발적)</option>
									<option value="3"
										${String.valueOf(emp.statusNo).trim() eq '3' ? 'selected' : ''}>휴직(병가
										등 복지)</option>
									<option value="4"
										${String.valueOf(emp.statusNo).trim() eq '4' ? 'selected' : ''}>대기</option>
									<option value="5"
										${String.valueOf(emp.statusNo).trim() eq '5' ? 'selected' : ''}>징계</option>
									<option value="6"
										${String.valueOf(emp.statusNo).trim() eq '6' ? 'selected' : ''}>인턴/수습</option>
									<option value="0"
										${String.valueOf(emp.statusNo).trim() eq '0' ? 'selected' : ''}>퇴직</option>

							</select></td>
							<th>직급번호</th>
							<td><select name="gradeNo">
									<option value="1"
										${String.valueOf(emp.gradeNo).trim() eq '1' ? 'selected' : ''}>1
										- 최고관리자</option>
									<option value="2"
										${String.valueOf(emp.gradeNo).trim() eq '2' ? 'selected' : ''}>2
										- 상급관리자</option>
									<option value="3"
										${String.valueOf(emp.gradeNo).trim() eq '3' ? 'selected' : ''}>3
										- 하급관리자</option>
									<option value="4"
										${String.valueOf(emp.gradeNo).trim() eq '4' ? 'selected' : ''}>4
										- 사원</option>
									<option value="5"
										${String.valueOf(emp.gradeNo).trim() eq '5' ? 'selected' : ''}>5
										- 인턴/수습</option>
									<option value="6"
										${String.valueOf(emp.gradeNo).trim() eq '6' ? 'selected' : ''}>6
										- 기타</option>


							</select> <br /> <span class="grade-guide"> ※ 재직/파견만 1~4등급 선택 가능,<br>
									인턴/수습은 5등급,<br> 휴직·대기·징계·퇴직 등은 6등급으로 고정됩니다.
							</span></td>
						</tr>

						<%-- 퇴직일용 달력 행 (처음엔 숨김) --%>
						<tr id="retireDateRow" style="display: none;">
							<th>퇴사일</th>
							<td><input type="date" id="retireDate" name="retireDate"
								class="form-control"></td>
							<td colspan="2"></td>
						</tr>

						<tr>
							<th>연락처</th>
							<td><input type="text" name="empPhone"
								value="${emp.empPhone}" style="width: 100%;"></td>
							<th>이메일</th>
							<td><input type="text" name="empEmail"
								value="${emp.empEmail}" style="width: 100%;"></td>
						</tr>

						<%-- 주소: 우편번호/도로명/상세 + hidden(empAddr) --%>
						<tr>
							<th>주소</th>
							<td colspan="3">
								<div class="addr-row">
									<input type="text" id="editPostcode"
										class="form-control addr-postcode" placeholder="우편번호">
									<button type="button" id="btnEditAddrSearch" class="btn-addr">주소
										검색</button>
								</div>

								<div class="addr-row" style="margin-top: 8px;">
									<input type="text" id="editAddrRoad" class="form-control"
										placeholder="도로명 주소" value="${emp.empAddr}">
								</div>

								<div class="addr-row" style="margin-top: 8px;">
									<input type="text" id="editAddrDetail" class="form-control"
										placeholder="상세 주소를 입력하세요">
								</div> <input type="hidden" name="empAddr" id="editEmpAddrHidden"
								value="${emp.empAddr}">
							</td>
						</tr>

						<%-- 비고 --%>
						<tr>
							<th>비고</th>
							<td colspan="3"><textarea id="eNoteHistoryView"
									class="emp-note-view" rows="8"
									style="width: 100%; resize: vertical; margin-bottom: 6px;"
									readonly><c:out value="${editNoteHistory}" /></textarea> <textarea
									id="eNote" name="eNote" rows="3"
									style="width: 100%; resize: vertical;"
									placeholder="추가로 남길 비고를 입력하세요."></textarea></td>
						</tr>
					</table>
				</div>
			</form>

			<div class="emp-card-actions">
				<button type="button" class="emp-btn emp-btn-edit"
					onclick="saveEmpEdit()">저장</button>
				<button type="button" class="emp-btn emp-btn-delete"
					onclick="cancelEmpEditMode()">취소</button>
			</div>
		</div>
	</c:if>

</div>

<%-- Daum 주소 검색 API --%>
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
	(function() {
		// ✅ 안정화: empCard는 AJAX로 계속 다시 로드되므로 "카드 DOM 내부 스코프"로만 조작합니다.
		const $root = $('#empCardRoot');
		const $form = $root.find('#empEditForm');

		function applyStatusGradeRule() {
			const status = $form.find('select[name="statusNo"]').val();
			const $grade = $form.find('select[name="gradeNo"]');

			$grade.prop('disabled', false);
			$grade.find('option').prop('disabled', false);

			if (status === '6') { // 인턴/수습 → 5 고정
				$grade.val('5').prop('disabled', true);
				return;
			}
			if ([ '0', '2', '3', '4', '5' ].includes(status)) { // 퇴직/휴직/대기/징계 → 6 고정
				$grade.val('6').prop('disabled', true);
				return;
			}
			if (status === '1' || status === '7') { // 재직/파견 → 1~4만 허용
				$grade.find('option').each(
						function() {
							const v = $(this).val();
							$(this).prop('disabled',
									![ '1', '2', '3', '4' ].includes(v));
						});
				const now = $grade.val();
				if (![ '1', '2', '3', '4' ].includes(now))
					$grade.val('3');
				return;
			}
			$grade.val('6').prop('disabled', true); // 그 외는 안전하게 6
		}

		function toggleRetireDate() {
			const status = $form.find('select[name="statusNo"]').val();
			const $row = $root.find('#retireDateRow');
			const $date = $root.find('#retireDate');

			if (status === '0') {
				$row.show();
			} else {
				$row.hide();
				$date.val('');
			}
		}

		function updateEditEmpAddrHidden() {
			const postcode = $root.find('#editPostcode').val().trim();
			const road = $root.find('#editAddrRoad').val().trim();
			const detail = $root.find('#editAddrDetail').val().trim();

			const parts = [];
			if (postcode)
				parts.push('(' + postcode + ')');
			if (road)
				parts.push(road);
			if (detail)
				parts.push(detail);

			$root.find('#editEmpAddrHidden').val(parts.join(' '));
		}

		function openPostcodeEdit() {
			new daum.Postcode(
					{
						oncomplete : function(data) {
							let addr = (data.userSelectedType === 'R') ? data.roadAddress
									: data.jibunAddress;

							const extra = [];
							if (data.bname)
								extra.push(data.bname);
							if (data.buildingName)
								extra.push(data.buildingName);
							if (extra.length > 0)
								addr += ' (' + extra.join(', ') + ')';

							$root.find('#editPostcode').val(data.zonecode);
							$root.find('#editAddrRoad').val(addr);
							$root.find('#editAddrDetail').focus();

							updateEditEmpAddrHidden();
						}
					}).open();
		}

		// ✅ 전역 함수는 기존 onclick과 호환되게 유지하되, 내부는 스코프 기반으로 안전 처리
		window.enterEmpEditMode = function() {
			$root.find('.emp-card-view').hide();
			$root.find('.emp-card-edit').show();

			applyStatusGradeRule();
			toggleRetireDate();

			$root.find('#empEditPhotoBox').css('cursor', 'pointer');
		};

		window.cancelEmpEditMode = function() {
			$root.find('.emp-card-edit').hide();
			$root.find('.emp-card-view').show();
		};

		window.saveEmpEdit = function() {
			applyStatusGradeRule();
			toggleRetireDate();
			updateEditEmpAddrHidden();

			const empNo = $form.find('input[name="empNo"]').val();
			const formData = new FormData($form[0]);

			$.ajax({
				type : 'POST',
				url : '${pageContext.request.contextPath}/emp/update',
				data : formData,
				processData : false,
				contentType : false,
				success : function(result) {
					if (result === 'DENY') {
						alert('수정 권한이 없습니다.');
						return;
					}
					if (result === 'FILE_SIZE') {
						alert('파일 용량은 2MB 이하만 가능합니다.');
						return;
					}
					if (result === 'FILE_TYPE') {
						alert('이미지 파일(jpg/png/gif)만 업로드할 수 있습니다.');
						return;
					}

					if (result === 'OK') {
						if (typeof EMP_CARD_URL !== 'undefined') {
							$('#emp-detail-card').load(
									EMP_CARD_URL + '?empNo=' + empNo);
						} else {
							alert('저장되었습니다.');
							location.reload();
						}
					} else {
						alert('사원 수정 중 오류가 발생했습니다.');
					}
				},
				error : function() {
					alert('저장 중 오류가 발생했습니다.');
				}
			});
		};

		function applyRetireDateToNote() {
			const date = $root.find('#retireDate').val();
			const $note = $root.find('#eNote');

			if (!date)
				return;

			const retireLine = '퇴사일 : ' + date;
			let note = $note.val() || '';

			if (note.includes('퇴사일 :')) {
				note = note.replace(/퇴사일\s*:\s*\d{4}-\d{2}-\d{2}/, retireLine);
			} else {
				note = (note.trim().length === 0) ? retireLine : (retireLine
						+ '\n' + note);
			}
			$note.val(note);
		}

		// ✅ 안정화: AJAX 재로드 시 이벤트 중복 방지 (off → on)
		$root.find('#empEditPhotoBox').off('click.emp').on('click.emp',
				function() {
					$root.find('#empEditImageFile').trigger('click');
				});

		$root.find('#empEditImageFile').off('change.emp').on(
				'change.emp',
				function(e) {
					const file = e.target.files && e.target.files[0];
					if (!file)
						return;

					const reader = new FileReader();
					reader.onload = function(ev) {
						$root.find('#empEditPhotoPreview').attr('src',
								ev.target.result).show();
						$root.find('#empEditPhotoText').hide();
					};
					reader.readAsDataURL(file);
				});

		$form.off('change.emp', 'select[name="statusNo"]').on('change.emp',
				'select[name="statusNo"]', function() {
					applyStatusGradeRule();
					toggleRetireDate();
				});

		$root.find('#retireDate').off('change.emp').on('change.emp',
				function() {
					applyRetireDateToNote();
				});

		$root.find('#btnEditAddrSearch').off('click.emp').on('click.emp',
				function() {
					openPostcodeEdit();
				});

		$root.find('#editAddrRoad, #editAddrDetail').off('input.emp blur.emp')
				.on('input.emp blur.emp', function() {
					updateEditEmpAddrHidden();
				});

		$root.find('#eNote').off('focus.emp click.emp').on(
				'focus.emp click.emp', function() {
					const textarea = this;
					setTimeout(function() {
						textarea.setSelectionRange(0, 0);
						textarea.scrollTop = 0;
					}, 0);
				});

		// ✅ 처음 로드 시 주소 값 보정
		const existingAddr = $root.find('#editEmpAddrHidden').val();
		if (existingAddr && !$root.find('#editAddrRoad').val()) {
			$root.find('#editAddrRoad').val(existingAddr);
		}

		// ✅ 혹시 edit 화면이 열려있는 상태로 로드되는 케이스 대비
		if ($root.find('.emp-card-edit').is(':visible')) {
			applyStatusGradeRule();
			toggleRetireDate();
		}
	})();

	// ✅ 삭제 (안정화)
	// - 성공 시: 오른쪽 상세 카드 비우고 placeholder 표시
	// - 왼쪽 목록: DataTable에서 해당 행 제거(가능하면)
	window.deleteEmp = function(empNo) {
		if (!empNo)
			return;
		if (!confirm('정말 삭제할까요?'))
			return;

		$.ajax({
			type : 'POST',
			url : '${pageContext.request.contextPath}/emp/delete',
			data : {
				empNo : empNo
			},
			success : function(result) {
				if (result === 'DENY') {
					alert('삭제 권한이 없습니다.');
					return;
				}
				if (result !== 'OK') {
					alert('삭제 중 오류가 발생했습니다.');
					return;
				}

				// 1) 오른쪽 상세 영역 정리
				$('#emp-detail-card').hide().empty();
				$('#emp-detail-placeholder').show();

				// 2) 왼쪽 DataTable에서 해당 행 제거 (있을 때만)
				try {
					const dt = $('#empTable').DataTable();
					const $row = $('#empTable tbody tr.emp-row[data-empno="'
							+ empNo + '"]');
					if ($row.length) {
						dt.row($row).remove().draw(false);
					} else {
						// 못 찾으면 새로고침(안전)
						// location.reload();
					}
				} catch (e) {
					// DataTable이 없거나 에러면 새로고침이 제일 안전
					// location.reload();
				}

				alert('삭제되었습니다.');
			},
			error : function() {
				alert('삭제 요청 중 오류가 발생했습니다.');
			}
		});
	};
</script>
