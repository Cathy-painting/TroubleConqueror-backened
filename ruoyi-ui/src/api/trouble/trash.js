import request from '@/utils/request'

// 查询错题回收站列表
export function listTrash(query) {
  return request({
    url: '/trouble/trash/list',
    method: 'get',
    params: query
  })
}

// 查询错题回收站详细
export function getTrash(trashId) {
  return request({
    url: '/trouble/trash/' + trashId,
    method: 'get'
  })
}

// 恢复错题
export function restoreQuestion(trashId) {
  return request({
    url: '/trouble/trash/restore/' + trashId,
    method: 'post'
  })
}

// 批量恢复错题
export function restoreQuestions(trashIds) {
  return request({
    url: '/trouble/trash/restore',
    method: 'post',
    data: trashIds
  })
}

// 彻底删除错题
export function permanentlyDelete(trashIds) {
  return request({
    url: '/trouble/trash/' + trashIds,
    method: 'delete'
  })
}

// 清空回收站
export function clearTrash() {
  return request({
    url: '/trouble/trash/clear',
    method: 'post'
  })
}

// 导出错题回收站
export function exportTrash(query) {
  return request({
    url: '/trouble/trash/export',
    method: 'post',
    data: query
  })
}



