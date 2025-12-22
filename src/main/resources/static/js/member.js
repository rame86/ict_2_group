$(function() {

	let formIdCheck = false;
	let formPassCheck = false;
	let $submitBtn = $('#submitBtn');

	// 비밀번호 입력 감지
	$('#empPass').on('input', checkPassword);
	$('#empPassConfirm').on('input', checkPassword);

	// [추가됨] 사원번호 입력 시 오류 메시지 초기화
	$('#empNo').on('input', function() {
		if ($(this).val()) {
			$(this).removeClass('is-invalid');
			$('#empNoMsg').hide();
		}
	});

	// [추가됨] 사원번호와 이름 입력창에서 포커스가 나갈 때(탭 키 등) 자동 검사
	$('#empNo, #empName').on('blur', function() {
		// true를 전달하여 '자동 모드'임을 알림 (경고창/에러메시지 띄우지 않음)
		checkEmpInfo(true);
	});

	// 버튼 클릭 시에는 수동 검사 (에러메시지 띄움)
	$('#empNoCheck').on('click', function(evt) {
		evt.preventDefault();
		// false를 전달하여 '수동 모드'임을 알림
		checkEmpInfo(false);
	});

	// 버튼 활성화
	function updateSubmitButtonState() {
		if (formIdCheck && formPassCheck) {
			$submitBtn.prop('disabled', false);
		} else {
			$submitBtn.prop('disabled', true);
		}
	}

	/**
	 * 피드백 메시지와 스타일을 적용하는 공통 함수
	 */
	function showFeedback(inputSelector, msgSelectorSuccess, msgSelectorFail, status, message) {
		const $input = $(inputSelector);
		const $successDiv = $(msgSelectorSuccess);
		const $failDiv = $(msgSelectorFail);

		// 일단 모든 상태 초기화
		$input.removeClass('is-valid is-invalid');
		// jQuery 객체에 대해 메서드를 호출하므로 선택자가 없어도 에러는 나지 않음
		$successDiv.text('').hide();
		$failDiv.text('').hide();

		if (status === 'success') {
			$input.addClass('is-valid'); // 테두리 파란색/초록색
			$successDiv.html('<i class="fas fa-check-circle"></i> ' + message).show();
		} else if (status === 'error') {
			$input.addClass('is-invalid'); // 테두리 빨간색
			$failDiv.html('<i class="fas fa-exclamation-circle"></i> ' + message).show();
		}
	}

	/**
	 * [리팩토링됨] 사원번호/이름 일치 확인 로직 함수화
	 * @param {boolean} isAuto - true면 자동검사(경고 없음), false면 버튼클릭(경고 있음)
	 */
	function checkEmpInfo(isAuto) {
		let empNoVal = $('#empNo').val();
		let empNameVal = $('#empName').val();

		// 1. 유효성 검사 (입력값 유무 확인)
		if (isAuto) {
			// 자동 검사(탭 이동)일 때는 둘 중 하나라도 없으면 그냥 조용히 리턴
			if (!empNoVal || !empNameVal) return;
		} else {
			// 버튼 클릭일 때는 적극적으로 피드백 표시

			// [수정] 사원번호 비었을 때 alert 대신 텍스트로 알림
			if (!empNoVal) {
				showFeedback('#empNo', '', '#empNoMsg', 'error', '사원번호를 입력해주세요.');
				$('#empNo').focus();
				return;
			}
			// 이름 비었을 때 (이 부분은 기존 로직 유지하되 필요하면 동일하게 변경 가능)
			if (!empNameVal) {
				alert("일치 여부 확인을 위해 이름을 먼저 입력해주세요.");
				$('#empName').focus();
				return;
			}
		}

		let param = { empNo: empNoVal, empName: empNameVal };

		$.ajax({
			type: 'get',
			data: param,
			url: '/member/empNoCheck',
			success: function(result) {
				// register.jsp에 있는 ID: #empName, #empNoSuccess, #empNoFail
				if (result === "2") {
					showFeedback('#empName', '#empNoSuccess', '#empNoFail', 'error', "이미 가입된 사원입니다.");
					formIdCheck = false;
				} else if (result === "3") {
					showFeedback('#empName', '#empNoSuccess', '#empNoFail', 'error', "사원정보가 일치하지 않습니다.");
					formIdCheck = false;
				} else if (result === "1") {
					showFeedback('#empName', '#empNoSuccess', '#empNoFail', 'success', "확인되었습니다. 가입 가능합니다.");
					// 사번 쪽 에러 메시지가 혹시 남아있다면 제거
					$('#empNo').removeClass('is-invalid').addClass('is-valid');
					$('#empNoMsg').hide();
					formIdCheck = true;
				} else if (result === "4") {
					$("#empEmailDiv").hide();
					$("#empEmail").removeAttr('required');
					showFeedback('#empName', '#empNoSuccess', '#empNoFail', 'success', "카카오 계정과 연동됩니다.");
					// 사번 쪽 에러 메시지 제거
					$('#empNo').removeClass('is-invalid').addClass('is-valid');
					$('#empNoMsg').hide();
					formIdCheck = true;
				} else {
					showFeedback('#empName', '#empNoSuccess', '#empNoFail', 'error', "오류가 발생했습니다.");
					formIdCheck = false;
				}
				updateSubmitButtonState();
			},
			error: function(err) {
				// 자동 검사 시에는 통신 에러 alert 무시
				if (!isAuto) alert('통신 실패');
				console.log(err);
				formIdCheck = false;
				updateSubmitButtonState();
			}
		});
	}

	// checkPassword - 비밀번호 검사
	function checkPassword() {
		let pass = $("#empPass").val();
		let pass2 = $('#empPassConfirm').val();

		// 1. 비밀번호 길이 검사 (8자리 미만)
		if (pass.length < 8) {
			showFeedback('#empPass', '', '#pass1Fail', 'error', '8자 이상 입력해주세요.');
			showFeedback('#empPassConfirm', '#passSuccess', '#passFail', 'reset', '');
			formPassCheck = false;
		}
		else {
			showFeedback('#empPass', '', '#pass1Fail', 'reset', '');
			$('#empPass').addClass('is-valid');

			// 2. 비밀번호 확인 입력 여부
			if (pass2.length === 0) {
				showFeedback('#empPassConfirm', '#passSuccess', '#passFail', 'reset', '');
				formPassCheck = false;
			}
			// 3. 불일치
			else if (pass !== pass2) {
				showFeedback('#empPassConfirm', '#passSuccess', '#passFail', 'error', '비밀번호가 일치하지 않습니다.');
				formPassCheck = false;
			}
			// 4. 일치
			else {
				showFeedback('#empPassConfirm', '#passSuccess', '#passFail', 'success', '비밀번호가 일치합니다.');
				formPassCheck = true;
			}
		}
		updateSubmitButtonState();
	}

	// memberSave 회원가입 및 연동 요청
	$('#registForm').on('submit', function(e) {
		e.preventDefault();

		let formData = $(this).serialize();

		// 현재 다크모드인지 확인
		const isDarkMode = $('body').hasClass('dark-mode');

		// 모드에 따른 SweetAlert 배경/글자색 설정
		const swalBackground = isDarkMode ? '#1e1e1e' : '#ffffff';
		const swalColor = isDarkMode ? '#ffffff' : '#212529';

		$.ajax({
			type: 'post',
			url: '/member/memberSave',
			data: formData,
			success: function(result) {
				if (result === 1) {
					// [성공] 신규가입 또는 연동 성공
					Swal.fire({
						icon: 'success',
						title: '완료!',
						text: '정상적으로 처리되었습니다. 로그인 페이지로 이동합니다.',
						background: swalBackground,
						color: swalColor,
						confirmButtonColor: '#e85a6a',
						confirmButtonText: '확인'
					}).then((result) => {
						if (result.isConfirmed) {
							window.location.href = "/member/login";
						}
					});
				} else if (result === 0) {
					// 연동 실패 (비밀번호 불일치 등 로직 실패 시 0 반환)
					Swal.fire({
						icon: 'error',
						title: '연동 실패',
						text: '기존 계정의 비밀번호와 일치하지 않습니다. 다시 확인해주세요.',
						background: swalBackground,
						color: swalColor,
						confirmButtonColor: '#e85a6a',
						confirmButtonText: '확인'
					});
				} else {
					// [기타] 데이터베이스 오류 등
					Swal.fire({
						icon: 'error',
						title: '처리 실패',
						text: '데이터 저장 중 알 수 없는 오류가 발생했습니다.',
						background: swalBackground,
						color: swalColor,
						confirmButtonColor: '#e85a6a'
					});
				}
			},
			error: function(err) {
				Swal.fire({
					icon: 'warning',
					title: '통신 오류',
					text: '서버와의 연결이 원활하지 않습니다.',
					background: swalBackground,
					color: swalColor
				});
			}
		});
	});
});