# 错题熟练度管理 API 接口文档

本文档说明错题熟练度管理相关功能的后端 API 接口。

## 1. 核心 API 接口

所有错题相关的 API 都以 `/trouble/question` 为前缀。

---

## 2. 查询错题列表（支持熟练度筛选）

### 2.1 接口信息

- **功能**: 查询当前登录用户的错题列表，支持按熟练度等级筛选
- **HTTP 方法**: `GET`
- **URL**: `/trouble/question/list`
- **权限**: `trouble:question:list`

### 2.2 查询参数 (Query Parameters)

| 参数名 | 类型 | 必填 | 说明 | 示例值 |
|--------|------|------|------|--------|
| pageNum | Integer | 否 | 页码，默认1 | 1 |
| pageSize | Integer | 否 | 每页数量，默认10 | 10 |
| questionContent | String | 否 | 题目内容（模糊查询） | "数学" |
| questionType | String | 否 | 题目类型 | "选择题" |
| tags | String | 否 | 标签（模糊查询） | "函数" |
| importance | Integer | 否 | 重要性等级（1=低，2=中，3=高） | 2 |
| **proficiency** | **Integer** | **否** | **熟练度等级（0=陌生，1=一般，2=较好，3=熟练）** | **2** |
| status | String | 否 | 状态（0=正常，1=删除） | "0" |

### 2.3 响应示例

```json
{
  "total": 100,
  "rows": [
    {
      "questionId": 1,
      "userId": 1,
      "questionContent": "这是一道数学题",
      "questionImages": "image1.jpg,image2.jpg",
      "answerContent": "答案是A",
      "answerImages": null,
      "questionType": "选择题",
      "tags": "数学,函数",
      "importance": 2,
      "proficiency": 2,
      "status": "0",
      "isFavorite": 0,
      "createTime": "2024-01-01 10:00:00",
      "updateTime": "2024-01-01 10:00:00"
    }
  ],
  "code": 200,
  "msg": "查询成功"
}
```

---

## 3. 更新错题熟练度

### 3.1 接口信息

- **功能**: 更新指定错题的熟练度等级
- **HTTP 方法**: `PUT`
- **URL**: `/trouble/question/proficiency/{questionId}`
- **权限**: `trouble:question:edit`

### 3.2 路径参数 (Path Parameters)

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| questionId | Long | 是 | 错题ID |

### 3.3 查询参数 (Query Parameters)

| 参数名 | 类型 | 必填 | 说明 | 示例值 |
|--------|------|------|------|--------|
| proficiency | Integer | 是 | 熟练度等级（0=陌生，1=一般，2=较好，3=熟练） | 2 |

### 3.4 响应示例

**成功响应**:
```json
{
  "code": 200,
  "msg": "更新熟练度成功"
}
```

**失败响应**:
```json
{
  "code": 500,
  "msg": "熟练度等级必须为0（陌生）、1（一般）、2（较好）或3（熟练）"
}
```

### 3.5 调用示例

**JavaScript (Vue/Axios)**:
```javascript
import request from '@/utils/request'

// 更新错题熟练度为"较好"
request({
  url: '/trouble/question/proficiency/1',
  method: 'put',
  params: { proficiency: 2 }
}).then(response => {
  console.log("更新成功", response);
})
```

---

## 4. 新增错题（支持设置熟练度）

### 4.1 接口信息

- **功能**: 新增错题，支持设置熟练度等级
- **HTTP 方法**: `POST`
- **URL**: `/trouble/question`
- **权限**: `trouble:question:add`

### 4.2 请求体参数 (Request Body)

| 参数名 | 类型 | 必填 | 说明 | 示例值 |
|--------|------|------|------|--------|
| questionContent | String | 是 | 题目内容 | "这是一道数学题" |
| answerContent | String | 否 | 答案内容 | null |
| answerImages | String | 否 | 答案图片（多个用逗号分隔） | null |
| questionType | String | 否 | 题目类型 | "未区分" |
| tags | String | 否 | 标签（多个用逗号分隔） | null |
| importance | Integer | 否 | 重要性等级（1=低，2=中，3=高） | 2 |
| **proficiency** | **Integer** | **否** | **熟练度等级（0=陌生，1=一般，2=较好，3=熟练）** | **0** |
| remark | String | 否 | 备注 | null |

### 4.3 调用示例

**JavaScript (Vue/Axios)**:
```javascript
import request from '@/utils/request'

const newQuestion = {
  questionContent: "这是一道新的错题",
  answerContent: "这是答案",
  questionType: "解答题",
  tags: "数学,函数",
  importance: 3,  // 设置为高重要性
  proficiency: 0  // 设置为陌生（默认值）
}

request({
  url: '/trouble/question',
  method: 'post',
  data: newQuestion
}).then(response => {
  console.log("添加成功", response);
})
```

---

## 5. 修改错题（支持更新熟练度）

### 5.1 接口信息

- **功能**: 修改错题信息，支持更新熟练度
- **HTTP 方法**: `PUT`
- **URL**: `/trouble/question`
- **权限**: `trouble:question:edit`

### 5.2 请求体参数 (Request Body)

与新增接口相同，但需要包含 `questionId` 字段。

---

## 6. 熟练度等级说明

| 等级值 | 等级名称 | 说明 |
|--------|---------|------|
| 0 | 陌生 | 对错题不熟悉，需要重点复习 |
| 1 | 一般 | 对错题有一定了解，但不够熟练 |
| 2 | 较好 | 对错题掌握程度较好，基本掌握 |
| 3 | 熟练 | 对错题熟练掌握，可以考虑删除 |

---

## 7. 注意事项

1. **权限验证**: 所有接口都需要用户登录，且只能操作属于当前用户的错题
2. **参数验证**: 更新熟练度接口会验证 proficiency 参数必须在 0-3 之间
3. **默认值**: 新增错题时，如果不指定 proficiency，默认为 0（陌生）
4. **筛选功能**: 查询接口支持按 proficiency 筛选，可以与其他筛选条件组合使用
5. **数据完整性**: 修改错题时，可以只更新部分字段（包括 proficiency），未提供的字段不会被修改
6. **使用场景**: 熟练度标签的目的是让用户能够有根据去删除错题。熟练度越高，说明掌握程度越好，可以考虑删除该错题。

---

## 8. 更新日志

### Version 1.0 (2024-01-XX)
- 新增 `proficiency` 字段到错题表
- 查询接口支持按熟练度筛选
- 新增更新熟练度专用接口
- 修改和新增接口支持设置熟练度
- 在首页的本周新增页面新增本周错题的熟练度统计

---

## 9. 前端使用示例

### 9.1 Vue组件中使用API

```javascript
import { updateProficiency, listQuestion } from "@/api/trouble/question";

// 更新熟练度
updateProficiency(questionId, 3).then(() => {
  this.$message.success("更新熟练度成功");
  this.loadData();
});

// 按熟练度筛选
listQuestion({ proficiency: 2 }).then(response => {
  // 处理返回的错题列表
});
```

### 9.2 表单中使用

```vue
<el-form-item label="熟练度" prop="proficiency">
  <el-radio-group v-model="form.proficiency">
    <el-radio :label="3">熟练</el-radio>
    <el-radio :label="2">较好</el-radio>
    <el-radio :label="1">一般</el-radio>
    <el-radio :label="0">陌生</el-radio>
  </el-radio-group>
</el-form-item>
```

