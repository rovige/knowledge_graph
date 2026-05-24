# 智慧数据平台 - 产业链知识图谱系统

基于Spring Boot + MySQL + H5的产业链数据分析平台。

## 项目概述

智慧数据平台是一个用于产业链数据分析的知识图谱管理系统，支持行业管理、实体关系管理、知识图谱可视化等功能。采用MySQL原生存储图数据，无需额外图数据库。

## 技术栈

### 后端
- Spring Boot 3.1.5
- Spring Security + JWT
- MyBatis Plus 3.5.5
- MySQL 8.x

### 前端
- HTML5 + CSS3 + JavaScript
- ECharts 5.4.3 (知识图谱可视化)
- 模块化架构

## 功能特性

### 1. 用户认证与权限管理
- 用户登录
- 用户管理（增删改查）
- 角色管理
- 权限管理
- 菜单管理
- 预置角色：管理员

### 2. 产业链数据管理
- 行业管理
- 实体管理（公司、产品、原材料等）
- 关系管理（供应、合作、竞争等）
- 企业管理（TOP10企业数据）
- 新闻管理（企业相关新闻）
- 自动生成TOP10企业数据（多线程模拟）

### 3. 任务管理
- 数据生成任务管理
- 实时进度展示
- 任务取消/删除
- 预估完成时间

### 4. 知识图谱可视化
- 动态知识图谱展示（MySQL原生存储）
- 节点拖拽、缩放、漫游
- 单击节点查看属性
- 企业详情展示（法人、地址、经营范围等）
- 企业相关新闻展示
- 图谱最大化/还原
- 圆形节点、箭头关系

## 项目结构

```
knowledge_graph/
├── backend/                    # 后端项目
│   ├── src/
│   │   └── main/
│   │       ├── java/com/smartdata/kg/
│   │       │   ├── common/     # 通用类
│   │       │   ├── config/     # 配置类
│   │       │   ├── controller/ # 控制器
│   │       │   ├── dto/        # 数据传输对象
│   │       │   ├── entity/     # 实体类（GraphNode, GraphEdge, Company, News等）
│   │       │   ├── exception/  # 异常处理
│   │       │   ├── repository/ # 数据访问层
│   │       │   ├── security/   # 安全认证
│   │       │   ├── service/    # 业务逻辑层
│   │       │   └── utils/      # 工具类
│   │       └── resources/
│   │           └── application.yml
│   └── pom.xml
└── frontend/                   # 前端项目
    ├── index.html
    ├── package.json
    ├── vite.config.js
    ├── assets/
    │   ├── css/
    │   └── js/
    └── views/
        ├── login/
        └── main/
            └── modules/        # 模块化代码
                ├── graph-core.js
                ├── task-manager.js
                └── company-manager.js
```

## 快速开始

### 前置要求

- JDK 17+
- Maven 3.6+
- MySQL 8.0+
- Node.js 16+ (可选，用于前端开发)

### 数据库配置

#### MySQL 配置

创建数据库：
```sql
CREATE DATABASE kg_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

执行初始化脚本：
```bash
cd backend/sql
# 执行 01_schema.sql (创建表结构)
# 执行 02_data.sql (导入初始数据)
```

修改 `backend/src/main/resources/application.yml` 中的MySQL连接信息：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/kg_system
    username: your_username
    password: your_password
```

### 后端启动

```bash
cd backend
mvn clean install
mvn spring-boot:run
```

后端服务将在 http://localhost:8080 启动。

### 前端启动

#### 方式一：直接打开
直接在浏览器中打开 `frontend/index.html`。

## 默认账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | 123456 |

## API 接口文档

### 认证相关

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 登录 | POST | /auth/login | 用户登录 |

### 系统管理

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 用户列表 | GET | /users | 分页查询用户 |
| 创建用户 | POST | /users | 新增用户 |
| 更新用户 | PUT | /users | 更新用户 |
| 删除用户 | DELETE | /users/{id} | 删除用户 |
| 角色列表 | GET | /roles | 分页查询角色 |
| 权限列表 | GET | /permissions | 分页查询权限 |
| 菜单树 | GET | /menus/tree | 查询菜单树 |

