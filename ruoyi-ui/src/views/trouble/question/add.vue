<template>
  <div class="app-container">
    <transition name="fade-slide">
      <el-card class="box-card">
        <div slot="header" class="clearfix header-row">
          <span class="card-title">添加错题</span>
          <el-button
            style="float: right; padding: 3px 0"
            type="text"
            @click="goBack"
          >
            返回列表
          </el-button>
        </div>

        <el-form
          ref="form"
          :model="form"
          :rules="rules"
          :label-width="labelWidth"
          class="form-layout"
        >
          <!-- 题目内容 -->
          <el-row :gutter="20">
            <el-col :xs="24" :sm="24" :md="24">
              <el-form-item label="题目内容" prop="questionContent">
                <el-input
                  v-model="form.questionContent"
                  type="textarea"
                  :rows="6"
                  placeholder="请输入题目内容，支持拍照识别"
                  show-word-limit
                  maxlength="2000"
                />
                <!-- OCR 按钮 -->
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleOCR('question')"
                  style="margin-top: 6px;"
                >
                  OCR
                </el-button>
              </el-form-item>
            </el-col>
          </el-row>

          <!-- 图片上传 -->
          <el-row :gutter="20">
            <el-col :xs="24" :sm="12" :md="12">
              <el-form-item label="题目图片">
                <image-upload
                  v-model="form.questionImages"
                  :limit="1"
                  class="image-upload-full"
                />
                <div class="upload-tip">支持拍照上传，最多1张图片</div>
              </el-form-item>
            </el-col>

          </el-row>

          <!-- 答案内容 -->
          <el-row :gutter="20">
            <el-col :xs="24" :sm="24" :md="24">
              <el-form-item label="答案内容">
                <el-input
                  v-model="form.answerContent"
                  type="textarea"
                  :rows="4"
                  placeholder="请输入答案内容或解析"
                  show-word-limit
                  maxlength="2000"
                />
                <!-- OCR 按钮 -->
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleOCR('answer')"
                  style="margin-top: 6px;"
                >
                  OCR
                </el-button>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :xs="24" :sm="12" :md="12">
              <el-form-item label="答案图片">
                <image-upload
                  v-model="form.answerImages"
                  :limit="1"
                  class="image-upload-full"
                />
                <div class="upload-tip">支持拍照上传，最多1张图片</div>
              </el-form-item>
            </el-col>
          </el-row>
          <!-- 类型与标签 -->
          <el-row :gutter="20" class="row-inline">
            <el-col :xs="24" :sm="12" :md="12">
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
            </el-col>

            <el-col :xs="24" :sm="12" :md="12">
              <el-form-item label="标签">
                <el-input
                  v-model="form.tags"
                  placeholder="请输入标签，多个用逗号分隔"
                  @input="handleTagsInput"
                />
                <div class="tag-tip">建议标签：数学、语文、英语、物理等</div>
              </el-form-item>
            </el-col>
          </el-row>

          <!-- 备注 -->
          <el-row :gutter="20">
            <el-col :xs="24" :sm="24" :md="24">
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
            </el-col>
          </el-row>

          <!-- 操作按钮 -->
          <el-row class="action-row" :gutter="12">
            <el-col :xs="24" :sm="24" :md="24" class="action-col">
              <transition name="button-press">
                <el-button
                  type="primary"
                  @click="submitForm"
                  :loading="submitLoading"
                  :style="buttonStyle"
                >
                  保存错题
                </el-button>
              </transition>
              <el-button @click="resetForm" :style="buttonStyle">
                重置 (Reset)
              </el-button>
              <el-button @click="goBack" :style="buttonStyle">
                取消 (Cancel)
              </el-button>
            </el-col>
          </el-row>
        </el-form>
      </el-card>
    </transition>
  </div>
</template>

