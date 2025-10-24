<template>
  <div class="app-container">
    <el-card class="welcome-card">
      <div slot="header" class="clearfix">
        <span class="welcome-title">🎯 错题征服者</span>
        <el-button class="refresh-btn" type="text" @click="refreshData">
          <i class="el-icon-refresh"></i>
        </el-button>
      </div>

      <div class="welcome-content">
        <p class="welcome-desc">
          专为中小学生设计的智能错题管理系统，帮助用户高效管理错题、提升学习效率。
        </p>

        <!-- 统计卡片 -->
        <el-row :gutter="10" class="stats-row">
          <el-col :xs="12" :sm="6" :md="6" :lg="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-number">{{ stats.totalQuestions }}</div>
                <div class="stat-label">总错题数</div>
                <i class="el-icon-document stat-icon"></i>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="12" :sm="6" :md="6" :lg="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-number">{{ stats.todayQuestions }}</div>
                <div class="stat-label">今日新增</div>
                <i class="el-icon-plus stat-icon"></i>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="12" :sm="6" :md="6" :lg="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-number">{{ stats.thisWeekQuestions }}</div>
                <div class="stat-label">本周新增</div>
                <i class="el-icon-date stat-icon"></i>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="12" :sm="6" :md="6" :lg="6">
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
    <el-row :gutter="10" class="function-row">
      <el-col :xs="24" :sm="8" :md="8" :lg="8">
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

      <el-col :xs="24" :sm="8" :md="8" :lg="8">
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

      <el-col :xs="24" :sm="8" :md="8" :lg="8">
        <el-card class="function-card" shadow="hover" @click.native="goToCameraAdd">
          <div class="function-content">
            <div class="function-icon">
              <i class="el-icon-camera"></i>
            </div>
            <div class="function-title">拍照添加</div>
            <div class="function-desc">拍照记录错题，更快更方便</div>
            <el-button type="warning" size="medium" class="function-btn">
              <i class="el-icon-camera"></i> 拍照
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

      <el-row :gutter="10">
        <el-col :xs="12" :sm="6" :md="6" :lg="6">
          <el-button type="primary" icon="el-icon-edit" size="small" @click="goToAddQuestion" block class="quick-btn">
            <span class="btn-text">手动添加</span>
          </el-button>
        </el-col>
        <el-col :xs="12" :sm="6" :md="6" :lg="6">
          <el-button type="success" icon="el-icon-view" size="small" @click="goToQuestionList" block class="quick-btn">
            <span class="btn-text">查看列表</span>
          </el-button>
        </el-col>
        <el-col :xs="12" :sm="6" :md="6" :lg="6">
          <el-button type="warning" icon="el-icon-camera" size="small" @click="goToCameraAdd" block class="quick-btn">
            <span class="btn-text">拍照添加</span>
          </el-button>
        </el-col>
        <el-col :xs="12" :sm="6" :md="6" :lg="6">
          <el-button type="info" icon="el-icon-download" size="small" @click="exportQuestions" block class="quick-btn">
            <span class="btn-text">导出数据</span>
          </el-button>
        </el-col>
      </el-row>
    </el-card>

    <!-- 最近错题展示 -->
    <el-card class="recent-questions">
      <div slot="header" class="clearfix">
        <span>📚 最近添加的错题</span>
        <el-button class="view-all-btn" type="text" @click="goToQuestionList">
          查看全部 <i class="el-icon-arrow-right"></i>
        </el-button>
      </div>

      <div v-if="recentQuestions.length === 0" class="empty-state">
        <i class="el-icon-document"></i>
        <p>还没有添加错题，点击上方按钮开始添加吧！</p>
      </div>

      <div v-else class="questions-wrapper">
        <!-- 桌面端表格 -->
        <el-table :data="recentQuestions" class="desktop-table">
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

        <!-- 移动端卡片 -->
        <div class="mobile-cards">
          <div v-for="item in recentQuestions" :key="item.questionId" class="question-card">
            <div class="question-card-content">
              <div class="question-text">{{ item.questionContent.length > 80 ? item.questionContent.substring(0, 80) + '...' : item.questionContent }}</div>
              <div class="question-meta">
                <el-tag :type="getTypeTagType(item.questionType)" size="mini">{{ item.questionType }}</el-tag>
                <el-tag v-for="tag in getTagsArray(item.tags).slice(0, 2)" :key="tag" size="mini" style="margin-left: 5px;">
                  {{ tag }}
                </el-tag>
              </div>
              <div class="question-time">{{ parseTime(item.createTime, '{y}-{m}-{d} {h}:{i}') }}</div>
            </div>
            <div class="question-card-actions">
              <el-button size="mini" type="text" @click="viewQuestion(item)">查看</el-button>
              <el-button size="mini" type="text" @click="editQuestion(item)">编辑</el-button>
            </div>
          </div>
        </div>
      </div>
    </el-card>

    <!-- 拍照对话框 -->
    <el-dialog title="📷 拍照添加题目" :visible.sync="cameraDialogVisible" :width="dialogWidth" :close-on-click-modal="false">
      <div class="camera-section">
        <div class="camera-tip">
          <i class="el-icon-camera"></i>
          <p>点击下方按钮调用手机相机拍照</p>
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
          <el-button type="primary" size="large" icon="el-icon-camera" block>
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
          <div class="camera-actions">
            <el-button type="primary" @click="useCameraResult" size="small">使用识别结果</el-button>
            <el-button @click="cameraResult = ''" size="small">重新识别</el-button>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listQuestion } from "@/api/trouble/question";
