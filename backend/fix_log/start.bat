@echo off
chcp 65001 >nul
title 启动智慧数据平台后端服务
echo ==========================================
echo   智慧数据平台 - 后端启动器
echo ==========================================
echo.

cd /d "%~dp0"

echo 检查 Maven 配置...
call mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] Maven 未正确配置
    echo 请确保 Maven 已安装并添加到 PATH
    pause
    exit /b 1
)
echo [OK] Maven 配置正常
echo.

echo 开始构建和启动 Spring Boot 应用...
echo 这可能需要几分钟时间，请耐心等待...
echo.

call mvn clean package spring-boot:run

if %errorlevel% neq 0 (
    echo.
    echo [错误] 启动失败
    echo 请检查：
    echo   1. Neo4j 是否已启动并正确配置
    echo   2. MySQL 是否已启动
    echo   3. application.yml 中的数据库配置是否正确
    pause
) else (
    echo.
    echo [成功] 应用已启动
    echo 访问地址: http://localhost:8080
)

pause
