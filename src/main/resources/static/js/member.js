$(function() {

	// idCheck - 아이디 중복 체크
	$('#empNoCheck').on('click', function(evt) {

		// 이벤트버블링 막기
		evt.preventDefault();

		let param = { empNo: $('#empNo').val() }

		let empNoCheckResult = $('#empNoCheckResult');

		$.ajax({
			type: 'get'
			, data: param
			, url: '/member/empNoCheck'
			, success: function(result) {
				// 아이디 유효성 검사
				if (result) {
					empNoCheckResult.css('color', 'blue');
					empNoCheckResult.text("사번이 확인되었습니다.")
				} else {
					empNoCheckResult.css('color', 'red');
					empNoCheckResult.text("사용 불가능한 사번 입니다.")
				}
			},
			error: function(err) {
				console.log(err.responseText)
				alert('실패:' + err.responseText)
			}
		})
	}) //end of idCheck


	// checkPassword - 아이디 중복 체크
	function checkPassword() {
		let pass = $("#empPass").val();
		let pass2 = $('#empPassConfirm').val();
		let passCheck = $('#passCheck');

		// 1. 비밀번호 길이 검사 (pass 필드 기준)
		if (pass.length < 8) {
			passCheck.css('color', 'red');
			passCheck.text("비밀번호는 최소 8자리 이상이어야 합니다.");
			return; // 길이 미달이면 여기서 종료
		}
		// 2. 비밀번호 확인 필드 입력 여부 및 일치 검사
		if (pass2.length == 0) {
			// pass가 8자 이상인데 pass2가 비어있는 경우
			passCheck.css('color', 'orange');
			passCheck.text("비밀번호 확인을 위해 한 번 더 입력해 주세요.");
			return;
		}
		// 3. 비밀번호 일치 검사 (길이도 8자 이상이고, pass2에도 값이 있는 경우)
		else if (pass != pass2) {
			passCheck.css('color', 'red');
			passCheck.text("비밀번호가 일치하지 않습니다.");


		} else {
			passCheck.css('color', 'blue');
			passCheck.text("비밀번호가 일치합니다.");
		}
	}

	$('#pass').on('input', checkPassword);
	$('#pass2').on('input', checkPassword);

	// end of checkPassword



})