<template>
  <div class="app-container">
    <el-card class="welcome-card">
      <div slot="header" class="clearfix header-row">
        <span class="welcome-title">🎯 错题征服者 - 智能错题管理系统</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="refreshData">
          <i class="el-icon-refresh"></i> 刷新 (Refresh)
        </el-button>
      </div>

      <div class="welcome-content">
        <p class="welcome-desc">
          专为中小学生设计的智能错题管理系统，帮助用户高效管理错题、提升学习效率。
          支持文本输入和拍照识别添加错题，智能分类管理，多维度统计分析。
        </p>

        <!-- 统计卡片：响应式列设置 -->
        <el-row :gutter="16" class="stats-row">
          <el-col :xs="24" :sm="12" :md="6" v-for="(item, idx) in statItems" :key="idx">
            <el-card class="stat-card" shadow="hover">
              <div class="stat-content">
                <div class="stat-number">{{ item.value }}</div>
                <div class="stat-label">{{ item.label }}</div>
                <i :class="item.icon" class="stat-icon"></i>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </el-card>

    <!-- 功能按钮区域：响应式 -->
    <el-row :gutter="16" class="function-row">
      <el-col :xs="24" :sm="12" :md="8">
        <el-card class="function-card" shadow="hover" @click.native="goToAddQuestion">
          <div class="function-content">
            <div class="function-icon"><i class="el-icon-edit-outline"></i></div>
            <div class="function-title">添加错题 (Add)</div>
            <div class="function-desc">手动输入题目内容，支持文本和图片</div>
            <el-button type="primary" size="medium" class="function-btn" @click.stop="goToAddQuestion">
              <i class="el-icon-edit"></i> 立即添加 (Add Now)
            </el-button>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="24" :sm="12" :md="8">
        <el-card class="function-card" shadow="hover" @click.native="goToQuestionList">
          <div class="function-content">
            <div class="function-icon"><i class="el-icon-view"></i></div>
            <div class="function-title">查看错题 (List)</div>
            <div class="function-desc">浏览和管理已添加的错题</div>
            <el-button type="success" size="medium" class="function-btn" @click.stop="goToQuestionList">
              <i class="el-icon-view"></i> 查看列表 (View)
            </el-button>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="24" :sm="24" :md="8">
        <el-card class="function-card" shadow="hover" @click.native="goToCameraAdd">
          <div class="function-content">
            <div class="function-icon"><i class="el-icon-camera"></i></div>
            <div class="function-title">拍照添加 (Camera)</div>
            <div class="function-desc">拍照识别题目，智能提取内容</div>
            <el-button type="warning" size="medium" class="function-btn" @click.stop="goToCameraAdd">
              <i class="el-icon-camera"></i> 拍照识别 (Scan)
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 快速操作区域 -->
    <el-card class="quick-actions">
      <div slot="header" class="clearfix">
        <span>🚀 快速操作 (Quick Actions)</span>
      </div>

      <el-row :gutter="12" class="quick-row">
        <el-col :xs="12" :sm="6"><el-button type="primary" icon="el-icon-edit" size="medium" @click="goToAddQuestion" block>手动添加 (Add)</el-button></el-col>
        <el-col :xs="12" :sm="6"><el-button type="success" icon="el-icon-view" size="medium" @click="goToQuestionList" block>查看列表 (List)</el-button></el-col>
        <el-col :xs="12" :sm="6"><el-button type="warning" icon="el-icon-camera" size="medium" @click="goToCameraAdd" block>拍照识别 (Camera)</el-button></el-col>
        <el-col :xs="12" :sm="6"><el-button type="info" icon="el-icon-download" size="medium" @click="exportQuestions" block>导出数据 (Export)</el-button></el-col>
      </el-row>
    </el-card>

    <!-- 最近错题展示：桌面显示表格，移动端显示卡片列表 -->
    <el-card class="recent-questions">
      <div slot="header" class="clearfix">
        <span>📚 最近添加的错题 (Recent)</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="goToQuestionList">
          查看全部 (View All) <i class="el-icon-arrow-right"></i>
        </el-button>
      </div>

      <div v-if="recentQuestions.length === 0" class="empty-state">
        <i class="el-icon-document"></i>
        <p>还没有添加错题，点击上方按钮开始添加吧！</p>
      </div>

      <div v-else>
        <!-- 手机端卡片列表 -->
        <div v-if="isMobile" class="mobile-list">
          <el-row :gutter="12">
            <el-col :span="24" v-for="q in recentQuestions" :key="q.questionId">
              <el-card class="mobile-question-card" shadow="never">
                <div class="mobile-card-header">
                  <div class="mobile-card-title">{{ truncate(q.questionContent, 120) }}</div>
                  <div class="mobile-card-meta">{{ parseTime(q.createTime, '{y}-{m}-{d} {h}:{i}') }}</div>
                </div>
                <div class="mobile-card-body">
                  <el-tag :type="getTypeTagType(q.questionType)" size="mini">{{ q.questionType }}</el-tag>
                  <div class="mobile-tags">
                    <el-tag v-for="tag in getTagsArray(q.tags)" :key="tag" size="mini">{{ tag }}</el-tag>
                  </div>
                </div>
                <div class="mobile-card-actions">
                  <el-button size="mini" type="text" @click="viewQuestion(q)">查看 (View)</el-button>
                  <el-button size="mini" type="text" @click="editQuestion(q)">编辑 (Edit)</el-button>
                </div>
              </el-card>
            </el-col>
          </el-row>
        </div>

        <!-- 桌面端表格 -->
        <div v-else class="desktop-table-wrapper">
          <el-table :data="recentQuestions" style="width: 100%" :stripe="true" :border="true">
            <el-table-column prop="questionContent" label="题目内容" :show-overflow-tooltip="true">
              <template #default="{ row }">
                <div class="question-preview">
                  {{ row.questionContent.length > 80 ? row.questionContent.substring(0, 80) + '...' : row.questionContent }}
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="questionType" label="类型" width="120">
              <template #default="{ row }">
                <el-tag :type="getTypeTagType(row.questionType)" size="small">{{ row.questionType }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="tags" label="标签" width="200">
              <template #default="{ row }">
                <el-tag v-for="tag in getTagsArray(row.tags)" :key="tag" size="mini" style="margin-right: 5px;">{{ tag }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="createTime" label="添加时间" width="180">
              <template #default="{ row }">
                <span>{{ parseTime(row.createTime, '{y}-{m}-{d} {h}:{i}') }}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="140">
              <template #default="{ row }">
                <el-button size="mini" type="text" @click="viewQuestion(row)">查看 (View)</el-button>
                <el-button size="mini" type="text" @click="editQuestion(row)">编辑 (Edit)</el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </div>
    </el-card>

    <!-- 拍照识别对话框（宽度和布局在小屏优化） -->
    <el-dialog title="📷 拍照识别题目 (Camera Scan)" :visible.sync="cameraDialogVisible" :width="cameraDialogWidth" :close-on-click-modal="false">
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
          <el-button type="primary" size="large" icon="el-icon-camera">点击拍照识别 (Take Photo)</el-button>
        </el-upload>

        <div v-if="cameraResult" class="camera-result">
          <h4>识别结果 (Result)：</h4>
          <el-input type="textarea" :rows="4" v-model="cameraResult" placeholder="识别结果将显示在这里..."></el-input>
          <div style="margin-top: 10px;">
            <el-button type="primary" @click="useCameraResult">使用识别结果 (Use)</el-button>
            <el-button @click="cameraResult = ''">重新识别 (Retry)</el-button>
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
      },
      // 响应式标志
      isMobile: false
    };
  },
  computed: {
    statItems() {
      return [
        { label: "总错题数", value: this.stats.totalQuestions, icon: "el-icon-document" },
        { label: "今日新增", value: this.stats.todayQuestions, icon: "el-icon-plus" },
        { label: "本周新增", value: this.stats.thisWeekQuestions, icon: "el-icon-date" },
        { label: "标签数量", value: this.stats.tagsCount, icon: "el-icon-collection-tag" }
      ];
    },
    // 弹窗宽度根据屏幕切换
    cameraDialogWidth() {
      return this.isMobile ? "95%" : "600px";
    }
  },
  created() {
    this.loadData();
    this.checkIsMobile();
    window.addEventListener("resize", this.checkIsMobile);
  },
  beforeDestroy() {
    window.removeEventListener("resize", this.checkIsMobile);
  },
  methods: {
    /** 检测移动端：使用 matchMedia 判定 */
    checkIsMobile() {
      // 视口宽度小于 768 视为移动端
      this.isMobile = window.matchMedia("(max-width: 767px)").matches;
    },

    /** 加载数据 */
    loadData() {
      this.loadStats();
      this.loadRecentQuestions();
    },

    /** 加载统计数据 */
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
        this.stats = { totalQuestions: 0, todayQuestions: 0, thisWeekQuestions: 0, tagsCount: 0 };
      });
    },

    /** 加载最近错题 */
    loadRecentQuestions() {
      listQuestion({ pageNum: 1, pageSize: 5 }).then(response => {
        this.recentQuestions = response.rows || [];
      }).catch(() => {
        this.recentQuestions = [];
      });
    },

    refreshData() {
      this.loadData();
      this.$message.success('数据已刷新 (Refreshed)');
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
      this.$router.push({ path: '/trouble/question', query: { id: row.questionId } });
    },

    editQuestion(row) {
      this.$router.push({ path: '/trouble/question', query: { edit: row.questionId } });
    },

    exportQuestions() {
      this.$router.push('/trouble/question');
      this.$nextTick(() => {
        this.$message.info('请在错题列表页面点击导出按钮 (Please use Export on list)');
      });
    },

    beforeCameraUpload(file) {
      const isImage = file.type.indexOf('image/') === 0;
      const isLt10M = file.size / 1024 / 1024 < 10;

      if (!isImage) {
        this.$message.error('只能上传图片文件! (Only images allowed)');
        return false;
      }
      if (!isLt10M) {
        this.$message.error('上传图片大小不能超过 10MB! (Max 10MB)');
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
    },

    handleCameraSuccess(response, file) {
      // 假设后端返回 { code:200, data:{ text: '识别文本' } }
      if (response && response.code === 200) {
        this.cameraResult = response.data && response.data.text ? response.data.text : '';
      } else if (typeof response === 'string') {
        // 某些后端直接返回文本
        this.cameraResult = response;
      } else {
        this.$message.error('识别失败 (Recognition failed)');
      }
    },

    useCameraResult() {
      // 将识别结果带到添加错题页面（示例做法）
      this.cameraDialogVisible = false;
      this.$router.push({ path: '/trouble/question/add', query: { content: this.cameraResult } });
    },

    truncate(text, n = 100) {
      if (!text) return '';
      return text.length > n ? text.substring(0, n) + '...' : text;
    },

    // 时间格式化函数：保持与现有 parseTime 调用一致（如果项目已有全局工具可替换）
    parseTime(time, cFormat) {
      if (!time) return '';
      const format = cFormat || '{y}-{m}-{d} {h}:{i}:{s}';
      let date = typeof time === 'object' ? time : new Date(time);
      const formatObj = {
        y: date.getFullYear(),
        m: date.getMonth() + 1,
        d: date.getDate(),
        h: date.getHours(),
        i: date.getMinutes(),
        s: date.getSeconds(),
        a: date.getDay()
      };
      return format.replace(/{([ymdhisa])+}/g, (result, key) => {
        let value = formatObj[key];
        if (key === 'a') return ['日', '一', '二', '三', '四', '五', '六'][value];
        return value < 10 ? '0' + value : value;
      });
    }
  }
};
</script>

