package com.smartdata.kg.service;

import com.smartdata.kg.common.Result;
import com.smartdata.kg.dto.LoginRequest;
import com.smartdata.kg.dto.LoginResponse;
import com.smartdata.kg.entity.User;
import com.smartdata.kg.security.LoginUser;
import com.smartdata.kg.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public Result<LoginResponse> login(LoginRequest request) {
        UsernamePasswordAuthenticationToken authenticationToken = 
            new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword());
        Authentication authentication = authenticationManager.authenticate(authenticationToken);
        
        LoginUser loginUser = (LoginUser) authentication.getPrincipal();
        User user = loginUser.getUser();
        
        String token = jwtUtil.generateToken(user.getId(), user.getUsername());
        
        LoginResponse.UserInfo userInfo = new LoginResponse.UserInfo(
            user.getId(), 
            user.getUsername(), 
            user.getNickname(), 
            user.getAvatar()
        );
        
        return Result.success(new LoginResponse(token, userInfo));
    }

    public Result<User> register(LoginRequest request) {
        User existUser = userService.getByUsername(request.getUsername());
        if (existUser != null) {
            return Result.error("Username already exists");
        }
        
        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setNickname(request.getUsername());
        user.setStatus(1);
        userService.save(user);
        
        return Result.success(user);
    }
}
