@echo off
chcp 65001 >nul
title 智慧数据平台 - 简单启动
echo ==========================================
echo   智慧数据平台 - 简单启动
echo ==========================================
echo.

cd /d "%~dp0"

echo [1/3] 清理旧文件...
call mvn clean
if %errorlevel% neq 0 (
    echo [错误] 清理失败
    pause
    exit /b 1
)

echo.
echo [2/3] 编译项目（这可能需要2-5分钟，第一次运行）...
call mvn compile
if %errorlevel% neq 0 (
    echo [错误] 编译失败
    pause
    exit /b 1
)

echo.
echo [3/3] 启动应用...
echo ==========================================
echo 提示：
echo - 如果看到 "Started KnowledgeGraphApplication" 说明启动成功
echo - 访问 http://localhost:8080
echo - 登录账号: admin / 123456
echo ==========================================
echo.
call mvn spring-boot:run

pause
