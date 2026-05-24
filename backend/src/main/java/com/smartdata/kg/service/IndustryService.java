package com.smartdata.kg.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartdata.kg.common.PageResult;
import com.smartdata.kg.entity.Company;
import com.smartdata.kg.entity.Industry;
import com.smartdata.kg.repository.IndustryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class IndustryService extends ServiceImpl<IndustryRepository, Industry> {

    public PageResult<Industry> page(Integer current, Integer size, String keyword) {
        Page<Industry> page = new Page<>(current, size);
        LambdaQueryWrapper<Industry> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Industry::getName, keyword)
                    .or()
                    .like(Industry::getCode, keyword);
        }
        wrapper.orderByAsc(Industry::getSort);
        page(page, wrapper);
        
        return new PageResult<>(page.getTotal(), page.getRecords());
    }

    public List<Industry> tree() {
        List<Industry> allIndustries = list(new LambdaQueryWrapper<Industry>()
                .orderByAsc(Industry::getSort));
        
        return buildTree(allIndustries, 0L);
    }

    public List<Industry> listAll() {
        return list(new LambdaQueryWrapper<Industry>()
                .orderByAsc(Industry::getSort));
    }

    public List<Industry> listWithData() {
        // 直接查询 has_data = 1 的行业
        List<Industry> industries = list(new LambdaQueryWrapper<Industry>()
                .eq(Industry::getHasData, 1)
                .orderByAsc(Industry::getSort));
        
        return industries;
    }

    private List<Industry> buildTree(List<Industry> industries, Long parentId) {
        List<Industry> tree = new ArrayList<>();
        for (Industry industry : industries) {
            if (parentId.equals(industry.getParentId())) {
                industry.setChildren(buildTree(industries, industry.getId()));
                tree.add(industry);
            }
        }
        return tree;
    }

    public Industry getById(Long id) {
        return getOne(new LambdaQueryWrapper<Industry>()
                .eq(Industry::getId, id));
    }
}
