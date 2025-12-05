<template>
  <el-dialog
    title="编辑错题"
    :visible.sync="visible"
    :width="isMobile ? '100%' : '800px'"
    :close-on-click-modal="false"
    :modal="true"
    :append-to-body="true"
    :lock-scroll="false"
    :custom-class="
      isMobile ? 'question-edit-dialog mobile-dialog' : 'question-edit-dialog'
    "
    @close="handleCancel"
    @opened="handleDialogOpened"
    @closed="handleDialogClosed"
  >
    <el-form
      ref="form"
      :model="form"
      :rules="rules"
      :label-width="isMobile ? '80px' : '100px'"
      class="edit-form"
    >
      <el-form-item label="题目内容" prop="questionContent">
        <el-input
          v-model="form.questionContent"
          type="textarea"
          :rows="4"
          placeholder="请输入题目内容"
          maxlength="2000"
          show-word-limit
        />
        <el-button
          size="mini"
          type="primary"
          @click="handleOCR('question')"
          style="margin-top: 6px"
        >
          OCR识别
        </el-button>
      </el-form-item>

      <el-form-item label="题目图片">
        <image-upload v-model="form.questionImages" :limit="5" />
      </el-form-item>

      <el-form-item label="答案内容">
        <el-input
          v-model="form.answerContent"
          type="textarea"
          :rows="4"
          placeholder="请输入答案内容"
          maxlength="2000"
          show-word-limit
        />
        <el-button
          size="mini"
          type="primary"
          @click="handleOCR('answer')"
          style="margin-top: 6px"
        >
          OCR识别
        </el-button>
      </el-form-item>

      <el-form-item label="答案图片">
        <image-upload v-model="form.answerImages" :limit="5" />
      </el-form-item>

      <el-form-item label="题目类型" prop="questionType">
        <el-select
          v-model="form.questionType"
          placeholder="请选择题目类型"
          style="width: 100%"
        >
          <el-option label="未区分" value="未区分" />
          <el-option label="选择题" value="选择题" />
          <el-option label="填空题" value="填空题" />
          <el-option label="解答题" value="解答题" />
          <el-option label="其他" value="其他" />
        </el-select>
      </el-form-item>

      <el-form-item label="重要性" prop="importance">
        <el-radio-group v-model="form.importance">
          <el-radio :label="3">高</el-radio>
          <el-radio :label="2">中</el-radio>
          <el-radio :label="1">低</el-radio>
        </el-radio-group>
      </el-form-item>

      <el-form-item label="熟练度" prop="proficiency">
        <el-radio-group v-model="form.proficiency">
          <el-radio :label="3">熟练</el-radio>
          <el-radio :label="2">较好</el-radio>
          <el-radio :label="1">一般</el-radio>
          <el-radio :label="0">陌生</el-radio>
        </el-radio-group>
      </el-form-item>

      <el-form-item label="错题来源">
        <el-select
          v-model="form.questionSource"
          placeholder="请选择错题来源"
          style="width: 100%"
          clearable
        >
          <el-option label="课堂练习" value="课堂练习" />
          <el-option label="课后作业" value="课后作业" />
          <el-option label="周测/月考" value="周测/月考" />
          <el-option label="单元测试" value="单元测试" />
          <el-option label="期中/期末考试" value="期中/期末考试" />
          <el-option label="模拟考试" value="模拟考试" />
          <el-option label="真题" value="真题" />
          <el-option label="教辅资料" value="教辅资料" />
          <el-option label="竞赛类" value="竞赛类" />
        </el-select>
      </el-form-item>

      <el-form-item label="年级">
        <el-select
          v-model="form.grade"
          placeholder="请选择年级"
          style="width: 100%"
          clearable
        >
          <el-option label="小学一年级" value="小学一年级" />
          <el-option label="小学二年级" value="小学二年级" />
          <el-option label="小学三年级" value="小学三年级" />
          <el-option label="小学四年级" value="小学四年级" />
          <el-option label="小学五年级" value="小学五年级" />
          <el-option label="小学六年级" value="小学六年级" />
          <el-option label="初中一年级" value="初中一年级" />
          <el-option label="初中二年级" value="初中二年级" />
          <el-option label="初中三年级" value="初中三年级" />
          <el-option label="高中一年级" value="高中一年级" />
          <el-option label="高中二年级" value="高中二年级" />
          <el-option label="高中三年级" value="高中三年级" />
        </el-select>
      </el-form-item>

      <el-form-item label="错误类型">
        <el-select
          v-model="form.errorType"
          placeholder="请选择错误类型"
          style="width: 100%"
          clearable
        >
          <el-option label="基础薄弱" value="基础薄弱" />
          <el-option label="粗心失误" value="粗心失误" />
          <el-option label="计算错误" value="思路方法" />
          <el-option label="审题不清" value="考试场景" />
        </el-select>
      </el-form-item>

      <el-form-item label="难度等级">
        <el-radio-group v-model="form.difficulty">
          <el-radio :label="1">简单</el-radio>
          <el-radio :label="2">中等</el-radio>
          <el-radio :label="3">困难</el-radio>
        </el-radio-group>
      </el-form-item>

      <el-form-item label="标签">
        <el-select
          v-model="selectedTags"
          multiple
          filterable
          allow-create
          default-first-option
          placeholder="请选择或输入标签（输入关键词可自动补全）"
          style="width: 100%"
          @change="handleTagsChange"
          @visible-change="handleTagSelectVisible"
          :filter-method="filterTags"
          :reserve-keyword="true"
        >
          <el-option
            v-for="tag in filteredTags"
            :key="tag"
            :label="tag"
            :value="tag"
          >
            <span>{{ tag }}</span>
            <span
              v-if="isCustomTag(tag)"
              style="float: right; color: #8492a6; font-size: 12px"
            >
              <i class="el-icon-star-on"></i> 自定义
            </span>
          </el-option>
        </el-select>
        <div style="font-size: 12px; color: #909399; margin-top: 5px">
          <i class="el-icon-info"></i>
          输入关键词可自动补全历史标签，自定义标签会自动保存
        </div>
      </el-form-item>

      <el-form-item label="备注">
        <el-input
          v-model="form.remark"
          type="textarea"
          :rows="2"
          placeholder="请输入备注信息（可选）"
          maxlength="500"
          show-word-limit
        />
      </el-form-item>
    </el-form>

    <div slot="footer" class="dialog-footer">
      <el-button @click="handleCancel">取 消</el-button>
      <el-button type="primary" :loading="submitLoading" @click="handleSubmit"
        >确 定</el-button
      >
    </div>
  </el-dialog>
