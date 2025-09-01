import { request } from '@/utils/request'

/**
 * 查询门店（根据名称）
 * @param {string} name 门店名称关键词
 * @returns Promise
 */
export const searchStoresByName = (name) => {
  return request({
    url: '/stores',
    method: 'GET',
    data: { name }
  })
}
