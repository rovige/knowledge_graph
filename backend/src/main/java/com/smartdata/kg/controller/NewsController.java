package com.smartdata.kg.controller;

import com.smartdata.kg.common.Result;
import com.smartdata.kg.entity.News;
import com.smartdata.kg.service.NewsService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/news")
@RequiredArgsConstructor
public class NewsController {

    private final NewsService newsService;

    @GetMapping("/company/{companyId}")
    public Result<List<News>> getByCompany(@PathVariable Long companyId) {
        return Result.success(newsService.getLatestByCompany(companyId, 10));
    }

    @GetMapping("/{id}")
    public Result<News> getById(@PathVariable Long id) {
        return Result.success(newsService.getById(id));
    }

    @PostMapping
    public Result<Void> save(@RequestBody News news) {
        newsService.save(news);
        return Result.success();
    }

    @PutMapping
    public Result<Void> updateById(@RequestBody News news) {
        newsService.updateById(news);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> removeById(@PathVariable Long id) {
        newsService.removeById(id);
        return Result.success();
    }
}