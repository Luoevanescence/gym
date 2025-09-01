// utils/request.js

export  const BASE_URL = 'http://172.16.37.19:3000/api' // ⚠️ 替换为你自己的后端 API 地址

export const request = (options = {}) => {
  return new Promise((resolve, reject) => {
    uni.request({
      url: BASE_URL + options.url,
      method: options.method || 'GET',
      data: options.data || {},
      header: {
        'Content-Type': 'application/json',
        ...(options.header || {})
      },
      success: res => {
        if (res.statusCode === 200) {
          // 业务 success: true 检查（根据后端约定）
          if (res.data.success !== false) {
            resolve(res.data)
          } else {
            uni.showToast({
              title: res.data.message || '接口返回错误',
              icon: 'none'
            })
            reject(res.data)
          }
        } else {
          uni.showToast({
            title: '服务器响应失败',
            icon: 'none'
          })
          reject(res)
        }
      },
      fail: err => {
        uni.showToast({
          title: '请求失败',
          icon: 'none'
        })
        reject(err)
      }
    })
  })
}
