-- 为错题表添加熟练度字段
-- 如果字段已存在，此脚本会失败，请先检查字段是否存在

-- 检查字段是否存在的语句（MySQL 8.0+可以使用）
-- SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
-- WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'trouble_question' AND COLUMN_NAME = 'proficiency';

-- 添加熟练度字段
ALTER TABLE trouble_question 
ADD COLUMN proficiency INT NOT NULL DEFAULT 0 
COMMENT '熟练度等级（0=陌生，1=一般，2=较好，3=熟练）' 
AFTER importance;

-- 为熟练度字段添加索引（可选，用于提高查询性能）
CREATE INDEX idx_proficiency ON trouble_question(proficiency);

