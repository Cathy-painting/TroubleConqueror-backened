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
                placeholder="请输入题目内容"
                show-word-limit
                maxlength="2000"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="题目类型" prop="questionType">
              <el-input v-model="form.questionType" placeholder="如：数学、英语、语文等" maxlength="50"/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="难度等级">
              <el-select v-model="form.difficulty" placeholder="请选择难度" style="width: 100%">
                <el-option label="简单" value="简单"></el-option>
                <el-option label="中等" value="中等"></el-option>
                <el-option label="困难" value="困难"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="标签">
              <el-input v-model="form.tags" placeholder="多个标签用逗号分隔，如：函数,应用题" maxlength="200"/>
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
                placeholder="请输入答案内容"
                maxlength="2000"
              />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="备注">
              <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="备注信息" maxlength="500"/>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item>
          <el-button type="primary" @click="submitForm" :loading="submitLoading">提交</el-button>
          <el-button @click="resetForm">重置</el-button>
          <el-button @click="goBack">取消</el-button>
        </el-form-item>
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
      form: {
        questionContent: '',
        questionType: '',
        difficulty: '',
        tags: '',
        answerContent: '',
        remark: ''
      },
      rules: {
        questionContent: [
          { required: true, message: "题目内容不能为空", trigger: "blur" }
        ],
        questionType: [
          { required: true, message: "题目类型不能为空", trigger: "blur" }
        ]
      },
      submitLoading: false
    };
  },
  methods: {
    submitForm() {
      this.$refs.form.validate(valid => {
        if (valid) {
          this.submitLoading = true;
          addQuestion(this.form).then(response => {
            this.$message.success("添加成功");
            this.goBack();
          }).catch(() => {
            this.submitLoading = false;
          });
        }
      });
    },
    resetForm() {
      this.form = {
        questionContent: '',
        questionType: '',
        difficulty: '',
        tags: '',
        answerContent: '',
        remark: ''
      };
      this.$refs.form.resetFields();
    },
    goBack() {
      this.$router.push('/trouble/question');
    }
  }
};
</script>

<style scoped>
.question-content-section {
  width: 100%;
}
</style>

