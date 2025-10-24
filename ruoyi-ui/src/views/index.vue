<template>
  <div class="app-container home">
    <el-row :gutter="20">
      <el-col :sm="24" :lg="12" style="padding-left: 20px">
        <h2>错题征服者 - 智能错题管理系统</h2>
        <p>
          专为中小学生设计的智能错题管理系统，帮助用户高效管理错题、提升学习效率。支持文本输入和拍照识别添加错题，智能分类管理，多维度统计分析，构建知识图谱，让学习更高效，让错题不再困扰。
        </p>
        <p>
          <b>当前版本:</b> <span>v{{ version }}</span>
        </p>
        <p>
          <el-tag type="success">🎯 智能错题管理</el-tag>
          <el-tag type="info">📊 学习分析</el-tag>
          <el-tag type="warning">🚀 知识图谱</el-tag>
        </p>
      </el-col>

      <el-col :sm="24" :lg="12" style="padding-left: 50px">
        <el-row>
          <el-col :span="12">
            <h2>核心功能</h2>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="6">
            <h4>智能识别</h4>
            <ul>
              <li>OCR文字识别</li>
              <li>数学公式识别</li>
              <li>智能分类</li>
              <li>自动标签</li>
              <li>批量导入</li>
              <li>...</li>
            </ul>
          </el-col>
          <el-col :span="6">
            <h4>学习分析</h4>
            <ul>
              <li>错题统计</li>
              <li>学习进度</li>
              <li>知识图谱</li>
              <li>薄弱点分析</li>
              <li>练习推荐</li>
              <li>...</li>
            </ul>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-divider />
  </div>
</template>

<script>
export default {
  name: "Index",
  data() {
    return {
      // 版本号
      version: "1.0.0"
    }
  },
  methods: {
    goTarget(href) {
      window.open(href, "_blank")
    }
  }
}
</script>

<style scoped lang="scss">
.home {
  blockquote {
    padding: 10px 20px;
    margin: 0 0 20px;
    font-size: 17.5px;
    border-left: 5px solid #eee;
  }
  hr {
    margin-top: 20px;
    margin-bottom: 20px;
    border: 0;
    border-top: 1px solid #eee;
  }
  .col-item {
    margin-bottom: 20px;
  }

  ul {
    padding: 0;
    margin: 0;
  }

  font-family: "open sans", "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-size: 13px;
  color: #676a6c;
  overflow-x: hidden;

  ul {
    list-style-type: none;
  }

  h4 {
    font-size: 1.2rem;
    margin-top: 0px;
  }

  h2 {
    margin-top: 10px;
    font-size: 2rem;
    font-weight: bold;
  }

  p {
    font-size: 1rem;
    margin-top: 10px;

    b {
      font-weight: 700;
    }
  }

  .update-log {
    ol {
      display: block;
      list-style-type: decimal;
      margin-block-start: 1em;
      margin-block-end: 1em;
      margin-inline-start: 0;
      margin-inline-end: 0;
      padding-inline-start: 40px;
    }
  }
}
</style>

