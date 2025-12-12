package com.example.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.domain.DeptVO;
import com.example.domain.EmpVO;

@Repository
public class DeptDAOImpl implements DeptDAO {

    @Autowired
    private SqlSessionTemplate sess;


    public List<DeptVO> selectAllDeptList() {
        return sess.selectList("com.example.repository.DeptDAO.selectAllDeptList");
    }


    public List<EmpVO> selectEmpListByDept(int deptNo) {
        return sess.selectList("com.example.repository.DeptDAO.selectEmpListByDept", deptNo);
    }
}