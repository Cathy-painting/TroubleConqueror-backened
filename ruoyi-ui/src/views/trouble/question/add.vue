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

        <!-- 拍照识别区域 -->
        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="拍照识别">
              <div class="camera-section">
                <!-- 移动端拍照按钮 -->
                <div class="camera-buttons">
                  <input 
                    type="file" 
                    id="camera-input" 
                    accept="image/*" 
                    capture="camera" 
                    @change="handleCameraCapture"
                    style="display: none;"
                  />
                  <el-button 
                    type="primary" 
                    icon="el-icon-camera" 
                    size="medium"
                    @click="triggerCamera"
                  >
                    拍照识别题目
                  </el-button>
                  
                  <!-- 桌面端文件选择 -->
                  <el-upload
                    class="camera-uploader"
                    :action="uploadUrl"
                    :headers="uploadHeaders"
                    :show-file-list="false"
                    :on-success="handleOCRSuccess"
                    :before-upload="beforeUpload"
                    accept="image/*"
                    style="display: inline-block; margin-left: 10px;"
                  >
                    <el-button type="success" icon="el-icon-upload" size="medium">
                      选择图片
                    </el-button>
                  </el-upload>
                </div>
                <div class="camera-tip">
                  <p>📱 移动端：点击"拍照识别题目"调用相机</p>
                  <p>💻 桌面端：点击"选择图片"上传文件</p>
                </div>
              </div>
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
import { getToken } from "@/utils/auth";

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
      submitLoading: false,
      // 上传配置
      uploadUrl: process.env.VUE_APP_BASE_API + "/common/upload",
      uploadHeaders: {
        Authorization: "Bearer " + getToken()
      }
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
    /** 拍照上传前检查 */
    beforeUpload(file) {
      const isImage = file.type.indexOf('image/') === 0;
      const isLt10M = file.size / 1024 / 1024 < 10;
      
      if (!isImage) {
        this.$modal.msgError('只能上传图片文件!');
        return false;
      }
      if (!isLt10M) {
        this.$modal.msgError('上传图片大小不能超过 10MB!');
        return false;
      }
      return true;
    },
    /** OCR识别成功回调 */
    handleOCRSuccess(response, file) {
      if (response.code === 200) {
        // 这里可以调用OCR识别接口，将识别结果填入题目内容
        this.form.questionContent = response.data || '';
        this.$modal.msgSuccess("图片上传成功，请检查识别的题目内容");
      } else {
        this.$modal.msgError(response.msg || "图片上传失败");
      }
    },
    
    /** 触发相机拍照 */
    triggerCamera() {
      const cameraInput = document.getElementById('camera-input');
      if (cameraInput) {
        cameraInput.click();
      }
    },
    
    /** 处理拍照结果 */
    handleCameraCapture(event) {
      const file = event.target.files[0];
      if (file) {
        this.uploadCameraImage(file);
      }
    },
    
    /** 上传拍照图片 */
    uploadCameraImage(file) {
      const formData = new FormData();
      formData.append('file', file);
      
      this.$http.post(this.uploadUrl, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer ' + this.$store.getters.token
        }
      }).then(response => {
        if (response.data.code === 200) {
          // 将图片URL添加到题目图片中
          if (this.form.questionImages) {
            this.form.questionImages += ',' + response.data.url;
          } else {
            this.form.questionImages = response.data.url;
          }
          
          // 模拟OCR识别结果
          this.form.questionContent = '识别到的题目内容：\n' + (response.data.url || '这是一道数学题，请计算...');
          
          this.$message.success('拍照成功，图片已上传');
        } else {
          this.$message.error(response.data.msg || '图片上传失败');
        }
      }).catch(error => {
        this.$message.error('图片上传失败：' + error.message);
      });
    }
  }
};
</script>

<style scoped>
.box-card {
  margin: 20px;
}

.upload-tip, .tag-tip, .camera-tip {
  font-size: 12px;
  color: #999;
  margin-top: 5px;
}

.camera-section {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  padding: 20px;
  text-align: center;
  background-color: #fafafa;
}

.camera-uploader {
  margin-bottom: 10px;
}

.camera-buttons {
  margin-bottom: 15px;
}

.camera-buttons .el-button {
  margin-right: 10px;
}

.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}
.clearfix:after {
  clear: both;
}
</style>
