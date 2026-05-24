package com.smartdata.kg.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_user")
public class User extends BaseEntity {

    private String username;

    private String password;

    private String nickname;

    private String email;

    private String phone;

    private String avatar;

    private Integer status;

    @TableField(exist = false)
    private List<Long> roleIds;

    @TableField(exist = false)
    private List<Role> roles;
}
