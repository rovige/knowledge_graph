-- =============================================
-- 完整数据库迁移脚本
-- 1. 备份现有数据
-- 2. 删除旧表
-- 3. 创建新表结构
-- 4. 恢复数据（可选）
-- =============================================

USE kg_system;

-- =============================================
-- 步骤1: 备份（如果需要保留数据，取消下面注释）
-- =============================================
-- CREATE TABLE IF NOT EXISTS backup_sys_industry AS SELECT * FROM sys_industry;
-- CREATE TABLE IF NOT EXISTS backup_sys_user AS SELECT * FROM sys_user;
-- CREATE TABLE IF NOT EXISTS backup_sys_role AS SELECT * FROM sys_role;
-- CREATE TABLE IF NOT EXISTS backup_sys_permission AS SELECT * FROM sys_permission;
-- CREATE TABLE IF NOT EXISTS backup_sys_menu AS SELECT * FROM sys_menu;
-- CREATE TABLE IF NOT EXISTS backup_company AS SELECT * FROM company;
-- CREATE TABLE IF NOT EXISTS backup_news AS SELECT * FROM news;
-- CREATE TABLE IF NOT EXISTS backup_data_task AS SELECT * FROM data_task;
-- CREATE TABLE IF NOT EXISTS backup_graph_node AS SELECT * FROM graph_node;
-- CREATE TABLE IF NOT EXISTS backup_graph_edge AS SELECT * FROM graph_edge;
-- CREATE TABLE IF NOT EXISTS backup_sys_user_role AS SELECT * FROM sys_user_role;
-- CREATE TABLE IF NOT EXISTS backup_sys_role_permission AS SELECT * FROM sys_role_permission;
-- CREATE TABLE IF NOT EXISTS backup_sys_role_menu AS SELECT * FROM sys_role_menu;

-- =============================================
-- 步骤2: 删除所有表（按外键依赖顺序）
-- =============================================
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS sys_role_menu;
DROP TABLE IF EXISTS sys_role_permission;
DROP TABLE IF EXISTS sys_user_role;
DROP TABLE IF EXISTS graph_edge;
DROP TABLE IF EXISTS graph_node;
DROP TABLE IF EXISTS data_task;
DROP TABLE IF EXISTS news;
DROP TABLE IF EXISTS company;
DROP TABLE IF EXISTS sys_industry;
DROP TABLE IF EXISTS sys_menu;
DROP TABLE IF EXISTS sys_permission;
DROP TABLE IF EXISTS sys_role;
DROP TABLE IF EXISTS sys_user;
DROP TABLE IF EXISTS kg_industry;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- 步骤3: 重新创建所有表（使用最新结构）
-- =============================================

-- 1. 用户表
CREATE TABLE sys_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    nickname VARCHAR(50) COMMENT '昵称',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '电话',
    avatar VARCHAR(255) COMMENT '头像',
    status INT DEFAULT 1 COMMENT '状态：1-正常，0-禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_username (username),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 2. 角色表
