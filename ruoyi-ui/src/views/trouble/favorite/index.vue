<template>
  <div class="app-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-left">
          <i class="el-icon-star-on header-icon"></i>
          <h2 class="header-title">我的收藏</h2>
        </div>
        <p class="header-desc">收藏的重要错题，方便随时复习</p>
      </div>
    </div>

    <!-- 搜索表单 -->
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px" class="search-form">
      <el-row :gutter="10">
        <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <el-form-item label="题目内容" prop="questionContent" class="search-form-item">
            <el-input
              v-model="queryParams.questionContent"
              placeholder="请输入题目内容"
              clearable
              @keyup.enter.native="handleQuery"
            />
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <el-form-item label="题目类型" prop="questionType" class="search-form-item">
            <el-select v-model="queryParams.questionType" placeholder="请选择题目类型" clearable style="width: 100%">
              <el-option label="未区分" value="未区分" />
              <el-option label="选择题" value="选择题" />
              <el-option label="填空题" value="填空题" />
              <el-option label="解答题" value="解答题" />
              <el-option label="其他" value="其他" />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <el-form-item label="标签" prop="tags">
            <el-input
              v-model="queryParams.tags"
              placeholder="请输入标签"
              clearable
              @keyup.enter.native="handleQuery"
            />
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
            <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>

    <!-- 操作按钮 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-back"
          size="mini"
          @click="goBack"
        >返回</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-star-off"
          size="mini"
          :disabled="multiple"
          @click="handleBatchUnfavorite"
        >批量取消收藏</el-button>
      </el-col>
    </el-row>

    <!-- 题目列表 - 参考view.vue设计 -->
    <div class="questions-container">
      <div v-loading="loading" class="questions-list">
        <question-list-item
          v-for="question in favoriteList"
          :key="question.questionId"
          :question="question"
          @view="handleView"
          @edit="handleEdit"
          @favorite="handleUnfavoriteFromList"
          @delete="handleUnfavoriteFromList"
        />
      </div>

      <!-- 空状态 -->
      <div v-if="!loading && favoriteList.length === 0" class="empty-state">
        <i class="el-icon-document-delete"></i>
        <p>没有找到相关题目</p>
      </div>
    </div>

    <!-- 原表格（隐藏） -->
    <el-table 
      v-loading="loading" 
      :data="favoriteList" 
      @selection-change="handleSelectionChange"
      class="favorite-table"
      stripe
      style="display: none;"
    >
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="题目内容" prop="questionContent" :show-overflow-tooltip="true" min-width="200">
        <template slot-scope="scope">
          <div class="question-preview">{{ scope.row.questionContent }}</div>
        </template>
      </el-table-column>
      <el-table-column label="题目类型" prop="questionType" width="100" align="center">
        <template slot-scope="scope">
          <el-tag :type="getTypeTagType(scope.row.questionType)" size="small">{{ scope.row.questionType }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="标签" prop="tags" width="180" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <el-tag v-for="tag in getTagsArray(scope.row.tags)" :key="tag" size="mini" style="margin-right: 5px;">
            {{ tag }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="收藏时间" align="center" prop="favoriteTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.favoriteTime || scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="200" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleView(scope.row)"
          >查看</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleEdit(scope.row)"
          >编辑</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-star-off"
            @click="handleUnfavorite(scope.row)"
            style="color: #f56c6c;"
          >取消收藏</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 编辑对话框 -->
    <question-edit-dialog
      ref="editDialog"
      :question-id="currentQuestion ? currentQuestion.questionId : null"
      @success="handleEditSuccess"
    />

    <!-- 查看详情对话框 -->
    <el-dialog title="错题详情" :visible.sync="viewDialogVisible" width="70%" append-to-body class="view-dialog">
      <div v-if="currentQuestion" class="question-detail">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="题目类型">
            <el-tag :type="getTypeTagType(currentQuestion.questionType)">{{ currentQuestion.questionType }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="题目内容">
            <div class="content-text">{{ currentQuestion.questionContent }}</div>
            <div v-if="currentQuestion.questionImages" class="images-preview">
              <el-image
                v-for="(img, index) in getImagesArray(currentQuestion.questionImages)"
                :key="index"
                :src="img"
                :preview-src-list="getImagesArray(currentQuestion.questionImages)"
                class="preview-image"
              />
            </div>
          </el-descriptions-item>
          <el-descriptions-item label="答案内容">
            <div class="content-text">{{ currentQuestion.answerContent }}</div>
            <div v-if="currentQuestion.answerImages" class="images-preview">
              <el-image
                v-for="(img, index) in getImagesArray(currentQuestion.answerImages)"
                :key="index"
                :src="img"
                :preview-src-list="getImagesArray(currentQuestion.answerImages)"
                class="preview-image"
              />
            </div>
          </el-descriptions-item>
          <el-descriptions-item label="标签">
            <el-tag v-for="tag in getTagsArray(currentQuestion.tags)" :key="tag" style="margin-right: 5px;">
              {{ tag }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="备注" v-if="currentQuestion.remark">
            {{ currentQuestion.remark }}
          </el-descriptions-item>
          <el-descriptions-item label="创建时间">
            {{ parseTime(currentQuestion.createTime) }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="viewDialogVisible = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listFavoriteQuestion, unfavoriteQuestion, getQuestion } from "@/api/trouble/question";
import QuestionListItem from "@/views/trouble/question/components/QuestionListItem.vue";
import QuestionEditDialog from "@/views/trouble/question/components/QuestionEditDialog.vue";

export default {
  name: "FavoriteQuestion",
  components: {
    QuestionListItem,
    QuestionEditDialog
  },
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 收藏错题表格数据
      favoriteList: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        questionContent: null,
        questionType: null,
        tags: null,
      },
      // 查看对话框
      viewDialogVisible: false,
      currentQuestion: null
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询收藏错题列表 */
    getList() {
      this.loading = true;
      listFavoriteQuestion(this.queryParams).then(response => {
        this.favoriteList = response.rows || [];
        this.total = response.total || 0;
        this.loading = false;
      }).catch(() => {
        this.favoriteList = [];
        this.total = 0;
        this.loading = false;
      });
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 多选框选中数据 */
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.questionId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    /** 查看详情 */
    handleView(row) {
      this.currentQuestion = { ...row };
      this.viewDialogVisible = true;
    },
    /** 编辑 */
    handleEdit(row) {
      this.currentQuestion = { ...row };
      this.$nextTick(() => {
        if (this.$refs.editDialog) {
          this.$refs.editDialog.open();
        }
      });
    },

    handleEditSuccess() {
      this.getList();
      this.currentQuestion = null;
    },
    /** 取消收藏 */
    handleUnfavorite(row) {
      const questionId = row.questionId || row;
      this.$modal.confirm('确认要取消收藏该错题吗？').then(() => {
        return unfavoriteQuestion(questionId);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("已取消收藏");
      }).catch(() => {});
    },

    /** 从列表组件取消收藏 */
    handleUnfavoriteFromList(question) {
      this.handleUnfavorite(question);
    },
    /** 批量取消收藏 */
    handleBatchUnfavorite() {
      const questionIds = this.ids;
      this.$modal.confirm('确认要批量取消收藏选中的错题吗？').then(() => {
        const promises = questionIds.map(id => unfavoriteQuestion(id));
        return Promise.all(promises);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("已批量取消收藏");
      }).catch(() => {});
    },
    /** 返回 */
    goBack() {
      this.$router.push('/');
    },
    /** 获取题目类型标签类型 */
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
    },
    /** 获取图片数组 */
    getImagesArray(images) {
      if (!images) return [];
      const imageList = images.split(',').filter(img => img.trim());
      return imageList.map(img => {
        if (img.startsWith('http')) return img;
        return process.env.VUE_APP_BASE_API + img;
      });
    }
  }
};
</script>

<style scoped>
/* 蓝色系美化 - 收藏页面 */
::v-deep .app-container {
  background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 50%, #90caf9 100%);
  min-height: calc(100vh - 50px);
  padding: 20px;
  position: relative;
  overflow: hidden;
}

/* 背景装饰元素 */
::v-deep .app-container::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(33, 150, 243, 0.1) 0%, transparent 70%);
  animation: rotate 30s linear infinite;
  z-index: 0;
  transform-origin: center;
}

::v-deep .app-container > * {
  position: relative;
  z-index: 1;
}

@keyframes rotate {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* 页面头部 */
.page-header {
  margin-bottom: 24px;
  padding: 24px;
  background: rgba(255, 255, 255, 0.95);
  /* 移除blur以提升性能 */
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(42, 82, 152, 0.12);
  animation: slideIn 0.6s ease-out;
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

.header-content {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-icon {
  font-size: 32px;
  background: linear-gradient(135deg, #f39c12 0%, #f1c40f 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.header-title {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.header-desc {
  margin: 0;
  font-size: 14px;
  color: #7a8a9a;
  padding-left: 44px;
}

/* 搜索表单美化 */
.search-form {
  margin-bottom: 20px;
  padding: 20px;
  background: rgba(255, 255, 255, 0.95);
  /* 移除blur以提升性能 */
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(42, 82, 152, 0.1);
}

::v-deep .search-form .el-form-item__label {
  color: #2c3e50;
  font-weight: 600;
  font-size: 14px;
  white-space: nowrap;
  flex-shrink: 0;
}

.search-form-item {
  min-width: 0;
}

.search-form-item ::v-deep .el-form-item__label {
  white-space: nowrap;
}

::v-deep .search-form .el-input__inner,
::v-deep .search-form .el-select .el-input__inner {
  border-radius: 8px;
  border: 1px solid #d4e8f7;
  transition: all 0.3s;
  font-size: 14px;
}

::v-deep .search-form .el-input__inner:focus {
  border-color: #2a5298;
  box-shadow: 0 0 0 2px rgba(42, 82, 152, 0.1);
}

::v-deep .search-form .el-button {
  font-size: 14px;
  font-weight: 600;
  padding: 10px 20px;
}

/* 操作按钮区 */
.mb8 {
  margin-bottom: 16px;
  padding: 20px;
  background: rgba(255, 255, 255, 0.95);
  /* 移除blur以提升性能 */
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(42, 82, 152, 0.1);
}

::v-deep .el-button {
  border-radius: 10px;
  font-weight: 600;
  font-size: 15px;
  padding: 12px 24px;
  transition: all 0.3s;
  letter-spacing: 0.5px;
}

::v-deep .el-button i {
  font-size: 16px;
  margin-right: 6px;
}

/* 操作按钮区的按钮 */
::v-deep .mb8 .el-button {
  color: #333;
  background: #ffffff;
  border: 1px solid #e0e0e0;
}

::v-deep .mb8 .el-button:hover {
  color: #667eea;
  border-color: #667eea;
  background: rgba(102, 126, 234, 0.05);
}

::v-deep .el-button--primary {
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  border: none;
  box-shadow: 0 4px 12px rgba(42, 82, 152, 0.25);
}

::v-deep .el-button--primary:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(42, 82, 152, 0.4);
}

::v-deep .el-button--danger {
  background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
  border: none;
  box-shadow: 0 4px 12px rgba(231, 76, 60, 0.25);
}

::v-deep .el-button--danger:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(231, 76, 60, 0.4);
}

::v-deep .el-button--info {
  background: linear-gradient(135deg, #5a6c7d 0%, #7a8a9a 100%);
  border: none;
  box-shadow: 0 4px 12px rgba(90, 108, 125, 0.25);
}

::v-deep .el-button--info:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(90, 108, 125, 0.4);
}

::v-deep .el-button--mini {
  font-size: 14px;
  padding: 9px 18px;
}

/* 表格美化 */
::v-deep .favorite-table {
  background: rgba(255, 255, 255, 0.95);
  /* 移除blur以提升性能 */
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(42, 82, 152, 0.12);
}

::v-deep .favorite-table .el-table__header th {
  background: linear-gradient(135deg, #f8fbff 0%, #ffffff 100%);
  color: #2c3e50;
  font-weight: 600;
  border-bottom: 2px solid #e8f1f8;
}

::v-deep .favorite-table .el-table__body td {
  border-bottom: 1px solid #e8f1f8;
}

::v-deep .favorite-table .el-table--striped .el-table__body tr.el-table__row--striped td {
  background: #f8fbff;
}

::v-deep .favorite-table .el-table__body tr:hover > td {
  background: #f0f7ff !important;
}

.question-preview {
  color: #5a6c7d;
  line-height: 1.6;
}

/* 标签美化 */
::v-deep .el-tag {
  border-radius: 6px;
  border: none;
  background: linear-gradient(135deg, #e8f4f8 0%, #d4e8f7 100%);
  color: #2a5298;
  font-weight: 500;
  margin-right: 4px;
}

/* 表格内按钮美化 */
::v-deep .el-table .el-button--text {
  font-size: 14px;
  font-weight: 600;
  padding: 8px 12px;
}

::v-deep .el-table .el-button--text:hover {
  background-color: rgba(42, 82, 152, 0.1);
  border-radius: 6px;
}

/* 分页美化 */
::v-deep .pagination-container {
  text-align: center;
  margin-top: 20px;
  padding: 16px;
  background: rgba(255, 255, 255, 0.95);
  /* 移除blur以提升性能 */
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(42, 82, 152, 0.1);
}

/* 对话框美化 */
::v-deep .view-dialog .el-dialog {
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.98);
  /* 移除blur以提升性能 */
  box-shadow: 0 12px 48px rgba(42, 82, 152, 0.2);
}

::v-deep .view-dialog .el-dialog__header {
  background: linear-gradient(135deg, #f39c12 0%, #f1c40f 100%);
  border-radius: 16px 16px 0 0;
  padding: 20px;
}

::v-deep .view-dialog .el-dialog__title {
  color: #ffffff;
  font-weight: 600;
}

::v-deep .view-dialog .el-dialog__headerbtn .el-dialog__close {
  color: rgba(255, 255, 255, 0.9);
}

::v-deep .view-dialog .el-dialog__headerbtn .el-dialog__close:hover {
  color: #ffffff;
}

::v-deep .view-dialog .el-dialog__body {
  padding: 24px;
  background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
}

.question-detail {
  padding: 12px;
}

.content-text {
  line-height: 1.8;
  color: #5a6c7d;
  white-space: pre-wrap;
  margin-bottom: 12px;
}

.images-preview {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 12px;
}

.preview-image {
  width: 120px;
  height: 120px;
  border-radius: 8px;
  object-fit: cover;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 2px 12px rgba(42, 82, 152, 0.1);
}

.preview-image:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 20px rgba(42, 82, 152, 0.2);
}

/* 题目列表容器 */
.questions-container {
  margin-top: 20px;
}

.questions-list {
  background: rgba(255, 255, 255, 0.95);
  border: 1px solid #e0e0e0;
  border-radius: 12px;
  margin-bottom: 24px;
  overflow: hidden;
  box-shadow: 0 4px 16px rgba(42, 82, 152, 0.1);
}

.empty-state {
  text-align: center;
  padding: 80px 20px;
  color: #9e9e9e;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 12px;
}

.empty-state i {
  font-size: 64px;
  display: block;
  margin-bottom: 16px;
  opacity: 0.4;
}

.empty-state p {
  font-size: 16px;
  margin: 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  ::v-deep .app-container {
    padding: 12px;
  }

  .page-header {
    padding: 16px;
    margin-bottom: 16px;
  }

  .header-icon {
    font-size: 24px;
  }

  .header-title {
    font-size: 20px;
  }

  .header-desc {
    padding-left: 36px;
    font-size: 13px;
  }

  .search-form {
    padding: 15px;
  }

  .mb8 {
    padding: 12px;
  }

  .preview-image {
    width: 80px;
    height: 80px;
  }
}
</style>

