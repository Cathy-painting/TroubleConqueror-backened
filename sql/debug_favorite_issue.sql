-- 调试收藏功能问题的SQL脚本

-- 1. 检查错题表是否存在数据
SELECT COUNT(*) as '错题总数' FROM trouble_question;

-- 2. 检查收藏表是否存在
SHOW TABLES LIKE 'trouble_question_favorite';

-- 3. 检查收藏表结构
DESCRIBE trouble_question_favorite;

-- 4. 检查收藏表数据
SELECT COUNT(*) as '收藏总数' FROM trouble_question_favorite;

-- 5. 检查错题表中的用户ID分布
SELECT user_id, COUNT(*) as '错题数量' 
FROM trouble_question 
GROUP BY user_id;

-- 6. 检查收藏表中的用户ID分布
SELECT user_id, COUNT(*) as '收藏数量' 
FROM trouble_question_favorite 
GROUP BY user_id;

-- 7. 检查是否有孤立的收藏记录（收藏的错题不存在）
SELECT tqf.favorite_id, tqf.question_id, tqf.user_id
FROM trouble_question_favorite tqf
LEFT JOIN trouble_question tq ON tqf.question_id = tq.question_id
WHERE tq.question_id IS NULL;

-- 8. 查看最近添加的错题
SELECT question_id, user_id, question_content, create_time
FROM trouble_question 
ORDER BY create_time DESC 
LIMIT 5;

-- 9. 查看最近的收藏记录
SELECT favorite_id, question_id, user_id, create_time
FROM trouble_question_favorite 
ORDER BY create_time DESC 
LIMIT 5;

-- 10. 检查特定用户的错题和收藏情况（请替换 YOUR_USER_ID 为实际用户ID）
-- SELECT 
--     tq.question_id,
--     tq.question_content,
--     tq.create_time as '错题创建时间',
--     tqf.favorite_id,
--     tqf.create_time as '收藏时间'
-- FROM trouble_question tq
-- LEFT JOIN trouble_question_favorite tqf ON tq.question_id = tqf.question_id AND tqf.user_id = tq.user_id
-- WHERE tq.user_id = YOUR_USER_ID
-- ORDER BY tq.create_time DESC;
