package com.smartdata.kg.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("graph_edge")
public class GraphEdge extends BaseEntity {
    
    private Long sourceNodeId;
    
    private Long targetNodeId;
    
    private String relationType;
    
    private String properties;
    
    private Long industryId;
    
    private Integer status;
}
