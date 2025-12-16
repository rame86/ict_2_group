package com.example.controller; // 패키지명 확인하세요

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CommonController {

    // 개발자 정보
    @GetMapping("/common/developerInfo")
    public String developerInfo() {
        return "common/developer_info"; 
    }

    // 개발툴 정보 모달 요청 처리
    @GetMapping("/common/toolsInfo")
    public String toolsInfo() {
        return "common/tools_info"; 
    }
}