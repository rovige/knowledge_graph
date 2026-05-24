# Spring Boot 应用启动指南

## 问题诊断

您遇到的错误：
```
[ERROR] No plugin found for prefix 'spring-boot'
```

**原因**：pom.xml 中的 spring-boot-maven-plugin 配置不完整

**已修复**：已在 pom.xml 中添加了完整的 executions 配置

---

## ✅ 解决方案

### 方法 1：使用启动脚本（推荐）

我已经为您创建了一个启动脚本：

**双击运行**：
```
d:\ai_workspace\knowledge_graph\backend\START.bat
```

这个脚本会自动：
1. 检查 Maven 配置
2. 清理并构建项目
3. 启动 Spring Boot 应用

---

### 方法 2：手动启动

打开 PowerShell 或 CMD，运行：

```powershell
cd d:\ai_workspace\knowledge_graph\backend

# 先清理
mvn clean

# 启动应用
mvn spring-boot:run
```

或者一行命令：

```powershell
mvn clean spring-boot:run
```

---

### 方法 3：先打包再运行

```powershell
cd d:\ai_workspace\knowledge_graph\backend

# 打包（跳过测试）
mvn clean package -DskipTests

# 运行 jar 包
java -jar target/knowledge-graph-1.0.0.jar
```

---

## 🚀 启动后

### 成功标志

看到以下信息说明启动成功：
```
Started KnowledgeGraphApplication in X seconds
```

### 访问地址

- **后端 API**: http://localhost:8080
- **前端页面**: 直接打开 `d:\ai_workspace\knowledge_graph\frontend\index.html`

### 默认登录

- **用户名**: admin
- **密码**: 123456

---

## ⚠️ 启动前检查

在启动应用前，请确保：

### 1. Neo4j Desktop
- [ ] Neo4j Desktop 已打开
- [ ] 数据库已启动（绿色状态）
- [ ] Bolt 连接器已启用
- [ ] 记住了 Bolt URL 和密码

### 2. MySQL
- [ ] MySQL 服务运行中
- [ ] 数据库 `kg_system` 已创建
- [ ] SQL 脚本已执行

### 3. 配置文件
- [ ] Neo4j 连接信息已配置在 application.yml
- [ ] MySQL 连接信息已配置在 application.yml

---

## 🔍 常见错误

### 错误 1：Neo4j 连接失败

**错误信息**：
```
Could not connect to Neo4j: ...
```

**解决方法**：
1. 确认 Neo4j Desktop 中数据库正在运行
2. 检查 application.yml 中的 Neo4j 配置
3. 确认用户名密码正确

### 错误 2：MySQL 连接失败

**错误信息**：
```
Communications link failure
```

**解决方法**：
1. 确认 MySQL 服务正在运行
2. 检查 application.yml 中的数据库配置
3. 确认用户名密码正确

### 错误 3：数据库不存在

**错误信息**：
```
Unknown database 'kg_system'
```

**解决方法**：
```sql
CREATE DATABASE kg_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

然后执行数据库初始化脚本。

---

## 📝 快速配置检查

启动前，请确认 `application.yml` 中的配置：

```yaml
spring:
  neo4j:
    uri: bolt://localhost:7687    # ← 您的 Neo4j Bolt URL
    authentication:
      username: neo4j            # ← 您的用户名
      password: 您的密码        # ← ⚠️ 重要
  
  datasource:
    url: jdbc:mysql://localhost:3306/kg_system
    username: root               # ← 您的 MySQL 用户名
    password: 您的密码          # ← ⚠️ 您的 MySQL 密码
```

---

## 🎯 推荐启动步骤

1. **确认环境**：
   - Neo4j Desktop 启动 ✓
   - MySQL 运行中 ✓

2. **启动应用**：
   - 双击 `START.bat` 或
   - 运行 `mvn clean spring-boot:run`

3. **访问系统**：
   - 打开前端页面
   - 使用 admin/123456 登录

---

## 📂 相关文件

- **启动脚本**：[START.bat](file:///d:/ai_workspace/knowledge_graph/backend/START.bat)
- **配置文件**：[application.yml](file:///d:/ai_workspace/knowledge_graph/backend/src/main/resources/application.yml)
- **数据库脚本**：[backend/sql/README.md](file:///d:/ai_workspace/knowledge_graph/backend/sql/README.md)
- **详细配置**：[backend/sql/CONFIG_INSTRUCTIONS.md](file:///d:/ai_workspace/knowledge_graph/backend/sql/CONFIG_INSTRUCTIONS.md)

---

**现在请双击运行 [START.bat](file:///d:/ai_workspace/knowledge_graph/backend/START.bat) 来启动系统！**
