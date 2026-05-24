package com.smartdata.kg.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartdata.kg.entity.GraphNode;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface GraphNodeRepository extends BaseMapper<GraphNode> {
}