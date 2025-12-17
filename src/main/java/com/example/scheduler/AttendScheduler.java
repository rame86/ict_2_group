package com.example.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.service.AttendService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class AttendScheduler {

	@Autowired
	private AttendService attendService;

	// 매일 18시 30분: 미출근자 일괄 결근 처리
	// (퇴근 기준 시간인 18:00가 지난 후 안전하게 실행)

	@Scheduled(cron = "0 30 18 * * *") // 매일 18시 30분 00초 실행
	public void autoProcessAbsence() {
		log.info("[Scheduler] 미출근자 결근 처리 시작");
		try {
			int count = attendService.processDailyAbsence();
			log.info("[Scheduler] 미출근자 결근 처리 완료 - 총 {}명", count);
		} catch (Exception e) {
			log.error("[Scheduler] 미출근자 처리 중 오류 발생", e);
		}
	}

	// 매일 23시 59분: 미퇴근자(출근은 했으나 퇴근 안 함) 결근 처리
	@Scheduled(cron = "0 59 23 * * *") // 매일 23시 59분 00초 실행
	public void autoProcessIncomplete() {
		log.info("[Scheduler] 미퇴근자 결근 처리 시작");
		try {
			int count = attendService.processIncompleteAttendance();
			log.info("[Scheduler] 미퇴근자 결근 처리 완료 - 총 {}건", count);
		} catch (Exception e) {
			log.error("[Scheduler] 미퇴근자 처리 중 오류 발생", e);
		}
	}
}