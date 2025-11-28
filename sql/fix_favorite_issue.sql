-- 修复收藏功能问题的SQL脚本

-- 1. 确保收藏表存在且结构正确
CREATE TABLE IF NOT EXISTS `trouble_question_favorite` (
  `favorite_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `question_id` BIGINT(20) NOT NULL COMMENT '错题ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `uk_user_question` (`user_id`, `question_id`),
  KEY `idx_question_id` (`question_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_favorite_question` FOREIGN KEY (`question_id`) REFERENCES `trouble_question` (`question_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='错题收藏表';

-- 2. 检查并修复错题表中可能缺失的字段
-- 确保 proficiency 字段存在且正确
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM information_schema.columns 
WHERE table_schema = DATABASE() 
  AND table_name = 'trouble_question' 
  AND column_name = 'proficiency';

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE trouble_question ADD COLUMN proficiency TINYINT DEFAULT 0 COMMENT ''熟练度（0-陌生，1-一般，2-较好，3-熟练）'' AFTER importance', 
    'SELECT ''proficiency字段已存在'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3. 确保错题表有正确的索引
CREATE INDEX IF NOT EXISTS idx_user_id ON trouble_question(user_id);
CREATE INDEX IF NOT EXISTS idx_create_time ON trouble_question(create_time);

-- 4. 清理可能存在的孤立收藏记录
DELETE tqf FROM trouble_question_favorite tqf
LEFT JOIN trouble_question tq ON tqf.question_id = tq.question_id
WHERE tq.question_id IS NULL;

-- 5. 验证修复结果
SELECT 
    '错题表记录数' as '检查项',
    COUNT(*) as '数量'
FROM trouble_question
UNION ALL
SELECT 
    '收藏表记录数' as '检查项',
    COUNT(*) as '数量'
FROM trouble_question_favorite
UNION ALL
SELECT 
    '有效收藏记录数' as '检查项',
    COUNT(*) as '数量'
FROM trouble_question_favorite tqf
INNER JOIN trouble_question tq ON tqf.question_id = tq.question_id;