import { getTroubleStatistics } from "@/api/trouble/statistics";
import { getToken } from "@/utils/auth";

export default {
  name: "TroubleDashboard",
  data() {
    return {
      stats: {
        totalQuestions: 0,
        todayQuestions: 0,
        thisWeekQuestions: 0,
        tagsCount: 0
      },
      recentQuestions: [],
      cameraDialogVisible: false,
      cameraResult: '',
      uploadUrl: process.env.VUE_APP_BASE_API + "/common/upload",
      uploadHeaders: {
        Authorization: "Bearer " + getToken()
      }
    };
  },
  computed: {
    dialogWidth() {
      return window.innerWidth < 768 ? '95%' : '600px';
    }
  },
  created() {
    this.loadData();
  },
  methods: {
    loadData() {
      this.loadStats();
      this.loadRecentQuestions();
    },
    loadStats() {
      getTroubleStatistics().then(response => {
        if (response.code === 200) {
          this.stats = {
            totalQuestions: response.data.totalQuestions || 0,
            todayQuestions: response.data.todayQuestions || 0,
            thisWeekQuestions: response.data.thisWeekQuestions || 0,
            tagsCount: response.data.tagsCount || 0
          };
        }
      }).catch(() => {
        this.stats = {
          totalQuestions: 0,
          todayQuestions: 0,
          thisWeekQuestions: 0,
          tagsCount: 0
        };
      });
    },
    loadRecentQuestions() {
      listQuestion({ pageNum: 1, pageSize: 5 }).then(response => {
        this.recentQuestions = response.rows || [];
      }).catch(() => {
        this.recentQuestions = [];
      });
    },
    refreshData() {
      this.loadData();
      this.$message.success('数据已刷新');
    },
    goToAddQuestion() {
      this.$router.push('/trouble/question/add');
    },
    goToQuestionList() {
      this.$router.push('/trouble/question');
    },
    goToCameraAdd() {
      this.cameraDialogVisible = true;
      this.cameraResult = '';
    },
    viewQuestion(row) {
      this.$router.push({
        path: '/trouble/question',
        query: { id: row.questionId }
      });
    },
    editQuestion(row) {
      this.$router.push({
        path: '/trouble/question',
        query: { edit: row.questionId }
      });
    },
    exportQuestions() {
      this.$router.push('/trouble/question');
      this.$nextTick(() => {
        this.$message.info('请在错题列表页面点击导出按钮');
      });
    },
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
    getTypeTagType(type) {
      const typeMap = {
        '选择题': 'success',
        '填空题': 'warning',
        '解答题': 'danger',
        '未区分': 'info'
      };
      return typeMap[type] || 'info';
    },
    getTagsArray(tags) {
      if (!tags) return [];
      return tags.split(',').filter(tag => tag.trim());
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 10px;
}

.welcome-card {
  margin-bottom: 15px;
}

.welcome-title {
  font-size: 18px;
  font-weight: bold;
  color: #409EFF;
}

.refresh-btn {
  float: right;
  padding: 3px 0;
}

.welcome-content {
  margin-top: 15px;
}

.welcome-desc {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  margin-bottom: 20px;
}

.stats-row {
  margin-bottom: 15px;
}

.stat-card {
  text-align: center;
  border: 1px solid #e4e7ed;
  transition: all 0.3s;
  margin-bottom: 10px;
}

.stat-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.stat-content {
  position: relative;
  padding: 15px 10px;
}

.stat-number {
  font-size: 24px;
  font-weight: bold;
  color: #409EFF;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 12px;
  color: #666;
  margin-bottom: 5px;
}

.stat-icon {
  position: absolute;
  top: 15px;
  right: 15px;
  font-size: 20px;
  color: #c0c4cc;
}

.function-row {
  margin-bottom: 15px;
}

.function-card {
  cursor: pointer;
  transition: all 0.3s;
  border: 1px solid #e4e7ed;
  margin-bottom: 10px;
}

.function-card:hover {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
  transform: translateY(-3px);
}

.function-content {
  text-align: center;
  padding: 20px 15px;
}

.function-icon {
  font-size: 36px;
  color: #409EFF;
  margin-bottom: 10px;
}

.function-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-bottom: 8px;
}

.function-desc {
  font-size: 13px;
  color: #666;
  margin-bottom: 15px;
  line-height: 1.5;
}

.function-btn {
  width: 100%;
}

.quick-actions {
  margin-bottom: 15px;
}

.quick-btn {
  margin-bottom: 10px;
}

.recent-questions {
  margin-bottom: 15px;
}

.view-all-btn {
  float: right;
  padding: 3px 0;
}

.empty-state {
  text-align: center;
  padding: 30px;
  color: #999;
}

.empty-state i {
  font-size: 48px;
  margin-bottom: 15px;
  display: block;
}

.questions-wrapper {
  width: 100%;
}

.desktop-table {
  display: none;
}

.mobile-cards {
  display: block;
}

.question-card {
  background: #f9f9f9;
  border-radius: 8px;
  padding: 12px;
  margin-bottom: 10px;
  border: 1px solid #e4e7ed;
}

.question-card-content {
  margin-bottom: 10px;
}

.question-text {
  font-size: 14px;
  color: #333;
  margin-bottom: 8px;
  line-height: 1.5;
}

.question-meta {
  margin-bottom: 8px;
}

.question-time {
  font-size: 12px;
  color: #999;
}

.question-card-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.camera-section {
  text-align: center;
  padding: 15px;
}

.camera-tip {
  margin-bottom: 20px;
}

.camera-tip i {
  font-size: 48px;
  color: #409EFF;
  margin-bottom: 10px;
  display: block;
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
  font-size: 14px;
}

.camera-actions {
  margin-top: 10px;
  display: flex;
  gap: 10px;
  justify-content: center;
}

.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}

