package com.smartdata.kg.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_menu")
public class Menu extends BaseEntity {

    private Long parentId;

    private String name;

    private String path;

    private String component;

    private String icon;

    private Integer sort;

    private String type;

    private String permission;

    private Integer visible;

    @TableField(exist = false)
    private List<Menu> children;
}
