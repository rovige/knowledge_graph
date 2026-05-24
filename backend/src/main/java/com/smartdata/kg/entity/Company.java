package com.smartdata.kg.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("company")
public class Company extends BaseEntity {
    
    private Long industryId;
    
    private String name;
    
    private String code;
    
    private String legalRepresentative;
    
    private String address;
    
    private String businessScope;
    
    private BigDecimal registeredCapital;
    
    private LocalDateTime establishmentDate;
    
    private Integer ranking;
    
    private String status;
    
    private String remark;
}
