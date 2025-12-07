USE `ry-vue`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 开启事务
START TRANSACTION;

-- =================================================================================
-- 第一阶段：双图题目 (20题: 题目图 + 答案图)
-- 时间段：分散在 11-15 到 12-05 之间，包含部分高峰日数据
-- =================================================================================

-- 1. [2025-11-20 高峰] 物理 - 力学 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '如图所示，物体A在斜面上静止，求受力分析。', 'https://img.makis-life.cn/troubleConqueror/12.png', '受重力、支持力、静摩擦力', 'https://img.makis-life.cn/troubleConqueror/13.png', '解答题', '力学,受力分析', '正常', 0, 3, '真题', '高中一年级', '基础薄弱', 3, '摩擦力方向判断错误', '2025-11-20 09:15:33', '2025-11-20 09:15:33');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 0, 3, '2025-11-20 09:16:00');

-- 2. [2025-11-20 高峰] 数学 - 导数 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '求函数 f(x) = x * e^x 的极值点。', 'https://img.makis-life.cn/troubleConqueror/5.png', '求导得 f\'(x)=(x+1)e^x, 极值点 x=-1', 'https://img.makis-life.cn/troubleConqueror/6.png', '解答题', '导数', '正常', 1, 3, '周测/月考', '高中三年级', '粗心失误', 2, NULL, '2025-11-20 10:45:12', '2025-11-20 10:45:12');

-- 3. [2025-11-20 高峰] 英语 - 阅读 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, 'What is the main idea of the second paragraph?', 'https://img.makis-life.cn/troubleConqueror/22.png', 'The impact of technology on education.', 'https://img.makis-life.cn/troubleConqueror/23.png', '选择题', '阅读理解', '正常', 2, 2, '模拟考试', '高中二年级', '基础薄弱', 2, '长难句没看懂', '2025-11-20 14:20:01', '2025-11-20 14:20:01');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 2, 2, '2025-11-20 14:21:05');

-- 4. [2025-11-20 高峰] 化学 - 氧化还原 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '配平反应：KMnO4 + HCl -> ...', 'https://img.makis-life.cn/troubleConqueror/8.png', '2KMnO4 + 16HCl = 2KCl + 2MnCl2 + 5Cl2 + 8H2O', 'https://img.makis-life.cn/troubleConqueror/9.png', '填空题', '化学方程', '正常', 1, 2, '课后作业', '高中一年级', '粗心失误', 2, NULL, '2025-11-20 19:33:55', '2025-11-20 19:33:55');

-- 5. [2025-11-15] 几何 - 相似 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '证明三角形ABC相似于三角形PQR。', 'https://img.makis-life.cn/troubleConqueror/15.png', '三边对应成比例', 'https://img.makis-life.cn/troubleConqueror/16.png', '解答题', '平面几何', '正常', 0, 3, '期中/期末考试', '初中三年级', '基础薄弱', 2, NULL, '2025-11-15 21:10:44', '2025-11-15 21:10:44');

-- 6. [2025-11-16] 生物 - 遗传 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '该系谱图中的遗传方式是？', 'https://img.makis-life.cn/troubleConqueror/28.png', '伴X隐性遗传', 'https://img.makis-life.cn/troubleConqueror/29.png', '选择题', '遗传学', '正常', 2, 2, '单元测试', '高中二年级', '粗心失误', 2, NULL, '2025-11-16 22:05:18', '2025-11-16 22:05:18');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 2, 2, '2025-11-16 22:06:00');

-- 7. [2025-11-16] 语文 - 古诗 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '赏析“大漠孤烟直”的意境。', 'https://img.makis-life.cn/troubleConqueror/2.png', '描绘了边塞奇特壮丽的风光...', 'https://img.makis-life.cn/troubleConqueror/3.png', '解答题', '古诗鉴赏', '正常', 1, 1, '课堂练习', '初中二年级', '基础薄弱', 1, NULL, '2025-11-16 16:12:33', '2025-11-16 16:12:33');

-- 8. [2025-11-17] 物理 - 电路 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '求图中R2消耗的功率。', 'https://img.makis-life.cn/troubleConqueror/19.png', 'P = I^2 * R = ...', 'https://img.makis-life.cn/troubleConqueror/20.png', '填空题', '电功率', '正常', 3, 2, '竞赛类', '初中三年级', '粗心失误', 2, '计算错误', '2025-11-17 17:45:22', '2025-11-17 17:45:22');

