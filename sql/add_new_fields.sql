-- 添加新字段到 trouble_question 表
-- 方式1: 如果表中已有 proficiency 字段，使用此语句
-- ALTER TABLE trouble_question 
-- ADD COLUMN question_source VARCHAR(50) COMMENT '错题来源' AFTER proficiency,
-- ADD COLUMN grade VARCHAR(20) COMMENT '年级' AFTER question_source,
-- ADD COLUMN error_type VARCHAR(50) COMMENT '错误类型' AFTER grade,
-- ADD COLUMN difficulty INT(1) DEFAULT 2 COMMENT '难度等级（1=简单，2=中等，3=困难）' AFTER error_type;

-- 方式2: 如果表中没有 proficiency 字段，使用此语句（在 importance 字段之后添加）
ALTER TABLE trouble_question 
ADD COLUMN question_source VARCHAR(50) COMMENT '错题来源' AFTER importance,
ADD COLUMN grade VARCHAR(20) COMMENT '年级' AFTER question_source,
ADD COLUMN error_type VARCHAR(50) COMMENT '错误类型' AFTER grade,
ADD COLUMN difficulty INT(1) DEFAULT 2 COMMENT '难度等级（1=简单，2=中等，3=困难）' AFTER error_type;
