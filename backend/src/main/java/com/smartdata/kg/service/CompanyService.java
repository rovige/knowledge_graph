package com.smartdata.kg.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartdata.kg.entity.Company;
import com.smartdata.kg.repository.CompanyRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CompanyService extends ServiceImpl<CompanyRepository, Company> {
    
    public List<Company> getTop10ByIndustry(Long industryId) {
        return list(new LambdaQueryWrapper<Company>()
                .eq(Company::getIndustryId, industryId)
                .orderByAsc(Company::getRanking)
                .last("LIMIT 10"));
    }
    
    public List<Company> listByIndustry(Long industryId) {
        return list(new LambdaQueryWrapper<Company>()
                .eq(Company::getIndustryId, industryId)
                .orderByAsc(Company::getRanking));
    }
}
