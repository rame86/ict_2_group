package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.AlertVO;
import com.example.repository.AlertDAO;

@Service
public class AlertServiceImpl implements AlertService {
	
	@Autowired
	private AlertDAO alertDao;

	@Override
	public void saveNewAlert(AlertVO vo) {
		alertDao.insertAlert(vo);
	}

	@Override
	public int getUnreadAlert(String empNo) {
		return alertDao.selectUnreadCount(empNo);
	}

	// 최신 알람정보 10개 얻어와서 띄우기
	@Override
	public List<AlertVO> getUnreadAlertView(String empNo) {
		return alertDao.selectLatestAlerts(empNo);
	}

}
