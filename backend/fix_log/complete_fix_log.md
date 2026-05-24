# 智慧数据平台 - 完整修复日志

## 修复日期
2026-05-24 00:36 (CST)

## 修复时间线

| 时间 | 修复内容 | 问题描述 |
|------|----------|----------|
| 2026-05-24 00:00 | 开始环境检查与编码问题修复 | Maven 编码错误 |
| 2026-05-24 00:15 | 修复多个 Controller 编码问题 | UTF-8 不可映射字符 |
| 2026-05-24 00:25 | 修复 JWT API 兼容性问题 | jjwt 0.12.x 不兼容 |
| 2026-05-24 00:30 | 修复 MyBatis-Plus 兼容性 | Spring Boot 3.2 不兼容 |
| 2026-05-24 00:36 | 最终版本兼容性调整 | factoryBeanObjectType 错误 |

---

## 完整修复列表

### 1. 编码问题修复（多个文件）

| 序号 | 文件 | 问题描述 |
|------|------|----------|
| 1 | PermissionController.java | 第 39 行乱码 |
| 2 | RoleController.java | 第 39 行乱码 |
| 3 | UserController.java | 第 31 行乱码 |
| 4 | IndustryController.java | 第 36 行乱码 |
| 5 | MenuController.java | 第 36 行乱码 |
| 6 | KnowledgeGraphController.java | 第 103 行中文 |
| 7 | AuthService.java | 第 54 行中文 |
| 8 | Result.java | 多处中文消息 |
| 9 | CrawlerService.java | 大量乱码（全部重写） |
| 10 | LoginRequest.java | 第 10 行乱码 |
| 11 | ApiResponse.java | 第 21 行中文 |
| 12 | GlobalExceptionHandler.java | 第 16、23 行中文 |

### 2. pom.xml 配置修复

| 修改项 | 原值 | 新值 | 说明 | 时间 |
|--------|------|------|------|------|
| spring-boot-starter-parent | 2.7.14 | 3.2.0 → 3.1.5 | 升级 Spring Boot 后又降级 | 2026-05-24 |
| project.build.sourceEncoding | 无 | UTF-8 | 添加编译编码配置 | 2026-05-24 |
| project.reporting.outputEncoding | 无 | UTF-8 | 添加报告编码配置 | 2026-05-24 |
| maven.compiler.encoding | 无 | UTF-8 | 添加 Maven 编译器编码配置 | 2026-05-24 |
| jjwt.version | 0.12.3 | 0.11.5 | 降级 JWT 版本以提升兼容性 | 2026-05-24 |
| mybatis-plus.version | 3.5.5 | 3.5.7 → 3.5.5 | 版本调整以兼容 Spring Boot | 2026-05-24 |

### 3. JWT API 修复

**文件**：`src/main/java/com/smartdata/kg/utils/JwtUtil.java`

**修改**：
- 更新 jjwt API 调用以兼容 0.11.5 版本
- 使用 parserBuilder() 替代 parser()
- 使用 setClaims()、setSubject() 等方法
- 使用 signWith(key, algorithm) 签名方法

### 4. Spring Boot 版本兼容性修复

**问题**：`java.lang.IllegalArgumentException: Invalid value type for attribute 'factoryBeanObjectType': java.lang.String`

**解决**：
- 降级 Spring Boot 从 3.2.0 到 3.1.5
- 保持 MyBatis-Plus 3.5.5 版本

---

## 当前配置（最终）

| 组件 | 版本 | 说明 |
|------|------|------|
| Spring Boot | 3.1.5 | Web 框架（最终版本） |
| Spring Data Neo4j | 7.2.0 | Neo4j ORM |
| MyBatis-Plus | 3.5.5 | MySQL ORM |
| Spring Security | 6.x | 安全框架 |
| jjwt | 0.11.5 | JWT 工具 |
| Lombok | 最新 | 代码简化 |
| Hutool | 5.8.23 | 工具库 |
| Java | 21 | 运行时环境 |

---

## 启动指南

### 启动前准备

1. **Neo4j Desktop**
   - 确保数据库已启动
   - 确认 Bolt 端口和密码配置

2. **MySQL**
   - 确保服务已启动
   - 创建数据库 `kg_system`（可选，首次运行会自动创建）
   - 执行初始化 SQL（可选）

3. **配置文件**
   - 修改 `src/main/resources/application.yml` 中的数据库连接信息

### 启动方式

#### 方式 1：快速启动脚本

```cmd
cd backend
FAST_START.bat
```

#### 方式 2：命令行启动

```powershell
cd backend
mvn clean spring-boot:run
```

### 访问系统

- **后端 API**：http://localhost:8080
- **前端**：打开 `frontend/index.html`
- **默认账号**：admin / 123456

---

## 相关文件

### 数据库初始化脚本
- `sql/01_schema.sql` - MySQL 建表脚本
- `sql/02_data.sql` - 数据预置脚本
- `sql/03_neo4j_init.cypher` - Neo4j 初始化脚本

### 系统配置
- `src/main/resources/application.yml` - 应用主配置文件

### 修复日志目录
- `fix_log/` - 包含所有修复过程的日志文件
