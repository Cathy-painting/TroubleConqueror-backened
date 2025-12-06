<template>
  <div class="question-view-page">
    <!-- 顶部搜索栏 -->
    <div class="view-header">
      <div class="header-inner">
        <div class="header-row">
          <div class="header-left">
            <h1 class="page-title">我的错题本</h1>
            <p class="page-subtitle">共 {{ total }} 道题目</p>
          </div>

          <el-button type="text" class="back-btn" @click="goToDashboard">
            <i class="el-icon-house"></i> 返回主页
          </el-button>
        </div>
        <div class="header-right">
          <el-button
            type="primary"
            icon="el-icon-s-operation"
            class="mobile-filter-btn"
            @click="showMobileFilter = true"
            plain
          >
            筛选
          </el-button>
          <el-input
            v-model="queryParams.questionContent"
            placeholder="搜索题目内容..."
            prefix-icon="el-icon-search"
            clearable
            @keyup.enter.native="handleQuery"
            @clear="handleQuery"
            class="search-input"
          />
        </div>
      </div>
    </div>

    <!-- 常用筛选（始终可见） -->
    <div class="common-filters">
      <div class="common-filters-inner">
        <div class="filter-group">
          <span class="filter-label">类型</span>
          <el-radio-group
            v-model="queryParams.questionType"
            @change="handleQuery"
            class="filter-radios"
          >
            <el-radio-button label="">全部</el-radio-button>
            <el-radio-button label="选择题">选择题</el-radio-button>
            <el-radio-button label="填空题">填空题</el-radio-button>
            <el-radio-button label="解答题">解答题</el-radio-button>
            <el-radio-button label="其他">其他</el-radio-button>
          </el-radio-group>
        </div>
        <div class="filter-group">
          <span class="filter-label">标签</span>
          <el-select
            v-model="selectedTags"
            multiple
            placeholder="选择标签"
            clearable
            @change="handleTagFilter"
            class="tag-select"
          >
            <el-option
              v-for="tag in availableTags"
              :key="tag"
              :label="tag"
              :value="tag"
            >
              <span>{{ tag }}</span>
              <span
                v-if="!systemTags.includes(tag)"
                style="float: right; color: #8492a6; font-size: 12px"
              >
                <i class="el-icon-star-on"></i>
              </span>
            </el-option>
          </el-select>
        </div>
        <div class="view-mode-group desktop-only">
          <span class="filter-label">视图</span>
          <el-radio-group
            v-model="viewMode"
            @change="handleViewModeChange"
            class="view-mode-radios"
          >
            <el-radio-button label="compact">
              <svg width="20" height="20" viewBox="0 0 24 24">
                <!-- 短横线，间距小 -->
                <rect x="4" y="6" width="14" height="2" rx="1"></rect>
                <rect x="4" y="10" width="14" height="2" rx="1"></rect>
                <rect x="4" y="14" width="14" height="2" rx="1"></rect>
                <rect x="4" y="18" width="14" height="2" rx="1"></rect>
              </svg>
            </el-radio-button>
            <el-radio-button label="list">
              <svg width="20" height="20" viewBox="0 0 24 24">
                <rect x="3" y="5" width="18" height="2" rx="1"></rect>
                <rect x="3" y="11" width="18" height="2" rx="1"></rect>
                <rect x="3" y="17" width="18" height="2" rx="1"></rect>
              </svg>
            </el-radio-button>
            <el-radio-button label="card">
              <i class="el-icon-menu"></i>
            </el-radio-button>
          </el-radio-group>
        </div>
      </div>
    </div>

    <div class="filter-bar" :class="{ 'mobile-show': showMobileFilter }">
      <div class="filter-inner">
        <!-- 移动端头部 -->
        <div class="mobile-filter-header">
          <span class="mobile-filter-title">筛选</span>
          <el-button
            type="text"
            icon="el-icon-close"
            @click="showMobileFilter = false"
            class="close-btn"
          ></el-button>
        </div>

        <!-- 第一行筛选条件 -->
        <div class="filter-row">
          <div class="filter-group">
            <span class="filter-label">重要性</span>
            <el-radio-group
              v-model="queryParams.importance"
              @change="handleQuery"
              class="filter-radios"
            >
              <el-radio-button label="">全部</el-radio-button>
              <el-radio-button :label="3">高</el-radio-button>
              <el-radio-button :label="2">中</el-radio-button>
              <el-radio-button :label="1">低</el-radio-button>
            </el-radio-group>
          </div>
          <div class="filter-group">
            <span class="filter-label">熟练度</span>
            <el-radio-group
              v-model="queryParams.proficiency"
              @change="handleQuery"
              class="filter-radios"
            >
              <el-radio-button label="">全部</el-radio-button>
              <el-radio-button :label="3">熟练</el-radio-button>
              <el-radio-button :label="2">较好</el-radio-button>
              <el-radio-button :label="1">一般</el-radio-button>
              <el-radio-button :label="0">陌生</el-radio-button>
            </el-radio-group>
          </div>
        </div>

        <!-- 第二行筛选条件 -->
        <div class="filter-row">
          <div class="filter-group">
            <span class="filter-label">难度</span>
            <el-radio-group
              v-model="queryParams.difficulty"
              @change="handleQuery"
              class="filter-radios"
            >
              <el-radio-button label="">全部</el-radio-button>
              <el-radio-button :label="1">简单</el-radio-button>
              <el-radio-button :label="2">中等</el-radio-button>
              <el-radio-button :label="3">困难</el-radio-button>
            </el-radio-group>
          </div>
          <div class="filter-group">
            <span class="filter-label">年级</span>
            <el-select
              v-model="queryParams.grade"
              placeholder="选择年级"
              clearable
              @change="handleQuery"
              class="grade-select"
            >
              <el-option label="小学一年级" value="小学一年级"></el-option>
              <el-option label="小学二年级" value="小学二年级"></el-option>
              <el-option label="小学三年级" value="小学三年级"></el-option>
              <el-option label="小学四年级" value="小学四年级"></el-option>
              <el-option label="小学五年级" value="小学五年级"></el-option>
              <el-option label="小学六年级" value="小学六年级"></el-option>
              <el-option label="初中一年级" value="初中一年级"></el-option>
              <el-option label="初中二年级" value="初中二年级"></el-option>
              <el-option label="初中三年级" value="初中三年级"></el-option>
              <el-option label="高中一年级" value="高中一年级"></el-option>
              <el-option label="高中二年级" value="高中二年级"></el-option>
              <el-option label="高中三年级" value="高中三年级"></el-option>
            </el-select>
          </div>
        </div>

        <!-- 第三行筛选条件 -->
        <div class="filter-row">
          <div class="filter-group">
            <span class="filter-label">来源</span>
            <el-select
              v-model="queryParams.questionSource"
              placeholder="选择错题来源"
              clearable
              @change="handleQuery"
              class="source-select"
            >
              <el-option label="课堂练习" value="课堂练习"></el-option>
              <el-option label="课后作业" value="课后作业"></el-option>
              <el-option label="周测/月考" value="周测/月考"></el-option>
              <el-option label="单元测试" value="单元测试"></el-option>
              <el-option
                label="期中/期末考试"
                value="期中/期末考试"
              ></el-option>
              <el-option label="模拟考试" value="模拟考试"></el-option>
              <el-option label="真题" value="真题"></el-option>
              <el-option label="教辅资料" value="教辅资料"></el-option>
              <el-option label="竞赛类" value="竞赛类"></el-option>
            </el-select>
          </div>
          <div class="filter-group">
            <span class="filter-label">错误类型</span>
            <el-select
              v-model="queryParams.errorType"
              placeholder="选择错误类型"
              clearable
              @change="handleQuery"
              class="error-type-select"
            >
              <el-option label="基础薄弱" value="基础薄弱"></el-option>
              <el-option label="粗心失误" value="粗心失误"></el-option>
              <el-option label="计算错误" value="思路方法"></el-option>
              <el-option label="审题不清" value="考试场景"></el-option>
            </el-select>
          </div>
        </div>
      </div>
    </div>

    <!-- 遮罩层 -->
    <div
      class="mobile-filter-overlay"
      v-if="showMobileFilter"
      @click="showMobileFilter = false"
    ></div>

    <!-- 题目列表 -->
    <div class="view-container">
      <!-- 列表视图 -->
      <div
        v-if="viewMode === 'list'"
        v-loading="loading"
        class="questions-list"
      >
        <question-list-item
          v-for="question in questionList"
          :key="question.questionId"
          :question="question"
          @click="handleQuestionClick"
          @view="handleView"
          @edit="handleEdit"
          @favorite="handleFavorite"
          @delete="handleDelete"
        />
      </div>

      <!-- 卡片视图 -->
      <div
        v-else-if="viewMode === 'card'"
        v-loading="loading"
        class="questions-grid"
      >
        <question-card
          v-for="question in questionList"
          :key="question.questionId"
          :question="question"
          @click="handleQuestionClick"
          @view="handleView"
          @edit="handleEdit"
          @favorite="handleFavorite"
          @delete="handleDelete"
        />
      </div>

      <!-- 紧凑视图 -->
      <div
        v-else-if="viewMode === 'compact'"
        v-loading="loading"
        class="questions-compact"
      >
        <question-compact-item
          v-for="question in questionList"
          :key="question.questionId"
          :question="question"
          @click="handleQuestionClick"
          @view="handleView"
          @edit="handleEdit"
          @favorite="handleFavorite"
          @delete="handleDelete"
        />
      </div>

      <!-- 空状态 -->
      <div v-if="!loading && questionList.length === 0" class="empty-state">
        <i class="el-icon-document-delete"></i>
        <p>没有找到相关题目</p>
        <el-button type="text" @click="resetFilters">清空筛选条件</el-button>
      </div>

      <!-- 分页 -->
      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
        class="pagination-wrapper"
      />
    </div>

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
      :question-id="editingQuestionId"
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
  getQuestion,
} from "@/api/trouble/question";
import { getAllTags } from "@/utils/tagUtils";
import QuestionCard from "./components/QuestionCard.vue";
import QuestionListItem from "./components/QuestionListItem.vue";
import QuestionCompactItem from "./components/QuestionCompactItem.vue";
import QuestionDetail from "./components/QuestionDetail.vue";
import QuestionEditDialog from "./components/QuestionEditDialog.vue";
import { mapGetters } from "vuex";

