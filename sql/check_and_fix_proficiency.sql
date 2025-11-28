-- 检查并修复 proficiency 字段问题的安全脚本

-- 步骤1: 检查当前表结构
SHOW CREATE TABLE trouble_question;

-- 步骤2: 检查 proficiency 字段的详细信息
SELECT 
    COLUMN_NAME,
    ORDINAL_POSITION,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE() 
  AND TABLE_NAME = 'trouble_question'
ORDER BY ORDINAL_POSITION;

-- 步骤3: 安全地检查并添加缺失的字段（如果 proficiency 不存在）
DELIMITER //

CREATE PROCEDURE SafeAddProficiencyField()
BEGIN
    DECLARE col_count INT DEFAULT 0;
    
    -- 检查 proficiency 字段是否存在
    SELECT COUNT(*) INTO col_count
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
      AND TABLE_NAME = 'trouble_question' 
      AND COLUMN_NAME = 'proficiency';
    
    IF col_count = 0 THEN
        -- 字段不存在，安全添加
        ALTER TABLE trouble_question 
        ADD COLUMN proficiency TINYINT DEFAULT 0 
        COMMENT '熟练度（0-陌生，1-一般，2-较好，3-熟练）' 
        AFTER importance;
        
        SELECT 'proficiency 字段已成功添加' as result;
    ELSE
        SELECT 'proficiency 字段已存在，无需添加' as result;
    END IF;
END//

DELIMITER ;

-- 执行安全添加过程
CALL SafeAddProficiencyField();

-- 清理存储过程
DROP PROCEDURE SafeAddProficiencyField;

-- 步骤4: 验证最终表结构
DESCRIBE trouble_question;
