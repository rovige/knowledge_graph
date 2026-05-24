package com.smartdata.kg.controller;

import com.smartdata.kg.common.PageResult;
import com.smartdata.kg.common.Result;
import com.smartdata.kg.entity.Industry;
import com.smartdata.kg.service.IndustryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/industries")
public class IndustryController {

    @Autowired
    private IndustryService industryService;

    @GetMapping
    public Result<PageResult<Industry>> page(@RequestParam(defaultValue = "1") Integer current,
                                               @RequestParam(defaultValue = "10") Integer size,
                                               @RequestParam(required = false) String keyword) {
        return Result.success(industryService.page(current, size, keyword));
    }

    @GetMapping("/tree")
    public Result<List<Industry>> tree() {
        return Result.success(industryService.tree());
    }

    @GetMapping("/all")
    public Result<List<Industry>> listAll() {
        return Result.success(industryService.listAll());
    }

    @GetMapping("/with-data")
    public Result<List<Industry>> listWithData() {
        return Result.success(industryService.listWithData());
    }

    @GetMapping("/{id}")
    public Result<Industry> getById(@PathVariable Long id) {
        Industry industry = industryService.getById(id);
        if (industry == null) {
            return Result.error("Industry not found");
        }
        return Result.success(industry);
    }

    @PostMapping
    public Result<Void> save(@RequestBody Industry industry) {
        industryService.save(industry);
        return Result.success();
    }

    @PutMapping
    public Result<Void> updateById(@RequestBody Industry industry) {
        industryService.updateById(industry);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> removeById(@PathVariable Long id) {
        industryService.removeById(id);
        return Result.success();
    }
}
