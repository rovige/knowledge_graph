package com.smartdata.kg.controller;

import com.smartdata.kg.common.PageResult;
import com.smartdata.kg.common.Result;
import com.smartdata.kg.entity.Menu;
import com.smartdata.kg.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/menus")
public class MenuController {

    @Autowired
    private MenuService menuService;

    @GetMapping
    public Result<PageResult<Menu>> page(@RequestParam(defaultValue = "1") Integer current,
                                          @RequestParam(defaultValue = "10") Integer size,
                                          @RequestParam(required = false) String keyword) {
        return Result.success(menuService.page(current, size, keyword));
    }

    @GetMapping("/tree")
    public Result<List<Menu>> tree() {
        return Result.success(menuService.tree());
    }

    @GetMapping("/all")
    public Result<List<Menu>> listAll() {
        return Result.success(menuService.listAll());
    }

    @GetMapping("/{id}")
    public Result<Menu> getById(@PathVariable Long id) {
        Menu menu = menuService.getById(id);
        if (menu == null) {
            return Result.error("Menu not found");
        }
        return Result.success(menu);
    }

    @PostMapping
    public Result<Void> save(@RequestBody Menu menu) {
        menuService.save(menu);
        return Result.success();
    }

    @PutMapping
    public Result<Void> updateById(@RequestBody Menu menu) {
        menuService.updateById(menu);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> removeById(@PathVariable Long id) {
        menuService.removeById(id);
        return Result.success();
    }
}