### 知识图谱

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 获取图谱 | GET | /kg/graph/{industryId} | 获取行业知识图谱 |
| 实体列表 | GET | /kg/nodes | 获取实体列表 |
| 关系列表 | GET | /kg/edges | 获取关系列表 |
| 创建实体 | POST | /kg/nodes | 创建图节点 |
| 更新实体 | PUT | /kg/nodes | 更新图节点 |
| 删除实体 | DELETE | /kg/nodes/{id} | 删除图节点 |
| 创建关系 | POST | /kg/edges | 创建图关系 |
| 更新关系 | PUT | /kg/edges | 更新图关系 |
| 删除关系 | DELETE | /kg/edges/{id} | 删除图关系 |

### 任务管理

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 任务列表 | GET | /kg/tasks | 分页查询任务 |
| 生成数据 | POST | /kg/tasks/generate | 创建并启动数据生成任务 |
| 获取状态 | GET | /kg/tasks/{taskId} | 获取任务状态 |
| 取消任务 | POST | /kg/tasks/{taskId}/cancel | 取消任务 |
| 删除任务 | DELETE | /kg/tasks/{taskId} | 删除任务 |

### 行业管理

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 行业列表 | GET | /industries | 获取所有行业 |
| 创建行业 | POST | /industries | 创建行业 |
| 更新行业 | PUT | /industries | 更新行业 |
| 删除行业 | DELETE | /industries/{id} | 删除行业 |

### 企业管理

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 企业列表 | GET | /companies | 获取企业列表 |
| 企业详情 | GET | /companies/{id} | 获取企业详情 |
| 企业新闻 | GET | /companies/{id}/news | 获取企业相关新闻 |

## 使用说明

### 1. 登录系统

访问登录页面，使用管理员账号登录。

### 2. 创建行业

进入系统管理 -> 行业管理，创建一个新行业。

### 3. 生成数据

在主界面左侧选择行业，点击「生成数据」按钮，系统会多线程生成该行业的TOP10企业数据及相关知识图谱。

### 4. 查看知识图谱

在左侧选择行业，中间区域显示知识图谱：
- 单击节点：右侧显示企业详细属性和相关新闻
- 拖拽节点：调整位置
- 缩放滚轮：放大/缩小图谱
- 点击最大化：全屏显示图谱

### 5. 任务管理

在系统管理 -> 任务管理中查看数据生成任务进度。

### 6. 管理数据

在系统管理中可以管理用户、角色、权限、菜单、行业、实体、关系等。

## 开发说明

### 后端开发

- 代码位于 `backend/src/main/java/com/smartdata/kg/`
- 使用Spring Boot分层架构
- 实体类位于 `entity/` 目录（包含 GraphNode, GraphEdge, Company, News, DataTask等）
- Repository层使用 MyBatis Plus 进行数据访问
- Service层实现业务逻辑（支持多线程任务）
- Controller层提供REST API

### 前端开发

- 代码位于 `frontend/` 目录
- 登录页面：`views/login/`
- 主页面：`views/main/`
- 模块化代码位于 `views/main/modules/`：
  - `graph-core.js` - 知识图谱核心模块
  - `task-manager.js` - 任务管理模块
  - `company-manager.js` - 企业管理模块
- 知识图谱使用ECharts力导向图实现

## 图数据存储说明

本项目使用MySQL原生存储图数据，不需要额外的图数据库：

- **GraphNode 表**：存储节点信息（实体）
- **GraphEdge 表**：存储边信息（关系）
- 通过 startNodeId 和 endNodeId 建立节点间的关联关系

## 注意事项

1. 数据生成功能为模拟实现，实际使用需要对接真实的数据源
2. 首次启动需要初始化数据库表结构（使用 backend/sql/ 目录下的脚本）
3. 建议使用Chrome或Edge浏览器访问前端
4. 生产环境请修改JWT密钥和数据库密码
5. 数据生成任务使用8线程ExecutorService并行处理

## 许可证

本项目仅供学习和研究使用。
