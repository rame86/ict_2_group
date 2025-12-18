

$(function() {

	$('#replyConfirm').on("click", function() {

		let params = $('#replyFrm').serialize();

		$.ajax({
			type: 'get'
			, data: params
			, url: '/replies/new'
			, success: function(result) {
				console.log(result);
				$('#reply').val("");
				replyList(); // replyList 함수 호출
			}

			, error: function(err) {
				alert('에러:');
				console.log(err);
			}
		})
	}) // end of $('#replyConfirm') click



	replyList(); // replyList 함수 호출

	// 리플레이 목록 가져와 출력하기
	function replyList() {
		let param = { bno: $('#bno').val() };

		$.ajax({
			type: 'get'
			, data: param
			, url: '/replies'
			, success: function(result) {
				console.log(result);
				// 화면 초기화
				$('#replyList').empty();

				// 로그인 확인
				console.log(loginId);
				// 댓글 메뉴 출력
				let newTable = '<tr>';
				newTable += '<th>댓글 번호</th>';
				newTable += '<th>작성자</th>';
				newTable += '<th>내용</th>';
				newTable += '<th>작성일</th>';				
				newTable += '</tr>';
				$('#replyList').append(newTable);

				$.each(result, function(index, reply) {
					let output = '<tr>';
					output += '<td>' + reply.rno + '</td>';      // 댓글 번호					       
					output += '<td>' + reply.replyer + '</td>';   // 작성자
					output += '<td>' + reply.reply + '</td>';  // 댓글 내용
					output += '<td>' + reply.replydate + '</td>'; // 작성일
					if (reply.replyer == loginId) {
						output += '<td><button class="modify" >수정</button></td>';
						output += '<td><button class="delete" >삭제</button></td>';
					}
					output += '</tr>';

					$('#replyList').append(output);

				})

			}
			, error: function(err) {
				alert('에러:');
				console.log(err);
			}
		})

	} // end of replyList()


	// '삭제' 버튼을 클릭했을 때 restful 방식
	$('#replyList').on("click", ".delete", function() {

		let rno = $(this).closest('tr').find('td:first').text();

		$.ajax({
			type: 'delete'
			, url: '/replies/' + rno
			, success: function(result) {
				console.log(result + "개의 댓글 삭제성공");
				replyList(); // replyList 함수 호출
			}

			, error: function(err) {
				alert('에러:');
				console.log(err);
			}
		})


	})

	$('#replyList').on("click", ".modify", function() {

		let btn = $(this)
		let replyTd = $(this).closest('tr').find('td:eq(2)');


		if (btn.text().trim() == '수정') {

			// 댓글 부분을 수정할 수 있게 변경
			let replyText = replyTd.text();
			replyTd.empty();
			let modifyText = '<input type="text" name="reply" value="' + replyText + '">'
			replyTd.append(modifyText)

			btn.text('수정하기')

		} else if (btn.text().trim() == '수정하기') {

			//댓글 수정한 input 내용 컨트롤로 보내기
			let rno = $(this).closest('tr').find('td:first').text();
			let params = { reply: $(this).closest('tr').find('input:eq(0)').val() };


			$.ajax({
				type: 'put'
				, data: params
				, url: '/replies/' + rno
				, success: function(result) {
					console.log(result + "개의 댓글 수정성공");
					replyList(); // replyList 함수 호출
				}

				, error: function(err) {
					alert('에러:');
					console.log(err);
				}
			})

		}

	})
})

