<template>
  <div class="app-container">
    <!-- 顶部导航栏 -->
    <div class="top-navbar">
      <div class="navbar-content">
        <div class="navbar-left">
          <h1 class="app-title">错题征服者</h1>
        </div>
        <div class="navbar-right">
          <span class="user-name">{{ userName }}</span>
          <el-button type="text" class="logout-btn" @click="handleLogout">
            <i class="el-icon-switch-button"></i> 退出登录
          </el-button>
        </div>
      </div>
    </div>

    <el-card class="welcome-card">
      <div slot="header" class="clearfix header-row">
        <span class="welcome-title">Dashboard</span>
        <el-button
          style="padding: 3px 0; margin-left: auto"
          type="text"
          @click="refreshData"
          class="refresh-btn"
        >
          <i class="el-icon-refresh"></i> 刷新
        </el-button>
      </div>

      <div class="welcome-content">
        <!-- 统计卡片 -->
        <el-row :gutter="16" class="stats-row">
          <el-col
            :xs="12"
            :sm="12"
            :md="6"
            :lg="6"
            v-for="(item, idx) in statItems"
            :key="idx"
          >
            <el-card
              class="stat-card"
              :class="{ 'stat-card-clickable': item.clickable }"
              shadow="hover"
              @click.native="item.onClick ? item.onClick() : null"
            >
              <div class="stat-content">
                <div class="stat-number">{{ item.value }}</div>
                <div class="stat-label">{{ item.label }}</div>
                <i :class="item.icon" class="stat-icon"></i>
                <i
                  v-if="item.clickable"
                  class="el-icon-d-arrow-right stat-arrow"
                ></i>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </el-card>

    <!-- 功能按钮区域 -->
    <el-card class="function-card-wrapper">
      <el-row :gutter="16" class="function-row">
        <el-col :xs="8" :sm="8" :md="8" :lg="8">
          <div
            class="function-item function-item-primary"
            @click="goToAddQuestion"
          >
            <div class="function-icon">
              <i class="el-icon-edit-outline"></i>
            </div>
            <div class="function-title">添加错题</div>
          </div>
        </el-col>
        <el-col :xs="8" :sm="8" :md="8" :lg="8">
          <div
            class="function-item function-item-success"
            @click="goToQuestionList"
          >
            <div class="function-icon"><i class="el-icon-view"></i></div>
            <div class="function-title">查看错题</div>
          </div>
        </el-col>
        <el-col :xs="8" :sm="8" :md="8" :lg="8">
          <div
            class="function-item function-item-warning"
            @click="goToFavorite"
          >
            <div class="function-icon"><i class="el-icon-star-on"></i></div>
            <div class="function-title">我的收藏</div>
          </div>
        </el-col>
      </el-row>
    </el-card>

    <!-- 最近错题展示：桌面显示表格，移动端显示卡片列表 -->
    <el-card class="recent-questions">
      <div slot="header" class="clearfix">
        <span>📚 最近添加</span>
        <el-button
          style="float: right; padding: 3px 0"
          type="text"
          @click="goToQuestionList"
          class="view-all-btn"
        >
          查看全部 <i class="el-icon-arrow-right"></i>
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
                  <div class="mobile-card-title">
                    {{ truncate(q.questionContent, 100) }}
                  </div>
                  <div class="mobile-card-meta">
                    {{ parseTime(q.createTime, "{y}-{m}-{d} {h}:{i}") }}
                  </div>
                </div>
                <div class="mobile-card-body">
                  <el-tag
                    :type="getTypeTagType(q.questionType)"
                    size="mini"
                    class="mobile-type-tag"
                    >{{ q.questionType }}</el-tag
                  >
                  <div class="mobile-tags" v-if="q.tags">
                    <el-tag
                      v-for="tag in getTagsArray(q.tags).slice(0, 3)"
                      :key="tag"
                      size="mini"
                      class="mobile-tag"
                      >{{ tag }}</el-tag
                    >
                  </div>
                </div>
                <div class="mobile-card-actions">
                  <el-button
                    size="mini"
                    type="text"
                    @click.stop="viewQuestion(q)"
                    >查看</el-button
                  >
                  <el-button
                    size="mini"
                    type="text"
                    @click.stop="editQuestion(q)"
                    >编辑</el-button
                  >
                  <el-button
                    size="mini"
                    type="text"
                    @click.stop="handleFavorite(q)"
                    :style="{ color: q.isFavorite ? '#f56c6c' : '#909399' }"
                    >收藏</el-button
                  >
                  <el-button
                    size="mini"
                    type="text"
                    @click.stop="handleDelete(q)"
                    style="color: #f56c6c"
                    >删除</el-button
                  >
                </div>
              </el-card>
            </el-col>
          </el-row>
        </div>

        <!-- 桌面端表格 -->
        <div v-else class="desktop-table-wrapper">
          <el-table
            :data="recentQuestions"
            style="width: 100%"
            :stripe="true"
            :border="true"
          >
            <el-table-column
              prop="questionContent"
              label="题目内容"
              :show-overflow-tooltip="true"
              min-width="200"
            >
              <template #default="{ row }">
                <div class="question-preview">
                  {{
                    row.questionContent.length > 80
                      ? row.questionContent.substring(0, 80) + "..."
                      : row.questionContent
                  }}
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="questionType" label="类型" width="100">
              <template #default="{ row }">
                <el-tag :type="getTypeTagType(row.questionType)" size="small">{{
                  row.questionType
                }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column
              prop="tags"
              label="标签"
              width="180"
              :show-overflow-tooltip="true"
            >
              <template #default="{ row }">
                <el-tag
                  v-for="tag in getTagsArray(row.tags)"
                  :key="tag"
                  size="mini"
                  style="margin-right: 5px"
                  >{{ tag }}</el-tag
                >
              </template>
            </el-table-column>
            <el-table-column prop="createTime" label="添加时间" width="160">
              <template #default="{ row }">
                <span>{{
                  parseTime(row.createTime, "{y}-{m}-{d} {h}:{i}")
                }}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="200" fixed="right">
              <template #default="{ row }">
                <el-button size="mini" type="text" @click="viewQuestion(row)"
                  >查看</el-button
                >
                <el-button size="mini" type="text" @click="editQuestion(row)"
                  >编辑</el-button
                >
                <el-button
                  size="mini"
                  type="text"
                  @click="handleFavorite(row)"
                  :style="{ color: row.isFavorite ? '#f56c6c' : '#909399' }"
                  >收藏</el-button
                >
                <el-button
                  size="mini"
                  type="text"
                  @click="handleDelete(row)"
                  style="color: #f56c6c"
                  >删除</el-button
                >
              </template>
            </el-table-column>
          </el-table>
        </div>
      </div>
    </el-card>

    <!-- 详情弹窗 -->
    <question-detail
      v-if="selectedQuestion"
      :question="selectedQuestion"
      @close="selectedQuestion = null"
      @refresh="handleQuestionRefresh"
    />

    <!-- 编辑对话框 -->
    <question-edit-dialog
      ref="editDialog"
      :question-id="editQuestionId"
      @success="handleEditSuccess"
    />
  </div>
</template>

<script>
import {
  listQuestion,
  delQuestion,
  favoriteQuestion,
  unfavoriteQuestion,
} from "@/api/trouble/question";
import { getTroubleStatistics } from "@/api/trouble/statistics";
import QuestionEditDialog from "@/views/trouble/question/components/QuestionEditDialog.vue";
import QuestionDetail from "@/views/trouble/question/components/QuestionDetail.vue";
import { mapGetters } from "vuex";

export default {
  name: "TroubleDashboard",
  components: {
    QuestionEditDialog,
    QuestionDetail,
  },
  data() {
    return {
      // 统计数据
      stats: {
        totalQuestions: 0,
        todayQuestions: 0,
        thisWeekQuestions: 0,
        tagsCount: 0,
      },
      // 最近错题
      recentQuestions: [],
      // 响应式标志
      isMobile: false,
      // 选中的错题（用于查看详情）
      selectedQuestion: null,
      // 编辑的错题ID（用于编辑窗口）
      editQuestionId: null,
    };
  },
  computed: {
    ...mapGetters(["name", "nickName"]),
    userName() {
      return this.nickName || this.name || "用户";
    },
    statItems() {
      return [
        {
          label: "总错题数",
          value: this.stats.totalQuestions,
          icon: "el-icon-document",
        },
        {
          label: "今日新增",
          value: this.stats.todayQuestions,
          icon: "el-icon-plus",
        },
        {
          label: "本周新增",
          value: this.stats.thisWeekQuestions,
          icon: "el-icon-date",
          clickable: true,
          onClick: () => this.goToWeeklyChart(),
        },
        {
          label: "标签数量",
          value: this.stats.tagsCount,
          icon: "el-icon-collection-tag",
        },
      ];
    },
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
      getTroubleStatistics()
        .then((response) => {
          if (response.code === 200) {
            this.stats = {
              totalQuestions: response.data.totalQuestions || 0,
              todayQuestions: response.data.todayQuestions || 0,
              thisWeekQuestions: response.data.thisWeekQuestions || 0,
              tagsCount: response.data.tagsCount || 0,
            };
          }
        })
        .catch(() => {
          this.stats = {
            totalQuestions: 0,
            todayQuestions: 0,
            thisWeekQuestions: 0,
            tagsCount: 0,
          };
        });
    },

    /** 加载最近错题 */
    loadRecentQuestions() {
      listQuestion({ pageNum: 1, pageSize: 5 })
        .then((response) => {
          this.recentQuestions = response.rows || [];
        })
        .catch(() => {
          this.recentQuestions = [];
        });
    },

    refreshData() {
      this.loadData();
      this.$message.success("数据已刷新 (Refreshed)");
    },

    goToAddQuestion() {
      this.$router.push("/trouble/question/add");
    },

    goToQuestionList() {
      this.$router.push("/trouble/question/view");
    },

    goToFavorite() {
      this.$router.push("/trouble/favorite");
    },

    goToTrash() {
      this.$router.push("/trouble/trash");
    },

    goToWeeklyChart() {
      this.$router.push("/trouble/weekly-chart");
    },

    viewQuestion(row) {
      this.selectedQuestion = row;
    },

    editQuestion(row) {
      this.selectedQuestion = null;
      this.editQuestionId = row.questionId;
      this.$nextTick(() => {
        if (this.$refs.editDialog) {
          this.$refs.editDialog.open();
        }
      });
    },

    handleFavorite(question) {
      const isFavorite = question.isFavorite;
      const action = isFavorite ? unfavoriteQuestion : favoriteQuestion;
      const actionText = isFavorite ? "取消收藏" : "收藏";

      action(question.questionId)
        .then(() => {
          this.$message.success(`${actionText}成功`);
          question.isFavorite = !isFavorite;
          this.loadRecentQuestions();
        })
        .catch(() => {
          this.$message.error(`${actionText}失败`);
        });
    },

    handleDelete(question) {
      this.$modal
        .confirm("确认要删除该错题吗？")
        .then(() => {
          return delQuestion(question.questionId);
        })
        .then(() => {
          this.$message.success("删除成功");
          this.loadRecentQuestions();
        })
        .catch(() => {});
    },

    handleEditSuccess() {
      this.loadRecentQuestions();
      this.selectedQuestion = null;
      this.editQuestionId = null;
    },

    handleQuestionRefresh() {
      this.loadRecentQuestions();
      if (this.selectedQuestion) {
        const questionId = this.selectedQuestion.questionId;
        this.loadRecentQuestions().then(() => {
          const updatedQuestion = this.recentQuestions.find(
            (q) => q.questionId == questionId
          );
          if (updatedQuestion) {
            this.selectedQuestion = updatedQuestion;
          }
        });
      }
    },

    handleLogout() {
      this.$confirm("确定注销并退出系统吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(() => {
          this.$store.dispatch("LogOut").then(() => {
            location.href = "/index";
          });
        })
        .catch(() => {});
    },

    exportQuestions() {
      this.$router.push("/trouble/question");
      this.$nextTick(() => {
        this.$message.info(
          "请在错题列表页面点击导出按钮 (Please use Export on list)"
        );
      });
    },

    getTypeTagType(type) {
      const typeMap = {
        选择题: "success",
        填空题: "warning",
        解答题: "danger",
        未区分: "info",
      };
      return typeMap[type] || "info";
    },

    getTagsArray(tags) {
      if (!tags) return [];
      return tags.split(",").filter((tag) => tag.trim());
    },

    truncate(text, n = 100) {
      if (!text) return "";
      return text.length > n ? text.substring(0, n) + "..." : text;
    },

    // 时间格式化函数：保持与现有 parseTime 调用一致（如果项目已有全局工具可替换）
    parseTime(time, cFormat) {
      if (!time) return "";
      const format = cFormat || "{y}-{m}-{d} {h}:{i}:{s}";
      let date = typeof time === "object" ? time : new Date(time);
      const formatObj = {
        y: date.getFullYear(),
        m: date.getMonth() + 1,
        d: date.getDate(),
        h: date.getHours(),
        i: date.getMinutes(),
        s: date.getSeconds(),
        a: date.getDay(),
      };
      return format.replace(/{([ymdhisa])+}/g, (result, key) => {
        let value = formatObj[key];
        if (key === "a")
          return ["日", "一", "二", "三", "四", "五", "六"][value];
        return value < 10 ? "0" + value : value;
      });
    },
  },
};
</script>

