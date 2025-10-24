<template>
  <div class="app-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix header-row">
        <span class="card-title">添加错题</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="goBack">
          返回列表 (Back)
        </el-button>
      </div>

      <el-form
        ref="form"
        :model="form"
        :rules="rules"
        :label-width="labelWidth"
        class="form-layout"
      >
        <el-row :gutter="20">
          <el-col :xs="24" :sm="24" :md="24">
            <el-form-item label="题目内容" prop="questionContent">
              <el-input
                v-model="form.questionContent"
                type="textarea"
                :rows="6"
                placeholder="请输入题目内容，支持拍照识别 (Enter question content, supports camera OCR)"
                show-word-limit
                maxlength="2000"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :xs="24" :sm="12" :md="12">
            <el-form-item label="题目图片">
              <!-- 确保 image-upload 在移动端是宽满的 -->
              <image-upload v-model="form.questionImages" :limit="1" class="image-upload-full" />
              <div class="upload-tip">支持拍照上传，最多1张图片 (Supports photo upload, max 1)</div>
            </el-form-item>
          </el-col>

          <el-col :xs="24" :sm="12" :md="12">
            <el-form-item label="答案图片">
              <image-upload v-model="form.answerImages" :limit="1" class="image-upload-full" />
              <div class="upload-tip">支持拍照上传，最多1张图片 (Supports photo upload, max 1)</div>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :xs="24" :sm="24" :md="24">
            <el-form-item label="答案内容">
              <el-input
                v-model="form.answerContent"
                type="textarea"
                :rows="4"
                placeholder="请输入答案内容或解析 (Enter answer or explanation)"
                show-word-limit
                maxlength="2000"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20" class="row-inline">
          <el-col :xs="24" :sm="12" :md="12">
            <el-form-item label="题目类型" prop="questionType">
              <el-select v-model="form.questionType" placeholder="请选择题目类型 (Select type)" style="width: 100%">
                <el-option label="未区分" value="未区分" />
                <el-option label="选择题" value="选择题" />
                <el-option label="填空题" value="填空题" />
                <el-option label="解答题" value="解答题" />
                <el-option label="其他" value="其他" />
              </el-select>
            </el-form-item>
          </el-col>

          <el-col :xs="24" :sm="12" :md="12">
            <el-form-item label="标签">
              <el-input
                v-model="form.tags"
                placeholder="请输入标签，多个用逗号分隔，如：数学,几何 (e.g. Math,Geometry)"
                @input="handleTagsInput"
              />
              <div class="tag-tip">建议标签：数学、语文、英语、物理、化学、生物、历史、地理、政治等</div>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :xs="24" :sm="24" :md="24">
            <el-form-item label="备注">
              <el-input
                v-model="form.remark"
                type="textarea"
                :rows="2"
                placeholder="请输入备注信息（可选） (Optional notes)"
                maxlength="500"
                show-word-limit
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row class="action-row" :gutter="12">
          <!-- 按钮在移动端占满，桌面端靠中居中显示 -->
          <el-col :xs="24" :sm="24" :md="24" class="action-col">
            <el-button
              type="primary"
              @click="submitForm"
              :loading="submitLoading"
              :style="buttonStyle"
            >
              保存错题 (Save)
            </el-button>
            <el-button @click="resetForm" :style="buttonStyle">重置 (Reset)</el-button>
            <el-button @click="goBack" :style="buttonStyle">取消 (Cancel)</el-button>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { addQuestion } from "@/api/trouble/question";

