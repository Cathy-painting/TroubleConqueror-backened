USE ry-vue;

INSERT INTO trouble_question
(user_id, question_content, question_images, answer_content, answer_images, question_type, tags, status, proficiency, importance, question_source, grade, error_type, difficulty, remark, create_by, create_time)
VALUES
(100,'计算 12+7 的结果','https://img.makis-life.cn/troubleConqueror/3.png','答案是 19','https://img.makis-life.cn/troubleConqueror/12.png','选择题','数学,运算','正常',2,1,'课堂练习','小学五年级','粗心失误',1,NULL,'Maki','2025-11-15 09:12:33'),
(100,'求方程 x+5=12 的解','https://img.makis-life.cn/troubleConqueror/7.png','x=7','https://img.makis-life.cn/troubleConqueror/15.png','解答题','数学,代数','正常',1,2,'课后作业','初中一年级','基础薄弱',2,NULL,'Maki','2025-11-15 14:22:41'),
(100,'下列哪个是哺乳动物？',NULL,'猫','https://img.makis-life.cn/troubleConqueror/18.png','选择题','生物','正常',3,1,'单元测试','小学六年级','粗心失误',1,NULL,'Maki','2025-11-15 16:51:09'),
(100,'阅读短文回答问题：小红为什么迟到？','https://img.makis-life.cn/troubleConqueror/9.png',NULL,NULL,'解答题','语文,阅读','正常',0,0,'周测/月考','小学四年级','基础薄弱',2,NULL,'Maki','2025-11-16 08:33:58'),
(100,'化简 (a+a+a)/3','https://img.makis-life.cn/troubleConqueror/4.png','a','https://img.makis-life.cn/troubleConqueror/25.png','填空题','数学,代数','正常',2,2,'真题','初中二年级','粗心失误',1,NULL,'Maki','2025-11-16 12:23:11'),
(100,'求圆的周长公式是什么？',NULL,'C=2πr',NULL,'填空题','数学,几何','正常',3,1,'教辅资料','小学六年级','基础薄弱',1,NULL,'Maki','2025-11-16 17:41:52'),
(100,'英语单词 apple 的中文意思是什么？','https://img.makis-life.cn/troubleConqueror/13.png',NULL,NULL,'选择题','英语','正常',0,0,'课堂练习','小学三年级','粗心失误',1,NULL,'Maki','2025-11-16 19:12:32'),
(100,'判断：水的冰点是 0℃。','https://img.makis-life.cn/troubleConqueror/22.png','正确','https://img.makis-life.cn/troubleConqueror/27.png','选择题','科学','正常',2,2,'单元测试','小学五年级','基础薄弱',1,NULL,'Maki','2025-11-17 09:14:19'),
(100,'计算 5×8','https://img.makis-life.cn/troubleConqueror/10.png','40','https://img.makis-life.cn/troubleConqueror/2.png','填空题','数学,运算','正常',1,1,'期中/期末考试','小学四年级','粗心失误',1,NULL,'Maki','2025-11-17 11:09:55'),
(100,'语文：找出句子中的错别字','https://img.makis-life.cn/troubleConqueror/1.png',NULL,NULL,'解答题','语文','正常',0,2,'周测/月考','小学五年级','基础薄弱',2,NULL,'Maki','2025-11-17 13:40:21'),

(100,'化简 3x+2x','https://img.makis-life.cn/troubleConqueror/8.png','5x','https://img.makis-life.cn/troubleConqueror/24.png','填空题','数学,代数','正常',1,0,'课堂练习','初中一年级','粗心失误',2,NULL,'Maki','2025-11-18 08:22:16'),
(100,'下列哪个是质数？',NULL,'7',NULL,'选择题','数学,数论','正常',0,1,'课后作业','小学六年级','基础薄弱',1,NULL,'Maki','2025-11-18 10:33:11'),
(100,'求阴影部分面积','https://img.makis-life.cn/troubleConqueror/19.png','已知答案如图','https://img.makis-life.cn/troubleConqueror/26.png','解答题','数学,几何','正常',2,2,'模拟考试','初中二年级','粗心失误',3,NULL,'Maki','2025-11-18 16:47:44'),
(100,'英语翻译：I have a pen.',NULL,'我有一支笔',NULL,'解答题','英语','正常',3,1,'课堂练习','小学五年级','基础薄弱',1,NULL,'Maki','2025-11-19 09:12:08'),
(100,'判断：地球绕太阳转。','https://img.makis-life.cn/troubleConqueror/29.png','正确',NULL,'选择题','科学','正常',1,1,'单元测试','小学六年级','粗心失误',1,NULL,'Maki','2025-11-19 12:42:22'),
(100,'解方程：2x=18','https://img.makis-life.cn/troubleConqueror/5.png','x=9','https://img.makis-life.cn/troubleConqueror/11.png','解答题','数学,代数','正常',2,0,'教辅资料','初中一年级','基础薄弱',2,NULL,'Maki','2025-11-19 15:51:57'),
(100,'语文：修辞手法判断','https://img.makis-life.cn/troubleConqueror/30.png',NULL,NULL,'选择题','语文','正常',1,1,'周测/月考','初中一年级','粗心失误',2,NULL,'Maki','2025-11-19 20:37:31'),