<script>
import { addQuestion } from "@/api/trouble/question";
export default {
  name: "QuestionAdd",
  data() {
    return {
      form: {
        questionContent: "",
        questionImages: "",
        answerContent: "",
        answerImages: "",
        questionType: "未区分",
        tags: "",
        remark: "",
      },
      rules: {
        questionContent: [
          { required: true, message: "题目内容不能为空", trigger: "blur" },
        ],
      },
      submitLoading: false,
      isMobile: false,
    };
  },
  computed: {
    labelWidth() {
      return this.isMobile ? "90px" : "100px";
    },
    buttonStyle() {
      return this.isMobile
        ? { width: "100%", marginBottom: "10px", transition: "all 0.3s" }
        : { marginLeft: "8px", transition: "all 0.3s" };
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
    async handleOCR(target) {
      // target = 'question' 或 'answer'
      const fileInput = document.createElement('input');
      fileInput.type = 'file';
      fileInput.accept = 'image/*';
      fileInput.onchange = async (e) => {
        const file = e.target.files[0];
        if (!file) return;

        const formData = new FormData();
        formData.append('file', file);

        try {
          // 动态获取当前页面 host
          const host = window.location.hostname; // 手机访问时就是电脑局域网 IP
          const port = 9000; // OCR 服务端口

          // 上传到 OCR 后端
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

          // 填入输入框
          if (target === 'question') {
            this.form.questionContent = data.text;
          } else if (target === 'answer') {
            this.form.answerContent = data.text;
          }

          this.$message.success('OCR识别成功');
        } catch (err) {
          this.$message.error('OCR识别失败');
          console.error(err);
        }
      };

      fileInput.click();
    },
    submitForm() {
      this.$refs["form"].validate((valid) => {
        if (valid) {
          this.submitLoading = true;
          addQuestion(this.form)
            .then(() => {
              this.$modal.msgSuccess("错题添加成功");
              this.submitLoading = false;
              this.goBack();
            })
            .catch(() => {
              this.submitLoading = false;
            });
        }
      });
    },
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
      this.$nextTick(() => {
        if (this.$refs.form) this.$refs.form.resetFields();
      });
    },
    goBack() {
      this.$router.push("/trouble/question");
    },
    handleTagsInput(value) {
      if (typeof value !== "string") return;
      let raw = value.replace(/，/g, ",");
      const arr = raw
        .split(",")
        .map((t) => t.trim())
        .filter((t) => t.length > 0);
      const unique = Array.from(new Set(arr));
      const maxTags = 8;
      if (unique.length > maxTags) {
        unique.length = maxTags;
        this.$message.info(`标签数量已限制为 ${maxTags} 个`);
      }
      this.form.tags = unique.join(",");
    },
  },
};
</script>

<style scoped>
.box-card {
  margin: 20px;
  box-sizing: border-box;
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
  transition: all 0.3s ease;
}
.box-card:hover {
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
}

.header-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}
.card-title {
  font-size: 18px;
  font-weight: 600;
  color: #333;
}

.image-upload-full {
  display: block;
  width: 100%;
}
.upload-tip,
.tag-tip {
  font-size: 12px;
  color: #888;
  margin-top: 6px;
  transition: color 0.3s;
}
.upload-tip:hover,
.tag-tip:hover {
  color: #409eff;
}

.form-layout .el-form-item {
  margin-bottom: 16px;
  transition: all 0.3s ease;
}

.el-input__inner:focus,
.el-textarea__inner:focus {
  box-shadow: 0 0 6px rgba(64, 158, 255, 0.3);
  transition: box-shadow 0.2s;
}

.action-row {
  margin-top: 10px;
  text-align: center;
}
.action-col {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-wrap: wrap;
}

/* 动画与响应式 */
.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.4s ease;
}
.fade-slide-enter,
.fade-slide-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

.button-press-enter-active {
  transition: transform 0.15s;
}
.button-press-enter {
  transform: scale(0.98);
}

/* 小屏优化 */
@media (max-width: 767px) {
  .box-card {
    margin: 10px;
    border-radius: 10px;
  }
  .el-form-item__label {
    font-size: 13px;
  }
  .el-button {
    width: 100%;
    margin-bottom: 8px;
  }
  .upload-tip,
  .tag-tip {
    margin-top: 8px;
  }
}

/* 桌面端 */
@media (min-width: 768px) {
  .el-button {
    min-width: 120px;
  }
  .el-button + .el-button {
    margin-left: 10px;
  }
}
</style>
