# 快速启动指南

## 解决 Maven 问题（当前问题）

### 方法 1：使用批处理脚本（最简单）

双击运行我刚创建的文件：
```
d:\ai_workspace\knowledge_graph\setup_maven.bat
```

这个脚本会自动查找 Maven 并配置环境变量。

---

### 方法 2：临时允许 PowerShell 脚本运行

在 PowerShell（管理员）中运行：

```powershell
# 临时允许当前会话运行脚本
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 然后运行修复脚本
cd d:\ai_workspace\knowledge_graph
.\fix_maven.ps1
```

---

### 方法 3：绕过执行策略（推荐，安全）

```powershell
powershell -ExecutionPolicy Bypass -File "d:\ai_workspace\knowledge_graph\fix_maven.ps1"
```

---

### 方法 4：手动配置（最安全）

如果您不想运行脚本，请按以下步骤操作：

#### 1. 找到 Maven 安装目录

在文件资源管理器中搜索 "apache-maven"，找到您安装 Maven 的位置，例如：
```
D:\apache-maven-3.9.6
```

#### 2. 配置环境变量

1. 右键点击 **"此电脑"** → **"属性"**
2. 点击 **"高级系统设置"**
3. 点击 **"环境变量"**
4. 在 **"系统变量"** 部分：
   - 点击 **"新建"**
   - 变量名：`MAVEN_HOME`
   - 变量值：`D:\apache-maven-3.9.6`（替换为您的实际路径）
   - 点击 **"确定"**
   
5. 找到 **"Path"** 变量，双击编辑：
   - 点击 **"新建"**
   - 输入：`%MAVEN_HOME%\bin`
   - 点击 **"确定"** → **"确定"** → **"确定"**

#### 3. 验证配置

**重要：关闭所有现有的 CMD/PowerShell 窗口！**

重新打开 PowerShell，运行：

```powershell
mvn -version
```

如果看到版本信息，说明配置成功！

---

## 启动项目

### 1. 先配置数据库

在配置好 Maven 后，先初始化数据库：

```powershell
cd backend/sql
# 可以先手动执行 SQL 脚本，或者使用数据库工具
```

详见 [backend/sql/README.md](file:///d:/ai_workspace/knowledge_graph/backend/sql/README.md)

### 2. 启动后端

```powershell
cd d:\ai_workspace\knowledge_graph\backend
mvn spring-boot:run
```

### 3. 访问前端

直接在浏览器中打开：
```
d:\ai_workspace\knowledge_graph\frontend\index.html
```

---

## 常见问题

### Q: 为什么要关闭窗口再重新打开？

**A:** 环境变量的修改只对新打开的程序生效。

### Q: Maven 没有安装怎么办？

**A:** 下载地址：https://maven.apache.org/download.cgi

下载 `apache-maven-3.9.6-bin.zip`，解压到某个目录（如 D:\），然后按上面的步骤配置。

### Q: 我可以不使用 Maven 吗？

**A:** 可以！您可以直接运行我们已经配置好的 [frontend/index.html](file:///d:/ai_workspace/knowledge_graph/frontend/index.html) 来查看前端界面。
