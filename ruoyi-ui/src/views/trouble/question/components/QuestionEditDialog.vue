<template>
  <el-dialog
    title="编辑错题"
    :visible.sync="visible"
    width="800px"
    :close-on-click-modal="false"
    :modal="false"
    :append-to-body="true"
    :lock-scroll="false"
    custom-class="question-edit-dialog"
    @close="handleCancel"
    @opened="handleDialogOpened"
    @closed="handleDialogClosed"
  >
    <el-form
      ref="form"
      :model="form"
      :rules="rules"
      label-width="100px"
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
          style="margin-top: 6px;"
        >
          OCR识别
        </el-button>
      </el-form-item>

      <el-form-item label="题目图片">
        <image-upload
          v-model="form.questionImages"
          :limit="5"
        />
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
          style="margin-top: 6px;"
        >
          OCR识别
        </el-button>
      </el-form-item>

      <el-form-item label="答案图片">
        <image-upload
          v-model="form.answerImages"
          :limit="5"
        />
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

      <el-form-item label="标签">
        <el-select
          v-model="selectedTags"
          multiple
          filterable
          allow-create
          default-first-option
          placeholder="请选择或输入标签"
          style="width: 100%"
          @change="handleTagsChange"
        >
          <el-option
            v-for="tag in defaultTags"
            :key="tag"
            :label="tag"
            :value="tag"
          />
        </el-select>
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
      <el-button type="primary" :loading="submitLoading" @click="handleSubmit">确 定</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { getQuestion, updateQuestion } from "@/api/trouble/question";

export default {
  name: "QuestionEditDialog",
  props: {
    questionId: {
      type: [Number, String],
      default: null
    }
  },
  data() {
    return {
      visible: false,
      submitLoading: false,
      form: {
        questionId: null,
        questionContent: "",
        questionImages: "",
        answerContent: "",
        answerImages: "",
        questionType: "未区分",
        tags: "",
        remark: ""
      },
      rules: {
        questionContent: [
          { required: true, message: "题目内容不能为空", trigger: "blur" }
        ]
      },
      selectedTags: [],
      defaultTags: ["语文", "数学", "英语", "物理", "化学", "生物", "政治", "历史", "地理"]
    };
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
    }
  },
  methods: {
    open() {
      this.visible = true;
    },
    close() {
      this.visible = false;
    },
    handleDialogOpened() {
      // 移除可能存在的多余遮罩层
      this.$nextTick(() => {
        const modals = document.querySelectorAll('.v-modal');
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
        const modals = document.querySelectorAll('.v-modal');
        modals.forEach(modal => {
          if (!modal.getAttribute('data-keep')) {
            modal.remove();
          }
        });
      });
    },
    loadQuestion() {
      if (!this.questionId) return;
      getQuestion(this.questionId).then(response => {
        this.form = {
          questionId: response.data.questionId,
          questionContent: response.data.questionContent || "",
          questionImages: response.data.questionImages || "",
          answerContent: response.data.answerContent || "",
          answerImages: response.data.answerImages || "",
          questionType: response.data.questionType || "未区分",
          tags: response.data.tags || "",
          remark: response.data.remark || ""
        };
        this.selectedTags = this.form.tags ? this.form.tags.split(',').filter(t => t.trim()) : [];
      });
    },
    async handleOCR(target) {
      const fileInput = document.createElement('input');
      fileInput.type = 'file';
      fileInput.accept = 'image/*';
      fileInput.onchange = async (e) => {
        const file = e.target.files[0];
        if (!file) return;

        const formData = new FormData();
        formData.append('file', file);

        try {
          const host = window.location.hostname;
          const port = 9000;

          const res = await fetch(`http://${host}:${port}/ocr/upload`, {
            method: 'POST',
            body: formData,
          });

          if (!res.ok) {
            throw new Error(`HTTP错误 ${res.status}`);
          }

          const data = await res.json();
          if (!data.text) {
            throw new Error('OCR返回内容为空');
          }

          if (target === 'question') {
            this.form.questionContent = data.text;
          } else if (target === 'answer') {
            this.form.answerContent = data.text;
          }

          this.$message.success('OCR识别成功');
        } catch (err) {
          this.$message.error('OCR识别失败: ' + (err.message || '未知错误'));
          console.error(err);
        }
      };

      fileInput.click();
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
      }
    },
    handleSubmit() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.submitLoading = true;
          updateQuestion(this.form)
            .then(() => {
              this.$message.success("修改成功");
              this.submitLoading = false;
              this.$emit('success');
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
      this.$emit('cancel');
      this.close();
    }
  }
};
</script>

<style scoped>
.dialog-footer {
  text-align: right;
}
</style>

<style>
/* 编辑对话框样式 */
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
</style>
