package com.example.service;

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

}
