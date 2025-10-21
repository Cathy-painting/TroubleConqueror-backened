import request from '@/utils/request'

// 获取错题统计数据
export function getTroubleStats() {
  return request({
    url: '/trouble/dashboard/stats',
    method: 'get'
  })
}

// 获取最近错题
export function getRecentQuestions(params) {
  return request({
    url: '/trouble/dashboard/recent',
    method: 'get',
    params: params
  })
}

// 获取错题标签统计
export function getTagStats() {
  return request({
    url: '/trouble/dashboard/tags',
    method: 'get'
  })
}



