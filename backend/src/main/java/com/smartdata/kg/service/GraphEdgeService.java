package com.smartdata.kg.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartdata.kg.entity.GraphEdge;
import com.smartdata.kg.repository.GraphEdgeRepository;
import org.springframework.stereotype.Service;

@Service
public class GraphEdgeService extends ServiceImpl<GraphEdgeRepository, GraphEdge> {
}