export default {
  name: "QuestionView",
  components: {
    QuestionCard,
    QuestionListItem,
    QuestionCompactItem,
    QuestionDetail,
    QuestionEditDialog,
  },
  computed: {
    ...mapGetters(["roles"]),
  },
  data() {
    return {
      loading: true,
      questionList: [],
      total: 0,
      selectedQuestion: null,
      editingQuestionId: null,
      selectedTags: [],
      availableTags: [],
      systemTags: [
        "语文",
        "数学",
        "英语",
        "物理",
        "化学",
        "生物",
        "政治",
        "历史",
        "地理",
      ],
      viewMode: "list",
      showMobileFilter: false,
      queryParams: {
        pageNum: 1,
        pageSize: 12,
        questionContent: null,
        questionType: "",
        tags: null,
        importance: "",
        proficiency: "",
        difficulty: "",
        grade: null,
        questionSource: null,
        errorType: null,
      },
      weekStart: null,
      weekEnd: null,
    };
  },
  created() {
    const savedViewMode = localStorage.getItem("questionViewMode");
    if (savedViewMode && ["list", "card", "compact"].includes(savedViewMode)) {
      this.viewMode = savedViewMode;
    }
    if (this.viewMode === "list") {
      this.queryParams.pageSize = 20;
    } else if (this.viewMode === "compact") {
      this.queryParams.pageSize = 30;
    }

    if (
      this.$route.query.proficiency !== undefined &&
      this.$route.query.proficiency !== null &&
      this.$route.query.proficiency !== ""
    ) {
      this.queryParams.proficiency = parseInt(this.$route.query.proficiency);
    }
    if (this.$route.query.weekStart && this.$route.query.weekEnd) {
      this.weekStart = new Date(this.$route.query.weekStart);
      this.weekEnd = new Date(this.$route.query.weekEnd);
    }
    if (this.$route.query.id) {
      this.getList().then(() => {
        const question = this.questionList.find(
          (q) => q.questionId == this.$route.query.id
        );
        if (question) {
          this.selectedQuestion = question;
        }
      });
    } else {
      this.getList();
    }
    this.loadTags();
  },
  methods: {
    getList() {
      this.loading = true;
      if (this.selectedTags.length > 0) {
        this.queryParams.tags = this.selectedTags.join(",");
      } else {
        this.queryParams.tags = null;
      }

      const queryParams = { ...this.queryParams };
      if (queryParams.importance === "") {
        queryParams.importance = null;
      }
      if (queryParams.proficiency === "") {
        queryParams.proficiency = null;
      }
      if (queryParams.difficulty === "") {
        queryParams.difficulty = null;
      }

      if (this.weekStart && this.weekEnd) {
        queryParams.pageSize = 1000;
      }

      return listQuestion(queryParams)
        .then((response) => {
          let questions = response.rows || [];

          if (this.weekStart && this.weekEnd) {
            questions = questions.filter((q) => {
              const createDate = new Date(q.createTime);
              return createDate >= this.weekStart && createDate <= this.weekEnd;
            });
            this.total = questions.length;
          } else {
            this.total = response.total || 0;
          }

          this.questionList = questions;
          this.loading = false;
          return response;
        })
        .catch(() => {
          this.questionList = [];
          this.total = 0;
          this.loading = false;
          return Promise.reject();
        });
    },
    loadTags() {
      listQuestion({ pageNum: 1, pageSize: 1000 }).then((response) => {
        const allQuestions = response.rows || [];
        const tagSet = new Set();
        allQuestions.forEach((q) => {
          if (q.tags) {
            q.tags.split(",").forEach((tag) => {
              const trimmedTag = tag.trim();
              if (trimmedTag) {
                tagSet.add(trimmedTag);
              }
            });
          }
        });

        const questionTags = Array.from(tagSet);
        this.availableTags = getAllTags([...this.systemTags, ...questionTags]);
      });
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
      // 移动端自动关闭筛选栏
      if (window.innerWidth <= 768) {
        this.showMobileFilter = false;
      }
    },
    handleTagFilter() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    handleViewModeChange() {
      localStorage.setItem("questionViewMode", this.viewMode);
      if (this.viewMode === "list") {
        this.queryParams.pageSize = 20;
      } else if (this.viewMode === "compact") {
        this.queryParams.pageSize = 30;
      } else {
        this.queryParams.pageSize = 12;
      }
      this.queryParams.pageNum = 1;
      this.getList();
    },
    handleQuestionClick(question) {
      this.selectedQuestion = question;
    },
    handleQuestionRefresh() {
      this.getList();
      if (this.selectedQuestion) {
        const questionId = this.selectedQuestion.questionId;
        this.getList().then(() => {
          const updatedQuestion = this.questionList.find(
            (q) => q.questionId == questionId
          );
          if (updatedQuestion) {
            this.selectedQuestion = updatedQuestion;
          }
        });
      }
    },
    handleEditSuccess() {
      this.getList();
      if (this.selectedQuestion) {
        const questionId = this.selectedQuestion.questionId;
        this.getList().then(() => {
          const updatedQuestion = this.questionList.find(
            (q) => q.questionId == questionId
          );
          if (updatedQuestion) {
            this.selectedQuestion = updatedQuestion;
          }
        });
      }
    },
    goToDashboard() {
      this.$router.push("/index");
    },
    handleView(question) {
      this.selectedQuestion = question;
    },
    handleEdit(question) {
      this.editingQuestionId = question.questionId;
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
          this.getList();
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
          this.getList();
        })
        .catch(() => {});
    },
    resetFilters() {
      this.queryParams = {
        pageNum: 1,
        pageSize: this.queryParams.pageSize,
        questionContent: null,
        questionType: "",
        tags: null,
        importance: "",
        proficiency: "",
        difficulty: "",
        grade: null,
        questionSource: null,
        errorType: null,
      };
      this.selectedTags = [];
      this.getList();
    },
  },
};
</script>