(100,'计算 9×9',NULL,'81',NULL,'填空题','数学','正常',0,0,'课堂练习','小学三年级','基础薄弱',1,NULL,'Maki','2025-11-20 08:49:14'),
(100,'英语：选择正确的时态','https://img.makis-life.cn/troubleConqueror/16.png','答案如图','https://img.makis-life.cn/troubleConqueror/21.png','选择题','英语','正常',2,1,'真题','初中二年级','粗心失误',2,NULL,'Maki','2025-11-20 11:55:48'),
(100,'判断图形是否对称','https://img.makis-life.cn/troubleConqueror/23.png',NULL,NULL,'选择题','数学,几何','正常',1,0,'模拟考试','小学六年级','基础薄弱',3,NULL,'Maki','2025-11-20 17:29:18'),

(100,'化学：识别物质状态',NULL,'固体',NULL,'选择题','科学','正常',0,1,'单元测试','初中一年级','粗心失误',1,NULL,'Maki','2025-11-21 09:17:52'),
(100,'数学：分式化简','https://img.makis-life.cn/troubleConqueror/14.png','答案如图','https://img.makis-life.cn/troubleConqueror/17.png','解答题','数学,代数','正常',3,2,'期中/期末考试','初中二年级','基础薄弱',3,NULL,'Maki','2025-11-21 13:31:07'),
(100,'阅读理解：主旨概括','https://img.makis-life.cn/troubleConqueror/6.png',NULL,NULL,'解答题','语文','正常',1,0,'教辅资料','初中一年级','粗心失误',2,NULL,'Maki','2025-11-21 20:06:42'),

(100,'历史：判断史实',NULL,'正确',NULL,'选择题','历史','正常',1,1,'课堂练习','初中一年级','基础薄弱',1,NULL,'Maki','2025-11-22 09:55:49'),
(100,'地理：气候类型判断','https://img.makis-life.cn/troubleConqueror/20.png',NULL,NULL,'选择题','地理','正常',2,0,'单元测试','初中二年级','粗心失误',1,NULL,'Maki','2025-11-22 12:11:21'),
(100,'物理：杠杆原理计算','https://img.makis-life.cn/troubleConqueror/28.png','答案如图','https://img.makis-life.cn/troubleConqueror/3.png','解答题','物理','正常',3,2,'模拟考试','初中二年级','基础薄弱',3,NULL,'Maki','2025-11-22 17:16:09'),

(100,'数学：解比例 3:x=6:12',NULL,'x=6',NULL,'填空题','数学','正常',1,1,'课后作业','小学六年级','粗心失误',2,NULL,'Maki','2025-11-23 08:19:40'),
(100,'化简代数式','https://img.makis-life.cn/troubleConqueror/1.png',NULL,NULL,'填空题','数学','正常',0,0,'课堂练习','初中一年级','基础薄弱',2,NULL,'Maki','2025-11-23 14:55:18'),
(100,'科学：密度判断','https://img.makis-life.cn/troubleConqueror/7.png','如图','https://img.makis-life.cn/troubleConqueror/16.png','选择题','科学','正常',2,2,'真题','初中三年级','粗心失误',3,NULL,'Maki','2025-11-23 18:34:52'),

(100,'语文：修改病句',NULL,'答案如图',NULL,'解答题','语文','正常',1,0,'周测/月考','初中一年级','基础薄弱',2,NULL,'Maki','2025-11-24 09:51:12'),
(100,'计算 45÷5','https://img.makis-life.cn/troubleConqueror/14.png','9','https://img.makis-life.cn/troubleConqueror/29.png','填空题','数学','正常',2,1,'课堂练习','小学五年级','粗心失误',1,NULL,'Maki','2025-11-24 13:42:52'),

(100,'数学：图形周长计算','https://img.makis-life.cn/troubleConqueror/30.png',NULL,NULL,'解答题','数学','正常',1,0,'期中/期末考试','小学六年级','基础薄弱',2,NULL,'Maki','2025-11-25 10:32:41'),
(100,'物理：速度=路程/时间',NULL,'正确',NULL,'判断题','物理','正常',0,2,'课后作业','初中二年级','粗心失误',1,NULL,'Maki','2025-11-25 12:55:20'),

