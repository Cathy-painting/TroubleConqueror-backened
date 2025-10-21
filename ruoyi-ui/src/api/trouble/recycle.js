import request from '@/utils/request'

// 查询软删除错题列表
export function listDeletedQuestions(query) {
  return request({
    url: '/trouble/recycle/list',
    method: 'get',
    params: query
  })
}

// 恢复错题
export function restoreQuestion(ids) {
  return request({
    url: '/trouble/recycle/restore/' + ids,
    method: 'post'
  })
}

// 彻底删除错题
export function forceDeleteQuestion(ids) {
  return request({
    url: '/trouble/recycle/forceDelete/' + ids,
    method: 'delete'
  })
}

// 清理过期数据
export function cleanExpiredQuestions() {
  return request({
    url: '/trouble/recycle/clean',
    method: 'post'
  })
}
