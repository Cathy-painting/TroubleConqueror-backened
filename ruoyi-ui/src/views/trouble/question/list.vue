<template>
  <div class="question-list-page">
    <!-- 顶部导航 -->
    <div class="list-header">
      <div class="header-content">
        <div class="header-left">
          <h1 class="page-title">我的错题本</h1>
          <p class="page-subtitle">共 {{ total }} 道题目</p>
        </div>

        <!-- 搜索框 -->
        <div class="header-search">
          <el-input
            v-model="queryParams.questionContent"
            placeholder="搜索题目或标签..."
            prefix-icon="el-icon-search"
            clearable
            @keyup.enter.native="handleQuery"
            @clear="handleQuery"
            class="search-input"
          />
        </div>
      </div>
    </div>

    <!-- 过滤器 -->
    <div class="filter-section">
      <div class="filter-content">
        <el-button
          :type="filterType === 'all' ? 'primary' : ''"
          :plain="filterType !== 'all'"
          size="medium"
          @click="setFilterType('all')"
          class="filter-btn"
        >
          <i class="el-icon-document"></i> 全部题目
        </el-button>
        <el-button
          :type="filterType === 'with-image' ? 'success' : ''"
          :plain="filterType !== 'with-image'"
          size="medium"
          @click="setFilterType('with-image')"
          class="filter-btn"
        >
          <i class="el-icon-picture"></i> 有图题目
        </el-button>
        <el-button
          :type="filterType === 'no-image' ? 'info' : ''"
          :plain="filterType !== 'no-image'"
          size="medium"
          @click="setFilterType('no-image')"
          class="filter-btn"
        >
          <i class="el-icon-document-copy"></i> 纯文字题目
        </el-button>
        <el-button
          type="text"
          size="medium"
          @click="goToDashboard"
          class="back-btn"
        >
          <i class="el-icon-house"></i> 返回主页
        </el-button>
      </div>
    </div>

    <!-- 题目列表 -->
    <div class="question-list-container">
      <div v-loading="loading" class="questions-grid">
        <question-card
          v-for="question in filteredQuestions"
          :key="question.questionId"
          :question="question"
          @click="handleQuestionClick"
        />
      </div>

      <!-- 空状态 -->
      <div
        v-if="!loading && filteredQuestions.length === 0"
        class="empty-state"
      >
        <i class="el-icon-document-delete"></i>
        <p>没有找到相关题目</p>
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
    />
  </div>
</template>

<script>
import { listQuestion } from "@/api/trouble/question";
import QuestionCard from "./components/QuestionCard.vue";
import QuestionDetail from "./components/QuestionDetail.vue";

export default {
  name: "QuestionList",
  components: {
    QuestionCard,
    QuestionDetail,
  },
  data() {
    return {
      loading: true,
      questionList: [],
      total: 0,
      selectedQuestion: null,
      filterType: "all",
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        questionContent: null,
        questionType: null,
        tags: null,
      },
    };
  },
  computed: {
    filteredQuestions() {
      if (this.filterType === "all") {
        return this.questionList;
      } else if (this.filterType === "with-image") {
        return this.questionList.filter(
          (q) => q.questionImages && q.questionImages.trim() !== ""
        );
      } else if (this.filterType === "no-image") {
        return this.questionList.filter(
          (q) => !q.questionImages || q.questionImages.trim() === ""
        );
      }
      return this.questionList;
    },
  },
  created() {
    // 检查是否有查询参数（从其他页面跳转过来时可能带有 id）
    if (this.$route.query.id) {
      // 如果有 id，先加载列表，然后自动打开详情
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
  },
  methods: {
    /** 查询错题列表 */
    getList() {
      this.loading = true;
      return listQuestion(this.queryParams)
        .then((response) => {
          let allQuestions = response.rows || [];
          // 根据过滤类型过滤数据
          if (this.filterType === "with-image") {
            allQuestions = allQuestions.filter(
              (q) => q.questionImages && q.questionImages.trim() !== ""
            );
          } else if (this.filterType === "no-image") {
            allQuestions = allQuestions.filter(
              (q) => !q.questionImages || q.questionImages.trim() === ""
            );
          }
          this.questionList = allQuestions;
          this.total = response.total || 0;
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
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 设置过滤类型 */
    setFilterType(type) {
      this.filterType = type;
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 题目点击 */
    handleQuestionClick(question) {
      this.selectedQuestion = question;
    },
    /** 返回主页 */
    goToDashboard() {
      this.$router.push("/trouble/dashboard");
    },
  },
};
</script>

<style scoped>
.question-list-page {
  min-height: 100vh;
  background: linear-gradient(to bottom right, #f5f7fa, #e8ecf1);
}

.list-header {
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

@media (min-width: 768px) {
  .header-content {
    flex-direction: row;
    align-items: center;
    justify-content: space-between;
  }
}

.header-left {
  flex: 1;
}

.page-title {
  font-size: 28px;
  font-weight: bold;
  background: linear-gradient(to right, #409eff, #67c23a);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin: 0 0 5px 0;
}

@media (max-width: 767px) {
  .page-title {
    font-size: 22px;
  }
}

.page-subtitle {
  color: #909399;
  font-size: 14px;
  margin: 0;
}

.header-search {
  width: 100%;
}

@media (min-width: 768px) {
  .header-search {
    width: 400px;
  }
}

.search-input {
  width: 100%;
}

.filter-section {
  background: white;
  border-bottom: 1px solid #e4e7ed;
}

.filter-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 15px 20px;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  align-items: center;
}

.filter-btn {
  margin: 0;
}

.back-btn {
  margin-left: auto;
  color: #606266;
}

@media (max-width: 767px) {
  .back-btn {
    width: 100%;
    margin-left: 0;
    margin-top: 10px;
  }
}

.question-list-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.questions-grid {
  display: grid;
  gap: 20px;
  margin-bottom: 20px;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #909399;
}

.empty-state i {
  font-size: 64px;
  display: block;
  margin-bottom: 20px;
  opacity: 0.5;
}

.empty-state p {
  font-size: 16px;
  margin: 0;
}

.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

@media (max-width: 767px) {
  .question-list-container {
    padding: 15px;
  }

  .questions-grid {
    gap: 15px;
  }
}
</style>
