<template>
  <div class="register">
    <!-- 装饰性背景元素 -->
    <div class="bg-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>
    
    <!-- 注册表单容器 -->
    <div class="register-container">
      <el-form ref="registerForm" :model="registerForm" :rules="registerRules" class="register-form">
        <div class="form-header">
          <h3 class="title">{{title}}</h3>
          <p class="subtitle">创建您的账号，开始错题管理之旅</p>
        </div>
        
        <el-form-item prop="username">
          <el-input 
            v-model="registerForm.username" 
            type="text" 
            auto-complete="off" 
            placeholder="请输入账号（2-20个字符）"
            prefix-icon="el-icon-user"
          >
          </el-input>
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input
            v-model="registerForm.password"
            type="password"
            auto-complete="off"
            placeholder="请输入密码（5-20个字符）"
            prefix-icon="el-icon-lock"
            show-password
          >
          </el-input>
        </el-form-item>
        
        <el-form-item prop="confirmPassword">
          <el-input
            v-model="registerForm.confirmPassword"
            type="password"
            auto-complete="off"
            placeholder="请再次输入密码"
            prefix-icon="el-icon-lock"
            show-password
            @keyup.enter.native="handleRegister"
          >
          </el-input>
        </el-form-item>
        
        <el-form-item prop="code" v-if="captchaEnabled">
          <el-input
            v-model="registerForm.code"
            auto-complete="off"
            placeholder="请输入验证码"
            prefix-icon="el-icon-key"
            style="width: 63%"
            @keyup.enter.native="handleRegister"
          >
          </el-input>
          <div class="register-code">
            <img :src="codeUrl" @click="getCode" class="register-code-img" title="点击刷新验证码"/>
          </div>
        </el-form-item>
        
        <el-form-item style="width:100%; margin-bottom: 15px;">
          <el-button
            :loading="loading"
            size="medium"
            type="primary"
            class="register-button"
            @click.native.prevent="handleRegister"
          >
            <span v-if="!loading">
              <i class="el-icon-edit"></i> 立即注册
            </span>
            <span v-else>注 册 中...</span>
          </el-button>
        </el-form-item>
        
        <div class="login-link">
          <span>已有账号？</span>
          <router-link class="link-type" :to="'/login'">立即登录</router-link>
        </div>
      </el-form>
    </div>
    
    <!--  底部  -->
    <div class="el-register-footer">
      <span>Copyright © 2025 错题征服者. All Rights Reserved.</span>
    </div>
  </div>
</template>

<script>
import { getCodeImg, register } from "@/api/login"

