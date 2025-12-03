package com.example.controller;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ToDate {

	public String getToMonth() {
		log.info("[ToDate - getToMonth 메소드 요청 받음]");
		LocalDate todayDate = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
		String toMonth = todayDate.format(formatter);
		log.info("[ToDate - getToMonth : " + toMonth + "]");
		return toMonth;
	}

	public String getToDay() {
		log.info("[ToDate - getToDay 메소드 요청 받음]");
		LocalDate todayDate = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String toDay = todayDate.format(formatter);
		log.info("[[ToDate - getToDay : " + toDay + "]");
		return toDay;
	}
	
	public String getCurrentTime() {
		log.info("[ToDate - getToTime 메소드 요청 받음]");
		LocalTime nowTime = LocalTime.now();	
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss"); 		
		String currentTime = nowTime.format(formatter);
		log.info("[ToDate - getToTime : " + currentTime + "]");
		return currentTime;
	}
	
	

}
