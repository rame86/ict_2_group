package com.example.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.DeptVO;
import com.example.domain.EmpVO;
import com.example.service.DeptService;

@Controller
public class DeptController {
	
	@Autowired
    private DeptService deptService;
	
	@GetMapping("/dept/dept")
	public String department(Model m) {
		List<DeptVO> deptList = deptService.getOrgChartData();
		m.addAttribute("deptList", deptList);
		return "/dept/dept";
	}
	
	
	
	
	// JSP의 loadEmployeeList() 함수에서 ajax로 호출될 URL
    @GetMapping("/dept/api/employees")
    @ResponseBody 
    public List<EmpVO> getEmployeeList(@RequestParam("deptNo") int deptNo) {
        return deptService.getEmployeesByDept(deptNo);
    }

}
