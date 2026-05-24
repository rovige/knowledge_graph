package com.smartdata.kg.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartdata.kg.common.PageResult;
import com.smartdata.kg.entity.Role;
import com.smartdata.kg.repository.RoleRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RoleService extends ServiceImpl<RoleRepository, Role> {

    public PageResult<Role> page(Integer current, Integer size, String keyword) {
        Page<Role> page = new Page<>(current, size);
        LambdaQueryWrapper<Role> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Role::getName, keyword)
                    .or()
                    .like(Role::getCode, keyword);
        }
        wrapper.orderByDesc(Role::getCreateTime);
        page(page, wrapper);
        return new PageResult<>(page.getTotal(), page.getRecords());
    }

    public List<Role> listAll() {
        return list(new LambdaQueryWrapper<Role>()
                .eq(Role::getStatus, 1)
                .orderByDesc(Role::getCreateTime));
    }

    public Role getById(Long id) {
        return getOne(new LambdaQueryWrapper<Role>()
                .eq(Role::getId, id));
    }
}
