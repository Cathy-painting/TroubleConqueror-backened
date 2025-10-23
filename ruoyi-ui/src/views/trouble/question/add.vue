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
              <div class="question-content-section">
                <el-input 
                  v-model="form.questionContent" 
                  type="textarea" 
                  :rows="6" 
                  placeholder="请输入题目内容，或点击下方OCR识别按钮上传图片识别"
                  show-word-limit
                  maxlength="2000"
                />
                <div class="ocr-actions" style="margin-top: 10px;">
                  <el-button 
                    size="small" 
                    type="primary" 
                    icon="el-icon-camera" 
                    @click="openOcrDialog"
                  >
                    📷 OCR图片识别
                  </el-button>
                  <span style="margin-left: 10px; color: #909399; font-size: 12px;">
                    上传图片自动识别题目内容
                  </span>
                </div>
              </div>
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

    <!-- OCR识别对话框 -->
    <el-dialog
      title="OCR图片识别"
      :visible.sync="ocrDialogVisible"
      width="600px"
      :close-on-click-modal="false"
    >
      <div class="ocr-dialog-content">
        <div class="upload-section">
          <el-upload
            class="upload-demo"
            drag
            action="#"
            :auto-upload="false"
            :on-change="handleFileChange"
            :show-file-list="false"
            accept="image/*"
          >
            <i class="el-icon-upload"></i>
            <div class="el-upload__text">
              将图片拖到此处，或<em>点击上传</em>
            </div>
            <div class="el-upload__tip" slot="tip">
              支持jpg、png、bmp格式，文件大小不超过10MB
              <br>
              <span style="color: #E6A23C;">提示：文件名包含"数学"、"英语"、"语文"、"物理"等关键词可获得对应学科的示例题目</span>
            </div>
          </el-upload>
        </div>

        <div v-if="selectedFile" class="file-info">
          <el-alert
            :title="`已选择文件: ${selectedFile.name}`"
            type="success"
            :closable="false"
            show-icon
          />
        </div>

        <div v-if="ocrLoading" class="ocr-loading">
          <el-progress :percentage="ocrProgress" :status="ocrProgress === 100 ? 'success' : ''"></el-progress>
          <p style="text-align: center; margin-top: 10px;">正在识别中，请稍候...</p>
        </div>

        <div v-if="ocrResult" class="ocr-result">
          <el-divider>识别结果</el-divider>
          <el-input
            v-model="ocrResult"
            type="textarea"
            :rows="10"
            placeholder="识别结果将显示在这里"
          />
          <div style="margin-top: 10px; text-align: right;">
            <el-button size="small" type="primary" @click="useOcrResult">
              使用此内容
            </el-button>
            <el-button size="small" @click="resetOcr">
              重新识别
            </el-button>
          </div>
        </div>
      </div>

      <div slot="footer" class="dialog-footer">
        <el-button @click="closeOcrDialog">取消</el-button>
        <el-button 
          type="primary" 
          @click="startOcrRecognition" 
          :loading="ocrLoading"
          :disabled="!selectedFile || ocrLoading"
        >
          开始识别
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { addQuestion } from "@/api/trouble/question";
import request from '@/utils/request';

export default {
  name: "QuestionAdd",
  data() {
    return {
      // 表单参数
      form: {
        questionContent: '',
        questionType: '',
        difficulty: '',
        tags: '',
        answerContent: '',
        remark: ''
      },
      // 表单校验
      rules: {
        questionContent: [
          { required: true, message: "题目内容不能为空", trigger: "blur" }
        ],
        questionType: [
          { required: true, message: "题目类型不能为空", trigger: "blur" }
        ]
      },
      // 提交状态
      submitLoading: false,
      
      // OCR相关
      ocrDialogVisible: false,
      selectedFile: null,
      ocrLoading: false,
      ocrProgress: 0,
      ocrResult: ''
    };
  },
  methods: {
    /** 打开OCR对话框 */
    openOcrDialog() {
      this.ocrDialogVisible = true;
      this.resetOcr();
    },

    /** 关闭OCR对话框 */
    closeOcrDialog() {
      this.ocrDialogVisible = false;
      this.resetOcr();
    },

    /** 重置OCR状态 */
    resetOcr() {
      this.selectedFile = null;
      this.ocrLoading = false;
      this.ocrProgress = 0;
      this.ocrResult = '';
    },

    /** 文件选择处理 */
    handleFileChange(file, fileList) {
      this.selectedFile = file.raw;
      this.ocrResult = '';
    },

    /** 开始OCR识别 */
    async startOcrRecognition() {
      if (!this.selectedFile) {
        this.$message.warning('请先选择图片文件');
        return;
      }

      // 验证文件大小
      if (this.selectedFile.size > 10 * 1024 * 1024) {
        this.$message.error('文件大小不能超过10MB');
        return;
      }

      this.ocrLoading = true;
      this.ocrProgress = 0;

      // 模拟进度条
      const progressInterval = setInterval(() => {
        if (this.ocrProgress < 90) {
          this.ocrProgress += 10;
        }
      }, 200);

      try {
        // 创建FormData
        const formData = new FormData();
        formData.append('file', this.selectedFile);

        // 调用OCR API
        const response = await request({
          url: '/trouble/ocr/recognize',
          method: 'post',
          data: formData,
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        });

        clearInterval(progressInterval);
        this.ocrProgress = 100;

        if (response.code === 200) {
          this.ocrResult = response.data.recognizedText || '';
          this.$message.success('OCR识别成功！');
        } else {
          this.$message.error(response.msg || 'OCR识别失败');
        }
      } catch (error) {
        clearInterval(progressInterval);
        console.error('OCR识别错误:', error);
        this.$message.error('OCR识别失败: ' + (error.message || '未知错误'));
      } finally {
        this.ocrLoading = false;
      }
    },

    /** 使用OCR识别结果 */
    useOcrResult() {
      if (this.ocrResult) {
        this.form.questionContent = this.ocrResult;
        this.$message.success('已将识别内容填入题目内容');
        this.closeOcrDialog();
      }
    },

    /** 提交表单 */
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

    /** 重置表单 */
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

    /** 返回列表 */
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

.ocr-actions {
  display: flex;
  align-items: center;
}

.upload-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

.ocr-dialog-content {
  min-height: 200px;
}

.upload-section {
  margin-bottom: 20px;
}

.file-info {
  margin: 15px 0;
}

.ocr-loading {
  margin: 20px 0;
}

.ocr-result {
  margin-top: 20px;
}

.el-upload__tip {
  font-size: 12px;
  color: #606266;
  margin-top: 7px;
}
</style>
