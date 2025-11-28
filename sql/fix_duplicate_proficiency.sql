-- 修复 proficiency 字段重复问题
-- 此脚本会检查并修复可能的重复列问题

-- 1. 检查当前表结构
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_COMMENT 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'trouble_question' 
  AND COLUMN_NAME = 'proficiency'
ORDER BY ORDINAL_POSITION;

-- 2. 如果发现重复的 proficiency 字段，需要手动处理
-- 通常情况下，MySQL不会允许重复列名，所以这个错误可能是由于：
-- a) 执行了多次 ALTER TABLE ADD COLUMN 语句
-- b) 表结构不一致

-- 3. 安全的解决方案：重建表（如果需要）
-- 注意：执行前请备份数据！

-- 创建临时表用于数据迁移（如果需要）
/*
CREATE TABLE trouble_question_backup AS 
SELECT * FROM trouble_question;

-- 删除原表
DROP TABLE trouble_question;

-- 重新创建表（使用正确的结构）
CREATE TABLE `trouble_question` (
  `question_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '错题ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID',
  `question_content` TEXT NOT NULL COMMENT '题目内容',
  `question_images` VARCHAR(1000) DEFAULT NULL COMMENT '题目图片路径，逗号分隔',
  `answer_content` TEXT DEFAULT NULL COMMENT '答案内容',
  `answer_images` VARCHAR(1000) DEFAULT NULL COMMENT '答案图片路径，逗号分隔',
  `question_type` VARCHAR(50) DEFAULT NULL COMMENT '题目类型',
  `tags` VARCHAR(255) DEFAULT NULL COMMENT '标签，逗号分隔',
  `status` VARCHAR(20) DEFAULT '正常' COMMENT '题目状态',
  `proficiency` TINYINT DEFAULT 0 COMMENT '熟练度（0-陌生，1-一般，2-较好，3-熟练）',
  `importance` TINYINT DEFAULT 1 COMMENT '重要程度（1-5星）',
  `question_source` VARCHAR(50) DEFAULT NULL COMMENT '错题来源',
  `grade` VARCHAR(20) DEFAULT NULL COMMENT '年级',
  `error_type` VARCHAR(50) DEFAULT NULL COMMENT '错误类型',
  `difficulty` INT(1) DEFAULT 2 COMMENT '难度等级（1=简单，2=中等，3=困难）',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `create_by` VARCHAR(50) DEFAULT NULL COMMENT '创建人',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` VARCHAR(50) DEFAULT NULL COMMENT '更新人',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `del_flag` CHAR(1) DEFAULT '0' COMMENT '删除标记（0-正常，1-删除）',
  PRIMARY KEY (`question_id`),
  KEY `idx_question_type` (`question_type`),
  KEY `idx_tags` (`tags`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_proficiency` (`proficiency`),
  KEY `idx_importance` (`importance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='错题表';

-- 恢复数据
INSERT INTO trouble_question SELECT * FROM trouble_question_backup;

-- 删除备份表
DROP TABLE trouble_question_backup;
*/
