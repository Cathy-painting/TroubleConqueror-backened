<template>
  <div class="app-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>添加错题</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="goBack">返回列表</el-button>
      </div>
      
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="题目内容" prop="questionContent">
              <el-input 
                v-model="form.questionContent" 
                type="textarea" 
                :rows="6" 
                placeholder="请输入题目内容，支持拍照识别"
                show-word-limit
                maxlength="2000"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="题目图片">
              <image-upload v-model="form.questionImages" :limit="5"/>
              <div class="upload-tip">支持拍照上传，最多5张图片</div>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="答案图片">
              <image-upload v-model="form.answerImages" :limit="5"/>
              <div class="upload-tip">支持拍照上传，最多5张图片</div>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="答案内容">
              <el-input 
                v-model="form.answerContent" 
                type="textarea" 
                :rows="4" 
                placeholder="请输入答案内容或解析"
                show-word-limit
                maxlength="2000"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
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
          <el-col :span="12">
            <el-form-item label="标签">
              <el-input 
                v-model="form.tags" 
                placeholder="请输入标签，多个用逗号分隔，如：数学,几何,难题"
                @input="handleTagsInput"
              />
              <div class="tag-tip">建议标签：数学、语文、英语、物理、化学、生物、历史、地理、政治等</div>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="24">
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


        <el-row>
          <el-col :span="24" style="text-align: center;">
            <el-button type="primary" @click="submitForm" :loading="submitLoading">保存错题</el-button>
            <el-button @click="resetForm">重置</el-button>
            <el-button @click="goBack">取消</el-button>
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
        questionContent: '',
        questionImages: '',
        answerContent: '',
        answerImages: '',
        questionType: '未区分',
        tags: '',
        remark: ''
      },
      // 表单校验
      rules: {
        questionContent: [
          { required: true, message: "题目内容不能为空", trigger: "blur" }
        ]
      },
      // 提交状态
      submitLoading: false
    };
  },
  methods: {
    /** 提交表单 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.submitLoading = true;
          addQuestion(this.form).then(response => {
            this.$modal.msgSuccess("错题添加成功");
            this.submitLoading = false;
            this.goBack();
          }).catch(() => {
            this.submitLoading = false;
          });
        }
      });
    },
    /** 重置表单 */
    resetForm() {
      this.form = {
        questionContent: '',
        questionImages: '',
        answerContent: '',
        answerImages: '',
        questionType: '未区分',
        tags: '',
        remark: ''
      };
      this.$refs["form"].resetFields();
    },
    /** 返回列表 */
    goBack() {
      this.$router.push('/trouble/question');
    },
    /** 处理标签输入 */
    handleTagsInput(value) {
      // 可以在这里添加标签提示逻辑
    },
  }
};
</script>

<style scoped>
.box-card {
  margin: 20px;
}

.upload-tip, .tag-tip {
  font-size: 12px;
  color: #999;
  margin-top: 5px;
}

.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}
.clearfix:after {
  clear: both;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .box-card {
    margin: 10px;
  }
  
  .el-form-item {
    margin-bottom: 15px;
  }
  
  .el-input,
  .el-textarea,
  .el-select {
    width: 100%;
  }
  
  .el-button {
    width: 100%;
    margin-bottom: 10px;
  }
  
  .el-row {
    margin: 0;
  }
  
  .el-col {
    padding: 0 5px;
  }
}

@media (min-width: 769px) and (max-width: 1024px) {
  .box-card {
    margin: 15px;
  }
  
  .el-form-item {
    margin-bottom: 12px;
  }
}

/* 表单优化 */
.el-form-item__label {
  font-weight: 500;
}

.el-textarea__inner {
  resize: vertical;
}

/* 按钮组优化 */
.el-button + .el-button {
  margin-left: 10px;
}

@media (max-width: 768px) {
  .el-button + .el-button {
    margin-left: 0;
  }
}
</style>
