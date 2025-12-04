package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.DayAttendVO;
import com.example.domain.DocVO;
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

	@Override
	public void insertVacation(DocVO vo) {
		
		DayAttendVO davo = new DayAttendVO();
		
		String totalDayStr = vo.getTotalDays();
		String totalDaySt = totalDayStr.replaceAll("[^0-9]", "");
		Integer totalDays = 0;
	    if (!totalDaySt.isEmpty()) {
	        totalDays = Integer.parseInt(totalDaySt);
	    }
		
	    davo.setEmpNo(vo.getEmpNo());
		davo.setUpdateTime(vo.getStartDate());
		davo.setMemo("연차 :" +vo.getStartDate()+"~"+vo.getEndDate()+", "+vo.getTotalDays());
		davo.setAttStatus("연차");
		
		attendDAO.insertVacation(vo, totalDays);

	}
}
