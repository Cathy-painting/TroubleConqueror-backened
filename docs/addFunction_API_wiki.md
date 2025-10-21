# 错题管理功能前端调用说明

本文档说明前端页面在调用错题管理相关功能 (添加、展示、删除) 时的后端 API 接口。

## 1. 核心 API 接口

所有错题相关的 API 都以 `/trouble/question` 为前缀。

### 1.1. 添加错题

-   **功能**: 创建一个新的错题记录。
-   **HTTP 方法**: `POST`
-   **URL**: `/trouble/question`
-   **请求体 (Request Body)**: `JSON` 格式的错题对象。

    ```json
    {
        "questionContent": "题目内容",
        "questionImages": "图片路径1,图片路径2",
        "answerContent": "答案内容",
        "answerImages": "答案图片路径1,图片路径2",
        "questionType": "题目类型",
        "tags": "标签1,标签2",
        "remark": "备注"
    }
    ```

-   **调用示例 (JavaScript - aue)**:

    ```javascript
    import { addQuestion } from "@/api/trouble/question";

    // ...

    const newQuestion = {
        questionContent: "这是一道新的错题",
        answerContent: "这是答案",
        questionType: "解答题",
        tags: "数学,函数"
    };

    addQuestion(newQuestion).then(response => {
        console.log("添加成功", response);
    });
    ```

### 1.2. 展示错题列表

-   **功能**: 获取当前登录用户的错题列表，支持分页和条件查询。
-   **HTTP 方法**: `GET`
-   **URL**: `/trouble/question/list`
-   **查询参数 (Query Parameters)**:

    -   `pageNum`: 页码
    -   `pageSize`: 每页数量
    -   `questionContent`: 题目内容 (模糊查询)
    -   `questionType`: 题目类型
    -   `tags`: 标签 (模糊查询)

-   **调用示例 (JavaScript - aue)**:

    ```javascript
    import { listQuestion } from "@/api/trouble/question";

    // ...

    const queryParams = {
        pageNum: 1,
        pageSize: 10,
        questionContent: "数学"
    };

    listQuestion(queryParams).then(response => {
        console.log("获取列表成功", response);
        this.questionList = response.rows;
        this.total = response.total;
    });
    ```

### 1.3. 删除错题

-   **功能**: 删除一个或多个错题。
-   **HTTP 方法**: `DELETE`
-   **URL**: `/trouble/question/{questionIds}`
    -   `questionIds`: 需要删除的错题 ID，多个 ID 用逗号分隔。
-   **调用示例 (JavaScript - aue)**:

    ```javascript
    import { delQuestion } from "@/api/trouble/question";

    // ...

    const questionIds = [1, 2, 3]; // 要删除的错题 ID 数组

    delQuestion(questionIds).then(response => {
        console.log("删除成功", response);
    });
    ```

## 2. 普通用户操作流程

普通用户登录系统后，可以通过以下步骤进行错题管理：

1.  **访问错题管理页面**:
    -   通常在侧边栏菜单中会有一个 “错题管理” 或类似的入口。
    -   点击后，前端会路由到错题列表页面，并调用 `listQuestion` 接口获取第一页的数据。

2.  **添加错题**:
    -   在错题列表页面，会有一个 “新增” 或 “添加错题” 的按钮。
    -   点击该按钮，会弹出一个表单或跳转到新的页面，让用户输入错题的详细信息。
    -   填写完毕后，点击 “确定” 或 “保存” 按钮，前端将收集表单数据，并调用 `addQuestion` 接口将数据发送到后端。

3.  **查看/修改错题**:
    -   在错题列表中，每一行错题后面通常会有 “修改” 或 “详情” 按钮。
    -   点击后，会弹出或跳转到编辑页面，并调用 `getQuestion(questionId)` 接口获取该错题的完整信息，填充到表单中。
    -   修改后，点击保存，调用 `updateQuestion(questionData)` 接口。

4.  **删除错题**:
    -   在错题列表中，每一行错题后面会有 “删除” 按钮。
    -   用户也可以通过复选框选择多个错题，然后点击列表上方的 “批量删除” 按钮。
    -   点击删除按钮后，前端会获取一个或多个错题的 ID，并调用 `delQuestion(questionIds)` 接口来删除这些错题。
