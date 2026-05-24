package com.smartdata.kg.controller;

import com.smartdata.kg.common.Result;
import com.smartdata.kg.dto.LoginRequest;
import com.smartdata.kg.dto.LoginResponse;
import com.smartdata.kg.entity.User;
import com.smartdata.kg.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    public Result<LoginResponse> login(@Validated @RequestBody LoginRequest request) {
        return authService.login(request);
    }

    @PostMapping("/register")
    public Result<User> register(@Validated @RequestBody LoginRequest request) {
        return authService.register(request);
    }
}
