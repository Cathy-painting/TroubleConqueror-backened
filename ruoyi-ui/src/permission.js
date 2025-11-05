import router from './router'
import store from './store'
import { Message } from 'element-ui'
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'
import { getToken } from '@/utils/auth'
import { isPathMatch } from '@/utils/validate'
import { isRelogin } from '@/utils/request'

NProgress.configure({ showSpinner: false })

const whiteList = ['/login', '/register']

const isWhiteList = (path) => {
  return whiteList.some(pattern => isPathMatch(pattern, path))
}

router.beforeEach((to, from, next) => {
  NProgress.start()
  if (getToken()) {
    to.meta.title && store.dispatch('settings/setTitle', to.meta.title)
    
    // 控制侧边栏显示/隐藏
    const roles = store.getters.roles || []
    const isAdmin = roles.includes('admin')
    const hideSidebar = to.meta.noSidebar === true || (!isAdmin && (to.path === '/trouble/dashboard' || to.path === '/trouble/question/view'))
    store.dispatch('app/toggleSideBarHide', hideSidebar)
    
    /* has token */
    if (to.path === '/login') {
      next({ path: '/' })
      NProgress.done()
    } else if (isWhiteList(to.path)) {
      next()
    } else {
      if (store.getters.roles.length === 0) {
        isRelogin.show = true
        // 判断当前用户是否已拉取完 user_info 信息
        store.dispatch('GetInfo').then(() => {
          isRelogin.show = false
          store.dispatch('GenerateRoutes').then(accessRoutes => {
            // 根据 roles 权限生成可访问的路由表
            router.addRoutes(accessRoutes) // 动态添加可访问路由表

            // 根据用户角色决定跳转页面
            const roles = store.getters.roles
            let redirectPath = '/index' // 默认跳转到首页

            // 如果不是 admin 用户，跳转到 trouble/dashboard
            if (!roles.includes('admin')) {
              redirectPath = '/trouble/dashboard'
            }

            // 如果存在原始重定向地址，优先使用
            if (to.query.redirect) {
              redirectPath = decodeURIComponent(to.query.redirect)
            }

            next({ path: redirectPath, replace: true })
          })
        }).catch(err => {
          store.dispatch('LogOut').then(() => {
            Message.error(err)
            next({ path: '/' })
          })
        })
      } else {
        next()
      }
    }
  } else {
    // 没有 token
    if (isWhiteList(to.path)) {
      // 在免登录白名单，直接进入
      next()
    } else {
      next(`/login?redirect=${encodeURIComponent(to.fullPath)}`) // 否则全部重定向到登录页
      NProgress.done()
    }
  }
})

router.afterEach(() => {
  NProgress.done()
})
