# 错题本系统新增属性更新总结

## 新增属性

为错题本系统添加了以下4个新属性：

1. **questionSource (错题来源)** - String类型
   - 课堂练习
   - 课后作业
   - 周测/月考
   - 单元测试
   - 期中/期末考试
   - 模拟考试
   - 真题
   - 教辅资料
   - 竞赛类

2. **grade (年级)** - String类型
   - 小学一年级 ~ 小学六年级
   - 初中一年级 ~ 初中三年级
   - 高中一年级 ~ 高中三年级

3. **errorType (错误类型)** - String类型
   - 基础薄弱
   - 粗心失误
   - 思路方法
   - 考试场景

4. **difficulty (难度等级)** - Integer类型
   - 1 = 简单
   - 2 = 中等（默认值）
   - 3 = 困难

## 更新的文件

### 后端 (Java)

1. **TroubleQuestion.java** (实体类)
   - 添加了4个新属性字段
   - 添加了对应的getter/setter方法
   - 更新了toString()方法

2. **TroubleQuestionMapper.xml** (MyBatis映射文件)
   - 更新了resultMap映射
   - 更新了selectTroubleQuestionVo SQL查询
   - 更新了selectTroubleQuestionList查询条件
   - 更新了selectFavoriteQuestionList查询
   - 更新了insertTroubleQuestion插入语句
   - 更新了updateTroubleQuestion更新语句

3. **add_new_fields.sql** (数据库迁移脚本)
   - 创建了ALTER TABLE语句用于添加新字段

### 前端 (Vue)

1. **add.vue** (添加错题页面)
   - 添加了4个新表单字段的UI组件
   - 更新了form数据对象
   - 更新了resetForm方法

2. **QuestionEditDialog.vue** (编辑错题对话框)
   - 添加了4个新表单字段的UI组件
   - 更新了form数据对象
   - 更新了loadQuestion方法以加载新字段数据

3. **QuestionDetail.vue** (查看错题详情组件)
   - 添加了难度等级的显示
   - 添加了"其他信息"section显示错题来源、年级、错误类型
   - 添加了getDifficultyText()和getDifficultyTagType()方法
   - 添加了cyan颜色样式

## 数据库迁移

执行以下SQL脚本以更新数据库：

```sql
ALTER TABLE trouble_question 
ADD COLUMN question_source VARCHAR(50) COMMENT '错题来源' AFTER proficiency,
ADD COLUMN grade VARCHAR(20) COMMENT '年级' AFTER question_source,
ADD COLUMN error_type VARCHAR(50) COMMENT '错误类型' AFTER grade,
ADD COLUMN difficulty INT(1) DEFAULT 2 COMMENT '难度等级（1=简单，2=中等，3=困难）' AFTER error_type;
```

## 功能说明

### 添加错题页面
- 用户可以选择错题来源（下拉选择）
- 用户可以选择年级（下拉选择）
- 用户可以选择错误类型（下拉选择）
- 用户可以选择难度等级（单选按钮：简单/中等/困难）

### 编辑错题对话框
- 所有新增字段都可以编辑
- 保持与添加页面相同的UI组件和交互方式

### 查看错题详情
- 在"标签信息"section中显示难度等级（带颜色标签）
- 新增"其他信息"section显示错题来源、年级、错误类型
- 使用不同颜色的图标和标签进行区分

## 注意事项

1. **数据库迁移**：在部署前端代码之前，请先执行数据库迁移脚本
2. **默认值**：difficulty字段默认值为2（中等）
3. **可选字段**：所有新增字段都是可选的，不影响现有功能
4. **样式一致性**：新增字段的UI样式与现有字段保持一致，使用蓝色主题

## 测试建议

1. 测试添加新错题时填写所有新字段
2. 测试编辑现有错题时修改新字段
3. 测试查看错题详情时新字段的显示
4. 测试新字段为空时的显示效果
5. 测试数据库查询和筛选功能
