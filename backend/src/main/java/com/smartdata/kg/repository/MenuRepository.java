package com.smartdata.kg.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartdata.kg.entity.Menu;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MenuRepository extends BaseMapper<Menu> {
}