CREATE TABLE sys_role (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '角色名称',
    code VARCHAR(50) NOT NULL UNIQUE COMMENT '角色编码',
    description VARCHAR(255) COMMENT '角色描述',
    status INT DEFAULT 1 COMMENT '状态：1-正常，0-禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_code (code),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 3. 用户角色关联表
CREATE TABLE sys_user_role (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_user_role (user_id, role_id),
    INDEX idx_user_id (user_id),
    INDEX idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- 4. 权限表
CREATE TABLE sys_permission (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL COMMENT '权限名称',
    code VARCHAR(100) NOT NULL UNIQUE COMMENT '权限编码',
    type VARCHAR(20) COMMENT '权限类型',
    path VARCHAR(200) COMMENT 'API路径',
    method VARCHAR(20) COMMENT '请求方法',
    status INT DEFAULT 1 COMMENT '状态：1-正常，0-禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_code (code),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限表';

-- 5. 角色权限关联表
CREATE TABLE sys_role_permission (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_id BIGINT NOT NULL COMMENT '角色ID',
    permission_id BIGINT NOT NULL COMMENT '权限ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_role_permission (role_id, permission_id),
    INDEX idx_role_id (role_id),
    INDEX idx_permission_id (permission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

-- 6. 菜单表
CREATE TABLE sys_menu (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_id BIGINT DEFAULT 0 COMMENT '父菜单ID',
    name VARCHAR(50) NOT NULL COMMENT '菜单名称',
    path VARCHAR(200) COMMENT '路由路径',
    component VARCHAR(200) COMMENT '组件路径',
    icon VARCHAR(100) COMMENT '菜单图标',
    sort INT DEFAULT 0 COMMENT '排序',
    type VARCHAR(20) COMMENT '菜单类型',
    permission VARCHAR(200) COMMENT '权限标识',
    visible INT DEFAULT 1 COMMENT '是否显示：1-显示，0-隐藏',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_parent_id (parent_id),
    INDEX idx_sort (sort)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单表';

-- 7. 角色菜单关联表
CREATE TABLE sys_role_menu (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_id BIGINT NOT NULL COMMENT '角色ID',
    menu_id BIGINT NOT NULL COMMENT '菜单ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_role_menu (role_id, menu_id),
    INDEX idx_role_id (role_id),
    INDEX idx_menu_id (menu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色菜单关联表';

-- 8. 行业表
CREATE TABLE sys_industry (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_id BIGINT DEFAULT 0 COMMENT '父行业ID',
    name VARCHAR(100) NOT NULL COMMENT '行业名称',
    code VARCHAR(50) COMMENT '行业编码',
    description TEXT COMMENT '行业描述',
    sort INT DEFAULT 0 COMMENT '排序',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_parent_id (parent_id),
    INDEX idx_code (code),
    INDEX idx_sort (sort)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='行业表';

-- 9. 企业表
CREATE TABLE company (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    industry_id BIGINT NOT NULL COMMENT '行业ID',
    name VARCHAR(200) NOT NULL COMMENT '企业名称',
    code VARCHAR(50) COMMENT '企业编码',
    legal_representative VARCHAR(100) COMMENT '法人代表',
    address VARCHAR(500) COMMENT '地址',
    business_scope TEXT COMMENT '经营范围',
    registered_capital DECIMAL(20,2) COMMENT '注册资本',
    establishment_date DATETIME COMMENT '成立日期',
    ranking INT COMMENT '排名',
    status VARCHAR(20) DEFAULT 'ACTIVE' COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_industry_id (industry_id),
    INDEX idx_ranking (ranking),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='企业表';

-- 10. 新闻表
CREATE TABLE news (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT NOT NULL COMMENT '企业ID',
    title VARCHAR(500) NOT NULL COMMENT '新闻标题',
    summary TEXT COMMENT '新闻摘要',
    content TEXT COMMENT '新闻内容',
    source VARCHAR(200) COMMENT '新闻来源',
    url VARCHAR(500) COMMENT '新闻链接',
    publish_time DATETIME COMMENT '发布时间',
    type INT DEFAULT 1 COMMENT '新闻类型',
    status VARCHAR(20) DEFAULT 'PUBLISHED' COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_company_id (company_id),
    INDEX idx_publish_time (publish_time),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='新闻表';

-- 11. 数据任务表
CREATE TABLE data_task (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    industry_id BIGINT NOT NULL COMMENT '行业ID',
    industry_name VARCHAR(100) COMMENT '行业名称',
    task_type VARCHAR(50) COMMENT '任务类型',
    status VARCHAR(20) COMMENT '任务状态',
    progress INT DEFAULT 0 COMMENT '进度',
    error_message TEXT COMMENT '错误信息',
    start_time DATETIME COMMENT '开始时间',
    end_time DATETIME COMMENT '结束时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_industry_id (industry_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据任务表';

-- 12. 图节点表
CREATE TABLE graph_node (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL COMMENT '节点名称',
    type VARCHAR(50) COMMENT '节点类型',
    properties JSON COMMENT '节点属性',
    industry_id BIGINT COMMENT '行业ID',
    status INT DEFAULT 1 COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_industry_id (industry_id),
    INDEX idx_type (type),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图节点表';

-- 13. 图边表
CREATE TABLE graph_edge (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    source_node_id BIGINT NOT NULL COMMENT '源节点ID',
    target_node_id BIGINT NOT NULL COMMENT '目标节点ID',
    relation_type VARCHAR(50) COMMENT '关系类型',
    properties JSON COMMENT '关系属性',
    industry_id BIGINT COMMENT '行业ID',
    status INT DEFAULT 1 COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_source (source_node_id),
    INDEX idx_target (target_node_id),
    INDEX idx_industry_id (industry_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图边表';

-- =============================================
-- 步骤4: 恢复数据（如果之前备份了，取消下面注释）
-- =============================================
-- 注意：需要根据实际备份表结构调整
-- INSERT INTO sys_industry SELECT * FROM backup_sys_industry;
-- INSERT INTO sys_user SELECT * FROM backup_sys_user;
-- INSERT INTO sys_role SELECT * FROM backup_sys_role;
-- ... 其他表

-- =============================================
-- 完成
-- =============================================
SELECT 'Database migration completed successfully!' AS message;
SHOW TABLES;
