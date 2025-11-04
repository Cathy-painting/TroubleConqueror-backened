-- 为普通角色（role_id=2）分配所有错题相关权限
-- 首先需要确保这些权限菜单存在，如果不存在需要先创建

-- 分配错题列表查询权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 2, menu_id FROM sys_menu WHERE perms = 'trouble:question:list'
ON DUPLICATE KEY UPDATE role_id = role_id;

-- 分配错题添加权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 2, menu_id FROM sys_menu WHERE perms = 'trouble:question:add'
ON DUPLICATE KEY UPDATE role_id = role_id;

-- 分配错题查询权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 2, menu_id FROM sys_menu WHERE perms = 'trouble:question:query'
ON DUPLICATE KEY UPDATE role_id = role_id;

-- 分配错题修改权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 2, menu_id FROM sys_menu WHERE perms = 'trouble:question:edit'
ON DUPLICATE KEY UPDATE role_id = role_id;

-- 分配错题删除权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 2, menu_id FROM sys_menu WHERE perms = 'trouble:question:remove'
ON DUPLICATE KEY UPDATE role_id = role_id;

-- 分配错题导出权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 2, menu_id FROM sys_menu WHERE perms = 'trouble:question:export'
ON DUPLICATE KEY UPDATE role_id = role_id;

-- 分配错题回收站权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 2, menu_id FROM sys_menu WHERE perms = 'trouble:trash:list'
ON DUPLICATE KEY UPDATE role_id = role_id;

-- 如果上述菜单不存在，需要先创建菜单。以下是创建菜单的SQL（如果菜单已存在则跳过）
-- 注意：这里假设错题管理菜单的parent_id，需要根据实际情况调整

-- 检查并创建错题管理菜单（如果不存在）
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT 
    2000, '错题管理', 0, 5, 'trouble', NULL, 1, 0, 'M', '0', '0', '', 'education', 'admin', sysdate(), '错题管理目录'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2000);

-- 创建错题列表菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT 
    2001, '错题列表', 2000, 1, 'question', 'trouble/question/index', 1, 0, 'C', '0', '0', 'trouble:question:list', 'list', 'admin', sysdate(), '错题列表菜单'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2001);

-- 创建添加错题菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT 
    2002, '添加错题', 2000, 2, 'question/add', 'trouble/question/add', 1, 0, 'C', '0', '0', 'trouble:question:add', 'edit', 'admin', sysdate(), '添加错题菜单'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2002);

-- 创建错题查询按钮权限
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT 
    2003, '错题查询', 2001, 1, '', '', 1, 0, 'F', '0', '0', 'trouble:question:query', '#', 'admin', sysdate(), ''
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2003);

-- 创建错题修改按钮权限
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT 
    2004, '错题修改', 2001, 2, '', '', 1, 0, 'F', '0', '0', 'trouble:question:edit', '#', 'admin', sysdate(), ''
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2004);

-- 创建错题删除按钮权限
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT 
    2005, '错题删除', 2001, 3, '', '', 1, 0, 'F', '0', '0', 'trouble:question:remove', '#', 'admin', sysdate(), ''
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2005);

-- 创建错题导出按钮权限
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT 
    2006, '错题导出', 2001, 4, '', '', 1, 0, 'F', '0', '0', 'trouble:question:export', '#', 'admin', sysdate(), ''
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2006);

-- 创建错题回收站菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT 
    2007, '错题回收站', 2000, 3, 'trash', 'trouble/trash/index', 1, 0, 'C', '0', '0', 'trouble:trash:list', 'delete', 'admin', sysdate(), '错题回收站菜单'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2007);

-- 现在重新分配所有权限给普通角色
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 2, menu_id FROM sys_menu 
WHERE perms IN ('trouble:question:list', 'trouble:question:add', 'trouble:question:query', 'trouble:question:edit', 'trouble:question:remove', 'trouble:question:export', 'trouble:trash:list')
   OR menu_id IN (2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007)
ON DUPLICATE KEY UPDATE role_id = role_id;

