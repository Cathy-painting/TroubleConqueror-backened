import request from '@/utils/request'

// 获取错题统计数据
export function getTroubleStatistics() {
  return request({
    url: '/trouble/statistics',
    method: 'get'
  })
}



