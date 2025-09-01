import { request } from '@/utils/request'

/**
 * 获取所有激活状态的会员卡类型
 * @returns Promise<Array>
 */
export const getCardTypes = () => {
  return request({
    url: '/cards/types',
    method: 'GET'
  });
};

/**
 * 根据typeId获取会员卡类型
 * @returns Promise<Object>
 */
export const getCardTypeById = (typeId) => {
  return request({
    url: `/cards/types/${typeId}`,
    method: 'GET'
  })
}