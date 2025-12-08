package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.controller.ToDate;
import com.example.domain.DayAttendVO;
import com.example.domain.DocVO;
import com.example.repository.AttendDAO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AttendServiceImpl implements AttendService {

	@Autowired
    private ToDate toDate;

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

    @Transactional
	@Override
	public void insertVacation(DocVO vo) {
		log.info("[AttendService - insertVacation 요청 받음]");
		log.info(vo.toString());
		DayAttendVO davo = new DayAttendVO();
		
		String totalDayStr = vo.getTotalDays();
		String totalDaySt = totalDayStr.replaceAll("[^0-9]", "");
		Integer totalDays = 0;
	    if (!totalDaySt.isEmpty()) {
	        totalDays = Integer.parseInt(totalDaySt);
	    }
	    
	    String startDate = toDate.getFomatterDate(vo.getStartDate());
	    String endDate = toDate.getFomatterDate(vo.getEndDate());
	    
	    davo.setEmpNo(vo.getEmpNo());
		davo.setUpdateTime(toDate.getToDay());
		davo.setMemo("연차 :" +startDate+"~"+endDate+", "+vo.getTotalDays());
		log.info("메모는??" + davo.getMemo());
		davo.setAttStatus("연차");
		davo.setDateAttend(startDate);
		
		attendDAO.insertVacation(davo, totalDays);

	}
	
	
	public void commuteCorrection(DocVO vo) {
		log.info("[AttendService - commuteCorrection 요청 받음]");
		log.info(vo.toString());
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
		
		
		attendDAO.commuteCorrection(davo);

	}
}
