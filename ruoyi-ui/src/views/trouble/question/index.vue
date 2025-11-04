<template>
  <div class="app-container">
    <!-- 搜索表单-->
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px" class="search-form">
      <el-row :gutter="10">
        <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <el-form-item label="题目内容" prop="questionContent">
            <el-input
              v-model="queryParams.questionContent"
              placeholder="请输入题目内容"
              clearable
              @keyup.enter.native="handleQuery"
            />
          </el-form-item>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="6">
          <el-form-item label="题目类型" prop="questionType">
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

    <!-- 操作按钮-->
    <el-row :gutter="10" class="mb8 action-buttons">
      <el-col :xs="12" :sm="6" :md="4" :lg="3" :xl="3">
        <el-button
          type="info"
          plain
          icon="el-icon-house"
          size="mini"
          @click="goToDashboard"
          class="full-width-btn"
        >返回主页</el-button>
      </el-col>
      <el-col :xs="12" :sm="6" :md="4" :lg="3" :xl="3">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['trouble:question:add']"
          class="full-width-btn"
        >新增</el-button>
      </el-col>
      <el-col :xs="12" :sm="6" :md="4" :lg="3" :xl="3">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['trouble:question:edit']"
          class="full-width-btn"
        >修改</el-button>
      </el-col>
      <el-col :xs="12" :sm="6" :md="4" :lg="3" :xl="3">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['trouble:question:remove']"
          class="full-width-btn"
        >删除</el-button>
      </el-col>
      <el-col :xs="12" :sm="6" :md="4" :lg="3" :xl="3">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['trouble:question:export']"
          class="full-width-btn"
        >导出</el-button>
      </el-col>
      <el-col :xs="24" :sm="24" :md="8" :lg="12" :xl="12">
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
      </el-col>
    </el-row>

    <!-- 表格-->
    <div class="table-container">
      <el-table
        v-loading="loading"
        :data="questionList"
        @selection-change="handleSelectionChange"
        :default-sort="{prop: 'createTime', order: 'descending'}"
        stripe
        border
        class="responsive-table"
      >
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column
          label="题目内容"
          align="center"
          prop="questionContent"
          :show-overflow-tooltip="true"
          min-width="200"
          class-name="question-content"
        />
        <el-table-column
          label="题目图片"
          align="center"
          prop="questionImages"
          width="100"
          class-name="hidden-xs-only"
        >
          <template slot-scope="scope">
            <el-image
              v-if="scope.row.questionImages"
              :src="getImageUrl(scope.row.questionImages.split(',')[0])"
              :preview-src-list="scope.row.questionImages.split(',').map(img => getImageUrl(img))"
              style="width: 60px; height: 60px"
              fit="cover"
            />
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column
          label="答案内容"
          align="center"
          prop="answerContent"
          :show-overflow-tooltip="true"
          min-width="150"
          class-name="hidden-xs-only"
        />
        <el-table-column
          label="题目类型"
          align="center"
          prop="questionType"
          width="100"
        />
        <el-table-column
          label="标签"
          align="center"
          prop="tags"
          :show-overflow-tooltip="true"
          min-width="120"
          class-name="hidden-xs-only"
        />
        <el-table-column
          label="创建时间"
          align="center"
          prop="createTime"
          width="180"
          sortable
        >
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
          </template>
        </el-table-column>
        <el-table-column
          label="操作"
          align="center"
          class-name="small-padding fixed-width"
          width="150"
        >
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="text"
              icon="el-icon-edit"
              @click="handleUpdate(scope.row)"
              v-hasPermi="['trouble:question:edit']"
            >修改</el-button>
            <el-button
              size="mini"
              type="text"
              icon="el-icon-delete"
              @click="handleDelete(scope.row)"
              v-hasPermi="['trouble:question:remove']"
            >删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改错题对话框 - 响应式设计 -->
    <el-dialog
      :title="title"
      :visible.sync="open"
      :width="dialogWidth"
      :fullscreen="isMobile"
      append-to-body
      class="responsive-dialog"
    >
      <el-form ref="form" :model="form" :rules="rules" label-width="80px" class="dialog-form">
        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="题目内容" prop="questionContent">
              <el-input
                v-model="form.questionContent"
                type="textarea"
                :rows="4"
                placeholder="请输入题目内容"
                maxlength="2000"
                show-word-limit
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :xs="24" :sm="12">
            <el-form-item label="题目图片" prop="questionImages">
              <image-upload v-model="form.questionImages" :limit="5"/>
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="12">
            <el-form-item label="答案图片" prop="answerImages">
              <image-upload v-model="form.answerImages" :limit="5"/>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="答案内容" prop="answerContent">
              <el-input
                v-model="form.answerContent"
                type="textarea"
                :rows="3"
                placeholder="请输入答案内容"
                maxlength="2000"
                show-word-limit
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :xs="24" :sm="12">
            <el-form-item label="题目类型" prop="questionType">
              <el-select v-model="form.questionType" placeholder="请选择题目类型" style="width: 100%">
                <el-option label="未区分" value="未区分" />
                <el-option label="选择题" value="选择题" />
                <el-option label="填空题" value="填空题" />
                <el-option label="解答题" value="解答题" />
                <el-option label="其他" value="其他" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="12">
            <el-form-item label="标签" prop="tags">
              <el-input
                v-model="form.tags"
                placeholder="请输入标签，多个用逗号分隔"
                maxlength="500"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="备注" prop="remark">
              <el-input
                v-model="form.remark"
                type="textarea"
                :rows="2"
                placeholder="请输入备注信息（可选）"
                maxlength="500"
                show-word-limit
              />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listQuestion, getQuestion, delQuestion, addQuestion, updateQuestion } from "@/api/trouble/question";

