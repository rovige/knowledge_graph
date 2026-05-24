package com.smartdata.kg.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("data_task")
public class DataTask extends BaseEntity {
    
    private Long industryId;
    
    private String industryName;
    
    private String taskType;
    
    private String status;
    
    private Integer progress;
    
    private String errorMessage;
    
    private LocalDateTime startTime;
    
    private LocalDateTime endTime;
}
