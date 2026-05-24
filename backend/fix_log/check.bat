@echo off
chcp 65001 >nul
title 环境检查工具
echo ==========================================
echo   智慧数据平台 - 环境检查
echo ==========================================
echo.

echo 检查 1/5: Java 环境
call java -version 2>nul
if %errorlevel% neq 0 (
    echo [错误] Java 未找到
) else (
    echo [OK] Java 已安装
)
echo.

echo 检查 2/5: Maven 环境
call mvn -version 2>nul
if %errorlevel% neq 0 (
    echo [错误] Maven 未找到
) else (
    echo [OK] Maven 已安装
)
echo.

echo 检查 3/5: MySQL 服务
sc query MySQL80 >nul
if %errorlevel% equ 0 (
    echo [OK] MySQL 服务存在
) else (
    sc query MySQL >nul
    if %errorlevel% equ 0 (
        echo [OK] MySQL 服务存在
    ) else (
        echo [警告] 未找到 MySQL 服务
    )
)
echo.

echo 检查 4/5: 项目文件
if exist "pom.xml" (
    echo [OK] pom.xml 存在
) else (
    echo [错误] pom.xml 不存在
)
if exist "src\main\java\com\smartdata\kg\KnowledgeGraphApplication.java" (
    echo [OK] 主程序存在
) else (
    echo [错误] 主程序不存在
)
if exist "src\main\resources\application.yml" (
    echo [OK] 配置文件存在
) else (
    echo [错误] 配置文件不存在
)
echo.

echo 检查 5/5: 当前目录
echo 当前目录: %cd%
echo.

echo ==========================================
echo 检查完成！
echo.
echo 如果所有检查都是 [OK]，请运行：
echo   SIMPLE_START.bat
echo 或者：
echo   mvn clean spring-boot:run
echo ==========================================
echo.
pause
