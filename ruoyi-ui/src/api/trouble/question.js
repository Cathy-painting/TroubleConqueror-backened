import request from '@/utils/request'

// 查询错题列表
export function listQuestion(query) {
  return request({
    url: '/trouble/question/list',
    method: 'get',
    params: query
  })
}

// 查询错题详细
export function getQuestion(questionId) {
  return request({
    url: '/trouble/question/' + questionId,
    method: 'get'
  })
}

// 新增错题
export function addQuestion(data) {
  return request({
    url: '/trouble/question',
    method: 'post',
    data: data
  })
}

// 修改错题
export function updateQuestion(data) {
  return request({
    url: '/trouble/question',
    method: 'put',
    data: data
  })
}

// 删除错题
export function delQuestion(questionId) {
  return request({
    url: '/trouble/question/' + questionId,
    method: 'delete'
  })
}

// 导出错题
export function exportQuestion(query) {
  return request({
    url: '/trouble/question/export',
    method: 'post',
    data: query
  })
}


