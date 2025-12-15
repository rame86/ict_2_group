package com.example.repository;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.DocVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class EmpDAOImpl implements EmpDAO{
	
	@Autowired
	private SqlSessionTemplate sess;

	 // =======================================================================================
 	// setEmpJobTitle()
 	public void setEmpJobTitle(Map<String,Object> map) {
 		log.info("[EmpDAO - setEmpJobTitle 요청 받음]");
 		sess.update("com.example.repository.EmpMapper.setEmpJobTitle", map);
 	}
 	// =======================================================================================
 	// end of setEmpJobTitle()

 	//

}
