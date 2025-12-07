-- 创建 trouble_question 表
CREATE TABLE `trouble_question` (
  `question_id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `question_content` TEXT NOT NULL,
  `question_images` VARCHAR(1000) DEFAULT NULL,
  `answer_content` TEXT DEFAULT NULL,
  `answer_images` VARCHAR(1000) DEFAULT NULL,
  `question_type` VARCHAR(50) DEFAULT NULL,
  `tags` VARCHAR(255) DEFAULT NULL,
  `status` VARCHAR(20) DEFAULT '正常',
  `proficiency` TINYINT DEFAULT 0,
  `importance` TINYINT DEFAULT 1,
  `question_source` VARCHAR(50) DEFAULT NULL,
  `grade` VARCHAR(20) DEFAULT NULL,
  `error_type` VARCHAR(50) DEFAULT NULL,
  `difficulty` INT DEFAULT 2,
  `remark` VARCHAR(500) DEFAULT NULL,
  `create_by` VARCHAR(50) DEFAULT NULL,
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_by` VARCHAR(50) DEFAULT NULL,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `del_flag` CHAR(1) DEFAULT '0',
  PRIMARY KEY (`question_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_question_type` (`question_type`),
  KEY `idx_tags` (`tags`),
  KEY `idx_proficiency` (`proficiency`),
  KEY `idx_importance` (`importance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建 trouble_question_favorite 表
CREATE TABLE `trouble_question_favorite` (
  `favorite_id` BIGINT NOT NULL AUTO_INCREMENT,
  `question_id` BIGINT NOT NULL,
  `user_id` BIGINT NOT NULL,
  `proficiency` TINYINT DEFAULT NULL,
  `importance` TINYINT DEFAULT NULL,
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`favorite_id`),
  KEY `idx_question_id` (`question_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建 trouble_question_trash 表
CREATE TABLE `trouble_question_trash` (
  `trash_id` BIGINT NOT NULL AUTO_INCREMENT,
  `question_id` BIGINT NOT NULL,
  `user_id` BIGINT NOT NULL,
  `question_content` TEXT NOT NULL,
  `question_images` VARCHAR(1000) DEFAULT NULL,
  `answer_content` TEXT DEFAULT NULL,
  `answer_images` VARCHAR(1000) DEFAULT NULL,
  `question_type` VARCHAR(50) NOT NULL DEFAULT '未区分',
  `tags` VARCHAR(500) DEFAULT NULL,
  `delete_reason` VARCHAR(500) DEFAULT NULL,
  `delete_by` VARCHAR(64) DEFAULT '',
  `delete_time` DATETIME DEFAULT NULL,
  `original_create_time` DATETIME DEFAULT NULL,
  `original_create_by` VARCHAR(64) DEFAULT '',
  `remark` VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (`trash_id`),
  KEY `idx_question_id` (`question_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_delete_time` (`delete_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

