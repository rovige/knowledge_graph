# Neo4j Desktop 与系统对接指南

## 第一部分：获取 Neo4j 连接信息

### 步骤 1：查看 Neo4j Desktop 数据库信息

1. 打开 **Neo4j Desktop**
2. 选择您的数据库（Graph）
3. 点击数据库卡片上的 **"..."** 按钮
4. 选择 **"Properties"**（属性）

### 步骤 2：记录连接信息

记录以下信息：
- **Bolt URL**: 通常是 `bolt://localhost:7687` 或 `bolt://localhost:7687`（带随机端口）
- **用户名**: 通常是 `neo4j`
- **密码**: 您设置的密码

### 步骤 3：查找连接端口

如果 Bolt 端口不是默认的 `7687`，需要额外配置：

1. 点击数据库的 **"..."** 按钮
2. 选择 **"Settings"**
3. 查找 **Bolt connector** 配置
4. 记录 **Bolt port**（例如 `7687`、`7688` 等）

---

## 第二部分：配置后端连接

### 步骤 1：修改 application.yml

打开文件：`d:\ai_workspace\knowledge_graph\backend\src\main\resources\application.yml`

找到 `spring.neo4j` 部分，修改配置：

```yaml
spring:
  neo4j:
    uri: bolt://localhost:7687    # 根据您的实际端口修改
    authentication:
      username: neo4j           # 您的用户名
      password: your_password    # 您的密码
```

### 步骤 2：常见 Neo4j Desktop 端口配置

Neo4j Desktop 可能使用不同的端口，常见情况：

| 数据库 | Bolt 端口 |
|--------|----------|
| 第1个 | bolt://localhost:7687 |
| 第2个 | bolt://localhost:7688 |
| 第3个 | bolt://localhost:7689 |
| ... | ... |

---

## 第三部分：配置数据库连接（MySQL）

### 步骤 1：确认 MySQL 信息

1. 打开 MySQL（已确认运行中）
2. 创建数据库（如果还没有）：

```sql
CREATE DATABASE IF NOT EXISTS kg_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 步骤 2：执行数据库初始化脚本

在 MySQL 中执行：

1. 打开 MySQL Workbench 或命令行
2. 选择 `kg_system` 数据库
3. 执行 `01_schema.sql` 建表
4. 执行 `02_data.sql` 预置数据

```bash
# 如果使用命令行
mysql -u root -p kg_system < d:\ai_workspace\knowledge_graph\backend\sql\01_schema.sql
mysql -u root -p kg_system < d:\ai_workspace\knowledge_graph\backend\sql\02_data.sql
```

### 步骤 3：配置 MySQL 连接

修改 `application.yml` 中的 MySQL 配置：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/kg_system?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
    username: root              # 您的 MySQL 用户名
    password: your_password    # 您的 MySQL 密码
```

---

## 第四部分：启动后端服务

### 方法 1：使用 Maven

```powershell
cd d:\ai_workspace\knowledge_graph\backend
mvn spring-boot:run
```

### 方法 2：使用 Maven Wrapper

```powershell
cd d:\ai_workspace\knowledge_graph\backend
.\mvnw.cmd spring-boot:run
```

### 方法 3：先打包再运行

```powershell
cd d:\ai_workspace\knowledge_graph\backend
mvn clean package -DskipTests
java -jar target/knowledge-graph-1.0.0.jar
```

---

## 第五部分：验证系统运行

### 步骤 1：检查后端启动

后端启动成功后会显示：
```
Started KnowledgeGraphApplication in X seconds
```

访问 http://localhost:8080

### 步骤 2：测试登录

1. 打开浏览器，访问 http://localhost:8080
2. 或直接打开前端文件：`d:\ai_workspace\knowledge_graph\frontend\index.html`

使用默认账号登录：
- **用户名**: admin
- **密码**: 123456

### 步骤 3：测试知识图谱功能

登录后，在系统中：
1. 选择一个行业（左侧）
2. 查看知识图谱（中间）
3. 点击节点查看属性（右侧）

---

## 第六部分：常见问题

### Q1: Neo4j 连接失败？

**检查项**：
- [ ] Neo4j Desktop 数据库是否启动？
- [ ] Bolt 端口是否正确？（可能是 7687, 7688, 7689...）
- [ ] 用户名密码是否正确？
- [ ] 是否在 Neo4j Desktop 中启用了 Bolt 连接器？

**解决方法**：
1. 在 Neo4j Desktop 中确认数据库运行状态
2. 检查 `application.yml` 中的端口和密码
3. 如果忘记了密码，可以重置（Neo4j Desktop 中有选项）

### Q2: MySQL 连接失败？

**检查项**：
- [ ] MySQL 服务是否运行？
- [ ] 数据库 `kg_system` 是否创建？
- [ ] 用户名密码是否正确？
- [ ] 是否执行了 SQL 脚本？

### Q3: 数据库初始化失败？

确保先创建数据库，再执行脚本：
```sql
CREATE DATABASE kg_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kg_system;
SOURCE d:\ai_workspace\knowledge_graph\backend\sql\01_schema.sql;
SOURCE d:\ai_workspace\knowledge_graph\backend\sql\02_data.sql;
```

---

## 快速检查清单

启动系统前，请确认：

- [ ] Neo4j Desktop 数据库已启动 ✓
- [ ] Neo4j Bolt 端口已记录
- [ ] Neo4j 连接信息已配置在 application.yml
- [ ] MySQL 服务运行中 ✓
- [ ] kg_system 数据库已创建
- [ ] SQL 脚本已执行
- [ ] application.yml 中的 MySQL 配置正确
- [ ] 已执行 Neo4j 数据导入脚本

---

## 下一步

配置完成后，就可以启动系统了！

**启动命令**：
```powershell
cd d:\ai_workspace\knowledge_graph\backend
mvn spring-boot:run
```

**访问系统**：
- 后端 API: http://localhost:8080
- 前端页面: 直接打开 `d:\ai_workspace\knowledge_graph\frontend\index.html`
