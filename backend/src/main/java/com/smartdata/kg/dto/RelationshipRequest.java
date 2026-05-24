package com.smartdata.kg.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RelationshipRequest {
    private String sourceName;
    private String targetName;
    private String relType;
    private Double weight;
}
