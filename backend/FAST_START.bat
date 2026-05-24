@echo off
chcp 65001 >nul
title 智慧数据平台 - 快速启动
echo ==========================================
echo   智慧数据平台 - 快速启动
echo ==========================================
echo.

cd /d "%~dp0"

echo [步骤 1/2] 清理并编译...
echo 注意：第一次运行可能需要 2-5 分钟下载依赖
echo.
call mvn clean compile
if %errorlevel% neq 0 (
    echo.
    echo [错误] 编译失败！
    echo.
    echo 请检查：
    echo   1. 网络连接是否正常（需要下载 Maven 依赖）
    echo   2. 是否有足够的磁盘空间
    echo.
    pause
    exit /b 1
)

echo.
echo [步骤 2/2] 启动应用...
echo.
echo ==========================================
echo 成功标志：看到 "Started KnowledgeGraphApplication"
echo 访问地址：http://localhost:8080
echo 登录账号：admin / 123456
echo ==========================================
echo.
call mvn spring-boot:run

if %errorlevel% neq 0 (
    echo.
    echo ==========================================
    echo [错误] 启动失败
    echo.
    echo 可能原因：
    echo   1. Neo4j 未启动或配置错误
    echo   2. MySQL 未启动或数据库不存在
    echo   3. application.yml 配置不正确
    echo.
    echo 请检查 application.yml 中的数据库配置
    echo ==========================================
    echo.
)
pause
