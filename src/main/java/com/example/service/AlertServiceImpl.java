package com.example.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
		System.out.println(vo.toString() + "alertService");
		alertDao.insertAlert(vo);
	}

	@Override
	public int getUnreadAlert(String empNo) {
		return alertDao.selectUnreadCount(empNo);
	}

	// 최신 알람정보 띄우기
	@Override
	public List<AlertVO> getUnreadAlertView(String empNo) {
		return alertDao.selectLatestAlerts(empNo);
	}

	@Override
	public void markUpdateAsRead(String empNo) {
		alertDao.markAllAsRead(empNo);
	}

	@Override
	public List<AlertVO> getAllAlertView(String empNo) {
		return alertDao.selectAllLatestAlerts(empNo);
	}

	@Override
	public void deleteAlert(Integer alertId, String empNo) {
		Map<String, String> param = new HashMap<>();
		param.put("alertId", Integer.toString(alertId));
		param.put("empNo", empNo);
		alertDao.deleteAlert(param);
	}

}
