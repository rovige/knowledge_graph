# Maven 环境变量配置问题解决方案

## 问题诊断

根据检查，您的系统 PATH 中没有包含 Maven 的路径。

## 解决方案

### 方案一：使用自动修复脚本（推荐）

我已为您创建了一个自动修复脚本：[fix_maven.ps1](file:///d:/ai_workspace/knowledge_graph/fix_maven.ps1)

**使用方法：**

1. 以管理员身份打开 PowerShell
2. 运行以下命令：
```powershell
cd d:\ai_workspace\knowledge_graph
.\fix_maven.ps1
```

脚本会自动：
- 搜索 Maven 安装位置
- 添加到系统 PATH
- 设置 MAVEN_HOME

### 方案二：手动配置

#### 步骤 1: 确认 Maven 安装位置

查找您安装 Maven 的目录，例如：
- `D:\apache-maven-3.9.6`
- `C:\apache-maven`

#### 步骤 2: 配置环境变量

**对于 Windows 10/11：**

1. 右键点击"此电脑" → "属性"
2. 点击"高级系统设置"
3. 点击"环境变量"
4. 在"系统变量"中，找到 `Path`，双击编辑
5. 点击"新建"，添加：`D:\apache-maven-3.9.6\bin`（根据您的实际路径）
6. 点击"确定"

#### 步骤 3: 设置 MAVEN_HOME（可选）

在"系统变量"中：
1. 点击"新建"
2. 变量名：`MAVEN_HOME`
3. 变量值：`D:\apache-maven-3.9.6`（根据您的实际路径）
4. 点击"确定"

#### 步骤 4: 验证配置

打开**新的**命令提示符或 PowerShell（重要！），运行：

```powershell
mvn -version
```

应该看到类似输出：
```
Apache Maven 3.9.6 (...)
Maven home: D:\apache-maven-3.9.6
Java version: 21.0.11, vendor: Oracle Corporation
```

## 常见问题

### Q: 已经配置了但还是不能用 mvn？

**A:** 请确保关闭所有现有的命令窗口并重新打开。新配置的环境变量只在新的窗口中生效。

### Q: 如何找到 Maven 的安装目录？

**A:** 常见的安装位置：
- `D:\apache-maven-3.9.6`
- `C:\Program Files\apache-maven`
- 您下载解压的位置

### Q: Maven 下载地址？

**A:** https://maven.apache.org/download.cgi

## 快速验证命令

在 PowerShell 中运行以下命令检查环境变量：

```powershell
# 查看当前 PATH 中是否包含 maven
$env:Path -split ';' | Select-String maven

# 或者
[Environment]::GetEnvironmentVariable("Path", "Machine") -split ';' | Select-String maven
```

如果返回空，说明还没有正确配置。

## 下一步

配置好 Maven 后，就可以启动项目了：

```powershell
cd d:\ai_workspace\knowledge_graph\backend
mvn spring-boot:run
```
