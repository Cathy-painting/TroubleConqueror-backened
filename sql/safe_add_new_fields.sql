-- 安全添加新字段到 trouble_question 表（检查字段是否存在）

-- 检查并添加 question_source 字段
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM information_schema.columns 
WHERE table_schema = DATABASE() 
  AND table_name = 'trouble_question' 
  AND column_name = 'question_source';

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE trouble_question ADD COLUMN question_source VARCHAR(50) DEFAULT NULL COMMENT ''错题来源'' AFTER importance', 
    'SELECT ''Column question_source already exists'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查并添加 grade 字段
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM information_schema.columns 
WHERE table_schema = DATABASE() 
  AND table_name = 'trouble_question' 
  AND column_name = 'grade';

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE trouble_question ADD COLUMN grade VARCHAR(20) DEFAULT NULL COMMENT ''年级'' AFTER question_source', 
    'SELECT ''Column grade already exists'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查并添加 error_type 字段
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM information_schema.columns 
WHERE table_schema = DATABASE() 
  AND table_name = 'trouble_question' 
  AND column_name = 'error_type';

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE trouble_question ADD COLUMN error_type VARCHAR(50) DEFAULT NULL COMMENT ''错误类型'' AFTER grade', 
    'SELECT ''Column error_type already exists'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查并添加 difficulty 字段
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM information_schema.columns 
WHERE table_schema = DATABASE() 
  AND table_name = 'trouble_question' 
  AND column_name = 'difficulty';

SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE trouble_question ADD COLUMN difficulty INT(1) DEFAULT 2 COMMENT ''难度等级（1=简单，2=中等，3=困难）'' AFTER error_type', 
    'SELECT ''Column difficulty already exists'' as message');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
