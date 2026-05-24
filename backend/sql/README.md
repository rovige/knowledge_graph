# 数据库初始化脚本

本目录包含智慧数据平台的数据库初始化脚本。

## 文件说明

| 文件名 | 说明 |
|--------|------|
| 01_schema.sql | MySQL 建表脚本 |
| 02_data.sql | 初始数据预置脚本 |
| 03_neo4j_init.cypher | Neo4j 示例数据初始化脚本 |
| init.ps1 | Windows PowerShell 一键初始化脚本 |
| README.md | 本说明文档 |

## 快速开始

### 方式一: 使用一键脚本 (推荐)

在 Windows 环境下，直接运行 PowerShell 脚本:

```powershell
cd backend/sql
.\init.ps1
```

**注意**: 脚本中默认数据库配置为:
- MySQL: localhost:3306, 用户: root, 密码: root
- Neo4j: localhost:7687, 用户: neo4j, 密码: neo4j

如需修改配置，请编辑 `init.ps1` 文件中的配置信息。

### 方式二: 手动执行 SQL 脚本

1. 创建数据库
```sql
CREATE DATABASE kg_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. 执行建表脚本
```bash
mysql -u root -p kg_system < 01_schema.sql
```

3. 执行数据预置脚本
```bash
mysql -u root -p kg_system < 02_data.sql
```

4. 初始化 Neo4j (可选)
在 Neo4j Browser 或 Cypher Shell 中执行 `03_neo4j_init.cypher` 脚本。

## 默认账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | 123456 |
| 数据用户 | user | 123456 |

## 数据库表结构

### 系统管理表

| 表名 | 说明 |
|------|------|
| sys_user | 用户表 |
| sys_role | 角色表 |
| sys_permission | 权限表 |
| sys_menu | 菜单表 |
| sys_industry | 行业表 |
| sys_user_role | 用户角色关联表 |
| sys_role_permission | 角色权限关联表 |
| sys_role_menu | 角色菜单关联表 |

### 预置数据说明

1. **角色**: 超级管理员、数据用户
2. **权限**: 用户管理、角色管理、权限管理、菜单管理、行业管理、知识图谱管理等
3. **菜单**: 系统首页、系统管理（用户/角色/权限/菜单/行业）、知识图谱（图谱浏览/实体管理/关系管理）
4. **行业**: 6个一级行业，24个二级行业（新一代信息技术、高端装备制造、新能源、新材料、生物医药、节能环保）

## Neo4j 示例数据

示例数据包含两个行业的知识图谱:
- **人工智能行业**: 10家企业、8项技术、多种关系
- **新能源汽车行业**: 10家企业、多种零部件和原材料

关系类型包括:
- `USES`: 使用
- `PRODUCES`: 生产
- `PROVIDES`: 提供
- `COMPETES_WITH`: 竞争
- `PARTNERS_WITH`: 合作
- `INVESTS_IN`: 投资
- `SPECIALIZES_IN`: 专精于
- `INCLUDES`: 包含
