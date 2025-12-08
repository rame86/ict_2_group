package com.example.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

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
	public String getFomatterHHmmss(String time) {
		log.info("[ToDate - getFomatter 메소드 요청 받음]");
		DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		LocalDateTime nowTime = LocalDateTime.parse(time, inputFormatter);
		DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
		String currentTime = nowTime.format(outputFormatter);
		log.info("[ToDate - getFomatter : " + currentTime + "]");
		return currentTime;
	}
	
	
	// 수정된 getFomatterDate (날짜 문자열만 필요할 경우)
	public String getFomatterDate(String time) {
	    log.info("[ToDate - getFomatterDate 메소드 요청 받음]");
	    
	    // 1. 입력 문자열이 'yyyy-MM-dd HH:mm:ss' 형식이라고 가정하고 파싱
	    DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	    LocalDateTime nowDateTime;
	    
	    try {
	        // 날짜와 시간을 모두 파싱
	        nowDateTime = LocalDateTime.parse(time, inputFormatter);
	    } catch (DateTimeParseException e) {
	        // 파싱 실패 시 (예: 'yyyy-MM-dd'만 들어온 경우) 대체 로직 수행
	        DateTimeFormatter dateOnlyFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	        nowDateTime = LocalDate.parse(time, dateOnlyFormatter).atStartOfDay();
	    }
	    
	    // 2. 원하는 출력 형식 (여기서는 날짜만 추출한다고 가정)
	    DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	    String formattedDate = nowDateTime.format(outputFormatter);
	    
	    log.info("[ToDate - getFomatterDate 결과 : " + formattedDate + "]");
	    return formattedDate;
	}
	
	//날짜를 하루씩 증가시키는 메소드
	public String addDay(String date) {
        log.info("[ToDate - addDay 메소드 요청 받음]");
        
        // String 타입 날짜를 LocalDate 변환
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate localDate = LocalDate.parse(date, formatter);
        log.info("원본 날짜 (LocalDate): " + localDate);

        // 날짜를 1일 증가. (연말/월말/윤년 자동 처리)
        LocalDate nextDay = localDate.plusDays(1);
        log.info("증가된 날짜 (LocalDate): " + nextDay);

        // 증가된 날짜를 다시 String으로 변환하여 반환
        String nextDayString = nextDay.format(formatter);
        log.info("[ToDate - addDay 결과 : " + nextDayString + "]");
        
        return nextDayString;
    }
	
	// yyyy-MM-dd 형식 String과 HH:mm:ss 형식 스트링을 합치는 메소드
	public String combineDateAndTime(String dateString, String timeString) {
        log.info("[ToDate - combineDateAndTime 메소드 요청 받음]");        
        log.info("  -> dateString: " + dateString + ", timeString: " + timeString);

        if (dateString == null || dateString.isEmpty() || timeString == null || timeString.isEmpty()) {
            log.warn("날짜 또는 시간 문자열이 비어있어 결합 불가");
            return null;
        }

        // 1. LocalDate 파싱 (yyyy-MM-dd)
        LocalDate date = LocalDate.parse(dateString, DateTimeFormatter.ISO_LOCAL_DATE);
        // 2. LocalTime 파싱 (HH:mm 또는 HH:mm:ss 형태 모두 지원)
        LocalTime time;
        
        try {
            // HH:mm 형식으로 먼저 시도
            time = LocalTime.parse(timeString, DateTimeFormatter.ofPattern("HH:mm"));
        } catch (DateTimeParseException e) {
            try {
                // HH:mm:ss 형식으로 다시 시도
                time = LocalTime.parse(timeString, DateTimeFormatter.ofPattern("HH:mm:ss"));
            } catch (DateTimeParseException ex) {
                log.error("시간 문자열 파싱 실패: " + timeString, ex);
                return null; // 파싱 실패 시 null 반환
            }
        }
        // 3. LocalDateTime 결합
        LocalDateTime combinedDateTime = date.atTime(time);
        
        // 4. 원하는 형식(yyyy-MM-dd HH:mm:ss)으로 포맷하여 반환
        // DATE/TIMESTAMP 컬럼에 입력위해 초단위로 포맷
        DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formattedDateTime = combinedDateTime.format(outputFormatter);
        
        log.info("[ToDate - combineDateAndTime 결과 : " + formattedDateTime + "]");        
        return formattedDateTime;
    }
   

}
