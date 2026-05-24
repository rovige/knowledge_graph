package com.smartdata.kg.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartdata.kg.entity.News;
import com.smartdata.kg.repository.NewsRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NewsService extends ServiceImpl<NewsRepository, News> {

    public List<News> getLatestByCompany(Long companyId, int limit) {
        return list(new LambdaQueryWrapper<News>()
                .eq(News::getCompanyId, companyId)
                .orderByDesc(News::getPublishTime)
                .last("LIMIT " + limit));
    }
}