package com.smartdata.kg.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartdata.kg.common.PageResult;
import com.smartdata.kg.entity.Permission;
import com.smartdata.kg.repository.PermissionRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PermissionService extends ServiceImpl<PermissionRepository, Permission> {

    public PageResult<Permission> page(Integer current, Integer size, String keyword) {
        Page<Permission> page = new Page<>(current, size);
        LambdaQueryWrapper<Permission> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Permission::getName, keyword)
                    .or()
                    .like(Permission::getCode, keyword);
        }
        wrapper.orderByDesc(Permission::getCreateTime);
        page(page, wrapper);
        return new PageResult<>(page.getTotal(), page.getRecords());
    }

    public List<Permission> listAll() {
        return list(new LambdaQueryWrapper<Permission>()
                .eq(Permission::getStatus, 1)
                .orderByDesc(Permission::getCreateTime));
    }

    public Permission getById(Long id) {
        return getOne(new LambdaQueryWrapper<Permission>()
                .eq(Permission::getId, id));
    }
}
