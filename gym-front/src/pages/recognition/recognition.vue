<template>
    <view class="min-h-screen bg-white flex flex-col items-center justify-center px-4 sm:px-6 md:px-8">
        <div class="max-w-md w-full">
            <!-- 人脸识别卡片 -->
            <div class="bg-gray-50 rounded-2xl p-6 sm:p-8 shadow-sm">
                <div class="text-center mb-4 sm:mb-6">
                    <h2 class="text-lg sm:text-xl font-bold text-gray-800 mb-2">人脸识别</h2>
                    <p class="text-sm sm:text-base text-gray-600">请将面部对准摄像头</p>
                </div>

                <!-- 摄像头预览区域 -->
                <div class="aspect-square bg-black rounded-xl mb-4 sm:mb-6 overflow-hidden">
                    <camera 
                        device-position="front"
                        flash="off"
                        class="w-full h-full"
                    ></camera>
                </div>

                <!-- 操作按钮 -->
                <button 
                    @click="startFaceRecognition"
                    class="w-full bg-orange-500 text-white py-3 sm:py-4 rounded-lg text-sm sm:text-base font-medium hover:bg-orange-600 active:scale-95 transition-all duration-300 shadow-md"
                >
                    开始人脸识别
                </button>

                <!-- 状态提示 -->
                <div v-if="faceInfoList.length > 0" class="mt-4 sm:mt-6 text-center">
                    <p class="text-sm sm:text-base text-green-600">
                        已收集到 {{ faceInfoList.length }} 帧人脸信息
                    </p>
                </div>
            </div>

            <!-- 使用说明 -->
            <div class="mt-4 sm:mt-6 text-center">
                <p class="text-xs sm:text-sm text-gray-500">
                    请保持面部在摄像头范围内，并保持适当距离
                </p>
            </div>
        </div>
    </view>
</template>

<script setup>
import { ref, onMounted } from 'vue';

// 用于存储收集到的人脸信息
const faceInfoList = ref([]);

const session = wx.createVKSession({
    track: {
        face: {
            mode: 1
        } // mode: 1 - 使用摄像头；2 - 手动传入图像
    },
});

// 摄像头实时检测模式下，监测到人脸时，updateAnchors 事件会连续触发 （每帧触发一次）
session.on('updateAnchors', anchors => {
    anchors.forEach(anchor => {
        const faceInfo = {
            points: anchor.points,
            origin: anchor.origin,
            size: anchor.size,
            angle: anchor.angle
        };
        // 将当前帧的人脸信息添加到存储列表中
        faceInfoList.value.push(faceInfo);
        console.log('收集到人脸信息:', faceInfo);
    });
});

// 当人脸从相机中离开时，会触发 removeAnchors 事件
session.on('removeAnchors', () => {
    console.log('人脸离开，已收集到的人脸信息数量:', faceInfoList.value.length);
    // 这里可以进行更多操作，比如将收集到的信息发送到服务器
    // 示例：假设存在一个上传人脸信息到服务器的函数 uploadFaceInfo
    // uploadFaceInfo(faceInfoList.value);
});

// 定义触发的方法
const startFaceRecognition = () => {
    session.start(errno => {
        if (errno) {
            // 如果失败，将返回 errno
            console.error('人脸识别启动失败，错误码:', errno);
            wx.showToast({
                title: '启动失败',
                icon: 'error',
                duration: 2000
            });
        } else {
            // 否则，返回 null，表示成功
            console.log('人脸识别启动成功');
            wx.showToast({
                title: '启动成功',
                icon: 'success',
                duration: 2000
            });
        }
    });
};

onMounted(() => {
    // 可以在这里自动启动，也可以通过按钮点击启动
    // startFaceRecognition();
});
</script>

<style scoped>
/* 添加卡片悬停效果 */
.bg-gray-50 {
    transition: all 0.3s ease;
}

.bg-gray-50:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

/* 添加按钮点击动画 */
button:active {
    transform: scale(0.98);
}
</style>