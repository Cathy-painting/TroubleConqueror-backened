<template>
  <div class="app-container">
    <el-card class="welcome-card">
      <div slot="header" class="clearfix">
        <span class="welcome-title">🎯 错题征服者 - 智能错题管理系统</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="refreshData">
          <i class="el-icon-refresh"></i> 刷新
        </el-button>
      </div>
      
      <div class="welcome-content">
        <p class="welcome-desc">
          专为中小学生设计的智能错题管理系统，帮助用户高效管理错题、提升学习效率。
          支持文本输入和拍照识别添加错题，智能分类管理，多维度统计分析。
        </p>
        
        <!-- 统计卡片 -->
        <el-row :gutter="20" class="stats-row">
          <el-col :span="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-number">{{ stats.totalQuestions }}</div>
                <div class="stat-label">总错题数</div>
                <i class="el-icon-document stat-icon"></i>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-number">{{ stats.todayQuestions }}</div>
                <div class="stat-label">今日新增</div>
                <i class="el-icon-plus stat-icon"></i>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-number">{{ stats.thisWeekQuestions }}</div>
                <div class="stat-label">本周新增</div>
                <i class="el-icon-date stat-icon"></i>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-number">{{ stats.tagsCount }}</div>
                <div class="stat-label">标签数量</div>
                <i class="el-icon-collection-tag stat-icon"></i>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </el-card>

    <!-- 功能按钮区域 -->
    <el-row :gutter="20" class="function-row">
      <el-col :span="8">
        <el-card class="function-card" shadow="hover" @click.native="goToAddQuestion">
          <div class="function-content">
            <div class="function-icon">
              <i class="el-icon-edit-outline"></i>
            </div>
            <div class="function-title">添加错题</div>
            <div class="function-desc">手动输入题目内容，支持文本和图片</div>
            <el-button type="primary" size="medium" class="function-btn">
              <i class="el-icon-edit"></i> 立即添加
            </el-button>
          </div>
        </el-card>
      </el-col>
      
      <el-col :span="8">
        <el-card class="function-card" shadow="hover" @click.native="goToQuestionList">
          <div class="function-content">
            <div class="function-icon">
              <i class="el-icon-view"></i>
            </div>
            <div class="function-title">查看错题</div>
            <div class="function-desc">浏览和管理已添加的错题</div>
            <el-button type="success" size="medium" class="function-btn">
              <i class="el-icon-view"></i> 查看列表
            </el-button>
          </div>
        </el-card>
      </el-col>
      
      <el-col :span="8">
        <el-card class="function-card" shadow="hover" @click.native="goToCameraAdd">
          <div class="function-content">
            <div class="function-icon">
              <i class="el-icon-camera"></i>
            </div>
            <div class="function-title">拍照添加</div>
            <div class="function-desc">拍照识别题目，智能提取内容</div>
            <el-button type="warning" size="medium" class="function-btn">
              <i class="el-icon-camera"></i> 拍照识别
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 快速操作区域 -->
    <el-card class="quick-actions">
      <div slot="header" class="clearfix">
        <span>🚀 快速操作</span>
      </div>
      
      <el-row :gutter="15">
        <el-col :span="6">
          <el-button type="primary" icon="el-icon-edit" size="medium" @click="goToAddQuestion" block>
            手动添加错题
          </el-button>
        </el-col>
        <el-col :span="6">
          <el-button type="success" icon="el-icon-view" size="medium" @click="goToQuestionList" block>
            查看错题列表
          </el-button>
        </el-col>
        <el-col :span="6">
          <el-button type="warning" icon="el-icon-camera" size="medium" @click="goToCameraAdd" block>
            拍照识别题目
          </el-button>
        </el-col>
        <el-col :span="6">
          <el-button type="info" icon="el-icon-download" size="medium" @click="exportQuestions" block>
            导出错题数据
          </el-button>
        </el-col>
      </el-row>
    </el-card>

    <!-- 最近错题展示 -->
    <el-card class="recent-questions">
      <div slot="header" class="clearfix">
        <span>📚 最近添加的错题</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="goToQuestionList">
          查看全部 <i class="el-icon-arrow-right"></i>
        </el-button>
      </div>
      
      <div v-if="recentQuestions.length === 0" class="empty-state">
        <i class="el-icon-document"></i>
        <p>还没有添加错题，点击上方按钮开始添加吧！</p>
      </div>
      
      <div v-else>
        <el-table :data="recentQuestions" style="width: 100%">
          <el-table-column prop="questionContent" label="题目内容" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <div class="question-preview">
                {{ scope.row.questionContent.length > 50 ? scope.row.questionContent.substring(0, 50) + '...' : scope.row.questionContent }}
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="questionType" label="类型" width="100">
            <template slot-scope="scope">
              <el-tag :type="getTypeTagType(scope.row.questionType)" size="small">
                {{ scope.row.questionType }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="tags" label="标签" width="150">
            <template slot-scope="scope">
              <el-tag v-for="tag in getTagsArray(scope.row.tags)" :key="tag" size="mini" style="margin-right: 5px;">
                {{ tag }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="添加时间" width="180">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}') }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120">
            <template slot-scope="scope">
              <el-button size="mini" type="text" @click="viewQuestion(scope.row)">查看</el-button>
              <el-button size="mini" type="text" @click="editQuestion(scope.row)">编辑</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>

    <!-- 拍照识别对话框 -->
    <el-dialog title="📷 拍照识别题目" :visible.sync="cameraDialogVisible" width="600px" :close-on-click-modal="false">
      <div class="camera-section">
        <div class="camera-tip">
          <i class="el-icon-camera"></i>
          <p>点击下方按钮调用手机相机拍照</p>
          <p class="tip-text">支持识别数学公式、文字内容等</p>
        </div>
        
        <el-upload
          class="camera-uploader"
          :action="uploadUrl"
          :headers="uploadHeaders"
          :show-file-list="false"
          :on-success="handleCameraSuccess"
          :before-upload="beforeCameraUpload"
          accept="image/*"
          capture="camera"
        >
          <el-button type="primary" size="large" icon="el-icon-camera">
            点击拍照识别
          </el-button>
        </el-upload>
        
        <div v-if="cameraResult" class="camera-result">
          <h4>识别结果：</h4>
          <el-input
            type="textarea"
            :rows="4"
            v-model="cameraResult"
            placeholder="识别结果将显示在这里..."
          ></el-input>
          <div style="margin-top: 10px;">
            <el-button type="primary" @click="useCameraResult">使用识别结果</el-button>
            <el-button @click="cameraResult = ''">重新识别</el-button>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listQuestion } from "@/api/trouble/question";
