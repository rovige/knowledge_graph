package com.smartdata.kg.controller;

import com.smartdata.kg.common.PageResult;
import com.smartdata.kg.common.Result;
import com.smartdata.kg.entity.Role;
import com.smartdata.kg.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/roles")
public class RoleController {

    @Autowired
    private RoleService roleService;

    @GetMapping
    public Result<PageResult<Role>> page(@RequestParam(defaultValue = "1") Integer current,
                                          @RequestParam(defaultValue = "10") Integer size,
                                          @RequestParam(required = false) String keyword) {
        return Result.success(roleService.page(current, size, keyword));
    }

    @GetMapping("/all")
    public Result<List<Role>> listAll() {
        return Result.success(roleService.listAll());
    }

    @GetMapping("/{id}")
    public Result<Role> getById(@PathVariable Long id) {
        Role role = roleService.getById(id);
        if (role == null) {
            return Result.error("Role not found");
        }
        return Result.success(role);
    }

    @PostMapping
    public Result<Void> save(@RequestBody Role role) {
        roleService.save(role);
        return Result.success();
    }

    @PutMapping
    public Result<Void> updateById(@RequestBody Role role) {
        roleService.updateById(role);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> removeById(@PathVariable Long id) {
        roleService.removeById(id);
        return Result.success();
    }
}
