package com.smartdata.kg.controller;

import com.smartdata.kg.common.Result;
import com.smartdata.kg.entity.Company;
import com.smartdata.kg.service.CompanyService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/companies")
@RequiredArgsConstructor
public class CompanyController {

    private final CompanyService companyService;

    @GetMapping("/industry/{industryId}")
    public Result<List<Company>> getByIndustry(@PathVariable Long industryId) {
        return Result.success(companyService.getTop10ByIndustry(industryId));
    }

    @GetMapping("/{id}")
    public Result<Company> getById(@PathVariable Long id) {
        return Result.success(companyService.getById(id));
    }

    @PostMapping
    public Result<Void> save(@RequestBody Company company) {
        companyService.save(company);
        return Result.success();
    }

    @PutMapping
    public Result<Void> updateById(@RequestBody Company company) {
        companyService.updateById(company);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> removeById(@PathVariable Long id) {
        companyService.removeById(id);
        return Result.success();
    }
}