-- 9. [2025-11-19] 数学 - 三角 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '化简 cos(2x) - sin^2(x)', 'https://img.makis-life.cn/troubleConqueror/10.png', 'cos^2(x) - 2sin^2(x)...', 'https://img.makis-life.cn/troubleConqueror/11.png', '填空题', '三角恒等变换', '正常', 1, 2, '教辅资料', '高中一年级', '基础薄弱', 2, NULL, '2025-11-19 13:22:11', '2025-11-19 13:22:11');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 1, 2, '2025-11-19 13:25:00');

-- 10. [2025-11-21] 历史 - 近代史 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '图中的报刊宣传了什么思想？', 'https://img.makis-life.cn/troubleConqueror/1.png', '维新变法思想', 'https://img.makis-life.cn/troubleConqueror/2.png', '选择题', '近代史', '正常', 3, 1, '课堂练习', '初中二年级', '粗心失误', 1, NULL, '2025-11-21 15:55:00', '2025-11-21 15:55:00');

-- 11. [2025-11-22] 地理 - 等高线 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '图中A处的地形名称是？', 'https://img.makis-life.cn/troubleConqueror/25.png', '鞍部', 'https://img.makis-life.cn/troubleConqueror/26.png', '选择题', '地图', '正常', 0, 2, '期中/期末考试', '高中一年级', '基础薄弱', 2, '没看清等高线数值', '2025-11-22 08:30:15', '2025-11-22 08:30:15');

-- 12. [2025-11-23] 数学 - 数列 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '求该递推数列的通项公式。', 'https://img.makis-life.cn/troubleConqueror/7.png', 'an = 2^n - 1', 'https://img.makis-life.cn/troubleConqueror/8.png', '解答题', '数列', '正常', 2, 3, '周测/月考', '高中二年级', '粗心失误', 2, NULL, '2025-11-23 20:11:09', '2025-11-23 20:11:09');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 2, 3, '2025-11-23 20:12:00');

-- 13. [2025-11-24] 政治 - 经济 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '图表反映了什么经济现象？', 'https://img.makis-life.cn/troubleConqueror/4.png', '居民消费水平提高', 'https://img.makis-life.cn/troubleConqueror/5.png', '选择题', '经济生活', '正常', 1, 1, '课堂练习', '高中一年级', '基础薄弱', 1, NULL, '2025-11-24 11:11:11', '2025-11-24 11:11:11');

-- 14. [2025-11-26] 物理 - 天体 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '计算第一宇宙速度。', 'https://img.makis-life.cn/troubleConqueror/14.png', 'v = sqrt(GM/R)', 'https://img.makis-life.cn/troubleConqueror/15.png', '填空题', '天体运动', '正常', 1, 3, '真题', '高中一年级', '粗心失误', 2, NULL, '2025-11-26 19:22:33', '2025-11-26 19:22:33');

-- 15. [2025-11-27] 英语 - 完形 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, 'Section A: Cloze Test Question 41.', 'https://img.makis-life.cn/troubleConqueror/21.png', 'D. consequently', 'https://img.makis-life.cn/troubleConqueror/22.png', '选择题', NULL, '正常', 0, 2, '模拟考试', '高中三年级', '基础薄弱', 2, NULL, '2025-11-27 23:45:00', '2025-11-27 23:45:00');

-- 16. [2025-11-28] 化学 - 有机 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '写出该有机物的结构简式。', 'https://img.makis-life.cn/troubleConqueror/17.png', 'CH3-CH=CH-COOH', 'https://img.makis-life.cn/troubleConqueror/18.png', '其他', '有机化学', '正常', 0, 3, '竞赛类', '高中二年级', '基础薄弱', 3, '官能团写错了', '2025-11-28 10:10:10', '2025-11-28 10:10:10');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 0, 3, '2025-11-28 10:11:00');

-- 17. [2025-11-29] 数学 - 排列组合 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '将5本不同的书分给3个人，求分配方案。', 'https://img.makis-life.cn/troubleConqueror/3.png', '3^5 = 243', 'https://img.makis-life.cn/troubleConqueror/4.png', '填空题', '排列组合', '正常', 3, 1, '课后作业', '高中二年级', '粗心失误', 1, NULL, '2025-11-29 14:14:14', '2025-11-29 14:14:14');

