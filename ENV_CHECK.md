# 智慧数据平台 - 环境检查报告

## 检查日期
2026-05-23

## 环境检查结果

### ✅ Java 环境
- **状态**: 已安装
- **版本**: Java 21.0.11
- **要求**: Java 11+
- **位置**: 已检测到

### ❌ Maven 环境
- **状态**: 未检测到
- **解决方案**: 已配置 Maven Wrapper (`mvnw.cmd`)，无需单独安装 Maven

### ✅ MySQL 服务
- **状态**: 运行中
- **服务名**: MySQL80
- **启动类型**: 自动

### ❌ Neo4j 服务
- **状态**: 未检测到
- **注意**: 项目需要 Neo4j 数据库才能完整运行

### ✅ Node.js 环境
- **状态**: 已安装
- **版本**: v24.16.0
- **npm 版本**: 11.13.0
- **用途**: 可选，用于前端开发

---

## 配置已更新

### POM 文件更新
- Spring Boot: 2.7.14 → **3.2.0** (支持 Java 21)
- Java 版本: 11 → **21**
- Spring Data Neo4j: 6.3.14 → **7.2.0**
- MyBatis Plus: 3.5.3.1 → **3.5.5**
- JWT: 0.9.1 → **0.12.3**
- MySQL Connector: 已更新为 `com.mysql:mysql-connector-j`

### 代码适配
- 所有 `javax.` 包已更新为 `jakarta.`
- Spring Security 配置已更新为 Spring Boot 3.x 风格
- JWT 工具类已适配最新 API

---

## 启动步骤

### 1. 配置数据库 (必需)

#### MySQL 配置
修改 `backend/src/main/resources/application.yml` 中的数据库连接信息：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/kg_system
    username: your_username
    password: your_password
```

创建数据库：
```sql
CREATE DATABASE kg_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### Neo4j 配置 (可选，但推荐)
1. 下载并安装 Neo4j Community Edition 4.4+
2. 启动 Neo4j 服务
3. 修改 `application.yml`:
```yaml
spring:
  neo4j:
    uri: bolt://localhost:7687
    authentication:
      username: neo4j
      password: your_password
```

### 2. 启动后端

使用 Maven Wrapper (推荐):
```bash
cd backend
.\mvnw.cmd spring-boot:run
```

第一次运行会自动下载 Maven，需要耐心等待。

后端将在 http://localhost:8080 启动。

### 3. 启动前端

方式一：直接打开 (推荐，快速开始)
```
直接在浏览器中打开: frontend/index.html
```

方式二：使用 Vite 开发服务器
```bash
cd frontend
npm install
npm run dev
```

---

## 默认账号

- **管理员**: admin / 123456
- **普通用户**: user / 123456

---

## 项目结构

```
knowledge_graph/
├── backend/              # Spring Boot 后端
│   ├── src/
│   ├── pom.xml
│   └── mvnw.cmd         # Maven Wrapper (Windows)
├── frontend/            # HTML5 前端
│   ├── index.html
│   └── views/
├── README.md            # 项目说明
└── ENV_CHECK.md         # 本文档
```

---

## 常见问题

### 问题: Maven Wrapper 下载失败
**解决**: 手动下载 Maven 并安装，或配置代理。

### 问题: Java 版本不匹配
**解决**: 确保使用 Java 21，项目已配置支持 Java 21。

### 问题: Neo4j 连接失败
**解决**: 先启动 Neo4j 服务，或暂时注释掉 Neo4j 相关代码进行测试。

### 问题: 首次启动慢
**解决**: 首次运行 Maven 需要下载依赖，后续启动会快很多。
