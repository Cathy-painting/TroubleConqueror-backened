import request from '@/utils/request'

// 获取错题表SQL查询结果
export function getTroubleQuestionSQL() {
  return request({
    url: '/trouble/test/sql/trouble_question',
    method: 'get'
  })
}

// 获取错题回收站表SQL查询结果
export function getTroubleQuestionTrashSQL() {
  return request({
    url: '/trouble/test/sql/trouble_question_trash',
    method: 'get'
  })
}

