# =============================================
# Maven 环境变量修复脚本
# =============================================

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Maven 环境变量配置工具" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 方法1: 尝试在常见位置查找 Maven
$mavenPaths = @(
    "C:\apache-maven",
    "D:\apache-maven",
    "C:\Program Files\apache-maven",
    "D:\Program Files\apache-maven",
    "C:\maven",
    "D:\maven"
)

$foundMaven = $null

foreach ($path in $mavenPaths) {
    if (Test-Path $path) {
        $mvnExe = Join-Path $path "bin\mvn.cmd"
        if (Test-Path $mvnExe) {
            $foundMaven = $path
            Write-Host "找到 Maven 安装目录: $foundMaven" -ForegroundColor Green
            break
        }
    }
}

# 方法2: 使用 Get-ChildItem 递归搜索
if (-not $foundMaven) {
    Write-Host "在常见位置未找到 Maven，正在全盘搜索..." -ForegroundColor Yellow
    Write-Host "这可能需要一些时间，请稍候..." -ForegroundColor Gray
    
    $drives = @("C:\", "D:\", "E:\")
    foreach ($drive in $drives) {
        if (Test-Path $drive) {
            try {
                $searchPattern = "*maven*"
                $results = Get-ChildItem -Path $drive -Directory -Filter $searchPattern -ErrorAction SilentlyContinue |
                           Where-Object { $_.Name -like "*maven*" -and (Test-Path (Join-Path $_.FullName "bin\mvn.cmd")) }
                
                if ($results) {
                    $foundMaven = $results[0].FullName
                    Write-Host "找到 Maven 安装目录: $foundMaven" -ForegroundColor Green
                    break
                }
            } catch {
                # 忽略访问错误，继续搜索
            }
        }
    }
}

# 如果找到了 Maven
if ($foundMaven) {
    Write-Host ""
    Write-Host "Maven 安装路径: $foundMaven" -ForegroundColor Cyan
    
    # 验证 mvn.cmd
    $mvnExe = Join-Path $foundMaven "bin\mvn.cmd"
    if (Test-Path $mvnExe) {
        Write-Host "Maven 可执行文件: $mvnExe" -ForegroundColor Green
        
        # 添加到系统 PATH
        $mavenBin = Join-Path $foundMaven "bin"
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        
        if ($currentPath -notlike "*$mavenBin*") {
            Write-Host ""
            Write-Host "正在添加到系统 PATH..." -ForegroundColor Yellow
            $newPath = "$currentPath;$mavenBin"
            [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
            Write-Host "Maven 已成功添加到系统 PATH!" -ForegroundColor Green
            Write-Host "新路径: $mavenBin" -ForegroundColor Gray
        } else {
            Write-Host ""
            Write-Host "Maven 已经在 PATH 中，无需重复添加" -ForegroundColor Yellow
        }
        
        # 设置 MAVEN_HOME
        $currentMavenHome = [Environment]::GetEnvironmentVariable("MAVEN_HOME", "Machine")
        if ($currentMavenHome -ne $foundMaven) {
            Write-Host ""
            Write-Host "正在设置 MAVEN_HOME..." -ForegroundColor Yellow
            [Environment]::SetEnvironmentVariable("MAVEN_HOME", $foundMaven, "Machine")
            Write-Host "MAVEN_HOME 已设置为: $foundMaven" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host "  配置完成!" -ForegroundColor Cyan
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "请执行以下操作使配置生效:" -ForegroundColor Yellow
        Write-Host "  1. 关闭当前所有 PowerShell/CMD 窗口" -ForegroundColor White
        Write-Host "  2. 重新打开 PowerShell 或 CMD" -ForegroundColor White
        Write-Host "  3. 运行命令: mvn -version" -ForegroundColor White
        Write-Host ""
        Write-Host "或者在当前窗口立即测试（需要刷新环境变量）:" -ForegroundColor Yellow
        Write-Host "  $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine')" -ForegroundColor White
        Write-Host "  mvn -version" -ForegroundColor White
        Write-Host ""
        
    } else {
        Write-Host "错误: Maven 目录存在但找不到 mvn.cmd 文件" -ForegroundColor Red
    }
} else {
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Red
    Write-Host "  未找到 Maven 安装" -ForegroundColor Red
    Write-Host "==========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "请按以下步骤安装 Maven:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. 下载 Maven:" -ForegroundColor Cyan
    Write-Host "   https://maven.apache.org/download.cgi" -ForegroundColor White
    Write-Host ""
    Write-Host "2. 解压到目录，例如:" -ForegroundColor Cyan
    Write-Host "   D:\apache-maven" -ForegroundColor White
    Write-Host ""
    Write-Host "3. 设置环境变量:" -ForegroundColor Cyan
    Write-Host "   - MAVEN_HOME = D:\apache-maven" -ForegroundColor White
    Write-Host "   - 在 PATH 中添加: %MAVEN_HOME%\bin" -ForegroundColor White
    Write-Host ""
    Write-Host "4. 验证安装:" -ForegroundColor Cyan
    Write-Host "   mvn -version" -ForegroundColor White
    Write-Host ""
}

Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
