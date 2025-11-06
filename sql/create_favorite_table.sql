-- 创建错题收藏表
DROP TABLE IF EXISTS `trouble_question_favorite`;
CREATE TABLE `trouble_question_favorite` (
  `favorite_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `question_id` bigint(20) NOT NULL COMMENT '错题ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `create_time` datetime DEFAULT NULL COMMENT '收藏时间',
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `uk_user_question` (`user_id`,`question_id`) COMMENT '用户和错题唯一索引',
  KEY `idx_question_id` (`question_id`) COMMENT '错题ID索引',
  KEY `idx_user_id` (`user_id`) COMMENT '用户ID索引'
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='错题收藏表';