export default {
  name: "QuestionAdd",
  data() {
    return {
      // 表单参数
      form: {
        questionContent: "",
        questionImages: "",
        answerContent: "",
        answerImages: "",
        questionType: "未区分",
        tags: "",
        remark: "",
      },
      // 表单校验
      rules: {
        questionContent: [{ required: true, message: "题目内容不能为空 (Question content required)", trigger: "blur" }],
      },
      // 提交状态
      submitLoading: false,
      // 响应式标志
      isMobile: false,
    };
  },
  computed: {
    // label 宽度根据是否移动端调整（Element UI 的 label-width 可以直接传字符串）
    labelWidth() {
      return this.isMobile ? "90px" : "100px";
    },
    // 按钮在移动端宽满，桌面端为自动
    buttonStyle() {
      return this.isMobile ? { width: "100%", marginBottom: "10px" } : { marginLeft: "8px" };
    },
  },
  created() {
    this.checkIsMobile();
    window.addEventListener("resize", this.checkIsMobile);
  },
  beforeDestroy() {
    window.removeEventListener("resize", this.checkIsMobile);
  },
  methods: {
    checkIsMobile() {
      this.isMobile = window.matchMedia("(max-width: 767px)").matches;
    },

    /** 提交表单 */
    submitForm() {
      this.$refs["form"].validate((valid) => {
        if (valid) {
          this.submitLoading = true;
          addQuestion(this.form)
            .then((response) => {
              this.$modal.msgSuccess("错题添加成功 (Added successfully)");
              this.submitLoading = false;
              this.goBack();
            })
            .catch(() => {
              this.submitLoading = false;
            });
        }
      });
    },

    /** 重置表单 */
    resetForm() {
      this.form = {
        questionContent: "",
        questionImages: "",
        answerContent: "",
        answerImages: "",
        questionType: "未区分",
        tags: "",
        remark: "",
      };
      // 重置校验状态
      this.$nextTick(() => {
        if (this.$refs.form) this.$refs.form.resetFields();
      });
    },

    /** 返回列表 */
    goBack() {
      this.$router.push("/trouble/question");
    },

    /** 处理标签输入：去重、清理空格、限制数量（示例：最多 8 个标签） */
    handleTagsInput(value) {
      if (typeof value !== "string") return;
      // 把全角逗号替换为半角
      let raw = value.replace(/，/g, ",");
      // 分割、去空、去重
      const arr = raw
        .split(",")
        .map((t) => t.trim())
        .filter((t) => t.length > 0);
      // 去重
      const unique = Array.from(new Set(arr));
      // 限制个数
      const maxTags = 8;
      if (unique.length > maxTags) {
        unique.length = maxTags;
        this.$message.info(`标签数量已限制为 ${maxTags} 个 (Max ${maxTags} tags)`);
      }
      // 重新拼回字符串
      this.form.tags = unique.join(",");
    },
  },
};
</script>

<style scoped>
.box-card {
  margin: 20px;
  box-sizing: border-box;
}

/* header 行，用于在窄屏换行排列 */
.header-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}
.card-title {
  font-size: 16px;
  font-weight: 600;
}

/* 图片上传组件占满宽度（确保第三方组件支持宽度 100%） */
.image-upload-full {
  display: block;
  width: 100%;
}

/* 提示文字 */
.upload-tip,
.tag-tip {
  font-size: 12px;
  color: #999;
  margin-top: 6px;
}

/* 表单布局微调 */
.form-layout .el-form-item {
  margin-bottom: 14px;
}

/* 行内元素在小屏时垂直排列 */
.row-inline .el-form-item__content {
  min-width: 0;
}

/* 按钮区域 */
.action-row {
  margin-top: 8px;
  text-align: center;
}
.action-col {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-wrap: wrap;
}

/* 调整标签和输入项在移动端的间距 */
@media (max-width: 767px) {
  .box-card {
    margin: 10px;
  }
  .el-form-item__label {
    padding-right: 8px;
    font-size: 13px;
  }
  .el-button {
    width: 100%;
  }
  .el-button + .el-button {
    margin-left: 0;
  }
  .upload-tip,
  .tag-tip {
    margin-top: 8px;
  }
}

/* 中等屏到桌面端 */
@media (min-width: 768px) {
  .el-button {
    min-width: 120px;
  }
  .el-button + .el-button {
    margin-left: 10px;
  }
}
</style>
