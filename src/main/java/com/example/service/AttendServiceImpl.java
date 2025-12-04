package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.DayAttendVO;
import com.example.repository.AttendDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AttendServiceImpl implements AttendService {

    @Autowired
    private AttendDAO attendDAO;

    @Override
    public List<DayAttendVO> selectDayAttend(String empNo, String toDay) {
        log.info("[AttendService - selectDayAttend 요청 받음]");
        return attendDAO.selectDayAttend(empNo, toDay);
    }

    @Override
    public String checkIn(DayAttendVO davo) {
        return attendDAO.checkIn(davo);
    }

    @Override
    public String checkOut(DayAttendVO davo) {
        return attendDAO.checkOut(davo);
    }

    @Override
    public String fieldwork(DayAttendVO davo) {
        return attendDAO.fieldwork(davo);
    }
}
