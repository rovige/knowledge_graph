package com.smartdata.kg.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartdata.kg.common.PageResult;
import com.smartdata.kg.entity.Permission;
import com.smartdata.kg.entity.Role;
import com.smartdata.kg.entity.User;
import com.smartdata.kg.entity.UserRole;
import com.smartdata.kg.repository.PermissionRepository;
import com.smartdata.kg.repository.RolePermissionRepository;
import com.smartdata.kg.repository.RoleRepository;
import com.smartdata.kg.repository.UserRepository;
import com.smartdata.kg.repository.UserRoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserService extends ServiceImpl<UserRepository, User> {

    @Autowired
    private UserRoleRepository userRoleRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private RolePermissionRepository rolePermissionRepository;

    @Autowired
    private PermissionRepository permissionRepository;

    public User getByUsername(String username) {
        return getOne(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, username));
    }

    public PageResult<User> page(Integer current, Integer size, String keyword) {
        Page<User> page = new Page<>(current, size);
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(User::getUsername, keyword)
                    .or()
                    .like(User::getNickname, keyword);
        }
        wrapper.orderByDesc(User::getCreateTime);
        page(page, wrapper);
        return new PageResult<>(page.getTotal(), page.getRecords());
    }

    public User getById(Long id) {
        return getOne(new LambdaQueryWrapper<User>()
                .eq(User::getId, id));
    }

    public List<String> getPermissionsByUserId(Long userId) {
        List<String> permissions = new ArrayList<>();
        
        List<UserRole> userRoles = userRoleRepository.selectList(
            new LambdaQueryWrapper<UserRole>()
                .eq(UserRole::getUserId, userId)
        );
        
        if (userRoles.isEmpty()) {
            return permissions;
        }
        
        List<Long> roleIds = userRoles.stream()
            .map(UserRole::getRoleId)
            .collect(Collectors.toList());
        
        List<Role> roles = roleRepository.selectList(
            new LambdaQueryWrapper<Role>()
                .in(Role::getId, roleIds)
                .eq(Role::getStatus, 1)
        );
        
        List<Long> validRoleIds = roles.stream()
            .map(Role::getId)
            .collect(Collectors.toList());
        
        List<com.smartdata.kg.entity.RolePermission> rolePermissions = rolePermissionRepository.selectList(
            new LambdaQueryWrapper<com.smartdata.kg.entity.RolePermission>()
                .in(com.smartdata.kg.entity.RolePermission::getRoleId, validRoleIds)
        );
        
        List<Long> permissionIds = rolePermissions.stream()
            .map(com.smartdata.kg.entity.RolePermission::getPermissionId)
            .distinct()
            .collect(Collectors.toList());
        
        if (!permissionIds.isEmpty()) {
            List<Permission> permissionList = permissionRepository.selectList(
                new LambdaQueryWrapper<Permission>()
                    .in(Permission::getId, permissionIds)
                    .eq(Permission::getStatus, 1)
            );
            
            permissions = permissionList.stream()
                .map(Permission::getCode)
                .collect(Collectors.toList());
        }
        
        return permissions;
    }
}
