-- =============================================
-- 智慧数据平台 - 数据预置脚本
-- 创建日期: 2026-05-23
-- 数据库: kg_system
-- =============================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =============================================
-- 1. 插入角色数据
-- =============================================
INSERT INTO `sys_role` (`id`, `name`, `code`, `description`, `status`) VALUES
(1, '超级管理员', 'ADMIN', '系统超级管理员，拥有所有权限', 1),
(2, '数据用户', 'USER', '普通数据用户，可查看知识图谱和行业数据', 1);

-- =============================================
-- 2. 插入用户数据
-- 密码 123456 的 BCrypt 加密值
-- =============================================
INSERT INTO `sys_user` (`id`, `username`, `password`, `nickname`, `email`, `phone`, `status`) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '系统管理员', 'admin@smartdata.com', '13800138000', 1),
(2, 'user', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '数据用户', 'user@smartdata.com', '13800138001', 1);

-- =============================================
-- 3. 插入用户角色关联数据
-- =============================================
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 2);

-- =============================================
-- 4. 插入权限数据
-- =============================================
INSERT INTO `sys_permission` (`id`, `name`, `code`, `type`, `path`, `method`, `status`) VALUES
(1, '用户管理-查询', 'sys:user:query', 'api', '/users', 'GET', 1),
(2, '用户管理-新增', 'sys:user:add', 'api', '/users', 'POST', 1),
(3, '用户管理-编辑', 'sys:user:edit', 'api', '/users', 'PUT', 1),
(4, '用户管理-删除', 'sys:user:delete', 'api', '/users/{id}', 'DELETE', 1),
(5, '角色管理-查询', 'sys:role:query', 'api', '/roles', 'GET', 1),
(6, '角色管理-新增', 'sys:role:add', 'api', '/roles', 'POST', 1),
(7, '角色管理-编辑', 'sys:role:edit', 'api', '/roles', 'PUT', 1),
(8, '角色管理-删除', 'sys:role:delete', 'api', '/roles/{id}', 'DELETE', 1),
(9, '权限管理-查询', 'sys:permission:query', 'api', '/permissions', 'GET', 1),
(10, '权限管理-新增', 'sys:permission:add', 'api', '/permissions', 'POST', 1),
(11, '权限管理-编辑', 'sys:permission:edit', 'api', '/permissions', 'PUT', 1),
(12, '权限管理-删除', 'sys:permission:delete', 'api', '/permissions/{id}', 'DELETE', 1),
(13, '菜单管理-查询', 'sys:menu:query', 'api', '/menus', 'GET', 1),
(14, '菜单管理-新增', 'sys:menu:add', 'api', '/menus', 'POST', 1),
(15, '菜单管理-编辑', 'sys:menu:edit', 'api', '/menus', 'PUT', 1),
(16, '菜单管理-删除', 'sys:menu:delete', 'api', '/menus/{id}', 'DELETE', 1),
(17, '行业管理-查询', 'sys:industry:query', 'api', '/industry', 'GET', 1),
(18, '行业管理-新增', 'sys:industry:add', 'api', '/industry', 'POST', 1),
(19, '行业管理-编辑', 'sys:industry:edit', 'api', '/industry', 'PUT', 1),
(20, '行业管理-删除', 'sys:industry:delete', 'api', '/industry/{id}', 'DELETE', 1),
(21, '知识图谱-查询', 'kg:graph:query', 'api', '/kg/graph', 'GET', 1),
(22, '知识图谱-实体管理', 'kg:entity:manage', 'api', '/kg/entities', '*', 1),
(23, '知识图谱-关系管理', 'kg:relation:manage', 'api', '/kg/relations', '*', 1);

-- =============================================
-- 5. 插入角色权限关联数据
-- =============================================
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES
-- 管理员拥有所有权限
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10),
(1, 11), (1, 12), (1, 13), (1, 14), (1, 15), (1, 16), (1, 17), (1, 18), (1, 19), (1, 20),
(1, 21), (1, 22), (1, 23),
-- 普通用户只拥有查询权限
(2, 1), (2, 5), (2, 9), (2, 13), (2, 17), (2, 21);

