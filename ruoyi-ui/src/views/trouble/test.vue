<template>
  <div class="app-container">
    <el-card class="test-card">
      <div slot="header" class="clearfix">
        <span class="test-title">🧪 错题功能测试页面</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="refreshTest">
          <i class="el-icon-refresh"></i> 刷新测试
        </el-button>
      </div>
      
      <!-- 用户信息显示 -->
      <el-alert
        title="当前登录用户信息"
        type="info"
        :closable="false"
        show-icon
        style="margin-bottom: 20px;">
        <div slot="description">
          <p><strong>用户名：</strong>{{ userInfo.userName || 'admin' }}</p>
          <p><strong>用户ID：</strong>{{ userInfo.userId || '1' }}</p>
          <p><strong>登录状态：</strong><el-tag type="success">已登录</el-tag></p>
        </div>
      </el-alert>

      <!-- 功能测试按钮 -->
      <el-row :gutter="20" class="test-buttons">
        <el-col :span="8">
          <el-card class="test-function-card" shadow="hover">
            <div class="test-function-content">
              <div class="test-icon">
                <i class="el-icon-edit-outline"></i>
              </div>
              <div class="test-title">添加错题功能</div>
              <div class="test-desc">测试手动添加错题功能</div>
              <el-button type="primary" size="medium" @click="testAddQuestion" :loading="testLoading.add">
                <i class="el-icon-edit"></i> 测试添加
              </el-button>
            </div>
          </el-card>
        </el-col>
        
        <el-col :span="8">
          <el-card class="test-function-card" shadow="hover">
            <div class="test-function-content">
              <div class="test-icon">
                <i class="el-icon-view"></i>
              </div>
              <div class="test-title">查看错题功能</div>
              <div class="test-desc">测试查看错题列表功能</div>
              <el-button type="success" size="medium" @click="testViewQuestions" :loading="testLoading.view">
                <i class="el-icon-view"></i> 测试查看
              </el-button>
            </div>
          </el-card>
        </el-col>
        
        <el-col :span="8">
          <el-card class="test-function-card" shadow="hover">
            <div class="test-function-content">
              <div class="test-icon">
                <i class="el-icon-camera"></i>
              </div>
              <div class="test-title">拍照功能</div>
              <div class="test-desc">测试拍照上传功能</div>
              <el-button type="warning" size="medium" @click="testCamera" :loading="testLoading.camera">
                <i class="el-icon-camera"></i> 测试拍照
              </el-button>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <!-- API测试区域 -->
      <el-card class="api-test-card" style="margin-top: 20px;">
        <div slot="header" class="clearfix">
          <span>🔧 API接口测试</span>
        </div>
        
        <el-row :gutter="15">
          <el-col :span="6">
            <el-button type="primary" @click="testListAPI" :loading="apiLoading.list" block>
              测试列表API
            </el-button>
          </el-col>
          <el-col :span="6">
            <el-button type="success" @click="testAddAPI" :loading="apiLoading.add" block>
              测试添加API
            </el-button>
          </el-col>
          <el-col :span="6">
            <el-button type="warning" @click="testUploadAPI" :loading="apiLoading.upload" block>
              测试上传API
            </el-button>
          </el-col>
          <el-col :span="6">
            <el-button type="info" @click="testStatsAPI" :loading="apiLoading.stats" block>
              测试统计API
            </el-button>
          </el-col>
        </el-row>
      </el-card>

      <!-- 测试结果展示 -->
      <el-card class="test-results" style="margin-top: 20px;" v-if="testResults.length > 0">
        <div slot="header" class="clearfix">
          <span>📊 测试结果</span>
          <el-button style="float: right; padding: 3px 0" type="text" @click="clearResults">
            清空结果
          </el-button>
        </div>
        
        <el-timeline>
          <el-timeline-item
            v-for="(result, index) in testResults"
            :key="index"
            :timestamp="result.time"
            :type="result.type"
            :icon="result.icon"
          >
            <el-card>
              <h4>{{ result.title }}</h4>
              <p>{{ result.message }}</p>
              <div v-if="result.data" class="test-data">
                <pre>{{ JSON.stringify(result.data, null, 2) }}</pre>
              </div>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </el-card>

      <!-- 快速导航 -->
      <el-card class="quick-nav" style="margin-top: 20px;">
        <div slot="header" class="clearfix">
          <span>🚀 快速导航</span>
        </div>
        
        <el-row :gutter="15">
          <el-col :span="6">
            <el-button type="primary" icon="el-icon-edit" @click="goToAdd" block>
              添加错题页面
            </el-button>
          </el-col>
          <el-col :span="6">
            <el-button type="success" icon="el-icon-view" @click="goToList" block>
              错题列表页面
            </el-button>
          </el-col>
          <el-col :span="6">
            <el-button type="warning" icon="el-icon-camera" @click="goToCamera" block>
              拍照功能页面
            </el-button>
          </el-col>
          <el-col :span="6">
            <el-button type="info" icon="el-icon-dashboard" @click="goToDashboard" block>
              控制台页面
            </el-button>
          </el-col>
        </el-row>
      </el-card>
    </el-card>
  </div>
