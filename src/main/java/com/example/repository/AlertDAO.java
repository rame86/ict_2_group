package com.example.repository;

import java.util.List;
import java.util.Map;

import com.example.domain.AlertVO;

public interface AlertDAO {
	void insertAlert(AlertVO vo);
	List<AlertVO> selectLatestAlerts(String empNo);
	void markAllAsRead(String empNo);
	int selectUnreadCount(String empNo);
	List<AlertVO> selectAllLatestAlerts(String empNo);
	void deleteAlert(Map<String, String> param);
}