<style scoped>
/* 基础布局 - 参考收藏页面设计，去掉背景色 */
.app-container {
  padding: 20px;
  max-width: 1400px;
  margin: 0 auto;
  box-sizing: border-box;
  min-height: calc(100vh - 50px);
  background: #f5f5f5;
  position: relative;
  animation: fadeIn 0.4s ease-out;
}

/* 顶部导航栏 */
.top-navbar {
  background: #ffffff;
  border-bottom: 1px solid #e0e0e0;
  padding: 16px 24px;
  position: sticky;
  top: 0;
  z-index: 1000;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  margin-bottom: 24px;
  border-radius: 12px;
}

.navbar-content {
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.navbar-left {
  display: flex;
  align-items: center;
}

.app-title {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  color: #2c3e50;
  letter-spacing: 1px;
}

.navbar-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.user-name {
  font-size: 15px;
  color: #333;
  font-weight: 500;
}

.logout-btn {
  color: #5a6c7d;
  font-weight: 500;
  padding: 6px 12px;
  transition: all 0.3s;
}

.logout-btn:hover {
  color: #2c3e50;
  background: rgba(0, 0, 0, 0.05);
  border-radius: 4px;
}

/* 移除渐变移动动画以提升性能 */

/* 完全移除装饰性背景元素以提升性能 */
.bg-decoration {
  display: none;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 欢迎卡片美化 - 参考收藏页面 */
::v-deep .welcome-card {
  border-radius: 16px;
  border: none;
  box-shadow: 0 4px 20px rgba(42, 82, 152, 0.12);
  background: rgba(255, 255, 255, 0.95);
  margin-bottom: 24px;
  position: relative;
  z-index: 1;
  animation: slideIn 0.6s ease-out;
  transition: all 0.3s ease;
}

::v-deep .welcome-card:hover {
  box-shadow: 0 8px 32px rgba(42, 82, 152, 0.2);
  transform: translateY(-2px);
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 删除循环动画 */
::v-deep .welcome-card::before {
  display: none;
}

::v-deep .welcome-card .el-card__header {
  background: #ffffff;
  border-bottom: 1px solid #e0e0e0;
  padding: 24px 28px;
}

.welcome-title {
  font-size: 26px;
  font-weight: 500;
  color: #212121;
  letter-spacing: 0.5px;
}

.header-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}

.header-row .el-button {
  color: #667eea;
  font-weight: 500;
  transition: all 0.2s;
}

.header-row .el-button:hover {
  color: #764ba2;
}

.refresh-btn {
  color: #667eea;
  font-weight: 500;
}

.refresh-btn:hover {
  color: #764ba2;
}

.view-all-btn {
  color: #667eea;
  font-weight: 500;
}

.view-all-btn:hover {
  color: #764ba2;
}

.welcome-content {
  padding: 24px;
}

/* 统计卡片风格 - 优化间距，参考收藏页面 */
.stats-row {
  margin-top: 20px;
  margin-bottom: 0;
  gap: 16px;
}

::v-deep .stat-card {
  text-align: left;
  border: none;
  border-radius: 12px;
  transition: all 0.3s ease;
  padding: 24px;
  background: #ffffff;
  box-shadow: 0 4px 16px rgba(42, 82, 152, 0.1);
  position: relative;
  height: 100%;
  overflow: hidden;
  margin-bottom: 16px;
}

::v-deep .stat-card:hover {
  box-shadow: 0 8px 24px rgba(42, 82, 152, 0.18);
  transform: translateY(-4px);
}

::v-deep .stat-card-clickable {
  cursor: pointer;
}

::v-deep .stat-card-clickable:hover {
  transform: translateY(-6px) scale(1.02);
  box-shadow: 0 10px 40px rgba(30, 60, 114, 0.35);
}

::v-deep .stat-card .el-card__body {
  padding: 0;
}

.stat-content {
  position: relative;
  padding-right: 50px;
  min-width: 0;
}

.stat-number {
  font-size: 42px;
  font-weight: 700;
  color: #2a5298;
  margin-bottom: 10px;
  line-height: 1.2;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 移除脉冲动画以提升性能 */

.stat-label {
  font-size: 15px;
  color: #5a6c7d;
  font-weight: 600;
  letter-spacing: 0.3px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.stat-icon {
  position: absolute;
  top: 50%;
  right: 16px;
  transform: translateY(-50%);
  font-size: 42px;
  color: rgba(33, 150, 243, 0.2);
}

.stat-arrow {
  position: absolute;
  right: 16px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 20px;
  color: #2a5298;
  opacity: 0;
  transition: all 0.3s;
}

::v-deep .stat-card-clickable:hover .stat-arrow {
  opacity: 1;
  right: 12px;
}

/* 功能卡片 - 重新设计，三个独立卡片 */
.function-card-wrapper {
  margin-top: 24px;
  margin-bottom: 24px;
  border: none;
  box-shadow: none;
  background: transparent;
  position: relative;
  z-index: 1;
}

::v-deep .function-card-wrapper .el-card__body {
  padding: 0;
}

.function-row {
  display: flex;
  gap: 16px;
}

.function-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px 24px;
  margin: 10px 0;
  cursor: pointer;
  transition: all 0.3s ease;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(42, 82, 152, 0.1);
  position: relative;
  overflow: hidden;
  border: 1px solid #e8f1f8;
}

.function-item::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.function-item-primary::before {
  background: linear-gradient(
    135deg,
    rgba(102, 126, 234, 0.1) 0%,
    rgba(118, 75, 162, 0.1) 100%
  );
}

.function-item-success::before {
  background: linear-gradient(
    135deg,
    rgba(76, 175, 80, 0.1) 0%,
    rgba(56, 142, 60, 0.1) 100%
  );
}

.function-item-warning::before {
  background: linear-gradient(
    135deg,
    rgba(255, 152, 0, 0.1) 0%,
    rgba(245, 124, 0, 0.1) 100%
  );
}

.function-item:hover::before {
  opacity: 1;
}

.function-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(42, 82, 152, 0.18);
  border-color: #2a5298;
}

.function-icon {
  font-size: 56px;
  margin-bottom: 16px;
  transition: transform 0.3s ease;
  position: relative;
  z-index: 1;
}

.function-item-primary .function-icon {
  color: #2a5298;
}

.function-item-success .function-icon {
  color: #4caf50;
}

.function-item-warning .function-icon {
  color: #ff9800;
}

.function-item:hover .function-icon {
  transform: scale(1.15) rotate(5deg);
}

.function-title {
  font-size: 18px;
  font-weight: 600;
  text-align: center;
  position: relative;
  z-index: 1;
  letter-spacing: 0.5px;
}

.function-item-primary .function-title {
  color: #2c3e50;
}

.function-item-success .function-title {
  color: #2c3e50;
}

.function-item-warning .function-title {
  color: #2c3e50;
}

@media (max-width: 767px) {
  .function-row {
    gap: 8px;
  }

  .function-item {
    padding: 24px 8px;
    min-width: 0;
  }

  .function-icon {
    font-size: 32px;
    margin-bottom: 8px;
  }

  .function-title {
    font-size: 12px;
    padding: 0 4px;
    white-space: nowrap;
  }

  .stat-number {
    font-size: 28px;
  }

  .stat-label {
    font-size: 12px;
  }

  .stat-icon {
    font-size: 28px;
    right: 8px;
  }

  .stat-content {
    padding-right: 40px;
  }

  ::v-deep .stat-card {
    padding: 16px 12px;
  }
}

/* 最近错题卡片 - 参考收藏页面 */
::v-deep .recent-questions {
  border-radius: 16px;
  border: none;
  box-shadow: 0 4px 20px rgba(42, 82, 152, 0.12);
  background: rgba(255, 255, 255, 0.95);
  position: relative;
  z-index: 1;
  animation: slideIn 0.6s ease-out;
  transition: all 0.3s ease;
}

::v-deep .recent-questions:hover {
  box-shadow: 0 8px 32px rgba(42, 82, 152, 0.2);
  transform: translateY(-2px);
}

::v-deep .recent-questions .el-card__body {
  padding: 20px;
}

@media (max-width: 767px) {
  ::v-deep .recent-questions .el-card__body {
    padding: 12px;
  }
}

::v-deep .recent-questions .el-card__header {
  background: #ffffff;
  border-bottom: 1px solid #e0e0e0;
  padding: 18px 24px;
  font-size: 18px;
  font-weight: 500;
  color: #212121;
}

/* 最近错题 - 桌面表格，响应式优化 */
.desktop-table-wrapper {
  overflow-x: auto;
}

@media (max-width: 1024px) {
  .desktop-table-wrapper {
    overflow-x: auto;
  }

  ::v-deep .desktop-table-wrapper .el-table {
    min-width: 600px;
  }
}

@media (max-width: 768px) {
  .desktop-table-wrapper {
    display: none;
  }
}

::v-deep .desktop-table-wrapper .el-table {
  border-radius: 8px;
}

::v-deep .desktop-table-wrapper .el-table th {
  background: #fafafa;
  color: #212121;
  font-weight: 500;
  font-size: 15px;
  border-bottom: 1px solid #e0e0e0;
}

::v-deep
  .desktop-table-wrapper
  .el-table--striped
  .el-table__body
  tr.el-table__row--striped
  td {
  background: #fafafa;
}

::v-deep .desktop-table-wrapper .el-table tbody tr:hover > td {
  background: #f5f5f5 !important;
}

.question-preview {
  color: #5a6c7d;
  line-height: 1.6;
}

/* 移动端卡片列表 */
.mobile-list {
  padding: 8px 0;
}

::v-deep .mobile-question-card {
  margin-bottom: 12px;
  border-radius: 0;
  border: 1px solid #e0e0e0;
  box-shadow: none;
  transition: all 0.2s;
}

::v-deep .mobile-question-card:hover {
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  border-color: #2196f3;
}

.mobile-card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 12px;
  gap: 12px;
}

.mobile-card-title {
  font-weight: 500;
  word-break: break-word;
  color: #212121;
  font-size: 14px;
  line-height: 1.5;
  flex: 1;
  min-width: 0;
}

.mobile-card-meta {
  color: #7a8a9a;
  font-size: 12px;
  white-space: nowrap;
}

.mobile-card-body {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  align-items: center;
  margin-bottom: 12px;
}

.mobile-type-tag {
  margin-right: 6px;
}

.mobile-tag {
  margin-right: 4px;
}

.mobile-card-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  justify-content: flex-start;
  padding-top: 8px;
  border-top: 1px solid #f0f0f0;
}

.mobile-card-actions .el-button {
  padding: 4px 8px;
  font-size: 12px;
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 48px 12px;
  color: #7a8a9a;
}

.empty-state i {
  font-size: 64px;
  margin-bottom: 16px;
  display: block;
  color: rgba(42, 82, 152, 0.3);
}

.empty-state p {
  font-size: 15px;
  margin: 0;
}

/* 响应式微调 */
@media (max-width: 767px) {
  .app-container {
    padding: 12px;
  }

  .welcome-title {
    font-size: 18px;
  }

  .welcome-content {
    padding: 16px;
  }

  .stat-number {
    font-size: 24px;
  }

  .stat-label {
    font-size: 13px;
  }

  .stat-icon {
    font-size: 32px;
  }

  .desktop-table-wrapper {
    display: none;
  }

  .mobile-list {
    display: block;
  }
}

@media (min-width: 768px) {
  .mobile-list {
    display: none;
  }
}
</style>