<style scoped>
/* ============================================
   基础样式 - 页面容器
   ============================================ */
.question-view-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #e8eef5 100%);
  position: relative;
  padding: 0;
}

/* ============================================
   顶部栏 - Header
   ============================================ */
.view-header {
  background: #ffffff;
  border-bottom: 1px solid #e8eef5;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  backdrop-filter: blur(10px);
}

.header-inner {
  max-width: 1400px;
  margin: 0 auto;
  padding: 24px 32px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
}

.header-left {
  flex-shrink: 0;
}

.header-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-title {
  font-size: 28px;
  font-weight: 700;
  background: linear-gradient(135deg, #2196f3 0%, #1976d2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin: 0 0 6px 0;
  letter-spacing: -0.5px;
}

.page-subtitle {
  color: #757575;
  font-size: 14px;
  margin: 0;
  font-weight: 500;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
  flex: 1;
  justify-content: flex-end;
}

.search-input {
  width: 360px;
  transition: all 0.3s ease;
}

.search-input >>> .el-input__inner {
  border-radius: 24px;
  border: 2px solid #e8eef5;
  transition: all 0.3s ease;
  padding-left: 40px;
  height: 42px;
}

.search-input >>> .el-input__inner:focus {
  border-color: #2196f3;
  box-shadow: 0 0 0 4px rgba(33, 150, 243, 0.1);
}

.back-btn {
  margin-left: 20px;
  display: inline-flex;
  align-items: center;
  gap: 6px;

  padding: 6px 10px;
  font-size: 14px;
  color: #409eff; /* Element 主色 */
  background: transparent;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
}

/* 悬停效果 */
.back-btn:hover {
  background: rgba(64, 158, 255, 0.12);
  color: #337ecc;
}

.mobile-filter-btn {
  display: none;
  border-radius: 8px;
  padding: 10px 20px;
  font-weight: 500;
}

/* ============================================
   常用筛选区域
   ============================================ */
.common-filters {
  background: #ffffff;
  border-bottom: 1px solid #e8eef5;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02);
}

.common-filters-inner {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px 32px;
  display: flex;
  gap: 32px;
  flex-wrap: wrap;
  align-items: center;
}

/* ============================================
   筛选栏 - Filter Bar
   ============================================ */
.filter-bar {
  background: #fafbfc;
  border-bottom: 1px solid #e8eef5;
}

.filter-inner {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px 32px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.filter-row {
  display: flex;
  align-items: center;
  gap: 32px;
  flex-wrap: wrap;
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;
}

.filter-label {
  font-size: 14px;
  color: #424242;
  font-weight: 600;
  white-space: nowrap;
  min-width: 48px;
}

/* ============================================
   筛选按钮样式
   ============================================ */
.filter-radios {
  margin: 0;
  display: flex;
  gap: 8px;
}

.filter-radios
  >>> .el-radio-button__orig-radio:checked
  + .el-radio-button__inner {
  background: linear-gradient(135deg, #2196f3 0%, #1976d2 100%);
  border-color: #2196f3;
  color: #ffffff;
  box-shadow: 0 2px 8px rgba(33, 150, 243, 0.3);
}

.filter-radios >>> .el-radio-button__inner {
  border: 2px solid #e0e0e0;
  background: #ffffff;
  color: #616161;
  padding: 8px 18px;
  border-radius: 8px;
  transition: all 0.3s ease;
  font-weight: 500;
  font-size: 14px;
}

.filter-radios >>> .el-radio-button__inner:hover {
  border-color: #2196f3;
  color: #2196f3;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(33, 150, 243, 0.15);
}

/* ============================================
   视图模式按钮
   ============================================ */
.view-mode-group {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-left: auto;
}

.view-mode-radios {
  margin: 0;
  display: flex;
  gap: 6px;
}

.view-mode-radios >>> .el-radio-button__inner {
  border: 2px solid #e0e0e0;
  background: #ffffff;
  color: #616161;
  padding: 8px 12px;
  border-radius: 8px;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
}

.view-mode-radios >>> .el-radio-button__inner:hover {
  border-color: #2196f3;
  color: #2196f3;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(33, 150, 243, 0.2);
}

.view-mode-radios
  >>> .el-radio-button__orig-radio:checked
  + .el-radio-button__inner {
  background: linear-gradient(135deg, #2196f3 0%, #1976d2 100%);
  border-color: #2196f3;
  color: #ffffff;
  box-shadow: 0 4px 12px rgba(33, 150, 243, 0.35);
}

/* ============================================
   选择器样式
   ============================================ */
.tag-select {
  width: 280px;
}

.grade-select,
.source-select,
.error-type-select {
  width: 180px;
}

.tag-select >>> .el-input__inner,
.grade-select >>> .el-input__inner,
.source-select >>> .el-input__inner,
.error-type-select >>> .el-input__inner {
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  transition: all 0.3s ease;
  font-size: 14px;
}

.tag-select >>> .el-input__inner:focus,
.grade-select >>> .el-input__inner:focus,
.source-select >>> .el-input__inner:focus,
.error-type-select >>> .el-input__inner:focus {
  border-color: #2196f3;
  box-shadow: 0 0 0 4px rgba(33, 150, 243, 0.1);
}

/* ============================================
   内容区域
   ============================================ */
.view-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 32px;
  box-sizing: border-box;
}

/* ============================================
   列表视图
   ============================================ */
.questions-list {
  background: #ffffff;
  border-radius: 16px;
  margin-bottom: 32px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
  border: 1px solid #e8eef5;
}

/* ============================================
   卡片视图
   ============================================ */
.questions-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
  gap: 24px;
  margin-bottom: 32px;
}

.questions-grid .flat-card {
  background: #ffffff;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
  border: 1px solid #e8eef5;
  border-radius: 16px;
  transition: all 0.3s ease;
}

.questions-grid .flat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(33, 150, 243, 0.15);
  border-color: #2196f3;
}

/* ============================================
   紧凑视图
   ============================================ */
.questions-compact {
  background: #ffffff;
  border-radius: 16px;
  margin-bottom: 32px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
  border: 1px solid #e8eef5;
}

/* ============================================
   空状态
   ============================================ */
.empty-state {
  text-align: center;
  padding: 120px 20px;
  color: #9e9e9e;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
}

.empty-state i {
  font-size: 80px;
  display: block;
  margin-bottom: 24px;
  opacity: 0.3;
  background: linear-gradient(135deg, #bdbdbd 0%, #9e9e9e 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.empty-state p {
  font-size: 18px;
  margin: 0 0 16px 0;
  font-weight: 500;
}

/* ============================================
   分页
   ============================================ */
.pagination-wrapper {
  margin-top: 32px;
  display: flex;
  justify-content: center;
  padding: 24px;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
  border: 1px solid #e8eef5;
}

/* ============================================
   移动端筛选遮罩和侧边栏
   ============================================ */
.mobile-filter-overlay {
  display: none;
}

.mobile-filter-header {
  display: none;
}

.desktop-only {
  display: flex;
}

/* ============================================
   响应式设计 - 平板 (768px - 1024px)
   ============================================ */
@media (max-width: 1024px) {
  .header-inner {
    padding: 20px 24px;
  }

  .common-filters-inner,
  .filter-inner {
    padding: 16px 24px;
  }

  .view-container {
    padding: 24px;
  }

  .questions-grid {
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
  }
}

/* ============================================
   响应式设计 - 移动端 (< 768px)
   ============================================ */
@media (max-width: 768px) {
  /* 顶部栏 */
  .header-inner {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
    padding: 16px;
  }

  .header-left {
    width: 100%;
  }

  .page-title {
    font-size: 22px;
  }

  .page-subtitle {
    font-size: 13px;
  }

  .header-right {
    width: 100%;
  }

  .search-input {
    width: 100%;
    order: 2;
  }

  .mobile-filter-btn {
    display: inline-flex;
    order: 1;
    flex-shrink: 0;
  }

  .back-btn {
    order: 3;
    flex-shrink: 0;
  }

  /* 常用筛选 */
  .common-filters-inner {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
    padding: 16px;
  }

  .common-filters .filter-group {
    width: 100%;
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }

  .common-filters .filter-label {
    font-size: 13px;
  }

  .common-filters .tag-select {
    width: 100%;
  }

  .common-filters .filter-radios {
    width: 100%;
    flex-wrap: wrap;
  }

  .common-filters .filter-radios >>> .el-radio-button {
    flex: 0 0 auto;
    margin-bottom: 8px;
  }

  .common-filters .filter-radios >>> .el-radio-button__inner {
    padding: 6px 14px;
    font-size: 13px;
  }

  .desktop-only {
    display: none !important;
  }

  /* 筛选侧边栏 */
  .filter-bar {
    position: fixed;
    top: 0;
    left: -100%;
    width: 85%;
    max-width: 380px;
    height: 100vh;
    z-index: 1001;
    transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    overflow-y: auto;
    box-shadow: 4px 0 24px rgba(0, 0, 0, 0.15);
    background: #ffffff;
    border: none;
  }

  .filter-bar.mobile-show {
    left: 0;
  }

  .mobile-filter-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 16px;
    border-bottom: 2px solid #e8eef5;
    background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
    position: sticky;
    top: 0;
    z-index: 10;
  }

  .mobile-filter-title {
    font-size: 18px;
    font-weight: 700;
    color: #212121;
  }

  .close-btn {
    font-size: 20px;
    padding: 8px;
    color: #757575;
  }

  .close-btn:hover {
    color: #2196f3;
  }

  .filter-inner {
    padding: 20px 16px;
  }

  .filter-row {
    flex-direction: column;
    gap: 20px;
    align-items: flex-start;
  }

  .filter-group {
    width: 100%;
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }

  .filter-label {
    font-size: 13px;
  }

  .filter-radios {
    width: 100%;
    flex-wrap: wrap;
  }

  .filter-radios >>> .el-radio-button {
    flex: 0 0 auto;
    margin-bottom: 8px;
  }

  .filter-radios >>> .el-radio-button__inner {
    padding: 6px 14px;
    font-size: 13px;
  }

  .grade-select,
  .source-select,
  .error-type-select {
    width: 100%;
  }

  /* 遮罩层 */
  .mobile-filter-overlay {
    display: block;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    cursor: pointer;
    animation: fadeIn 0.3s ease;
  }

  @keyframes fadeIn {
    from {
      opacity: 0;
    }
    to {
      opacity: 1;
    }
  }

  /* 内容区域 */
  .view-container {
    padding: 16px;
  }

  .questions-grid {
    grid-template-columns: 1fr;
    gap: 16px;
  }

  .questions-list,
  .questions-compact {
    border-radius: 12px;
  }

  .empty-state {
    padding: 80px 20px;
    border-radius: 12px;
  }

  .empty-state i {
    font-size: 64px;
  }

  .empty-state p {
    font-size: 16px;
  }

  .pagination-wrapper {
    border-radius: 12px;
    padding: 16px;
  }
}

/* ============================================
   小屏幕移动端 (< 480px)
   ============================================ */
@media (max-width: 480px) {
  .page-title {
    font-size: 20px;
  }

  .filter-bar {
    width: 90%;
  }

  .common-filters .filter-radios >>> .el-radio-button__inner {
    padding: 5px 12px;
    font-size: 12px;
  }

  .filter-radios >>> .el-radio-button__inner {
    padding: 5px 12px;
    font-size: 12px;
  }

  .back-btn {
    color: #757575;
    padding: 10px 16px;
    font-weight: 500;
    transition: all 0.3s ease;
  }

  .back-btn:hover {
    color: #2196f3;
    background: rgba(33, 150, 243, 0.08);
    border-radius: 8px;
  }
}

/* ============================================
   滚动条美化
   ============================================ */
.filter-bar::-webkit-scrollbar {
  width: 6px;
}

.filter-bar::-webkit-scrollbar-track {
  background: #f1f1f1;
}

.filter-bar::-webkit-scrollbar-thumb {
  background: #cbd5e0;
  border-radius: 3px;
}

.filter-bar::-webkit-scrollbar-thumb:hover {
  background: #a0aec0;
}
</style>