.clearfix:after {
  clear: both;
}

/* 平板设备 */
@media (min-width: 768px) {
  .app-container {
    padding: 15px;
  }

  .welcome-title {
    font-size: 20px;
  }

  .stat-number {
    font-size: 28px;
  }

  .stat-label {
    font-size: 13px;
  }

  .function-icon {
    font-size: 42px;
  }

  .function-title {
    font-size: 17px;
  }

  .desktop-table {
    display: table;
  }

  .mobile-cards {
    display: none;
  }
}

/* 桌面设备 */
@media (min-width: 1024px) {
  .app-container {
    padding: 20px;
  }

  .welcome-title {
    font-size: 24px;
  }

  .welcome-desc {
    font-size: 16px;
  }

  .stat-content {
    padding: 20px;
  }

  .stat-number {
    font-size: 32px;
  }

  .stat-label {
    font-size: 14px;
  }

  .stat-icon {
    font-size: 24px;
  }

  .function-content {
    padding: 30px 20px;
  }

  .function-icon {
    font-size: 48px;
  }

  .function-title {
    font-size: 18px;
  }

  .function-desc {
    font-size: 14px;
  }

  .btn-text {
    display: inline;
  }
}

/* 小屏幕优化 */
@media (max-width: 767px) {
  .btn-text {
    display: none;
  }

  .quick-btn {
    padding: 8px 10px;
  }

  .camera-actions {
    flex-direction: column;
  }

  .camera-actions .el-button {
    width: 100%;
  }
}
</style>