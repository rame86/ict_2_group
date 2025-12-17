package com.example.repository;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.AlertVO;

@Repository
public class AlertDAOImpl implements AlertDAO{

	@Autowired
	private SqlSessionTemplate sess;
	
	@Override
	public void insertAlert(AlertVO vo) {
		sess.insert("com.example.repository.AlertDAO.insertAlert", vo);
	}

	@Override
	public List<AlertVO> selectLatestAlerts(String empNo) {
		return sess.selectList("com.example.repository.AlertDAO.selectLatestAlerts", empNo);
	}

	@Override
	public void markAllAsRead(String empNo) {
		sess.update("com.example.repository.AlertDAO.markAllAsRead", empNo);
	}

	@Override
	public int selectUnreadCount(String empNo) {
		return sess.selectOne("com.example.repository.AlertDAO.selectUnreadCount", empNo);
	}

	@Override
	public List<AlertVO> selectAllLatestAlerts(String empNo) {
		return sess.selectList("com.example.repository.AlertDAO.selectAllLatestAlerts", empNo);
	}

	@Override
	public void deleteAlert(Map<String, String> param) {
		sess.delete("com.example.repository.AlertDAO.deleteAlert", param);
	}

}
