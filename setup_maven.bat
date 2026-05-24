@echo off
chcp 65001 >nul
title Maven 环境变量配置工具
echo ==========================================
echo   Maven 环境变量配置工具
echo ==========================================
echo.

REM 尝试查找 Maven
set "MAVEN_FOUND="
set "MAVEN_PATH="

echo 正在搜索 Maven 安装位置...
echo.

REM 检查常见位置
if exist "D:\apache-maven\bin\mvn.cmd" (
    set "MAVEN_PATH=D:\apache-maven"
    goto found
)
if exist "C:\apache-maven\bin\mvn.cmd" (
    set "MAVEN_PATH=C:\apache-maven"
    goto found
)
if exist "C:\Program Files\apache-maven\bin\mvn.cmd" (
    set "MAVEN_PATH=C:\Program Files\apache-maven"
    goto found
)

REM 尝试查找带版本号的目录
for /d %%d in (D:\apache-maven-* C:\apache-maven-*) do (
    if exist "%%d\bin\mvn.cmd" (
        set "MAVEN_PATH=%%d"
        goto found
    )
)

:notfound
echo ==========================================
echo   未找到 Maven 安装位置
echo ==========================================
echo.
echo 请按以下步骤手动配置:
echo.
echo 1. 确认 Maven 安装目录（例如：D:\apache-maven-3.9.6）
echo.
echo 2. 右键 "此电脑" -^> "属性" -^> "高级系统设置" -^> "环境变量"
echo.
echo 3. 在 "系统变量" 中:
echo    - 新建变量：MAVEN_HOME = D:\apache-maven-3.9.6
echo    - 编辑 Path，添加：%%MAVEN_HOME%%\bin
echo.
echo 4. 关闭所有 CMD/PowerShell 窗口，重新打开
echo.
echo 5. 运行命令验证：mvn -version
echo.
pause
exit /b

:found
echo 找到 Maven: %MAVEN_PATH%
echo.

REM 检查是否已经在 PATH 中
echo %PATH% | findstr /i "%MAVEN_PATH%\bin" >nul
if %errorlevel% equ 0 (
    echo Maven 已经在 PATH 中
    echo.
    echo ==========================================
    echo   配置已完成
    echo ==========================================
    echo.
    echo 请运行: mvn -version 验证
    echo.
    pause
    exit /b
)

echo 正在添加到系统环境变量...
echo.

REM 使用 setx 设置用户变量
setx MAVEN_HOME "%MAVEN_PATH%"
setx PATH "%PATH%;%MAVEN_PATH%\bin"

echo.
echo ==========================================
echo   配置完成
echo ==========================================
echo.
echo MAVEN_HOME 已设置为: %MAVEN_PATH%
echo.
echo 请执行以下操作:
echo 1. 关闭当前 CMD 窗口
echo 2. 重新打开 CMD 或 PowerShell
echo 3. 运行: mvn -version
echo.
pause
