-- ============ 创建错题主表、回收站表、收藏表 ============

-- 错题表
DROP TABLE IF EXISTS `trouble_question`;
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

-- 问题回收站表
DROP TABLE IF EXISTS `trouble_question_trash`;
CREATE TABLE `trouble_question_trash` (
  `trash_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `question_id` BIGINT(20) NOT NULL COMMENT '问题ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID',
  `question_content` TEXT NOT NULL COMMENT '问题内容',
  `question_images` VARCHAR(1000) DEFAULT NULL COMMENT '问题图片',
  `answer_content` TEXT DEFAULT NULL COMMENT '回答内容',
  `answer_images` VARCHAR(1000) DEFAULT NULL COMMENT '回答图片',
  `question_type` VARCHAR(50) NOT NULL DEFAULT '未区分' COMMENT '问题类型',
  `tags` VARCHAR(500) DEFAULT NULL COMMENT '标签',
  `delete_reason` VARCHAR(500) DEFAULT NULL COMMENT '删除原因',
  `delete_by` VARCHAR(64) DEFAULT '' COMMENT '删除人',
  `delete_time` DATETIME DEFAULT NULL COMMENT '删除时间',
  `original_create_time` DATETIME DEFAULT NULL COMMENT '原创建时间',
  `original_create_by` VARCHAR(64) DEFAULT '' COMMENT '原创建人',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`trash_id`),
  KEY `idx_question_id` (`question_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_delete_time` (`delete_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='问题回收站表';

-- 错题收藏表
DROP TABLE IF EXISTS `trouble_question_favorite`;
CREATE TABLE `trouble_question_favorite` (
  `favorite_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `question_id` BIGINT(20) NOT NULL COMMENT '错题ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID',
  `proficiency` TINYINT DEFAULT NULL COMMENT '熟练度（0-陌生，1-一般，2-较好，3-熟练）',
  `importance` TINYINT DEFAULT NULL COMMENT '重要程度（1-5星）',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `uk_user_question` (`user_id`,`question_id`) COMMENT '用户和错题唯一索引',
  KEY `idx_question_id` (`question_id`) COMMENT '错题ID索引',
  KEY `idx_user_id` (`user_id`) COMMENT '用户ID索引'
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='错题收藏表';

