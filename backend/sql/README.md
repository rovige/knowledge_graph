# 数据库初始化脚本

本目录包含智慧数据平台的数据库初始化脚本。

## 文件说明

| 文件名 | 说明 |
|--------|------|
| 01_schema.sql | MySQL 建表脚本（包含图数据存储表） |
| 02_data.sql | 初始数据预置脚本 |
| README.md | 本说明文档 |

## 快速开始

### 手动执行 SQL 脚本

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

## 默认账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | 123456 |

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

### 业务数据表

| 表名 | 说明 |
|------|------|
| company | 企业表 |
| news | 新闻表 |
| data_task | 数据任务表 |
| graph_node | 图节点表（知识图谱） |
| graph_edge | 图边表（知识图谱关系） |

### 预置数据说明

1. **角色**: 管理员
2. **权限**: 用户管理、角色管理、权限管理、菜单管理、行业管理、知识图谱管理、任务管理等
3. **菜单**: 系统首页、系统管理（用户/角色/权限/菜单/行业/实体/关系/任务）、知识图谱
4. **行业**: 6个一级行业，24个二级行业（新一代信息技术、高端装备制造、新能源、新材料、生物医药、节能环保）

## 图数据存储说明

本项目使用 MySQL 原生存储图数据，不需要额外的图数据库：

- **graph_node 表**：存储节点信息（实体）
- **graph_edge 表**：存储边信息（关系）
- 通过 startNodeId 和 endNodeId 建立节点间的关联关系

关系类型包括:
- `USES`: 使用
- `PRODUCES`: 生产
- `PROVIDES`: 提供
- `COMPETES_WITH`: 竞争
- `PARTNERS_WITH`: 合作
- `INVESTS_IN`: 投资
- `SPECIALIZES_IN`: 专精于
- `INCLUDES`: 包含
