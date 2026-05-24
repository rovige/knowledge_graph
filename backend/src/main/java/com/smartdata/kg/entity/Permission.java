package com.smartdata.kg.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_permission")
public class Permission extends BaseEntity {

    private String name;

    private String code;

    private String type;

    private String path;

    private String method;

    private Integer status;
}
