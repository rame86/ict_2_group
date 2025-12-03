package com.example.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
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

	public String getCurrentDateTime() {
		log.info("[ToDate - getToTime 메소드 요청 받음]");
		LocalDateTime nowTime = LocalDateTime.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		String currentTime = nowTime.format(formatter);
		log.info("[ToDate - getCurrentTime : " + currentTime + "]");
		return currentTime;
	}
	
	public String getCurrentTime() {
		log.info("[ToDate - getToTime 메소드 요청 받음]");
		LocalDateTime nowTime = LocalDateTime.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
		String currentTime = nowTime.format(formatter);
		log.info("[ToDate - getCurrentTime : " + currentTime + "]");
		return currentTime;
	}

	// String 타입을 LocalDateTime 타입으로 파싱해주는 기능임
	public LocalDateTime dateTime(String date) {
		log.info("[ToDate - dateTime 메소드 요청 받음]");
		DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
		LocalTime time = LocalTime.parse(date, timeFormatter);
		LocalDate toDay = LocalDate.now();
		LocalDateTime currentDateTime = time.atDate(toDay);
		log.info("[ToDate - dateTime : " + currentDateTime + "]");
		return currentDateTime;
	}
	
	//인자값을 받아 HH:mm:ss 형식으로 변환해주는 메소드
	public String getFomatter(String time) {
		log.info("[ToDate - getFomatter 메소드 요청 받음]");
		DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		LocalDateTime nowTime = LocalDateTime.parse(time, inputFormatter);
		DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
		String currentTime = nowTime.format(outputFormatter);
		log.info("[ToDate - getFomatter : " + currentTime + "]");
		return currentTime;
	}

}
