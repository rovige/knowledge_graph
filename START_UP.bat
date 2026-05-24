@echo off
echo ====================================
echo 知识图谱管理系统 - 启动脚本
echo ====================================

echo.
echo [1/3] 检查Java环境...
java -version
if %errorlevel% neq 0 (
    echo 错误: 未找到Java环境，请先安装JDK 17+
    pause
    exit /b 1
)

echo.
echo [2/3] 检查Maven环境...
mvn -version
if %errorlevel% neq 0 (
    echo 错误: 未找到Maven环境，请先安装Maven
    pause
    exit /b 1
)

echo.
echo [3/3] 启动后端服务...
cd backend
call mvn spring-boot:run

pause
