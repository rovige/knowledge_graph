CREATE DATABASE IF NOT EXISTS kg_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE kg_system;

CREATE TABLE IF NOT EXISTS sys_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    real_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    avatar VARCHAR(255),
    status INT DEFAULT 1 COMMENT '1-正常 0-禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sys_role (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    status INT DEFAULT 1 COMMENT '1-正常 0-禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sys_user_role (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    UNIQUE KEY uk_user_role (user_id, role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sys_menu (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_id BIGINT DEFAULT 0,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(20) NOT NULL COMMENT 'DIR/MENU/BUTTON',
    icon VARCHAR(100),
    path VARCHAR(200),
    component VARCHAR(200),
    permission VARCHAR(200),
    sort_order INT DEFAULT 0,
    status INT DEFAULT 1 COMMENT '1-正常 0-禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sys_role_menu (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_id BIGINT NOT NULL,
    menu_id BIGINT NOT NULL,
    UNIQUE KEY uk_role_menu (role_id, menu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS kg_industry (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50),
    description TEXT,
    sort_order INT DEFAULT 0,
    status INT DEFAULT 1 COMMENT '1-正常 0-禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS company (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    industry_id BIGINT NOT NULL,
    name VARCHAR(200) NOT NULL,
    code VARCHAR(50),
    legal_representative VARCHAR(100),
    address VARCHAR(500),
    business_scope TEXT,
    registered_capital DECIMAL(20,2),
    establishment_date DATETIME,
    ranking INT,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_industry_id (industry_id),
    INDEX idx_ranking (ranking)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS news (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT NOT NULL,
    title VARCHAR(500) NOT NULL,
    summary TEXT,
    content TEXT,
    source VARCHAR(200),
    url VARCHAR(500),
    publish_time DATETIME,
    type INT DEFAULT 1,
    status VARCHAR(20) DEFAULT 'PUBLISHED',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_company_id (company_id),
    INDEX idx_publish_time (publish_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS data_task (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    industry_id BIGINT NOT NULL,
    industry_name VARCHAR(100),
    task_type VARCHAR(50),
    status VARCHAR(20),
    progress INT DEFAULT 0,
    error_message TEXT,
    start_time DATETIME,
    end_time DATETIME,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_industry_id (industry_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS graph_node (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    type VARCHAR(50),
    properties JSON,
    industry_id BIGINT,
    status INT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_industry_id (industry_id),
    INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS graph_edge (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    source_node_id BIGINT NOT NULL,
    target_node_id BIGINT NOT NULL,
    relation_type VARCHAR(50),
    properties JSON,
    industry_id BIGINT,
    status INT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_source (source_node_id),
    INDEX idx_target (target_node_id),
    INDEX idx_industry_id (industry_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO sys_user (username, password, real_name, email, status) VALUES 
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '超级管理员', 'admin@smartdata.com', 1);

INSERT INTO sys_role (name, code, description) VALUES 
('超级管理员', 'SUPER_ADMIN', '系统最高权限'),
('普通用户', 'USER', '普通用户权限');

INSERT INTO sys_menu (parent_id, name, type, icon, path, sort_order) VALUES 
(0, '工作台', 'DIR', 'dashboard', '/dashboard', 1),
(0, '知识图谱', 'DIR', 'graph', '/kg', 2),
(0, '系统管理', 'DIR', 'setting', '/system', 3),
(1, '首页', 'MENU', 'home', '/dashboard/index', 1),
(2, '图谱展示', 'MENU', 'graph', '/kg/main', 1),
(2, '实体管理', 'MENU', 'node', '/kg/entities', 2),
(2, '关系管理', 'MENU', 'edge', '/kg/relations', 3),
(2, '行业管理', 'MENU', 'industry', '/kg/industries', 4),
(3, '用户管理', 'MENU', 'user', '/system/users', 1),
(3, '角色管理', 'MENU', 'team', '/system/roles', 2),
(3, '菜单管理', 'MENU', 'menu', '/system/menus', 3);

INSERT INTO kg_industry (name, code, description, sort_order) VALUES 
('人工智能', 'AI', '人工智能相关产业', 1),
('大数据', 'BIG_DATA', '大数据相关产业', 2),
('云计算', 'CLOUD', '云计算相关产业', 3),
('区块链', 'BLOCKCHAIN', '区块链相关产业', 4),
('新能源', 'NEW_ENERGY', '新能源相关产业', 5),
('半导体', 'SEMICONDUCTOR', '半导体相关产业', 6),
('生物医药', 'BIOTECH', '生物医药相关产业', 7),
('智能制造', 'SMART_MFG', '智能制造相关产业', 8);

INSERT INTO sys_user_role (user_id, role_id) VALUES (1, 1);
