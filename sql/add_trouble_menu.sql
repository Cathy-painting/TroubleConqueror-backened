-- 添加错题管理菜单
-- 请在MySQL中执行此脚本

-- 1. 添加错题管理顶级菜单（假设菜单ID从2000开始）
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2000, '错题管理', 0, 4, 'trouble', NULL, 1, 0, 'M', '0', '0', '', 'education', 'admin', NOW(), '', NULL, '错题管理目录');

-- 2. 添加错题列表菜单
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2001, '错题列表', 2000, 1, 'question', 'trouble/question/index', 1, 0, 'C', '0', '0', 'trouble:question:list', 'list', 'admin', NOW(), '', NULL, '错题列表菜单');

-- 3. 添加添加错题菜单
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2002, '添加错题', 2000, 2, 'question/add', 'trouble/question/add', 1, 0, 'C', '0', '0', 'trouble:question:add', 'edit', 'admin', NOW(), '', NULL, '添加错题菜单');

-- 4. 添加产品首页菜单
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2003, '产品首页', 2000, 3, 'test', 'trouble/test', 1, 0, 'C', '0', '0', '', 'dashboard', 'admin', NOW(), '', NULL, '产品首页菜单');

-- 5. 添加错题回收站菜单
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2004, '错题回收站', 2000, 4, 'trash', 'trouble/trash/index', 1, 0, 'C', '0', '0', 'trouble:trash:list', 'delete', 'admin', NOW(), '', NULL, '错题回收站菜单');

-- 6. 添加错题查询按钮权限
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2011, '错题查询', 2001, 1, '#', '', 1, 0, 'F', '0', '0', 'trouble:question:query', '#', 'admin', NOW(), '', NULL, '');

-- 7. 添加错题新增按钮权限
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2012, '错题新增', 2001, 2, '#', '', 1, 0, 'F', '0', '0', 'trouble:question:add', '#', 'admin', NOW(), '', NULL, '');

-- 8. 添加错题修改按钮权限
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2013, '错题修改', 2001, 3, '#', '', 1, 0, 'F', '0', '0', 'trouble:question:edit', '#', 'admin', NOW(), '', NULL, '');

-- 9. 添加错题删除按钮权限
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2014, '错题删除', 2001, 4, '#', '', 1, 0, 'F', '0', '0', 'trouble:question:remove', '#', 'admin', NOW(), '', NULL, '');

-- 10. 添加错题导出按钮权限
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2015, '错题导出', 2001, 5, '#', '', 1, 0, 'F', '0', '0', 'trouble:question:export', '#', 'admin', NOW(), '', NULL, '');

-- 11. 添加回收站查询按钮权限
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2021, '回收站查询', 2004, 1, '#', '', 1, 0, 'F', '0', '0', 'trouble:trash:query', '#', 'admin', NOW(), '', NULL, '');

-- 12. 添加回收站恢复按钮权限
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2022, '回收站恢复', 2004, 2, '#', '', 1, 0, 'F', '0', '0', 'trouble:trash:restore', '#', 'admin', NOW(), '', NULL, '');

-- 13. 添加回收站删除按钮权限
INSERT INTO sys_menu(menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2023, '回收站删除', 2004, 3, '#', '', 1, 0, 'F', '0', '0', 'trouble:trash:remove', '#', 'admin', NOW(), '', NULL, '');

COMMIT;

