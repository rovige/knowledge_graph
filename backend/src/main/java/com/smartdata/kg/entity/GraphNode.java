package com.smartdata.kg.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("graph_node")
public class GraphNode extends BaseEntity {
    
    private String name;
    
    private String type;
    
    private String properties;
    
    private Long industryId;
    
    private Integer status;
}
