package com.smartdata.kg.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EntityRequest {
    private String name;
    private String type;
    private String industry;
    private String description;
    private Map<String, Object> properties;
}
