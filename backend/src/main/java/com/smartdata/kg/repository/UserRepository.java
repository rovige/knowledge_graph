package com.smartdata.kg.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartdata.kg.entity.User;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserRepository extends BaseMapper<User> {
}
