-- 迁移脚本：更新数据库表结构

USE kg_system;

-- 1. 删除旧的 kg_industry 表（如果存在且不需要保留数据）
DROP TABLE IF EXISTS kg_industry;

-- 2. 更新 sys_industry 表结构
ALTER TABLE sys_industry 
MODIFY COLUMN name VARCHAR(100) NOT NULL,
MODIFY COLUMN code VARCHAR(50),
MODIFY COLUMN description TEXT,
DROP COLUMN IF EXISTS deleted;

-- 3. 确保所有表都存在且结构正确
-- 检查表是否存在，不存在则创建
-- 注意：为了安全，我们使用 CREATE TABLE IF NOT EXISTS

-- 重新执行完整的建表脚本（IF NOT EXISTS 保证安全）
source d:/ai_workspace/knowledge_graph/backend/sql/01_schema.sql;

SELECT 'Database migration completed!' AS message;
