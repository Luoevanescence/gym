import { BASE_URL } from '@/utils/request';
export const uploadAvatar = (filePath) => {
    return new Promise((resolve, reject) => {
        uni.uploadFile({
            url: BASE_URL + '/upload/upload-to-github',
            filePath,
            name: 'file',
            success: (res) => {
                try {
                    const data = JSON.parse(res.data);
                    if (data.success) {
                        resolve(data); // 成功返回
                    } else {
                        reject(new Error(data.message || '上传失败'));
                    }
                } catch (err) {
                    reject(new Error('上传响应格式异常'));
                }
            },
            fail: (err) => {
                reject(err);
            }
        });
    });
};
