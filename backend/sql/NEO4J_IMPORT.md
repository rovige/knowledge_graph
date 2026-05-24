# Neo4j Desktop 数据导入指南

## 方法一：在 Neo4j Browser 中导入（推荐）

### 步骤 1：打开 Neo4j Desktop

1. 启动 **Neo4j Desktop** 应用
2. 选择或创建一个数据库（Graph）
3. 点击 **Open** 打开 Neo4j Browser

### 步骤 2：打开 Cypher 编辑器

1. 在 Neo4j Browser 顶部有一个命令行输入框
2. 或者点击左上角的 **">"** 图标打开 Cypher 编辑器

### 步骤 3：复制粘贴 Cypher 脚本

1. 打开文件：`d:\ai_workspace\knowledge_graph\backend\sql\03_neo4j_init.cypher`
2. 全选所有内容（Ctrl + A）
3. 复制（Ctrl + C）

### 步骤 4：执行脚本

在 Neo4j Browser 的 Cypher 编辑器中：
1. 粘贴脚本内容（Ctrl + V）
2. 点击 **运行** 按钮（或者按 Ctrl + Enter）

### 步骤 5：验证数据

执行以下查询验证数据导入成功：

```cypher
// 查看所有节点
MATCH (n) RETURN n LIMIT 25;

// 查看节点数量
MATCH (n) RETURN labels(n)[0] as Type, count(*) as Count;

// 查看关系数量
MATCH ()-[r]->() RETURN type(r) as RelationshipType, count(*) as Count;
```

---

## 方法二：使用 Neo4j Desktop 的文件导入功能

### 步骤 1：准备数据文件

1. 在 Neo4j Desktop 中，选择您的数据库
2. 点击 **"..."** 菜单 → **"Open folder"** → **"import"**
3. 这会打开导入文件夹

### 步骤 2：复制 Cypher 文件

将 `03_neo4j_init.cypher` 文件复制到导入文件夹中：
```
C:\Users\<您的用户名>\Neo4j\<数据库名称>\import\
```

### 步骤 3：执行文件

1. 在 Neo4j Browser 中执行：
```cypher
// 方式1: 使用 :source 命令（如果支持）
:source file:///03_neo4j_init.cypher

// 方式2: 手动复制粘贴文件内容
```

---

## 方法三：分批执行（如果数据量大）

如果您想分批导入，可以分别执行以下脚本：

### 3.1 先创建行业节点

```cypher
CREATE (ai:Industry {id: 101, name: '人工智能', code: 'AI', description: '人工智能领域'});
CREATE (new_energy_car:Industry {id: 305, name: '新能源汽车', code: 'NEW_ENERGY_CAR', description: '新能源汽车产业'});
```

### 3.2 创建企业节点（人工智能行业）

```cypher
CREATE (tencent:Company {id: 1001, name: '腾讯科技', industry: 'AI', description: '中国领先的互联网增值服务提供商'});
CREATE (alibaba:Company {id: 1002, name: '阿里巴巴', industry: 'AI', description: '全球领先的电子商务和云计算公司'});
CREATE (baidu:Company {id: 1003, name: '百度', industry: 'AI', description: '全球最大的中文搜索引擎和AI公司'});
CREATE (huawei:Company {id: 1004, name: '华为', industry: 'AI', description: '全球领先的ICT基础设施和智能终端提供商'});
CREATE (bytedance:Company {id: 1005, name: '字节跳动', industry: 'AI', description: '全球化的科技公司，拥有抖音、TikTok等产品'});
```

### 3.3 创建更多企业（新能源汽车）

```cypher
CREATE (byd:Company {id: 3001, name: '比亚迪', industry: 'NEW_ENERGY_CAR', description: '中国新能源汽车领导者'});
CREATE (tesla:Company {id: 3002, name: '特斯拉', industry: 'NEW_ENERGY_CAR', description: '全球新能源汽车和清洁能源公司'});
CREATE (nio:Company {id: 3003, name: '蔚来', industry: 'NEW_ENERGY_CAR', description: '中国高端智能电动汽车品牌'});
CREATE (xiaopeng:Company {id: 3004, name: '小鹏', industry: 'NEW_ENERGY_CAR', description: '专注于智能网联电动汽车的公司'});
CREATE (li_auto:Company {id: 3005, name: '理想汽车', industry: 'NEW_ENERGY_CAR', description: '中国新能源汽车公司'});
```

### 3.4 创建关系

```cypher
// 腾讯和阿里巴巴的竞争关系
MATCH (a:Company {name: '腾讯科技'}), (b:Company {name: '阿里巴巴'})
CREATE (a)-[:COMPETES_WITH {weight: 0.8}]->(b);

// 百度使用计算机视觉
MATCH (c:Company {name: '百度'}), (t:Technology {name: '计算机视觉'})
CREATE (c)-[:USES {weight: 0.95}]->(t);
```

---

## 方法四：使用 Cypher Shell

### 步骤 1：找到 Cypher Shell

在 Neo4j Desktop 中：
1. 点击数据库的 **"..."** 菜单
2. 选择 **"Cypher Shell"**

或者在终端中直接运行：
```bash
cd "C:\Users\<您的用户名>\Neo4j\<数据库名称>\bin"
cypher-shell.bat -u neo4j -p <您的密码>
```

### 步骤 2：执行脚本

```bash
cat "d:\ai_workspace\knowledge_graph\backend\sql\03_neo4j_init.cypher" | cypher-shell.bat -u neo4j -p <您的密码>
```

---

## 常见问题

### Q: 如何清除现有数据？

在导入新数据前，先执行：
```cypher
MATCH (n) DETACH DELETE n;
```

### Q: Neo4j Browser 在哪里？

在 Neo4j Desktop 主界面中，点击数据库卡片上的 **Open** 按钮。

### Q: 忘记密码怎么办？

1. 在 Neo4j Desktop 中停止数据库
2. 修改 `neo4j.conf` 文件，添加：
   ```
   dbms.security.auth_enabled=false
   ```
3. 重启数据库（注意：这会禁用认证，仅用于开发环境）

### Q: 如何查看导入的数据？

在 Neo4j Browser 中执行：
```cypher
// 查看所有公司
MATCH (c:Company) RETURN c;

// 查看所有关系
MATCH (a)-[r]->(b) RETURN a.name, type(r), b.name LIMIT 20;
```

---

## 导入文件位置

Cypher 脚本文件：
```
d:\ai_workspace\knowledge_graph\backend\sql\03_neo4j_init.cypher
```

您可以直接打开这个文件，将内容复制到 Neo4j Browser 中执行。
