package com.example.board;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;



import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class FileDAOImpl implements FileDAO {

	@Autowired
	private SqlSessionTemplate sess;

	// insertFile()
	public void insertFile(FileVO vo) {
		sess.insert("com.example.dao.FileDAO.insertFile", vo);
		log.info(vo.toString());
	}
	
	// insertMemberFile()
	public void insertMemberFile(FileVO vo){
		sess.insert("com.example.dao.FileDAO.insertMemberFile", vo);
	}

	// selectFile()
	public FileVO selectFile(FileVO vo) {
		return sess.selectOne("com.example.dao.FileDAO.selectFile", vo);
	}

}
