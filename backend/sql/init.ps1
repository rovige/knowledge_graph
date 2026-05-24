# =============================================
# 智慧数据平台 - 数据库初始化脚本
# 创建日期: 2026-05-23
# =============================================

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  智慧数据平台 - 数据库初始化脚本" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 配置信息
$mysqlHost = "localhost"
$mysqlPort = "3306"
$mysqlUser = "root"
$mysqlPassword = "root"
$mysqlDatabase = "kg_system"

$neo4jHost = "localhost"
$neo4jPort = "7687"
$neo4jUser = "neo4j"
$neo4jPassword = "neo4j"

# 获取脚本所在目录
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "脚本目录: $scriptPath" -ForegroundColor Gray

Write-Host ""
Write-Host "MySQL 配置信息:" -ForegroundColor Yellow
Write-Host "  Host:     $mysqlHost" -ForegroundColor Gray
Write-Host "  Port:     $mysqlPort" -ForegroundColor Gray
Write-Host "  User:     $mysqlUser" -ForegroundColor Gray
Write-Host "  Database: $mysqlDatabase" -ForegroundColor Gray
Write-Host ""

# 询问是否继续
$confirm = Read-Host "确认配置信息，继续初始化? (Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "已取消初始化" -ForegroundColor Red
    exit 0
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  步骤 1: 创建 MySQL 数据库" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

try {
    # 尝试使用 mysql 命令行工具
    if (Get-Command "mysql" -ErrorAction SilentlyContinue) {
        Write-Host "找到 mysql 命令行工具" -ForegroundColor Green
        
        # 创建数据库
        $createDbSql = "CREATE DATABASE IF NOT EXISTS \`$mysqlDatabase\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
        mysql -h $mysqlHost -P $mysqlPort -u $mysqlUser -p$mysqlPassword -e $createDbSql
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "数据库创建成功或已存在" -ForegroundColor Green
            
            # 执行建表脚本
            Write-Host "执行建表脚本..." -ForegroundColor Yellow
            $schemaFile = Join-Path $scriptPath "01_schema.sql"
            mysql -h $mysqlHost -P $mysqlPort -u $mysqlUser -p$mysqlPassword $mysqlDatabase < $schemaFile
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "建表成功" -ForegroundColor Green
                
                # 执行数据预置脚本
                Write-Host "执行数据预置脚本..." -ForegroundColor Yellow
                $dataFile = Join-Path $scriptPath "02_data.sql"
                mysql -h $mysqlHost -P $mysqlPort -u $mysqlUser -p$mysqlPassword $mysqlDatabase < $dataFile
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "数据预置成功" -ForegroundColor Green
                } else {
                    Write-Host "数据预置失败" -ForegroundColor Red
                }
            } else {
                Write-Host "建表失败" -ForegroundColor Red
            }
        } else {
            Write-Host "数据库创建失败，请检查 MySQL 连接配置" -ForegroundColor Red
        }
    } else {
        Write-Host ""
        Write-Host "未找到 mysql 命令行工具" -ForegroundColor Yellow
        Write-Host "请手动执行以下 SQL 脚本:" -ForegroundColor Yellow
        Write-Host "  1. 01_schema.sql - 建表脚本" -ForegroundColor Gray
        Write-Host "  2. 02_data.sql - 数据预置脚本" -ForegroundColor Gray
    }
} catch {
    Write-Host "MySQL 初始化出错: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  步骤 2: Neo4j 初始化" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "请在 Neo4j Browser 或 Cypher Shell 中手动执行:" -ForegroundColor Yellow
Write-Host "  脚本: 03_neo4j_init.cypher" -ForegroundColor Gray
Write-Host ""
Write-Host "如需清除所有数据，先执行: MATCH (n) DETACH DELETE n;" -ForegroundColor Gray

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  初始化完成" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "默认账号信息:" -ForegroundColor Yellow
Write-Host "  管理员: admin / 123456" -ForegroundColor White
Write-Host "  用户:   user / 123456" -ForegroundColor White
Write-Host ""
