$(function() {

	let formIdCheck = false;
	let formPassCheck = false;
	let $submitBtn = $('#submitBtn');

	$('#empPass').on('input', checkPassword);
	$('#empPassConfirm').on('input', checkPassword);
	
	
	function updateSubmitButtonState() {
		if (formIdCheck && formPassCheck) {
			$submitBtn.prop('disabled', false);
			alert("가입 버튼 활성화")
		} else {
			$submitBtn.prop('disabled', true);
			
		}
	}

	// idCheck - 아이디 중복 체크
	$('#empNoCheck').on('click', function(evt) {
		// 이벤트버블링 막기
		evt.preventDefault();

		let param = { empNo: $('#empNo').val(), empName: $('#empName').val() }

		let empNoCheckResult = $('#empNoCheckResult');

		$.ajax({
			type: 'get'
			, data: param
			, url: '/member/empNoCheck'
			, success: function(result) {
				// 아이디 유효성 검사
				if (result) {
					empNoCheckResult.css('color', 'blue');
					empNoCheckResult.text("사원ID가 확인되었습니다.")
					formIdCheck = true;
				} else {
					empNoCheckResult.css('color', 'red');
					empNoCheckResult.text("사원ID와 이름이 일치하지 않습니다.")
					formIdCheck = false;
				}
				updateSubmitButtonState();
			},
			error: function(err) {
				console.log(err.responseText)
				alert('실패:' + err.responseText)
				formIdCheck = false;
				updateSubmitButtonState();
			}
		})
	}) //end of idCheck


	// checkPassword - 아이디 중복 체크
	function checkPassword() {
		let pass = $("#empPass").val();
		let pass2 = $('#empPassConfirm').val();
		let passCheck = $('#passCheck');
	    
	    // 1. 초기 상태: 두 필드 모두 비어있을 때
	    // 'pass.length === 0'만 확인해도 됩니다.
	    if (pass.length === 0) { 
	        passCheck.text(""); // 메시지 삭제
	        formPassCheck = false;
	    }
		// 2. 비밀번호 길이 검사 (pass 필드 기준)
		else if (pass.length < 8) {
			passCheck.css('color', 'red');
			passCheck.text("비밀번호는 최소 8자리 이상이어야 합니다.");
			formPassCheck = false;
		}
		// 3. 비밀번호 확인 필드 입력 여부 검사 (pass는 8자 이상인데 pass2가 비어있는 경우)
		else if (pass2.length == 0) {
			passCheck.css('color', 'orange');
			passCheck.text("비밀번호 확인을 위해 한 번 더 입력해 주세요.");
			formPassCheck = false;
		}
		// 4. 비밀번호 불일치 검사
		else if (pass != pass2) {
			passCheck.css('color', 'red');
			passCheck.text("비밀번호가 일치하지 않습니다.");
			formPassCheck = false;
		} 
	    // 5. 최종 성공
	    else {
			passCheck.css('color', 'blue');
			passCheck.text("비밀번호가 일치합니다.");
			formPassCheck = true;
		}
		
		updateSubmitButtonState();
	}



	// end of checkPassword



})