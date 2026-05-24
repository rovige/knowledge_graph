# 启动错误排查指南

## 第一步：先运行环境检查

先双击运行：
```
CHECK.bat
```

这个脚本会检查您的环境配置是否正确。

---

## 第二步：使用简单启动方式

如果检查正常，双击运行：
```
SIMPLE_START.bat
```

---

## 常见错误及解决方法

### 错误 1：No plugin found for prefix 'spring-boot'

**错误信息**：
```
[ERROR] No plugin found for prefix 'spring-boot'
```

**原因**：Maven 依赖下载有问题

**解决方法**：
```powershell
# 在 backend 目录下运行
cd d:\ai_workspace\knowledge_graph\backend

# 强制更新依赖
mvn clean install -U

# 然后启动
mvn spring-boot:run
```

---

### 错误 2：Could not resolve dependencies

**错误信息**：
```
[ERROR] Could not resolve dependencies
```

**原因**：Maven 中央仓库无法访问或依赖下载失败

**解决方法**：
```powershell
# 清理本地仓库缓存
mvn dependency:purge-local-repository

# 重新下载
mvn clean install
```

---

### 错误 3：Java version mismatch

**错误信息**：
```
Unsupported class file major version
```

**原因**：Java 版本不匹配

**解决方法**：
```powershell
# 检查 Java 版本
java -version

# 需要 Java 17 或更高版本
# 确保您的系统中安装了正确的 JDK
```

---

### 错误 4：Neo4j 连接失败

**错误信息**：
```
Could not connect to Neo4j
```

**解决方法**：
1. 打开 Neo4j Desktop
2. 确认数据库正在运行（绿色状态）
3. 在 Neo4j Desktop 中点击 Open，检查连接是否正常
4. 检查 `application.yml` 中的 Neo4j 配置是否正确

---

### 错误 5：MySQL 连接失败

**错误信息**：
```
Communications link failure
Access denied for user
```

**解决方法**：
1. 确认 MySQL 服务正在运行
2. 检查 `application.yml` 中的用户名和密码
3. 确认数据库 `kg_system` 已创建

---

## 另一种启动方式：使用 IDE（如果您有 IDE）

### 方式 A：使用 IntelliJ IDEA

1. 打开 IntelliJ IDEA
2. 选择 **File** → **Open**
3. 选择 `d:\ai_workspace\knowledge_graph\backend` 目录
4. 等待 Maven 导入完成
5. 找到 `KnowledgeGraphApplication.java`
6. 右键 → **Run 'KnowledgeGraphApplication'**

### 方式 B：使用 Eclipse

1. 导入项目为 Maven 项目
2. 运行主类

---

## 如果都不行，先检查这几项

1. **网络连接**：确保可以访问 Maven 中央仓库
2. **磁盘空间**：确保有足够的磁盘空间
3. **防火墙**：暂时关闭防火墙试试

---

## 下一步

先运行 `CHECK.bat`，然后把结果告诉我，这样我就能帮您定位具体问题了！
