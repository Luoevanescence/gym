import { request } from '@/utils/request'

/**
 * 更新用户信息
 * @param {object} data 用户表单数据
 * @returns Promise
 */
export const updateUserInfo = (data) => {
  return request({
    url: '/users/update',
    method: 'POST',
    data
  })
}
export const getUserInfo = (userId) => {
  return request({
    url: `/users/info/${userId}`,
    method: 'GET',
  });
};