-- 18. [2025-12-01] 物理 - 动量 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '碰撞后小球的速度是多少？', 'https://img.makis-life.cn/troubleConqueror/9.png', 'v = (m1v1+m2v2)/(m1+m2)', 'https://img.makis-life.cn/troubleConqueror/10.png', '解答题', '动量', '正常', 1, 3, '单元测试', '高中二年级', '基础薄弱', 2, NULL, '2025-12-01 16:16:16', '2025-12-01 16:16:16');

-- 19. [2025-12-05 高峰] 语文 - 病句 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '下列哪个句子没有语病？', 'https://img.makis-life.cn/troubleConqueror/11.png', 'C', 'https://img.makis-life.cn/troubleConqueror/12.png', '选择题', '病句辨析', '正常', 2, 2, '真题', '初中三年级', '粗心失误', 2, NULL, '2025-12-05 18:18:18', '2025-12-05 18:18:18');

-- 20. [2025-12-05 高峰] 英语 - 翻译 (双图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, 'Translate the sentence in the picture.', 'https://img.makis-life.cn/troubleConqueror/29.png', '熟能生巧。', 'https://img.makis-life.cn/troubleConqueror/30.png', '其他', '翻译', '正常', 3, 1, '课堂练习', '初中一年级', '粗心失误', 1, NULL, '2025-12-05 20:20:20', '2025-12-05 20:20:20');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 3, 1, '2025-12-05 20:21:00');


-- =================================================================================
-- 第二阶段：单图题目 (15题: 仅题目图)
-- 时间段：重点填充 12-05 高峰日，其余分散
-- =================================================================================

-- 21. [2025-12-05 高峰] 数学 - 圆锥曲线 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '求双曲线的渐近线方程。', 'https://img.makis-life.cn/troubleConqueror/13.png', 'y = ±(b/a)x', NULL, '解答题', '圆锥曲线', '正常', 0, 3, '模拟考试', '高中二年级', '基础薄弱', 3, '记错公式', '2025-12-05 08:05:01', '2025-12-05 08:05:01');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 0, 3, '2025-12-05 08:06:00');

-- 22. [2025-12-05 高峰] 物理 - 磁场 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '带电粒子在磁场中的运动轨迹判断。', 'https://img.makis-life.cn/troubleConqueror/14.png', '向下偏转', NULL, '选择题', '磁场', '正常', 1, 2, '课后作业', '高中二年级', '粗心失误', 2, NULL, '2025-12-05 09:30:45', '2025-12-05 09:30:45');

-- 23. [2025-12-05 高峰] 化学 - 电解池 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '阴极产物是什么？', 'https://img.makis-life.cn/troubleConqueror/16.png', '铜', NULL, '填空题', '电化学', '正常', 0, 3, '周测/月考', '高中二年级', '基础薄弱', 3, NULL, '2025-12-05 13:12:12', '2025-12-05 13:12:12');

-- 24. [2025-12-05 高峰] 语文 - 文言文 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '翻译划线句子。', 'https://img.makis-life.cn/troubleConqueror/18.png', '如果不学习，就无法增长才干。', NULL, '解答题', '文言翻译', '正常', 2, 2, '真题', '高中三年级', '粗心失误', 2, NULL, '2025-12-05 16:45:33', '2025-12-05 16:45:33');

-- 25. [2025-11-20 高峰] 英语 - 作文 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, 'Write a letter based on the picture.', 'https://img.makis-life.cn/troubleConqueror/20.png', 'Dear Sir/Madam...', NULL, '其他', '写作', '正常', 1, 2, '模考', '高中三年级', '基础薄弱', 2, '格式错误', '2025-11-20 20:05:00', '2025-11-20 20:05:00');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 1, 2, '2025-11-20 20:06:00');

-- 26. [2025-11-20 高峰] 生物 - 光合 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '图示过程代表什么反应？', 'https://img.makis-life.cn/troubleConqueror/24.png', '暗反应（卡尔文循环）', NULL, '填空题', '代谢', '正常', 2, 1, '教辅资料', '高中一年级', '粗心失误', 1, NULL, '2025-11-20 22:55:55', '2025-11-20 22:55:55');

-- 27. [2025-12-03] 数学 - 立体几何 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '求点P到平面ABC的距离。', 'https://img.makis-life.cn/troubleConqueror/26.png', 'sqrt(2)', NULL, '解答题', '立体几何', '正常', 0, 3, '课后作业', '高中二年级', '基础薄弱', 3, NULL, '2025-12-03 11:11:11', '2025-12-03 11:11:11');

