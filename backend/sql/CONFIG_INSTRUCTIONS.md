# 系统对接配置说明

## 📝 当前配置文件

文件位置：`d:\ai_workspace\knowledge_graph\backend\src\main\resources\application.yml`

### Neo4j 配置（需要修改）

当前配置：
```yaml
spring:
  neo4j:
    uri: bolt://localhost:7687          # ⚠️ 可能需要修改
    authentication:
      username: neo4j                  # ⚠️ 根据实际填写
      password: neo4j                  # ⚠️ 您的密码
```

### MySQL 配置（需要修改）

当前配置：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/kg_system
    username: root                     # ⚠️ 根据实际填写
    password: root                     # ⚠️ 您的密码
```

---

## 🔧 如何修改配置

### 步骤 1：获取 Neo4j Desktop 连接信息

1. 打开 **Neo4j Desktop**
2. 点击数据库卡片上的 **"..."** 按钮
3. 选择 **"Properties"**（属性）
4. 找到并记录：
   - **Bolt URL**（例如：`bolt://localhost:7687`）
   - **Username**（通常是 `neo4j`）
   - **Password**（您设置的密码）

### 步骤 2：获取 MySQL 连接信息

1. 确认 MySQL 用户名（通常是 `root`）
2. 确认 MySQL 密码

### 步骤 3：修改 application.yml

用记事本或其他编辑器打开：
```
d:\ai_workspace\knowledge_graph\backend\src\main\resources\application.yml
```

修改以下部分：

```yaml
# Neo4j 配置
spring:
  neo4j:
    uri: bolt://localhost:7687    # 替换为您的 Bolt URL
    authentication:
      username: neo4j              # 替换为您的用户名
      password: 您的密码           # ⚠️ 替换为实际密码

# MySQL 配置
  datasource:
    username: root                 # 替换为您的用户名
    password: 您的密码            # ⚠️ 替换为实际密码
```

### 步骤 4：保存文件

保存修改后的 `application.yml` 文件。

---

## ✅ 检查清单

修改配置前，请确认：

### Neo4j 信息
- [ ] Bolt URL 正确（检查 Neo4j Desktop 中的 Properties）
- [ ] Username 正确（通常是 neo4j）
- [ ] Password 正确（您设置的密码）

### MySQL 信息
- [ ] Username 正确（通常是 root）
- [ ] Password 正确
- [ ] 数据库 `kg_system` 已创建

---

## 🚀 配置完成后启动系统

### 方法 1：使用 Maven

打开 PowerShell，运行：
```powershell
cd d:\ai_workspace\knowledge_graph\backend
mvn spring-boot:run
```

### 方法 2：使用 Maven Wrapper

```powershell
cd d:\ai_workspace\knowledge_graph\backend
.\mvnw.cmd spring-boot:run
```

---

## 🧪 测试系统

### 测试 1：后端启动

如果看到以下信息，说明后端启动成功：
```
Started KnowledgeGraphApplication in X seconds
```

### 测试 2：访问登录页面

打开浏览器：
```
http://localhost:8080
```

或者直接打开前端文件：
```
d:\ai_workspace\knowledge_graph\frontend\index.html
```

### 测试 3：登录系统

- 用户名：`admin`
- 密码：`123456`

---

## 📞 快速帮助

### 如果 Neo4j 连接失败

**检查项**：
1. Neo4j Desktop 数据库是否启动？（绿色状态）
2. Bolt URL 端口是否正确？
3. 密码是否正确？

### 如果 MySQL 连接失败

**检查项**：
1. MySQL 服务是否运行？
2. 数据库 `kg_system` 是否创建？
3. 用户名密码是否正确？

---

## 📂 相关文件

- **配置文件**：`application.yml`
- **详细说明**：[SYSTEM_CONNECTION.md](file:///d:/ai_workspace/knowledge_graph/backend/sql/SYSTEM_CONNECTION.md)
- **数据库脚本**：[01_schema.sql](file:///d:/ai_workspace/knowledge_graph/backend/sql/01_schema.sql)
- **数据脚本**：[02_data.sql](file:///d:/ai_workspace/knowledge_graph/backend/sql/02_data.sql)
