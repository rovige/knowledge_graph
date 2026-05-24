@echo off
chcp 65001 >nul
title 修复 Maven PATH

echo ==========================================
echo   Maven PATH 配置工具
echo ==========================================
echo.

set "MAVEN_PATH=D:\soft\apache-maven-3.9.16"
set "MAVEN_BIN=%MAVEN_PATH%\bin"

echo 找到 Maven: %MAVEN_PATH%
echo.

REM 检查 mvn.cmd 是否存在
if exist "%MAVEN_BIN%\mvn.cmd" (
    echo 验证通过: mvn.cmd 存在
) else (
    echo 错误: mvn.cmd 不存在于 %MAVEN_BIN%
    echo 请确认 Maven 安装正确
    pause
    exit /b
)
echo.

REM 检查当前 PATH
echo 检查当前 PATH...
echo.

REM 获取系统 PATH
set "SYS_PATH="
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set "SYS_PATH=%%b"

REM 检查是否已包含 Maven
echo %SYS_PATH% | findstr /i /C:"apache-maven" >nul
if %errorlevel% equ 0 (
    echo Maven 已在 PATH 中
) else (
    echo.
    echo 正在添加 Maven 到系统 PATH...
    echo.
    
    REM 使用 setx 更新系统 PATH
    setx PATH "%SYS_PATH%;%MAVEN_BIN%" >nul
    
    echo 配置完成！
)

echo.
echo ==========================================
echo   配置成功
echo ==========================================
echo.
echo Maven 安装路径: %MAVEN_PATH%
echo.
echo 请执行以下操作使配置生效:
echo 1. 关闭当前所有 CMD/PowerShell 窗口
echo 2. 重新打开 CMD 或 PowerShell
echo 3. 运行命令: mvn -version
echo.
pause