-- 28. [2025-12-04] 历史 - 古代史 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '图中文物出土于哪里？', 'https://img.makis-life.cn/troubleConqueror/27.png', '三星堆遗址', NULL, '选择题', '古代史', '正常', 3, 1, '单元测试', '初中一年级', '粗心失误', 1, NULL, '2025-12-04 09:09:09', '2025-12-04 09:09:09');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 3, 1, '2025-12-04 09:10:00');

-- 29. [2025-12-06] 物理 - 传送带 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '求物体到达顶端的速度。', 'https://img.makis-life.cn/troubleConqueror/30.png', '2 m/s', NULL, '解答题', '力学', '正常', 1, 2, '周测/月考', '高中一年级', '基础薄弱', 2, NULL, '2025-12-06 14:24:24', '2025-12-06 14:24:24');

-- 30. [2025-12-07] 化学 - 实验 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '指出图中的错误操作。', 'https://img.makis-life.cn/troubleConqueror/2.png', '视线未与凹液面最低处相平', NULL, '选择题', '化学实验', '正常', 2, 2, '真题', '高中三年级', '粗心失误', 2, NULL, '2025-12-07 15:33:44', '2025-12-07 15:33:44');

-- 31. [2025-12-08] 地理 - 气候 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '判断该气候类型。', 'https://img.makis-life.cn/troubleConqueror/6.png', '地中海气候', NULL, '解答题', '自然地理', '正常', 1, 2, '课堂练习', '高中一年级', '基础薄弱', 2, NULL, '2025-12-08 18:00:00', '2025-12-08 18:00:00');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 1, 2, '2025-12-08 18:01:00');

-- 32. [2025-12-09] 数学 - 平面几何 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '求扇形面积。', 'https://img.makis-life.cn/troubleConqueror/8.png', 'S = 0.5 * l * r', NULL, '填空题', '几何', '正常', 3, 1, '教辅资料', '小学六年级', '粗心失误', 1, NULL, '2025-12-09 21:21:21', '2025-12-09 21:21:21');

-- 33. [2025-12-10] 英语 - 情感分析 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, 'How does the man feel according to the picture?', 'https://img.makis-life.cn/troubleConqueror/12.png', 'Frustrated', NULL, '选择题', '听力/口语', '正常', 0, 3, '模拟考试', '高中三年级', '基础薄弱', 3, NULL, '2025-12-10 12:12:12', '2025-12-10 12:12:12');

-- 34. [2025-12-11] 物理 - 波 (单图)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '求波长。', 'https://img.makis-life.cn/troubleConqueror/22.png', '4m', NULL, '选择题', '机械波', '正常', 1, 2, '单元测试', '高中二年级', '粗心失误', 2, NULL, '2025-12-11 17:17:17', '2025-12-11 17:17:17');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 1, 2, '2025-12-11 17:18:00');

-- 35. [2025-11-15] 化学 - 鉴别 (单图，循环回头部填空隙)
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '如图，哪瓶是蒸馏水？', 'https://img.makis-life.cn/troubleConqueror/25.png', 'A瓶（无杂质）', NULL, '其他', '物质鉴别', '正常', 2, 1, '竞赛类', '初中三年级', '基础薄弱', 1, NULL, '2025-11-15 11:11:11', '2025-11-15 11:11:11');


-- =================================================================================
-- 第三阶段：无图题目 (15题: 纯文本)
-- 时间段：随机散落，避开空白日 (11-18, 11-25, 12-02)
-- =================================================================================

-- 36. [2025-11-16] 数学
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '已知 tanA=2, 求 tan(2A)。', NULL, '-4/3', NULL, '填空题', '三角函数', '正常', 3, 1, '课堂练习', '高中一年级', '粗心失误', 1, '公式记反了', '2025-11-16 19:19:19', '2025-11-16 19:19:19');

-- 37. [2025-11-17] 英语
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, 'She looks forward to _____ you.', NULL, 'seeing', NULL, '填空题', '语法', '正常', 2, 1, '课后作业', '初中二年级', '基础薄弱', 1, NULL, '2025-11-17 21:21:21', '2025-11-17 21:21:21');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 2, 1, '2025-11-17 21:22:00');

-- 38. [2025-11-19] 语文
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '“天生我材必有用”的作者是？', NULL, '李白', NULL, '填空题', '常识', '正常', 1, 2, '晨读检测', '小学六年级', '粗心失误', 2, NULL, '2025-11-19 07:30:00', '2025-11-19 07:30:00');

