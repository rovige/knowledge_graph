package com.smartdata.kg.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("news")
public class News extends BaseEntity {
    
    private Long companyId;
    
    private String title;
    
    private String summary;
    
    private String content;
    
    private String source;
    
    private String url;
    
    private LocalDateTime publishTime;
    
    private Integer type;
    
    private String status;
}
