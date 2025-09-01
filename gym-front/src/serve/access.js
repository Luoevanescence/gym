import { request } from '@/utils/request'
export const getAccessRecordsByUserId = (userId) => {
  return request({
    url: `/access/records`,
    method: 'GET',
    data: { userId },
  })
};
