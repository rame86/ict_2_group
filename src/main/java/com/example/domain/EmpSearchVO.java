package com.example.domain;

import lombok.Data;

@Data
public class EmpSearchVO {

    private String keyword;  // 이름/부서/상태 통합 검색어
    // 필요하면 deptNo, statusNo 등 추가
}