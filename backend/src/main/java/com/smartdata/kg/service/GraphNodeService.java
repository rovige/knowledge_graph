package com.smartdata.kg.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartdata.kg.entity.GraphNode;
import com.smartdata.kg.repository.GraphNodeRepository;
import org.springframework.stereotype.Service;

@Service
public class GraphNodeService extends ServiceImpl<GraphNodeRepository, GraphNode> {
}