-- 39. [2025-11-21] 历史
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '美国独立战争开始的标志是？', NULL, '列克星顿的枪声', NULL, '选择题', NULL, '正常', 3, 1, '模拟考试', '初中三年级', '粗心失误', 1, NULL, '2025-11-21 16:16:16', '2025-11-21 16:16:16');

-- 40. [2025-11-22] 政治
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '哲学的基本问题是？', NULL, '思维和存在的关系问题', NULL, '选择题', '哲学', '正常', 1, 2, '期中/期末考试', '高中二年级', '基础薄弱', 2, NULL, '2025-11-22 13:45:00', '2025-11-22 13:45:00');

-- 41. [2025-11-23] 数学
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '求函数 y=x^2 在 [0,2] 上的最大值。', NULL, '4', NULL, '选择题', '函数', '正常', 3, 1, '课堂练习', '高中一年级', '粗心失误', 1, NULL, '2025-11-23 10:20:30', '2025-11-23 10:20:30');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 3, 1, '2025-11-23 10:21:00');

-- 42. [2025-11-24] 物理
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '加速度的单位是？', NULL, 'm/s^2', NULL, '填空题', '力学基础', '正常', 2, 1, '教辅资料', '初中二年级', '粗心失误', 1, NULL, '2025-11-24 09:05:00', '2025-11-24 09:05:00');

-- 43. [2025-11-26] 化学
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '钠燃烧的火焰颜色？', NULL, '黄色', NULL, '选择题', '金属', '正常', 3, 1, '课堂练习', '高中一年级', '粗心失误', 1, NULL, '2025-11-26 11:11:11', '2025-11-26 11:11:11');

-- 44. [2025-11-29] 生物
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, 'DNA分子的基本骨架由什么构成？', NULL, '磷酸和脱氧核糖', NULL, '填空题', '分子遗传', '正常', 2, 2, '单元测试', '高中二年级', '基础薄弱', 2, NULL, '2025-11-29 15:15:15', '2025-11-29 15:15:15');

-- 45. [2025-11-30] 英语
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, 'It\'s no use _____ over spilt milk.', NULL, 'crying', NULL, '选择题', '谚语', '正常', 1, 2, '竞赛类', '高中二年级', '基础薄弱', 2, NULL, '2025-11-30 22:22:22', '2025-11-30 22:22:22');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 1, 2, '2025-11-30 22:23:00');

-- 46. [2025-12-04] 数学
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '向量 a=(1,2), b=(2,x), a//b, 求x。', NULL, '4', NULL, '填空题', '平面向量', '正常', 2, 1, '周测/月考', '高中一年级', '粗心失误', 1, NULL, '2025-12-04 08:08:08', '2025-12-04 08:08:08');

-- 47. [2025-12-08] 语文
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '“四书五经”中的“四书”指？', NULL, '大学、中庸、论语、孟子', NULL, '常识题', '文学常识', '正常', 3, 1, '课堂练习', '初中二年级', '粗心失误', 1, NULL, '2025-12-08 12:30:30', '2025-12-08 12:30:30');

-- 48. [2025-12-09] 地理
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '地球自转的方向？', NULL, '自西向东', NULL, '选择题', '地球运动', '正常', 2, 1, '教辅资料', '初中一年级', '基础薄弱', 1, NULL, '2025-12-09 19:19:00', '2025-12-09 19:19:00');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time) VALUES (LAST_INSERT_ID(), 100, 2, 1, '2025-12-09 19:20:00');

-- 49. [2025-12-10] 历史
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '新中国成立的时间？', NULL, '1949年10月1日', NULL, '填空题', '现代史', '正常', 3, 1, '真题', '初中二年级', '粗心失误', 1, NULL, '2025-12-10 21:05:05', '2025-12-10 21:05:05');

-- 50. [2025-12-11] 心理
INSERT INTO trouble_question (user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_time, update_time) 
VALUES (100, '遇到学习瓶颈怎么办？', NULL, '调整心态，寻求帮助', NULL, '其他', '心理', '正常', 3, 1, '其他', '高中三年级', '基础薄弱', 1, NULL, '2025-12-11 10:00:00', '2025-12-11 10:00:00');
-- 加入收藏
INSERT INTO trouble_question_favorite (question_id, user_id, proficiency, importance, create_time)
VALUES (LAST_INSERT_ID(), 100, 3, 1, '2025-12-11 10:02:00');

COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
