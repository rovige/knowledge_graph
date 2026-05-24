package com.smartdata.kg.controller;

import com.smartdata.kg.common.PageResult;
import com.smartdata.kg.common.Result;
import com.smartdata.kg.entity.User;
import com.smartdata.kg.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping
    public Result<PageResult<User>> page(@RequestParam(defaultValue = "1") Integer current,
                                          @RequestParam(defaultValue = "10") Integer size,
                                          @RequestParam(required = false) String keyword) {
        return Result.success(userService.page(current, size, keyword));
    }

    @GetMapping("/{id}")
    public Result<User> getById(@PathVariable Long id) {
        User user = userService.getById(id);
        if (user == null) {
            return Result.error("User not found");
        }
        return Result.success(user);
    }

    @PostMapping
    public Result<Void> save(@RequestBody User user) {
        userService.save(user);
        return Result.success();
    }

    @PutMapping
    public Result<Void> updateById(@RequestBody User user) {
        userService.updateById(user);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> removeById(@PathVariable Long id) {
        userService.removeById(id);
        return Result.success();
    }
}
