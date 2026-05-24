package com.smartdata.kg.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartdata.kg.entity.Permission;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PermissionRepository extends BaseMapper<Permission> {
}
