<h1 align="center" style="margin: 30px 0 30px; font-weight: bold;">错题征服者 - Trouble Conqueror</h1>
<h4 align="center">中小学生错题管理系统 - 让学习更高效，让错题不再困扰</h4>
<p align="center">
	<a href="https://github.com/Elowen-yu/TroubleConqueror-backened">GitHub</a>
</p>

## 项目简介

错题征服者是一套专为中小学生设计的错题管理系统，旨在帮助用户高效管理错题、提升学习效率。

### 核心功能
* **智能错题管理** - 支持文本输入和拍照识别添加错题
* **OCR智能识别** - 拍照即可自动识别题目内容
* **分类标签管理** - 按学科、难度、知识点分类管理
* **统计分析** - 错题统计、学习进度分析
* **知识图谱** - 构建知识点关联图谱
* **练习功能** - 智能推荐练习题目

### 技术架构
* 前端采用Vue、Element UI
* 后端采用Spring Boot、Spring Security、Redis & Jwt、React
* 数据库采用Mysql关系型数据库
* 权限认证使用Jwt，支持多终端认证系统
* 支持加载动态权限菜单，多方式轻松权限控制
* 基于若依框架开发，保证系统稳定性和可扩展性

## 系统功能

### 核心业务功能
1. **错题管理**：支持文本输入和拍照识别添加错题，智能分类管理
2. **OCR识别**：拍照即可自动识别题目内容，支持数学公式识别
3. **分类标签**：按学科、年级、难度、知识点进行多维度分类
4. **统计分析**：错题统计、学习进度分析、知识点掌握情况
5. **知识图谱**：构建知识点关联图谱，发现知识薄弱环节
6. **练习功能**：智能推荐练习题目，个性化学习路径


## TODO

### 增量1：完善首页与“添加错题”功能
- [x] 设计产品首页（Product GUI）
- [X] 设计应用首页（App GUI）
- [x] 初始化后端管理页面
- [x] 增加“添加错题”功能
- [x] 连接后端 API，实现前端的错题创建功能
- [x] 添加错题成功提示与跳转逻辑

### 增量2：错题管理功能
- [x] 错题管理页面(已有错题列表，需要优化下视觉效果（有/无图片）和交互)
- [ ] 错题收藏功能和收藏页面
- [ ] 实现分组功能(也就是标签了，基本上已经是实现了)
- [ ] 添加熟练度管理(没什么想法怎么设计，但是老师有提到，感觉和重要性管理重复了)
- [ ] 添加重要性管理(感觉是定义标签就可以，比如三种等级对应1,2,3写在表里就行)

### 增量3：查询与统计 + 知识图谱
- [ ] 实现错题查询功能（按关键字、分组、标签）
- [ ] 统计功能：错题数、熟练度分布、掌握进度
- [ ] 添加知识图谱模块（Knowledge Graph）
  - [ ] 支持用户手动建立错题间的双向/反向链接
  - [ ] 图谱可视化展示（力导向图、节点信息）
- [ ] 优化图谱交互（点击节点查看详情、编辑链接）

### 增量4：练习与导出功能
- [ ] 题目选择功能（支持批量勾选错题）
- [ ] 组卷逻辑实现（生成练习卷）
- [ ] 支持练习模式（限时 / 复习）
  - [ ] 记录练习结果与错题回流机制
- [ ] 实现导出为 PDF（Export as PDF）

## 开发团队

<p align="left">

  <a href="https://github.com/Elowen-yu">
    <img src="https://img.shields.io/badge/Elowen--yu-%E4%BA%A7%E5%93%81%E7%BB%8F%E7%90%86%EF%BC%88Product%20Manager%EF%BC%89-9cf" alt="Elowen">
  </a>
  <br>

  <a href="https://github.com/Cathy-painting">
    <img src="https://img.shields.io/badge/Cathy--painting-%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AE%A1%E7%90%86%E5%91%98%E4%B8%8E%E6%B5%8B%E8%AF%95%EF%BC%88DBA%20%26%20Tester%EF%BC%89-pink" alt="Cathy">
  </a>
  <br>

  <a href="https://github.com/MakiWinster72">
    <img src="https://img.shields.io/badge/MakiWinster72-%E7%B3%BB%E7%BB%9F%E5%88%86%E6%9E%90%E5%B8%88%EF%BC%88System%20Analyst%EF%BC%89-brightgreen" alt="Maki">
  </a>

</p>

## 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的修改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

## 许可证

本项目基于 MIT 许可证开源 - 查看 [LICENSE](LICENSE) 文件了解详情
此外，项目底层框架基于 若依（RuoYi） 框架进行二次开发与扩展，遵循其开源协议与使用规范。
