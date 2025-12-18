package com.example.domain;

import lombok.Data;

@Data
public class SalEditVO {
    private Integer editNo;
    private Integer salNum;
    private String editBy;       // 관리자 empNo
    private String editReason;
    private String editDate;     // Date로 해도 되지만 프로젝트 통일감 있으면 String도 OK

    private Integer beforeBase, afterBase;
    private Integer beforeBonus, afterBonus;
    private Integer beforePlus, afterPlus;
    private Integer beforeOt, afterOt;

    private Integer beforeIns, afterIns;
    private Integer beforeTax, afterTax;

    private Integer beforePayTotal, afterPayTotal;
    private Integer beforeDeduct, afterDeduct;
    private Integer beforeRealPay, afterRealPay;
    
    private String editByName; // 정정사원 이름
    
}