export default {
  name: "Register",
  data() {
    const equalToPassword = (rule, value, callback) => {
      if (this.registerForm.password !== value) {
        callback(new Error("两次输入的密码不一致"))
      } else {
        callback()
      }
    }
    return {
      title: process.env.VUE_APP_TITLE,
      codeUrl: "",
      registerForm: {
        username: "",
        password: "",
        confirmPassword: "",
        code: "",
        uuid: ""
      },
      registerRules: {
        username: [
          { required: true, trigger: "blur", message: "请输入您的账号" },
          { min: 2, max: 20, message: '用户账号长度必须介于 2 和 20 之间', trigger: 'blur' }
        ],
        password: [
          { required: true, trigger: "blur", message: "请输入您的密码" },
          { min: 5, max: 20, message: "用户密码长度必须介于 5 和 20 之间", trigger: "blur" },
          { pattern: /^[^<>"'|\\]+$/, message: "不能包含非法字符：< > \" ' \\\ |", trigger: "blur" }
        ],
        confirmPassword: [
          { required: true, trigger: "blur", message: "请再次输入您的密码" },
          { required: true, validator: equalToPassword, trigger: "blur" }
        ],
        code: [{ required: true, trigger: "change", message: "请输入验证码" }]
      },
      loading: false,
      captchaEnabled: true
    }
  },
  created() {
    this.getCode()
  },
  methods: {
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        if (this.captchaEnabled) {
          this.codeUrl = "data:image/gif;base64," + res.img
          this.registerForm.uuid = res.uuid
        }
      })
    },
    handleRegister() {
      this.$refs.registerForm.validate(valid => {
        if (valid) {
          this.loading = true
          register(this.registerForm).then(res => {
            const username = this.registerForm.username
            this.$alert("<font color='red'>恭喜你，您的账号 " + username + " 注册成功！</font>", '系统提示', {
              dangerouslyUseHTMLString: true,
              type: 'success'
            }).then(() => {
              this.$router.push("/login")
            }).catch(() => {})
          }).catch(() => {
            this.loading = false
            if (this.captchaEnabled) {
              this.getCode()
            }
          })
        }
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
.register {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  width: 100%;
  overflow-x: hidden;
  position: relative;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #7e8ba3 100%);
  padding: 20px;
  box-sizing: border-box;
  
  // 动态背景装饰
  .bg-decoration {
    position: absolute;
    width: 100%;
    height: 100%;
    overflow: hidden;
    z-index: 0;
    
    .circle {
      position: absolute;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.1);
      animation: float 20s infinite ease-in-out;
      
      &.circle-1 {
        width: 350px;
        height: 350px;
        top: -150px;
        right: -100px;
        animation-delay: 0s;
      }
      
      &.circle-2 {
        width: 250px;
        height: 250px;
        bottom: -80px;
        left: 5%;
        animation-delay: 7s;
      }
      
      &.circle-3 {
        width: 180px;
        height: 180px;
        top: 40%;
        left: -70px;
        animation-delay: 14s;
      }
    }
  }
  
  @keyframes float {
    0%, 100% {
      transform: translateY(0) scale(1);
      opacity: 0.3;
    }
    50% {
      transform: translateY(-50px) scale(1.1);
      opacity: 0.5;
    }
  }
}

.register-container {
  position: relative;
  z-index: 10;
  animation: slideIn 0.6s ease-out;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.register-form {
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  width: 440px;
  padding: 40px 40px 30px 40px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.3);
  
  .form-header {
    text-align: center;
    margin-bottom: 30px;
    
    .title {
      margin: 0 0 8px 0;
      font-size: 28px;
      font-weight: 600;
      background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
    
    .subtitle {
      margin: 0;
      font-size: 14px;
      color: #666;
    }
  }
  
  .el-form-item {
    margin-bottom: 20px;
  }
  
  .el-input {
    ::v-deep input {
      height: 45px;
      line-height: 45px;
      border-radius: 8px;
      border: 1px solid #e0e6ed;
      padding-left: 40px;
      font-size: 14px;
      transition: all 0.3s;
      
      &:focus {
        border-color: #2a5298;
        box-shadow: 0 0 0 2px rgba(42, 82, 152, 0.1);
      }
      
      &::placeholder {
        color: #a8abb2;
        font-size: 13px;
      }
    }
    
    ::v-deep .el-input__prefix {
      left: 12px;
      color: #2a5298;
      font-size: 16px;
    }
    
    ::v-deep .el-input__suffix {
      right: 12px;
      
      .el-input__icon {
        color: #909399;
        font-size: 16px;
        
        &:hover {
          color: #2a5298;
        }
      }
    }
  }
  
  .register-button {
    width: 100%;
    height: 45px;
    font-size: 16px;
    font-weight: 500;
    border-radius: 8px;
    background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
    border: none;
    transition: all 0.3s;
    
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 20px rgba(42, 82, 152, 0.4);
    }
    
    &:active {
      transform: translateY(0);
    }
  }
  
  .login-link {
    text-align: center;
    font-size: 14px;
    color: #606266;
    margin-top: 15px;
    
    span {
      margin-right: 8px;
    }
    
    .link-type {
      color: #2a5298;
      font-weight: 500;
      text-decoration: none;
      transition: all 0.3s;
      
      &:hover {
        color: #1e3c72;
        text-decoration: underline;
      }
    }
  }
}

.register-code {
  width: 33%;
  height: 45px;
  float: right;
  
  img {
    width: 100%;
    height: 100%;
    cursor: pointer;
    border-radius: 8px;
    border: 1px solid #e0e6ed;
    transition: all 0.3s;
    
    &:hover {
      border-color: #2a5298;
      box-shadow: 0 2px 8px rgba(42, 82, 152, 0.2);
    }
  }
}

.register-code-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.el-register-footer {
  height: 40px;
  line-height: 40px;
  position: relative;
  width: 100%;
  text-align: center;
  color: rgba(255, 255, 255, 0.8);
  font-family: Arial, sans-serif;
  font-size: 13px;
  letter-spacing: 1px;
  z-index: 20;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
  margin-top: auto;
  padding: 20px 0;
}

// 响应式设计
@media screen and (max-width: 768px) {
  .register {
    padding: 15px;
    justify-content: flex-start;
    padding-top: 40px;
  }

  .register-container {
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    flex: 1;
  }

  .register-form {
    width: 100%;
    max-width: 420px;
    padding: 30px 25px 20px 25px;
    margin: 0 auto;
    
    .form-header {
      .title {
        font-size: 24px;
      }
      
      .subtitle {
        font-size: 13px;
      }
    }
    
    .el-input {
      ::v-deep input {
        &::placeholder {
          font-size: 12px;
        }
      }
    }
  }

  .el-register-footer {
    margin-top: 20px;
    padding: 15px 0;
    font-size: 12px;
  }
}
</style>
