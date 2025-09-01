import { request } from '@/utils/request'

// 新增一条用户反馈
export const submitUserFeedback = (data) => {
  return request({
    url: '/user-feedback/submit',
    method: 'POST',
    data, // 包括 userId, feedbackType, content, images, contactPhone
  })
}

// 获取当前用户所有反馈记录
export const getUserFeedbacks = (userId) => {
  return request({
    url: '/user-feedback/list',
    method: 'GET',
    data: { userId }
  })
}