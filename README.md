# 智慧数据平台 - 产业链知识图谱系统

基于Spring Boot + Neo4j + H5的产业链数据分析平台。

## 项目概述

智慧数据平台是一个用于产业链数据分析的知识图谱管理系统，支持行业管理、实体关系管理、知识图谱可视化等功能。

## 技术栈

### 后端
- Spring Boot 2.7.14
- Spring Security + JWT
- Spring Data Neo4j
- Spring Data JPA
- MyBatis Plus 3.5.3.1
- MySQL
- Neo4j

### 前端
- HTML5 + CSS3 + JavaScript
- ECharts 5.4.3
- Vite (可选)

## 功能特性

### 1. 用户认证与权限管理
- 用户注册、登录
- 用户管理（增删改查）
- 角色管理
- 权限管理
- 菜单管理
- 预置角色：管理员、数据用户

### 2. 产业链数据管理
- 行业管理
- 实体管理（公司、产品、原材料等）
- 关系管理（供应、合作、竞争等）
- 属性管理
- 自动生成TOP10企业数据（爬虫模拟）

### 3. 知识图谱可视化
- 动态知识图谱展示
- 节点拖拽、缩放、漫游
- 单击节点查看属性
- 双击节点展开下一级关系
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
│   │       │   ├── entity/     # 实体类
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
```

## 快速开始

### 前置要求

- JDK 11+
- Maven 3.6+
- MySQL 8.0+
- Neo4j 4.4+
- Node.js 16+ (可选，用于前端开发)

### 数据库配置

#### MySQL 配置

创建数据库：
```sql
CREATE DATABASE kg_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

修改 `backend/src/main/resources/application.yml` 中的MySQL连接信息：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/kg_system
    username: your_username
    password: your_password
```

#### Neo4j 配置

修改 `application.yml` 中的Neo4j连接信息：
```yaml
spring:
  neo4j:
    uri: bolt://localhost:7687
    authentication:
      username: neo4j
      password: your_neo4j_password
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

#### 方式二：使用Vite
```bash
cd frontend
npm install
npm run dev
```

前端将在 http://localhost:5173 启动。

## 默认账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | 123456 |
| 数据用户 | user | 123456 |

## API 接口文档

### 认证相关

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 登录 | POST | /auth/login | 用户登录 |
| 注册 | POST | /auth/register | 用户注册 |

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
| 创建实体 | POST | /api/kg/entities | 创建实体 |
| 实体列表 | GET | /api/kg/entities | 获取所有实体 |
| 搜索实体 | GET | /api/kg/entities/search | 搜索实体 |
| 相关实体 | GET | /api/kg/related/{name} | 获取相关实体 |
| 行业图谱 | GET | /api/kg/graph/industry/{industry} | 获取行业图谱 |
| 创建关系 | POST | /api/kg/relationships | 创建关系 |

### 行业管理

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 行业列表 | GET | /api/industry/list | 获取所有行业 |
| 初始化行业 | POST | /api/industry/initialize/{industry} | 初始化行业数据 |
| 爬虫获取 | POST | /api/industry/crawl | 模拟爬虫获取数据 |
| 自动生成 | POST | /api/industry/auto-generate | 自动生成知识图谱 |

## 使用说明

### 1. 登录系统

访问登录页面，使用管理员账号登录。

### 2. 创建行业

进入行业管理，创建一个新行业，系统会自动生成该行业的TOP10企业数据。

### 3. 查看知识图谱

在左侧选择行业，中间区域显示知识图谱：
- 单击节点：右侧显示详细属性
- 双击节点：展开下一级关系
- 拖拽节点：调整位置
- 缩放滚轮：放大/缩小图谱
- 点击最大化：全屏显示图谱

### 4. 管理数据

在系统管理中可以管理用户、角色、权限、菜单等。

## 开发说明

### 后端开发

- 代码位于 `backend/src/main/java/com/smartdata/kg/`
- 使用Spring Boot分层架构
- 实体类位于 `entity/` 目录，Neo4j实体在 `entity/neo4j/` 子目录
- Repository层负责数据访问
- Service层实现业务逻辑
- Controller层提供REST API

### 前端开发

- 代码位于 `frontend/` 目录
- 登录页面：`views/login/`
- 主页面：`views/main/`
- 知识图谱使用ECharts力导向图实现

## 注意事项

1. 爬虫功能目前为模拟实现，实际使用需要对接真实的数据源
2. 首次启动需要初始化数据库表结构
3. Neo4j需要提前安装并启动
4. 建议使用Chrome或Edge浏览器访问前端
5. 生产环境请修改JWT密钥和数据库密码

## 许可证

本项目仅供学习和研究使用。