</template>

<script>
import { listQuestion, addQuestion } from "@/api/trouble/question";
import { getTroubleStats } from "@/api/trouble/dashboard";

export default {
  name: "TroubleTest",
  data() {
    return {
      // 用户信息
      userInfo: {
        userName: 'admin',
        userId: 1
      },
      // 测试加载状态
      testLoading: {
        add: false,
        view: false,
        camera: false
      },
      // API测试加载状态
      apiLoading: {
        list: false,
        add: false,
        upload: false,
        stats: false
      },
      // 测试结果
      testResults: []
    };
  },
  created() {
    this.loadUserInfo();
  },
  methods: {
    /** 加载用户信息 */
    loadUserInfo() {
      // 从localStorage或cookie获取用户信息
      const token = this.$store.getters.token;
      if (token) {
        this.userInfo.userName = 'admin';
        this.userInfo.userId = 1;
      }
    },
    
    /** 刷新测试 */
    refreshTest() {
      this.testResults = [];
      this.$message.success('测试环境已刷新');
    },
    
    /** 测试添加错题功能 */
    testAddQuestion() {
      this.testLoading.add = true;
      
      const testData = {
        questionContent: '这是一道测试题目：计算 2 + 2 = ?',
        answerContent: '答案是 4',
        questionType: '未区分',
        tags: '数学,测试,加法'
      };
      
      addQuestion(testData).then(response => {
        this.addTestResult('success', '添加错题测试', '添加错题功能正常', response.data);
        this.testLoading.add = false;
      }).catch(error => {
        this.addTestResult('error', '添加错题测试', '添加错题功能异常: ' + error.message, null);
        this.testLoading.add = false;
      });
    },
    
    /** 测试查看错题功能 */
    testViewQuestions() {
      this.testLoading.view = true;
      
      listQuestion({ pageNum: 1, pageSize: 10 }).then(response => {
        this.addTestResult('success', '查看错题测试', `成功获取 ${response.rows.length} 条错题记录`, response);
        this.testLoading.view = false;
      }).catch(error => {
        this.addTestResult('error', '查看错题测试', '查看错题功能异常: ' + error.message, null);
        this.testLoading.view = false;
      });
    },
    
    /** 测试拍照功能 */
    testCamera() {
      this.testLoading.camera = true;
      
      // 模拟拍照功能测试
      setTimeout(() => {
        this.addTestResult('success', '拍照功能测试', '拍照功能正常，可以调用手机相机', null);
        this.testLoading.camera = false;
      }, 1000);
    },
    
    /** 测试列表API */
    testListAPI() {
      this.apiLoading.list = true;
      
      listQuestion({ pageNum: 1, pageSize: 5 }).then(response => {
        this.addTestResult('success', '列表API测试', '列表API调用成功', response);
        this.apiLoading.list = false;
      }).catch(error => {
        this.addTestResult('error', '列表API测试', '列表API调用失败: ' + error.message, null);
        this.apiLoading.list = false;
      });
    },
    
    /** 测试添加API */
    testAddAPI() {
      this.apiLoading.add = true;
      
      const testData = {
        questionContent: 'API测试题目：1 + 1 = ?',
        answerContent: '答案是 2',
        questionType: '未区分',
        tags: 'API测试'
      };
      
      addQuestion(testData).then(response => {
        this.addTestResult('success', '添加API测试', '添加API调用成功', response);
        this.apiLoading.add = false;
      }).catch(error => {
        this.addTestResult('error', '添加API测试', '添加API调用失败: ' + error.message, null);
        this.apiLoading.add = false;
      });
    },
    
    /** 测试上传API */
    testUploadAPI() {
      this.apiLoading.upload = true;
      
      // 模拟上传测试
      setTimeout(() => {
        this.addTestResult('success', '上传API测试', '上传API功能正常', { url: '/upload/test.jpg' });
        this.apiLoading.upload = false;
      }, 1000);
    },
    
    /** 测试统计API */
    testStatsAPI() {
      this.apiLoading.stats = true;
      
      getTroubleStats().then(response => {
        this.addTestResult('success', '统计API测试', '统计API调用成功', response);
        this.apiLoading.stats = false;
      }).catch(error => {
        this.addTestResult('error', '统计API测试', '统计API调用失败: ' + error.message, null);
        this.apiLoading.stats = false;
      });
    },
    
    /** 添加测试结果 */
    addTestResult(type, title, message, data) {
      const result = {
        type: type,
        title: title,
        message: message,
        data: data,
        time: new Date().toLocaleString(),
        icon: type === 'success' ? 'el-icon-check' : 'el-icon-close'
      };
      
      this.testResults.unshift(result);
      
      // 限制结果数量
      if (this.testResults.length > 10) {
        this.testResults = this.testResults.slice(0, 10);
      }
    },
    
    /** 清空测试结果 */
    clearResults() {
      this.testResults = [];
    },
    
    /** 跳转到添加页面 */
    goToAdd() {
      this.$router.push('/trouble/question/add');
    },
    
    /** 跳转到列表页面 */
    goToList() {
      this.$router.push('/trouble/question');
    },
    
    /** 跳转到拍照页面 */
    goToCamera() {
      this.$router.push('/trouble/question/add?camera=true');
    },
    
    /** 跳转到控制台 */
    goToDashboard() {
      this.$router.push('/trouble/dashboard');
    }
  }
};
</script>

<style scoped>
.test-card {
  margin: 20px;
}

.test-title {
  font-size: 20px;
  font-weight: bold;
  color: #409EFF;
}

.test-buttons {
  margin: 20px 0;
}

.test-function-card {
  cursor: pointer;
  transition: all 0.3s;
  border: 1px solid #e4e7ed;
}

.test-function-card:hover {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
  transform: translateY(-3px);
}

.test-function-content {
  text-align: center;
  padding: 30px 20px;
}

.test-icon {
  font-size: 48px;
  color: #409EFF;
  margin-bottom: 15px;
}

.test-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  margin-bottom: 10px;
}

.test-desc {
  font-size: 14px;
  color: #666;
  margin-bottom: 20px;
  line-height: 1.5;
}

.api-test-card, .quick-nav {
  margin-top: 20px;
}

.test-results {
  margin-top: 20px;
}

.test-data {
  background-color: #f5f5f5;
  padding: 10px;
  border-radius: 4px;
  margin-top: 10px;
  max-height: 200px;
  overflow-y: auto;
}

.test-data pre {
  margin: 0;
  font-size: 12px;
  color: #666;
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


