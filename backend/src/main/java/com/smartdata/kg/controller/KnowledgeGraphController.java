package com.smartdata.kg.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.smartdata.kg.common.PageResult;
import com.smartdata.kg.common.Result;
import com.smartdata.kg.entity.*;
import com.smartdata.kg.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/kg")
@RequiredArgsConstructor
public class KnowledgeGraphController {

    private final KnowledgeGraphService knowledgeGraphService;
    private final CompanyService companyService;
    private final NewsService newsService;
    private final DataTaskService dataTaskService;

    @GetMapping("/entities")
    public Result<PageResult<GraphNode>> getEntitiesPage(@RequestParam(defaultValue = "1") Integer current,
                                                          @RequestParam(defaultValue = "10") Integer size,
                                                          @RequestParam(required = false) String keyword) {
        List<GraphNode> allEntities = keyword != null && !keyword.isEmpty() 
                ? knowledgeGraphService.searchEntities(keyword)
                : knowledgeGraphService.getAllEntities();
        
        int total = allEntities.size();
        int start = Math.max(0, (current - 1) * size);
        int end = Math.min(start + size, total);
        List<GraphNode> pageList = allEntities.subList(start, end);
        
        return Result.success(new PageResult<>((long) total, pageList));
    }

    @PostMapping("/entities")
    public Result<GraphNode> createEntity(@RequestBody GraphNode entity) {
        GraphNode created = knowledgeGraphService.createEntity(entity);
        return Result.success(created);
    }

    @PutMapping("/entities/{id}")
    public Result<GraphNode> updateEntity(@PathVariable Long id, @RequestBody GraphNode entity) {
        GraphNode updated = knowledgeGraphService.updateEntity(id, entity);
        return updated != null ? Result.success(updated) : Result.error("Entity not found");
    }

    @DeleteMapping("/entities/{id}")
    public Result<Void> deleteEntity(@PathVariable Long id) {
        knowledgeGraphService.deleteEntity(id);
        return Result.success();
    }

    @GetMapping("/entities/{id}")
    public Result<GraphNode> getEntityById(@PathVariable Long id) {
        GraphNode entity = knowledgeGraphService.getEntityById(id);
        return entity != null ? Result.success(entity) : Result.error("Entity not found");
    }

    @GetMapping("/relations")
    public Result<PageResult<GraphEdge>> getRelationsPage(@RequestParam(defaultValue = "1") Integer current,
                                                           @RequestParam(defaultValue = "10") Integer size,
                                                           @RequestParam(required = false) String keyword) {
        List<GraphEdge> allRelationships = knowledgeGraphService.getAllRelationships();
        
        int total = allRelationships.size();
        int start = Math.max(0, (current - 1) * size);
        int end = Math.min(start + size, total);
        List<GraphEdge> pageList = allRelationships.subList(start, end);
        
        return Result.success(new PageResult<>((long) total, pageList));
    }

    @PostMapping("/relations")
    public Result<GraphEdge> createRelation(@RequestBody GraphEdge edge) {
        GraphEdge created = knowledgeGraphService.saveRelationship(edge);
        return Result.success(created);
    }

    @DeleteMapping("/relations/{id}")
    public Result<Void> deleteRelation(@PathVariable Long id) {
        knowledgeGraphService.deleteRelationship(id);
        return Result.success();
    }

    @GetMapping("/graph/{industryId}")
    public Result<Map<String, Object>> getIndustryGraph(@PathVariable Long industryId) {
        Map<String, Object> graph = knowledgeGraphService.getIndustryGraphData(industryId);
        return Result.success(graph);
    }

    @GetMapping("/companies/{industryId}")
    public Result<List<Company>> getTopCompanies(@PathVariable Long industryId) {
        List<Company> companies = companyService.getTop10ByIndustry(industryId);
        return Result.success(companies);
    }

    @GetMapping("/news/{companyId}")
    public Result<List<News>> getCompanyNews(@PathVariable Long companyId) {
        List<News> news = newsService.getLatestByCompany(companyId, 10);
        return Result.success(news);
    }

    @PostMapping("/tasks/generate")
    public Result<DataTask> generateIndustryData(@RequestBody Map<String, Object> request) {
        Long industryId = Long.valueOf(request.get("industryId").toString());
        String industryName = request.get("industryName").toString();
        
        DataTask task = dataTaskService.createAndStartTask(industryId, industryName);
        return Result.success(task);
    }

    @GetMapping("/tasks/{taskId}")
    public Result<DataTask> getTaskStatus(@PathVariable Long taskId) {
        DataTask task = dataTaskService.getById(taskId);
        return task != null ? Result.success(task) : Result.error("Task not found");
    }

    @GetMapping("/tasks")
    public Result<PageResult<DataTask>> getTasksPage(@RequestParam(defaultValue = "1") Integer current,
                                                     @RequestParam(defaultValue = "10") Integer size) {
        Page<DataTask> page = dataTaskService.getTaskPage(current, size);
        return Result.success(new PageResult<>(page.getTotal(), page.getRecords()));
    }

    @PostMapping("/tasks/{taskId}/cancel")
    public Result<Boolean> cancelTask(@PathVariable Long taskId) {
        boolean success = dataTaskService.cancelTask(taskId);
        return Result.success(success);
    }

    @DeleteMapping("/tasks/{taskId}")
    public Result<Void> deleteTask(@PathVariable Long taskId) {
        dataTaskService.removeById(taskId);
        return Result.success();
    }
}
