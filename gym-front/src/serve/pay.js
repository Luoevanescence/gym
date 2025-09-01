import { request } from '@/utils/request'

export const createOrder = (data) => {
  return request({
    url: '/pay/create-order',
    method: 'POST',
    data
  })
}
export const getOrdersByUserId = (userId) => {
  return request({
    url: `/pay/orders?userId=${userId}`,
    method: 'GET'
  });
};
