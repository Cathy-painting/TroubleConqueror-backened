<h1 align="center" style="margin: 30px 0 30px; font-weight: bold;">错题征服者 - Trouble Conqueror</h1>
<h4 align="center">中小学生错题管理系统 - 让学习更高效，让错题不再困扰</h4>
<p align="center">
	<a href="https://gitee.com/y_project/RuoYi-Vue/stargazers"><img src="https://gitee.com/y_project/RuoYi-Vue/badge/star.svg?theme=dark"></a>
	<a href="https://gitee.com/y_project/RuoYi-Vue"><img src="https://img.shields.io/badge/RuoYi-v3.9.0-brightgreen.svg"></a>
	<a href="https://gitee.com/y_project/RuoYi-Vue/blob/master/LICENSE"><img src="https://img.shields.io/github/license/mashape/apistatus.svg"></a>
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
* 后端采用Spring Boot、Spring Security、Redis & Jwt
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

### 系统管理功能
1. **用户管理**：学生、教师、家长多角色用户管理
2. **权限管理**：基于角色的权限控制，支持数据权限
3. **学科管理**：配置学科信息，支持多学科学习
4. **知识点管理**：维护知识点体系，支持层级结构
5. **通知公告**：系统通知公告信息发布维护
6. **操作日志**：系统操作日志记录和查询
7. **数据统计**：学习数据统计和分析报告
8. **系统监控**：系统性能监控和健康检查

## 快速开始

### 环境要求
- JDK 1.8+
- MySQL 5.7+
- Redis 3.0+
- Maven 3.0+

### 默认账号
- 管理员账号：admin/admin123
- 测试账号：student/student123

## 安装部署

### 1. 克隆项目
```bash
git clone https://github.com/your-username/TroubleConqueror-backened.git
cd TroubleConqueror-backened
```

### 2. 数据库配置
```bash
# 创建数据库
CREATE DATABASE trouble_conqueror DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 导入数据库脚本
mysql -u root -p trouble_conqueror < sql/ry_20250522.sql
```

### 3. 修改配置
修改 `ruoyi-admin/src/main/resources/application-druid.yml` 中的数据库连接信息

### 4. 启动后端
```bash
# 进入项目目录
cd ruoyi-admin

# 启动项目
mvn spring-boot:run
```

### 5. 启动前端
```bash
# 进入前端目录
cd ruoyi-ui

# 安装依赖
npm install

# 启动前端
npm run dev
```

### 6. 访问系统
- 后端地址：http://localhost:8080
- 前端地址：http://localhost:80


## 项目特色

### 🎯 智能错题管理
- **OCR识别**：拍照即可自动识别题目内容，支持数学公式识别
- **智能分类**：自动识别学科、难度，智能推荐标签
- **批量导入**：支持Excel批量导入错题数据

### 📊 学习分析
- **错题统计**：多维度错题统计分析
- **学习进度**：可视化学习进度跟踪
- **知识图谱**：构建知识点关联图谱

### 🚀 技术优势
- **高性能**：基于Spring Boot微服务架构
- **易扩展**：模块化设计，支持功能扩展
- **安全可靠**：完善的权限控制和数据安全

## 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的修改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

## 许可证

本项目基于 MIT 许可证开源 - 查看 [LICENSE](LICENSE) 文件了解详情