<style scoped>
/* 基础布局 */
.app-container {
  padding: 16px;
  max-width: 1200px;
  margin: 0 auto;
  box-sizing: border-box;
}

/* header 自适应 */
.header-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}

/* 欢迎描述 */
.welcome-desc {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  margin-bottom: 20px;
}

/* 统计卡片风格 */
.stat-card {
  text-align: left;
  border: 1px solid #e4e7ed;
  transition: all 0.18s;
  padding: 12px;
}
.stat-content {
  position: relative;
  padding-right: 36px;
}
.stat-number { font-size: 22px; font-weight: 700; color: #409EFF; margin-bottom: 6px; }
.stat-label { font-size: 13px; color: #666; }
.stat-icon { position: absolute; top: 12px; right: 8px; font-size: 20px; color: #c0c4cc; }

/* 功能卡片 */
.function-card { cursor: pointer; border: 1px solid #e4e7ed; }
.function-content { text-align: center; padding: 18px; }
.function-icon { font-size: 40px; color: #409EFF; margin-bottom: 10px; }
.function-title { font-size: 16px; font-weight: 600; margin-bottom: 6px; }
.function-desc { font-size: 13px; color: #666; margin-bottom: 12px; }
.function-btn { width: 100%; }

/* 快速操作 */
.quick-actions { margin-top: 18px; margin-bottom: 18px; }
.quick-row .el-button { margin-bottom: 8px; }

/* 最近错题 - 桌面表格 */
.desktop-table-wrapper { overflow-x: auto; }

/* 移动端卡片列表 */
.mobile-list { padding: 8px 0; }
.mobile-question-card { margin-bottom: 12px; }
.mobile-card-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:8px; gap:8px; }
.mobile-card-title { font-weight:600; word-break:break-word; }
.mobile-card-meta { color:#999; font-size:12px; white-space:nowrap; }
.mobile-card-body { display:flex; flex-wrap:wrap; gap:6px; align-items:center; margin-bottom:8px; }
.mobile-card-actions { text-align:right; }

/* 空状态 */
.empty-state { text-align:center; padding: 28px 12px; color:#999; }
.empty-state i { font-size:36px; margin-bottom:8px; display:block; }

/* 相机区 */
.camera-section { text-align:center; padding: 12px; }
.camera-tip i { font-size:36px; color:#409EFF; margin-bottom:8px; display:block; }
.camera-result { margin-top:12px; text-align:left; }

/* 响应式微调 */
@media (max-width: 767px) {
  .app-container { padding: 12px; }
  .welcome-title { font-size: 18px; }
  .stat-number { font-size: 20px; }
  .function-icon { font-size: 36px; }
  .function-content { padding: 14px; }
  .desktop-table-wrapper { display: none; } /* 隐藏桌面表格 */
  .mobile-list { display: block; }
  .el-dialog__wrapper { align-items: flex-end; } /* 对话框靠下更像移动端体验 */
}

@media (min-width: 768px) {
  .mobile-list { display: none; } /* 隐藏移动卡片列表 */
}
</style>
