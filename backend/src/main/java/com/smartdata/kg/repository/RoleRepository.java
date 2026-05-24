package com.smartdata.kg.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartdata.kg.entity.Role;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface RoleRepository extends BaseMapper<Role> {
}