import { getToken } from "@/utils/auth";

export default {
  name: "TroubleDashboard",
  data() {
    return {
      // 统计数据
      stats: {
        totalQuestions: 0,
        todayQuestions: 0,
        thisWeekQuestions: 0,
        tagsCount: 0
      },
      // 最近错题
      recentQuestions: [],
      // 拍照对话框
      cameraDialogVisible: false,
      cameraResult: '',
      // 上传配置
      uploadUrl: process.env.VUE_APP_BASE_API + "/common/upload",
      uploadHeaders: {
        Authorization: "Bearer " + getToken()
      }
    };
  },
  created() {
    this.loadData();
  },
  methods: {
    /** 加载数据 */
    loadData() {
      this.loadStats();
      this.loadRecentQuestions();
    },
    
    /** 加载统计数据 */
    loadStats() {
      // 模拟统计数据，实际应该调用API
      this.stats = {
        totalQuestions: 15,
        todayQuestions: 3,
        thisWeekQuestions: 8,
        tagsCount: 12
      };
    },
    
    /** 加载最近错题 */
    loadRecentQuestions() {
      listQuestion({ pageNum: 1, pageSize: 5 }).then(response => {
        this.recentQuestions = response.rows || [];
      }).catch(() => {
        this.recentQuestions = [];
      });
    },
    
    /** 刷新数据 */
    refreshData() {
      this.loadData();
      this.$message.success('数据已刷新');
    },
    
    /** 跳转到添加错题页面 */
    goToAddQuestion() {
      this.$router.push('/trouble/question/add');
    },
    
    /** 跳转到错题列表 */
    goToQuestionList() {
      this.$router.push('/trouble/question');
    },
    
    /** 打开拍照识别对话框 */
    goToCameraAdd() {
      this.cameraDialogVisible = true;
      this.cameraResult = '';
    },
    
    /** 查看错题详情 */
    viewQuestion(row) {
      this.$router.push({
        path: '/trouble/question',
        query: { id: row.questionId }
      });
    },
    
    /** 编辑错题 */
    editQuestion(row) {
      this.$router.push({
        path: '/trouble/question',
        query: { edit: row.questionId }
      });
    },
    
    /** 导出错题 */
    exportQuestions() {
      this.$router.push('/trouble/question');
      this.$nextTick(() => {
        // 触发导出功能
        this.$message.info('请在错题列表页面点击导出按钮');
      });
    },
    
    /** 拍照上传前检查 */
    beforeCameraUpload(file) {
      const isImage = file.type.indexOf('image/') === 0;
      const isLt10M = file.size / 1024 / 1024 < 10;
      
      if (!isImage) {
        this.$message.error('只能上传图片文件!');
        return false;
      }
      if (!isLt10M) {
        this.$message.error('上传图片大小不能超过 10MB!');
        return false;
      }
      return true;
    },
    
    /** 拍照识别成功 */
    handleCameraSuccess(response, file) {
      if (response.code === 200) {
        // 模拟OCR识别结果
        this.cameraResult = `识别到的题目内容：\n${response.data || '这是一道数学题，请计算...'}`;
        this.$message.success('图片上传成功，正在识别...');
      } else {
        this.$message.error(response.msg || '图片上传失败');
      }
    },
    
    /** 使用识别结果 */
    useCameraResult() {
      this.cameraDialogVisible = false;
      this.$router.push({
        path: '/trouble/question/add',
        query: { content: this.cameraResult }
      });
    },
    
    /** 获取类型标签样式 */
    getTypeTagType(type) {
      const typeMap = {
        '选择题': 'success',
        '填空题': 'warning',
        '解答题': 'danger',
        '未区分': 'info'
      };
      return typeMap[type] || 'info';
    },
    
    /** 获取标签数组 */
    getTagsArray(tags) {
      if (!tags) return [];
      return tags.split(',').filter(tag => tag.trim());
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
}

.welcome-card {
  margin-bottom: 20px;
}

.welcome-title {
  font-size: 24px;
  font-weight: bold;
  color: #409EFF;
}

.welcome-content {
  margin-top: 20px;
}

.welcome-desc {
  font-size: 16px;
  color: #666;
  line-height: 1.6;
  margin-bottom: 30px;
}

.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  text-align: center;
  border: 1px solid #e4e7ed;
  transition: all 0.3s;
}

.stat-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.stat-content {
  position: relative;
  padding: 20px;
}

.stat-number {
  font-size: 32px;
  font-weight: bold;
  color: #409EFF;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 14px;
  color: #666;
  margin-bottom: 10px;
}

.stat-icon {
  position: absolute;
  top: 20px;
  right: 20px;
  font-size: 24px;
  color: #c0c4cc;
}

.function-row {
  margin-bottom: 20px;
}

.function-card {
  cursor: pointer;
  transition: all 0.3s;
  border: 1px solid #e4e7ed;
}

.function-card:hover {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
  transform: translateY(-3px);
}

.function-content {
  text-align: center;
  padding: 30px 20px;
}

.function-icon {
  font-size: 48px;
  color: #409EFF;
  margin-bottom: 15px;
}

.function-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  margin-bottom: 10px;
}

.function-desc {
  font-size: 14px;
  color: #666;
  margin-bottom: 20px;
  line-height: 1.5;
}

.function-btn {
  width: 100%;
}

.quick-actions {
  margin-bottom: 20px;
}

.recent-questions {
  margin-bottom: 20px;
}

.empty-state {
  text-align: center;
  padding: 40px;
  color: #999;
}

.empty-state i {
  font-size: 48px;
  margin-bottom: 15px;
  display: block;
}

.question-preview {
  max-width: 300px;
  word-break: break-all;
}

.camera-section {
  text-align: center;
  padding: 20px;
}

.camera-tip {
  margin-bottom: 30px;
}

.camera-tip i {
  font-size: 48px;
  color: #409EFF;
  margin-bottom: 15px;
  display: block;
}

.tip-text {
  color: #999;
  font-size: 12px;
  margin-top: 5px;
}

.camera-uploader {
  margin-bottom: 20px;
}

.camera-result {
  margin-top: 20px;
  text-align: left;
}

.camera-result h4 {
  margin-bottom: 10px;
  color: #333;
}

.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}
.clearfix:after {
  clear: both;
}
</style>
