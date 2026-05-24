package com.smartdata.kg.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.smartdata.kg.entity.GraphEdge;
import com.smartdata.kg.entity.GraphNode;
import com.smartdata.kg.repository.GraphEdgeRepository;
import com.smartdata.kg.repository.GraphNodeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class KnowledgeGraphService {

    private final GraphNodeRepository graphNodeRepository;
    private final GraphEdgeRepository graphEdgeRepository;

    public GraphNode createEntity(GraphNode entity) {
        entity.setStatus(1);
        graphNodeRepository.insert(entity);
        return entity;
    }

    public GraphNode updateEntity(Long id, GraphNode entity) {
        GraphNode existing = graphNodeRepository.selectById(id);
        if (existing != null) {
            existing.setName(entity.getName());
            existing.setType(entity.getType());
            existing.setProperties(entity.getProperties());
            graphNodeRepository.updateById(existing);
            return existing;
        }
        return null;
    }

    public void deleteEntity(Long id) {
        graphNodeRepository.deleteById(id);
    }

    public GraphNode getEntityById(Long id) {
        return graphNodeRepository.selectById(id);
    }

    public GraphNode getEntityByName(String name) {
        return graphNodeRepository.selectOne(
                new LambdaQueryWrapper<GraphNode>()
                        .eq(GraphNode::getName, name)
                        .last("LIMIT 1")
        );
    }

    public List<GraphNode> getAllEntities() {
        return graphNodeRepository.selectList(null);
    }

    public List<GraphNode> getEntitiesByType(String type) {
        return graphNodeRepository.selectList(
                new LambdaQueryWrapper<GraphNode>()
                        .eq(GraphNode::getType, type)
        );
    }

    public List<GraphNode> getEntitiesByIndustryId(Long industryId) {
        return graphNodeRepository.selectList(
                new LambdaQueryWrapper<GraphNode>()
                        .eq(GraphNode::getIndustryId, industryId)
        );
    }

    public List<GraphNode> searchEntities(String keyword) {
        return graphNodeRepository.selectList(
                new LambdaQueryWrapper<GraphNode>()
                        .like(GraphNode::getName, keyword)
        );
    }

    public GraphNode saveEntity(GraphNode node) {
        if (node.getId() == null) {
            node.setStatus(1);
            graphNodeRepository.insert(node);
        } else {
            graphNodeRepository.updateById(node);
        }
        return node;
    }

    public GraphEdge saveRelationship(GraphEdge edge) {
        if (edge.getId() == null) {
            edge.setStatus(1);
            graphEdgeRepository.insert(edge);
        } else {
            graphEdgeRepository.updateById(edge);
        }
        return edge;
    }

    public List<GraphEdge> getAllRelationships() {
        return graphEdgeRepository.selectList(null);
    }

    public List<GraphEdge> getRelationshipsByIndustryId(Long industryId) {
        return graphEdgeRepository.selectList(
                new LambdaQueryWrapper<GraphEdge>()
                        .eq(GraphEdge::getIndustryId, industryId)
        );
    }

    public void deleteRelationship(Long id) {
        graphEdgeRepository.deleteById(id);
    }

    public Map<String, Object> getIndustryGraphData(Long industryId) {
        Map<String, Object> result = new HashMap<>();
        
        List<GraphNode> nodes = getEntitiesByIndustryId(industryId);
        List<GraphEdge> edges = getRelationshipsByIndustryId(industryId);
        
        List<Map<String, Object>> nodeList = new ArrayList<>();
        for (GraphNode node : nodes) {
            Map<String, Object> n = new HashMap<>();
            n.put("id", node.getId());
            n.put("name", node.getName());
            n.put("type", node.getType());
            n.put("properties", node.getProperties());
            nodeList.add(n);
        }
        
        List<Map<String, Object>> edgeList = new ArrayList<>();
        for (GraphEdge edge : edges) {
            Map<String, Object> e = new HashMap<>();
            e.put("id", edge.getId());
            e.put("source", edge.getSourceNodeId());
            e.put("target", edge.getTargetNodeId());
            e.put("relationType", edge.getRelationType());
            e.put("properties", edge.getProperties());
            edgeList.add(e);
        }
        
        result.put("nodes", nodeList);
        result.put("edges", edgeList);
        return result;
    }
}