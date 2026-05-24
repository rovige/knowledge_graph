package com.smartdata.kg.controller;

import com.smartdata.kg.common.PageResult;
import com.smartdata.kg.common.Result;
import com.smartdata.kg.entity.Permission;
import com.smartdata.kg.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/permissions")
public class PermissionController {

    @Autowired
    private PermissionService permissionService;

    @GetMapping
    public Result<PageResult<Permission>> page(@RequestParam(defaultValue = "1") Integer current,
                                                 @RequestParam(defaultValue = "10") Integer size,
                                                 @RequestParam(required = false) String keyword) {
        return Result.success(permissionService.page(current, size, keyword));
    }

    @GetMapping("/all")
    public Result<List<Permission>> listAll() {
        return Result.success(permissionService.listAll());
    }

    @GetMapping("/{id}")
    public Result<Permission> getById(@PathVariable Long id) {
        Permission permission = permissionService.getById(id);
        if (permission == null) {
            return Result.error("Permission not found");
        }
        return Result.success(permission);
    }

    @PostMapping
    public Result<Void> save(@RequestBody Permission permission) {
        permissionService.save(permission);
        return Result.success();
    }

    @PutMapping
    public Result<Void> updateById(@RequestBody Permission permission) {
        permissionService.updateById(permission);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> removeById(@PathVariable Long id) {
        permissionService.removeById(id);
        return Result.success();
    }
}
