import { request } from '@/utils/request'

// 新增一条设备维修请求
export const submitRepairRequest = (data) => {
  return request({
    url: '/security/submit',
    method: 'POST',
    data // 包括 deviceId, remarks, imageUrl, contactPhone, userName
  })
}

// 获取当前用户提交的维修记录
export const getRepairList = (userId) => {
  return request({
    url: '/security/list',
    method: 'GET',
    data: { userId } // 后端如果不需要 userId，可移除
  })
}