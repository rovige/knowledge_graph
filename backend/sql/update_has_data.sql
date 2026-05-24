-- 为 sys_industry 表添加 has_data 字段
USE kg_system;

-- 添加 has_data 字段（默认 false）
ALTER TABLE sys_industry ADD COLUMN has_data TINYINT(1) DEFAULT 0 COMMENT '是否已生成数据：0-未生成，1-已生成';

-- 为已有的数据更新 has_data 状态（根据 company 表中的数据）
UPDATE sys_industry i 
SET i.has_data = 1 
WHERE EXISTS (
    SELECT 1 FROM company c WHERE c.industry_id = i.id
);

-- 查看结果
SELECT id, name, code, has_data FROM sys_industry;