-- =============================================
-- 6. 插入菜单数据
-- =============================================
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `path`, `component`, `icon`, `sort`, `type`, `permission`, `visible`) VALUES
-- 一级菜单
(1, 0, '系统首页', '/dashboard', 'Dashboard', 'home', 1, 'menu', NULL, 1),
(2, 0, '系统管理', '/system', NULL, 'setting', 2, 'menu', NULL, 1),
(3, 0, '知识图谱', '/knowledge', NULL, 'share-alt', 3, 'menu', NULL, 1),
-- 二级菜单 - 系统管理
(21, 2, '用户管理', '/system/user', 'User', 'user', 1, 'menu', 'sys:user:query', 1),
(22, 2, '角色管理', '/system/role', 'Role', 'team', 2, 'menu', 'sys:role:query', 1),
(23, 2, '权限管理', '/system/permission', 'Permission', 'safety', 3, 'menu', 'sys:permission:query', 1),
(24, 2, '菜单管理', '/system/menu', 'Menu', 'menu', 4, 'menu', 'sys:menu:query', 1),
(25, 2, '行业管理', '/system/industry', 'Industry', 'appstore', 5, 'menu', 'sys:industry:query', 1),
-- 二级菜单 - 知识图谱
(31, 3, '图谱浏览', '/knowledge/graph', 'Graph', 'apartment', 1, 'menu', 'kg:graph:query', 1),
(32, 3, '实体管理', '/knowledge/entity', 'Entity', 'solution', 2, 'menu', 'kg:entity:manage', 1),
(33, 3, '关系管理', '/knowledge/relation', 'Relation', 'link', 3, 'menu', 'kg:relation:manage', 1);

-- =============================================
-- 7. 插入角色菜单关联数据
-- =============================================
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
-- 管理员拥有所有菜单
(1, 1), (1, 2), (1, 3), (1, 21), (1, 22), (1, 23), (1, 24), (1, 25), (1, 31), (1, 32), (1, 33),
-- 普通用户
(2, 1), (2, 2), (2, 3), (2, 21), (2, 22), (2, 23), (2, 24), (2, 25), (2, 31);

-- =============================================
-- 8. 插入行业数据
-- =============================================
INSERT INTO `sys_industry` (`id`, `parent_id`, `name`, `code`, `description`, `sort`) VALUES
-- 一级行业
(1, 0, '新一代信息技术', 'NEW_IT', '新一代信息技术产业', 1),
(2, 0, '高端装备制造', 'EQUIPMENT', '高端装备制造产业', 2),
(3, 0, '新能源', 'NEW_ENERGY', '新能源产业', 3),
(4, 0, '新材料', 'NEW_MATERIAL', '新材料产业', 4),
(5, 0, '生物医药', 'BIOMED', '生物医药产业', 5),
(6, 0, '节能环保', 'ENVIRONMENT', '节能环保产业', 6),
-- 二级行业 - 新一代信息技术
(101, 1, '人工智能', 'AI', '人工智能领域', 1),
(102, 1, '大数据', 'BIG_DATA', '大数据领域', 2),
(103, 1, '云计算', 'CLOUD', '云计算领域', 3),
(104, 1, '区块链', 'BLOCKCHAIN', '区块链领域', 4),
(105, 1, '5G通信', '5G', '5G通信领域', 5),
-- 二级行业 - 高端装备制造
(201, 2, '工业机器人', 'ROBOT', '工业机器人', 1),
(202, 2, '航空航天', 'AEROSPACE', '航空航天装备', 2),
(203, 2, '轨道交通', 'RAIL', '轨道交通装备', 3),
(204, 2, '智能制造', 'SMART_MFG', '智能制造装备', 4),
-- 二级行业 - 新能源
(301, 3, '太阳能', 'SOLAR', '太阳能产业', 1),
(302, 3, '风能', 'WIND', '风能产业', 2),
(303, 3, '氢能', 'HYDROGEN', '氢能产业', 3),
(304, 3, '储能', 'ENERGY_STORAGE', '储能产业', 4),
(305, 3, '新能源汽车', 'NEW_ENERGY_CAR', '新能源汽车', 5),
-- 二级行业 - 新材料
(401, 4, '先进半导体材料', 'SEMICONDUCTOR', '先进半导体材料', 1),
(402, 4, '新型能源材料', 'ENERGY_MATERIAL', '新型能源材料', 2),
(403, 4, '生物医用材料', 'BIOMATERIAL', '生物医用材料', 3),
(404, 4, '高性能复合材料', 'COMPOSITE', '高性能复合材料', 4),
-- 二级行业 - 生物医药
(501, 5, '生物制药', 'BIO_PHARM', '生物制药', 1),
(502, 5, '化学制药', 'CHEM_PHARM', '化学制药', 2),
(503, 5, '医疗器械', 'MEDICAL_DEVICE', '医疗器械', 3),
(504, 5, '基因检测', 'GENE_TEST', '基因检测', 4),
-- 二级行业 - 节能环保
(601, 6, '节能技术', 'ENERGY_SAVING', '节能技术', 1),
(602, 6, '环保材料', 'ENV_MATERIAL', '环保材料', 2),
(603, 6, '污染治理', 'POLLUTION', '污染治理', 3),
(604, 6, '资源循环利用', 'RECYCLE', '资源循环利用', 4);

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- 数据预置完成
-- 默认账号: admin / 123456
-- =============================================