(100,'计算 7×12','https://img.makis-life.cn/troubleConqueror/5.png','84','https://img.makis-life.cn/troubleConqueror/9.png','填空题','数学,运算','正常',2,1,'模拟考试','小学六年级','基础薄弱',2,NULL,'Maki','2025-11-26 08:12:32'),
(100,'英语：选择正确的介词','https://img.makis-life.cn/troubleConqueror/18.png',NULL,NULL,'选择题','英语','正常',1,0,'课堂练习','初中一年级','粗心失误',1,NULL,'Maki','2025-11-26 13:21:18'),

(100,'语文：文言文翻译',NULL,'答案略',NULL,'解答题','语文','正常',0,2,'期中/期末考试','初中三年级','基础薄弱',3,NULL,'Maki','2025-11-27 14:50:51'),
(100,'数学：函数图像判断','https://img.makis-life.cn/troubleConqueror/11.png','答案如图','https://img.makis-life.cn/troubleConqueror/12.png','选择题','数学,函数','正常',3,1,'真题','高中一年级','粗心失误',3,NULL,'Maki','2025-11-27 19:03:22'),

(100,'化学：离子反应判断','https://img.makis-life.cn/troubleConqueror/26.png',NULL,NULL,'选择题','化学','正常',1,1,'模拟考试','初中三年级','基础薄弱',2,NULL,'Maki','2025-11-28 09:12:44'),

(100,'历史：事件排序',NULL,'答案如图',NULL,'解答题','历史','正常',0,2,'课后作业','初中一年级','粗心失误',1,NULL,'Maki','2025-11-29 11:01:35'),
(100,'数学：勾股定理判断','https://img.makis-life.cn/troubleConqueror/15.png','如图','https://img.makis-life.cn/troubleConqueror/20.png','选择题','数学,几何','正常',3,1,'单元测试','初中三年级','基础薄弱',3,NULL,'Maki','2025-11-29 17:43:29'),

(100,'英语阅读理解',NULL,'答案略',NULL,'解答题','英语','正常',1,0,'课堂练习','初中二年级','粗心失误',2,NULL,'Maki','2025-11-30 09:15:41'),
(100,'地理：地形判断','https://img.makis-life.cn/troubleConqueror/22.png',NULL,NULL,'选择题','地理','正常',1,2,'模拟考试','初中一年级','基础薄弱',2,NULL,'Maki','2025-11-30 12:45:59'),

(100,'数学：行程问题',NULL,'答案如图',NULL,'解答题','数学','正常',0,0,'真题','初中二年级','粗心失误',2,NULL,'Maki','2025-12-01 08:21:22'),
(100,'化学：物质变化判断','https://img.makis-life.cn/troubleConqueror/3.png',NULL,NULL,'选择题','化学','正常',3,1,'期中/期末考试','初中三年级','基础薄弱',3,NULL,'Maki','2025-12-01 15:42:18'),

(100,'语文：中心思想概括','https://img.makis-life.cn/troubleConqueror/13.png','参考如图','https://img.makis-life.cn/troubleConqueror/17.png','解答题','语文','正常',1,0,'课堂练习','初中三年级','粗心失误',2,NULL,'Maki','2025-12-02 09:41:57'),
(100,'数学：解方程 4x-8=0',NULL,'x=2',NULL,'解答题','数学','正常',0,1,'课后作业','初中一年级','基础薄弱',2,NULL,'Maki','2025-12-02 13:55:10'),

(100,'英语：写出反义词',NULL,'fast-slow',NULL,'填空题','英语','正常',2,0,'课堂练习','小学六年级','粗心失误',1,NULL,'Maki','2025-12-03 10:12:51'),
(100,'科学：判断浮沉',NULL,'下沉',NULL,'选择题','科学','正常',0,2,'单元测试','小学六年级','基础薄弱',1,NULL,'Maki','2025-12-03 19:21:42'),

(100,'数学：三角形面积计算','https://img.makis-life.cn/troubleConqueror/27.png',NULL,NULL,'解答题','数学','正常',3,1,'真题','初中二年级','粗心失误',3,NULL,'Maki','2025-12-04 11:40:18'),
(100,'化学：氧化还原判断','https://img.makis-life.cn/troubleConqueror/10.png','如图','https://img.makis-life.cn/troubleConqueror/21.png','解答题','化学','正常',2,2,'模拟考试','高中一年级','基础薄弱',3,NULL,'Maki','2025-12-04 15:32:11');


