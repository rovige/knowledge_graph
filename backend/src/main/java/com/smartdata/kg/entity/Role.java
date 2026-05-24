package com.smartdata.kg.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_role")
public class Role extends BaseEntity {

    private String name;

    private String code;

    private String description;

    private Integer status;

    @TableField(exist = false)
    private List<Long> permissionIds;

    @TableField(exist = false)
    private List<Permission> permissions;

    @TableField(exist = false)
    private List<Long> menuIds;

    @TableField(exist = false)
    private List<Menu> menus;
}
