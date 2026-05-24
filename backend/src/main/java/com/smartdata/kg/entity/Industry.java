package com.smartdata.kg.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_industry")
public class Industry extends BaseEntity {

    private Long parentId;

    private String name;

    private String code;

    private String description;

    private Integer sort;

    @TableField(exist = false)
    private List<Industry> children;
}