</template>

<script>
import { getQuestion, updateQuestion } from "@/api/trouble/question";
import {
  getAllTags,
  saveCustomTags,
  extractAndSaveTags,
} from "@/utils/tagUtils";

export default {
  name: "QuestionEditDialog",
  props: {
    questionId: {
      type: [Number, String],
      default: null,
    },
  },
  data() {
    return {
      visible: false,
      submitLoading: false,
      isMobile: false,
      form: {
        questionId: null,
        questionContent: "",
        questionImages: "",
        answerContent: "",
        answerImages: "",
        questionType: "未区分",
        tags: "",
        importance: 2,
        proficiency: 0,
        questionSource: "",
        grade: "",
        errorType: "",
        difficulty: 2,
        remark: "",
      },
      rules: {
        questionContent: [
          { required: true, message: "题目内容不能为空", trigger: "blur" },
        ],
      },
      selectedTags: [],
      defaultTags: [
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
      allAvailableTags: [], // 所有可用标签（系统标签 + 自定义标签）
      filteredTags: [], // 过滤后的标签列表
      tagSearchQuery: "", // 标签搜索关键词
    };
  },
  created() {
    this.checkIsMobile();
    window.addEventListener("resize", this.checkIsMobile);
    // 加载所有可用标签
    this.loadAllTags();
  },
  beforeDestroy() {
    window.removeEventListener("resize", this.checkIsMobile);
  },
  watch: {
    questionId(newVal) {
      if (newVal) {
        this.loadQuestion();
      }
    },
    visible(newVal) {
      if (newVal && this.questionId) {
        this.loadQuestion();
      }
    },
  },
  methods: {
    checkIsMobile() {
      this.isMobile = window.matchMedia("(max-width: 767px)").matches;
    },
    open() {
      this.visible = true;
    },
    close() {
      this.visible = false;
    },
    handleDialogOpened() {
      // 移除可能存在的多余遮罩层
      this.$nextTick(() => {
        const modals = document.querySelectorAll(".v-modal");
        if (modals.length > 1) {
          // 如果存在多个遮罩，移除多余的
          for (let i = 1; i < modals.length; i++) {
            modals[i].remove();
          }
        }
      });
    },
    handleDialogClosed() {
      // 确保关闭时清理遮罩
      this.$nextTick(() => {
        const modals = document.querySelectorAll(".v-modal");
        modals.forEach((modal) => {
          if (!modal.getAttribute("data-keep")) {
            modal.remove();
          }
        });
      });
    },
    loadQuestion() {
      if (!this.questionId) return;
      getQuestion(this.questionId).then((response) => {
        this.form = {
          questionId: response.data.questionId,
          questionContent: response.data.questionContent || "",
          questionImages: response.data.questionImages || "",
          answerContent: response.data.answerContent || "",
          answerImages: response.data.answerImages || "",
          questionType: response.data.questionType || "未区分",
          tags: response.data.tags || "",
          importance: response.data.importance || 2,
          proficiency:
            response.data.proficiency !== undefined &&
            response.data.proficiency !== null
              ? response.data.proficiency
              : 0,
          questionSource: response.data.questionSource || "",
          grade: response.data.grade || "",
          errorType: response.data.errorType || "",
          difficulty:
            response.data.difficulty !== undefined &&
            response.data.difficulty !== null
              ? response.data.difficulty
              : 2,
          remark: response.data.remark || "",
        };
        this.selectedTags = this.form.tags
          ? this.form.tags.split(",").filter((t) => t.trim())
          : [];
      });
    },
    async handleOCR(target) {
      const fileInput = document.createElement("input");
      fileInput.type = "file";
      fileInput.accept = "image/*";
      fileInput.onchange = async (e) => {
        const file = e.target.files[0];
        if (!file) return;

        const formData = new FormData();
        formData.append("file", file);

        try {
          const host = window.location.hostname;
          const port = 9000;

          const res = await fetch(`http://${host}:${port}/ocr/upload`, {
            method: "POST",
            body: formData,
          });

          if (!res.ok) {
            throw new Error(`HTTP错误 ${res.status}`);
          }

          const data = await res.json();
          if (!data.text) {
            throw new Error("OCR返回内容为空");
          }

          if (target === "question") {
            this.form.questionContent = data.text;
          } else if (target === "answer") {
            this.form.answerContent = data.text;
          }

          this.$message.success("OCR识别成功");
        } catch (err) {
          this.$message.error("OCR识别失败: " + (err.message || "未知错误"));
          console.error(err);
        }
      };

      fileInput.click();
    },
    /** 加载所有可用标签 */
    loadAllTags() {
      this.allAvailableTags = getAllTags(this.defaultTags);
      this.filteredTags = [...this.allAvailableTags];
    },

    /** 过滤标签（用于自动补全） */
    filterTags(query) {
      this.tagSearchQuery = query || "";
      if (!query || !query.trim()) {
        this.filteredTags = [...this.allAvailableTags];
        return;
      }

      const queryLower = query.trim().toLowerCase();
      this.filteredTags = this.allAvailableTags.filter((tag) =>
        tag.toLowerCase().includes(queryLower)
      );

      // 如果查询的内容不在现有标签中，也显示在列表中（用户可以创建）
      if (
        !this.allAvailableTags.some((tag) => tag.toLowerCase() === queryLower)
      ) {
        this.filteredTags.push(query.trim());
      }
    },

    /** 判断是否为自定义标签 */
    isCustomTag(tag) {
      return !this.defaultTags.includes(tag);
    },

    /** 处理标签选择器显示/隐藏 */
    handleTagSelectVisible(visible) {
      if (visible) {
        // 打开时重新加载标签（可能有新的自定义标签）
        this.loadAllTags();
      }
    },

    handleTagsChange(value) {
      if (Array.isArray(value)) {
        const maxTags = 8;
        if (value.length > maxTags) {
          value = value.slice(0, maxTags);
          this.selectedTags = value;
          this.$message.info(`标签数量已限制为 ${maxTags} 个`);
        }
        this.form.tags = value.join(",");

        // 保存自定义标签到本地存储
        const customTags = value.filter((tag) => this.isCustomTag(tag));
        if (customTags.length > 0) {
          saveCustomTags(customTags);
          // 重新加载所有标签
          this.loadAllTags();
        }
      }
    },
    handleSubmit() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.submitLoading = true;
          updateQuestion(this.form)
            .then(() => {
              this.$message.success("修改成功");
              // 保存标签到本地存储
              if (this.form.tags) {
                extractAndSaveTags(this.form.tags);
                this.loadAllTags();
              }
              this.submitLoading = false;
              this.$emit("success");
              this.close();
            })
            .catch(() => {
              this.submitLoading = false;
            });
        }
      });
    },
    handleCancel() {
      this.$refs.form.resetFields();
      this.$emit("cancel");
      this.close();
    },
  },
};
</script>

