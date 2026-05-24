package com.smartdata.kg.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartdata.kg.entity.Company;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CompanyRepository extends BaseMapper<Company> {
}
