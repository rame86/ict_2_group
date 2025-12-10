package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.domain.ReplyVO;
import com.example.service.ReplyService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController // 100% ajax 호출인 경우!!!****************
public class ReplyController {

	@Autowired
	private ReplyService replyService;

	//

	// insertReply() ----------------------------------------------
	@GetMapping("replies/new")
	public String insertReply(ReplyVO vo) {

		log.info("[ReplyController - replies/new] 요청" + vo.toString());

		Integer result = replyService.insertReply(vo);
		if (result == 1) {
			return "[댓글 입력 성공]";
		} else {
			return "[댓글 입력 실패]";
		}

	}// end of insertReply() ----------------------------------------------

	//

	// selectAllReply() ----------------------------------------------
	@GetMapping("replies")
	public List<ReplyVO> selectAllReply(@RequestParam("bno") int boardNo) {
		log.info("[ReplyController - replies] 요청");

		List<ReplyVO> result = replyService.selectAllReply(boardNo);

//		// 결과값 확인
//		for(ReplyVO vo: result) {
//			log.info(vo.toString());
//		}

		return result;
	} // end of selectAllReply() ------------------------------------

	//

	// deleteReply() ----------------------------------------------
	@DeleteMapping("/replies/{rno}")
	public Integer deleteReply(@PathVariable Integer rno) {
		log.info("[ReplyController - deleteReply] 요청 - rno 값:"+ rno);
		Integer result = replyService.deleteReply(rno);
		return result;
	}// end of deleteReply() --------------------------------------
	
	//
	
	// modifyReply() ---------------------------------------------
	@PutMapping("/replies/{rno}")
	public Integer modifyReply(@PathVariable Integer rno, ReplyVO vo) {
		log.info("[ReplyController - deleteReply] 요청 - rno 값:"+ rno);
		log.info("[ReplyController - deleteReply] 요청 - ReplyVO 값:"+ vo.getReply());
		
		vo.setRno(rno);
		
		Integer result = replyService.modifyReply(vo);
		return result;
		
	}
	
}