<style scoped>
.dialog-footer {
  text-align: right;
}
</style>

<style>
/* 编辑对话框样式 - 蓝色系美化 */
.question-edit-dialog {
  z-index: 2001 !important;
}

/* 隐藏编辑对话框的遮罩层 */
.question-edit-dialog + .v-modal {
  display: none !important;
}

/* 确保详情弹窗的遮罩在编辑对话框之上 */
.question-detail-overlay {
  z-index: 2000 !important;
}

/* 对话框整体美化 */
.question-edit-dialog .el-dialog {
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(42, 82, 152, 0.15);
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  overflow: hidden;
}

/* 对话框头部美化 */
.question-edit-dialog .el-dialog__header {
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  border-bottom: none;
  padding: 20px 24px;
  margin: 0;
}

.question-edit-dialog .el-dialog__title {
  color: #ffffff;
  font-weight: 600;
  font-size: 18px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.question-edit-dialog .el-dialog__headerbtn .el-dialog__close {
  color: rgba(255, 255, 255, 0.9);
  font-size: 20px;
}

.question-edit-dialog .el-dialog__headerbtn .el-dialog__close:hover {
  color: #ffffff;
}

/* 对话框主体美化 */
.question-edit-dialog .el-dialog__body {
  padding: 32px;
  background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
}

/* 编辑表单样式 */
.edit-form {
  padding: 0;
}

.edit-form .el-form-item {
  margin-bottom: 24px;
  transition: all 0.3s ease;
}

.edit-form .el-form-item__label {
  color: #2c3e50;
  font-weight: 500;
  font-size: 14px;
}

/* 输入框美化 */
.question-edit-dialog .el-input__inner,
.question-edit-dialog .el-textarea__inner {
  border-radius: 8px;
  border: 1px solid #d4e8f7;
  transition: all 0.3s;
  background: #ffffff;
}

.question-edit-dialog .el-input__inner:focus,
.question-edit-dialog .el-textarea__inner:focus {
  border-color: #2a5298;
  box-shadow: 0 0 0 2px rgba(42, 82, 152, 0.1);
}

.question-edit-dialog .el-input__inner:hover,
.question-edit-dialog .el-textarea__inner:hover {
  border-color: #4a9ff5;
}

/* 选择框美化 */
.question-edit-dialog .el-select {
  width: 100%;
}

.question-edit-dialog .el-select .el-input__inner {
  background: #ffffff;
}

/* 标签选择美化 */
.question-edit-dialog .el-tag {
  border-radius: 6px;
  border: none;
  background: linear-gradient(135deg, #e8f4f8 0%, #d4e8f7 100%);
  color: #2a5298;
  font-weight: 500;
  transition: all 0.3s;
}

.question-edit-dialog .el-tag:hover {
  background: linear-gradient(135deg, #d4e8f7 0%, #c5dff5 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(42, 82, 152, 0.15);
}

.question-edit-dialog .el-tag .el-tag__close {
  color: #2a5298;
}

.question-edit-dialog .el-tag .el-tag__close:hover {
  background-color: #2a5298;
  color: #ffffff;
}

/* 按钮美化 */
.question-edit-dialog .el-dialog__footer {
  padding: 16px 24px;
  border-top: 2px solid #e8f1f8;
  background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
  margin: 0;
}

.question-edit-dialog .el-button {
  border-radius: 8px;
  font-weight: 500;
  padding: 12px 32px;
  transition: all 0.3s;
  min-width: 100px;
}

.question-edit-dialog .el-button--primary {
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  border: none;
}

.question-edit-dialog .el-button--primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(42, 82, 152, 0.3);
}

.question-edit-dialog .el-button--default {
  background: #ffffff;
  border: 1px solid #d4e8f7;
  color: #5a6c7d;
}

.question-edit-dialog .el-button--default:hover {
  background: #f8fbff;
  border-color: #2a5298;
  color: #2a5298;
  transform: translateY(-2px);
}

/* 移动端响应式设计 */
@media (max-width: 767px) {
  .question-edit-dialog.mobile-dialog {
    width: 100% !important;
    margin: 0 !important;
    max-height: 100vh;
    border-radius: 0;
  }

  .question-edit-dialog.mobile-dialog .el-dialog {
    width: 100% !important;
    margin: 0 !important;
    height: 100vh;
    max-height: 100vh;
    border-radius: 0;
    display: flex;
    flex-direction: column;
    background: #ffffff;
  }

  .question-edit-dialog.mobile-dialog .v-modal {
    background-color: rgba(0, 0, 0, 0.5) !important;
    opacity: 1 !important;
  }

  .question-edit-dialog.mobile-dialog .el-dialog__header {
    padding: 16px;
    flex-shrink: 0;
    background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
    border-bottom: none;
    border-radius: 0;
  }

  .question-edit-dialog.mobile-dialog .el-dialog__title {
    font-size: 18px;
    color: #ffffff;
  }

  .question-edit-dialog.mobile-dialog .el-dialog__body {
    flex: 1;
    overflow-y: auto;
    padding: 20px 16px;
    background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
    -webkit-overflow-scrolling: touch;
  }

  .question-edit-dialog.mobile-dialog .edit-form {
    padding: 0;
  }

  .question-edit-dialog.mobile-dialog .edit-form .el-form-item {
    margin-bottom: 18px;
  }

  .question-edit-dialog.mobile-dialog .el-form-item__label {
    font-size: 14px;
    padding-bottom: 8px;
    line-height: 1.5;
    color: #2c3e50;
  }

  .question-edit-dialog.mobile-dialog .el-input__inner,
  .question-edit-dialog.mobile-dialog .el-textarea__inner {
    font-size: 14px;
  }

  .question-edit-dialog.mobile-dialog .el-select {
    width: 100%;
  }

  .question-edit-dialog.mobile-dialog .el-dialog__footer {
    padding: 16px;
    flex-shrink: 0;
    border-top: 2px solid #e8f1f8;
    background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
    border-radius: 0;
  }

  .question-edit-dialog.mobile-dialog .el-button {
    width: 100%;
    margin: 0;
  }

  .question-edit-dialog.mobile-dialog .dialog-footer {
    display: flex;
    gap: 12px;
  }

  .question-edit-dialog.mobile-dialog .dialog-footer .el-button {
    flex: 1;
  }
}
</style>
