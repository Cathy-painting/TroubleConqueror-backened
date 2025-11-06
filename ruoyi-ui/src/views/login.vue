<template>
  <div class="login">
    <!-- 装饰性背景元素 -->
    <div class="bg-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
    </div>
    
    <!-- 登录表单容器 -->
    <div class="login-container">
      <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
        <div class="form-header">
          <h3 class="title">{{title}}</h3>
          <p class="subtitle">欢迎回来！请登录您的账号</p>
        </div>
        
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            type="text"
            auto-complete="off"
            placeholder="请输入账号"
            prefix-icon="el-icon-user"
          >
          </el-input>
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            auto-complete="off"
            placeholder="请输入密码"
            prefix-icon="el-icon-lock"
            @keyup.enter.native="handleLogin"
          >
          </el-input>
        </el-form-item>
        
        <el-form-item prop="code" v-if="captchaEnabled">
          <el-input
            v-model="loginForm.code"
            auto-complete="off"
            placeholder="请输入验证码"
            prefix-icon="el-icon-key"
            style="width: 63%"
            @keyup.enter.native="handleLogin"
          >
          </el-input>
          <div class="login-code">
            <img :src="codeUrl" @click="getCode" class="login-code-img" title="点击刷新验证码"/>
          </div>
        </el-form-item>
        
        <div class="login-options">
          <el-checkbox v-model="loginForm.rememberMe" class="remember-me">
            <span>记住密码</span>
          </el-checkbox>
        </div>
        
        <el-form-item style="width:100%; margin-bottom: 15px;">
          <el-button
            :loading="loading"
            size="medium"
            type="primary"
            class="login-button"
            @click.native.prevent="handleLogin"
          >
            <span v-if="!loading">
              <i class="el-icon-user-solid"></i> 登 录
            </span>
            <span v-else>登 录 中...</span>
          </el-button>
        </el-form-item>
        
        <div class="register-link" v-if="register">
          <span>还没有账号？</span>
          <router-link class="link-type" :to="'/register'">立即注册</router-link>
        </div>
      </el-form>
    </div>
    
    <!--  底部  -->
    <div class="el-login-footer">
      <span>Copyright © 2025 错题征服者. All Rights Reserved.</span>
    </div>
  </div>
</template>

<script>
import { getCodeImg } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from '@/utils/jsencrypt'

export default {
  name: "Login",
  data() {
    return {
      title: process.env.VUE_APP_TITLE,
      codeUrl: "",
      loginForm: {
        username: "admin",
        password: "admin123",
        rememberMe: false,
        code: "",
        uuid: ""
      },
      loginRules: {
        username: [
          { required: true, trigger: "blur", message: "请输入您的账号" }
        ],
        password: [
          { required: true, trigger: "blur", message: "请输入您的密码" }
        ],
        code: [{ required: true, trigger: "change", message: "请输入验证码" }]
      },
      loading: false,
      // 验证码开关
      captchaEnabled: true,
      // 注册开关
      register: true,
      redirect: undefined
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  created() {
    this.getCode()
    this.getCookie()
  },
  methods: {
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        if (this.captchaEnabled) {
          this.codeUrl = "data:image/gif;base64," + res.img
          this.loginForm.uuid = res.uuid
        }
      })
    },
    getCookie() {
      const username = Cookies.get("username")
      const password = Cookies.get("password")
      const rememberMe = Cookies.get('rememberMe')
      this.loginForm = {
        username: username === undefined ? this.loginForm.username : username,
        password: password === undefined ? this.loginForm.password : decrypt(password),
        rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
      }
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          if (this.loginForm.rememberMe) {
            Cookies.set("username", this.loginForm.username, { expires: 30 })
            Cookies.set("password", encrypt(this.loginForm.password), { expires: 30 })
            Cookies.set('rememberMe', this.loginForm.rememberMe, { expires: 30 })
          } else {
            Cookies.remove("username")
            Cookies.remove("password")
            Cookies.remove('rememberMe')
          }
          this.$store.dispatch("Login", this.loginForm).then(() => {
            this.$router.push({ path: this.redirect || "/" }).catch(()=>{})
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
.login {
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
        width: 300px;
        height: 300px;
        top: -100px;
        left: -100px;
        animation-delay: 0s;
      }
      
      &.circle-2 {
        width: 200px;
        height: 200px;
        bottom: -50px;
        right: 10%;
        animation-delay: 5s;
      }
      
      &.circle-3 {
        width: 150px;
        height: 150px;
        top: 50%;
        right: -50px;
        animation-delay: 10s;
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

.login-container {
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

.login-form {
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  width: 420px;
  padding: 40px 40px 30px 40px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.3);
  
  .form-header {
    text-align: center;
    margin-bottom: 35px;
    
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
    margin-bottom: 22px;
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
      }
    }
    
    ::v-deep .el-input__prefix {
      left: 12px;
      color: #2a5298;
      font-size: 16px;
    }
  }
  
  .login-options {
    margin-bottom: 20px;
    
    .remember-me {
      ::v-deep .el-checkbox__label {
        color: #606266;
        font-size: 14px;
      }
      
      ::v-deep .el-checkbox__input.is-checked .el-checkbox__inner {
        background-color: #2a5298;
        border-color: #2a5298;
      }
    }
  }
  
  .login-button {
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
  
  .register-link {
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

.login-code {
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

.login-code-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.el-login-footer {
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
  .login {
    padding: 15px;
    justify-content: flex-start;
    padding-top: 40px;
  }

  .login-container {
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    flex: 1;
  }

  .login-form {
    width: 100%;
    max-width: 400px;
    padding: 30px 25px 20px 25px;
    margin: 0 auto;
    
    .form-header {
      .title {
        font-size: 24px;
      }
    }
  }

  .el-login-footer {
    margin-top: 20px;
    padding: 15px 0;
    font-size: 12px;
  }
}
</style>
