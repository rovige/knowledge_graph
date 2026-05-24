package com.smartdata.kg.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartdata.kg.entity.News;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface NewsRepository extends BaseMapper<News> {
}