export default {
  name: "Question",
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
      // 错题表格数据
      questionList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        questionContent: null,
        questionType: null,
        tags: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        questionContent: [
          { required: true, message: "题目内容不能为空", trigger: "blur" }
        ]
      },
      // 响应式相关
      isMobile: false,
      dialogWidth: '800px'
    };
  },
  computed: {
    // 动态计算对话框宽度
    computedDialogWidth() {
      return this.isMobile ? '100%' : '800px';
    }
  },
  mounted() {
    this.handleResize();
    window.addEventListener('resize', this.handleResize);
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize);
  },
  created() {
    this.getList();
  },
  methods: {
    /** 处理窗口大小变化 */
    handleResize() {
      const width = window.innerWidth;
      this.isMobile = width < 768;
      this.dialogWidth = this.isMobile ? '95%' : '800px';
    },
    /** 获取完整的图片URL */
    getImageUrl(imagePath) {
      if (!imagePath) return '';
      // 如果已经是完整URL，直接返回
      if (imagePath.startsWith('http')) {
        return imagePath;
      }
      // 如果是相对路径，添加baseUrl前缀
      const baseUrl = process.env.VUE_APP_BASE_API;
      return baseUrl + (imagePath.startsWith('/') ? imagePath : '/' + imagePath);
    },
    /** 查询错题列表 */
    getList() {
      this.loading = true;
      listQuestion(this.queryParams).then(response => {
        this.questionList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        questionId: null,
        userId: null,
        questionContent: null,
        questionImages: null,
        answerContent: null,
        answerImages: null,
        questionType: "未区分",
        tags: null,
        status: "0",
        createBy: null,
        createTime: null,
        updateBy: null,
        updateTime: null,
        remark: null
      };
      this.resetForm("form");
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
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.questionId)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    goToDashboard() {
      this.$router.push("/trouble/dashboard");
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加错题";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const questionId = row.questionId || this.ids
      getQuestion(questionId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改错题";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.questionId != null) {
            updateQuestion(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addQuestion(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const questionIds = row.questionId || this.ids;
      this.$modal.confirm('是否确认删除错题编号为"' + questionIds + '"的数据项？').then(function() {
        return delQuestion(questionIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('trouble/question/export', {
        ...this.queryParams
      }, `question_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

<style scoped>
/* 响应式样式 */
.search-form {
  margin-bottom: 20px;
}

.action-buttons {
  margin-bottom: 20px;
}

.full-width-btn {
  width: 100%;
}

.table-container {
  overflow-x: auto;
}

.responsive-table {
  min-width: 600px;
}

/* 移动端优化 */
@media (max-width: 768px) {
  .search-form .el-form-item {
    margin-bottom: 15px;
  }

  .action-buttons .el-col {
    margin-bottom: 10px;
  }

  .responsive-table {
    font-size: 12px;
  }

  .responsive-table .el-table__cell {
    padding: 8px 4px;
  }

  .dialog-form .el-form-item {
    margin-bottom: 15px;
  }

  .dialog-form .el-input,
  .dialog-form .el-textarea,
  .dialog-form .el-select {
    width: 100%;
  }
}

/* 平板优化 */
@media (min-width: 769px) and (max-width: 1024px) {
  .search-form .el-col {
    margin-bottom: 10px;
  }

  .responsive-table {
    font-size: 13px;
  }
}

/* 桌面端优化 */
@media (min-width: 1025px) {
  .search-form .el-col {
    margin-bottom: 0;
  }
}

/* 表格列隐藏控制 */
.hidden-xs-only {
  display: table-cell;
}

@media (max-width: 768px) {
  .hidden-xs-only {
    display: none;
  }
}

/* 对话框响应式 */
.responsive-dialog .el-dialog {
  margin: 0 auto;
}

@media (max-width: 768px) {
  .responsive-dialog .el-dialog {
    margin: 0;
    width: 100% !important;
    height: 100%;
  }

  .responsive-dialog .el-dialog__body {
    padding: 15px;
    max-height: calc(100vh - 120px);
    overflow-y: auto;
  }
}

/* 表格内容优化 */
.question-content {
  max-width: 200px;
  word-break: break-word;
}

/* 按钮组优化 */
.action-buttons .el-button {
  margin-bottom: 5px;
}

@media (max-width: 768px) {
  .action-buttons .el-button {
    font-size: 12px;
    padding: 5px 10px;
  }
}
</style>
