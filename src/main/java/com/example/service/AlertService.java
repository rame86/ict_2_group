package com.example.service;

import java.util.List;

import com.example.domain.AlertVO;

public interface AlertService {
	void saveNewAlert(AlertVO vo);
	int getUnreadAlert(String empNo);
	List<AlertVO> getUnreadAlertView(String empNo);
	void markUpdateAsRead(String empNo); 
	List<AlertVO> getAllAlertView(String empNo);
	void deleteAlert(Integer alertId, String empNo);
}