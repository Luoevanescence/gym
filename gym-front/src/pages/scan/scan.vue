<script setup>
import { ref } from 'vue';
import { onLoad } from '@dcloudio/uni-app';

// 使用 ref 创建响应式数据
const scanCode = ref('');

// onLoad 生命周期钩子
onLoad((options) => {
	// 这里可以处理页面加载时的逻辑
});

// 扫码事件
const scanCodeEvent = () => {
	uni.scanCode({
		onlyFromCamera: true, // 只允许从相机扫码
		success: (res) => {
			console.log("扫码成功：", JSON.stringify(res));
			// 扫码成功后，更新 scanCode 的值
			scanCode.value = res.result;
			// 提示信息
			wx.showToast({
				title: '成功',
				icon: 'success',
				duration: 2000//持续的时间
			})
		},
		fail: (err) => {
			console.error("扫码失败：", err);
			wx.showToast({
				title: '扫码失败',
				icon: 'error',
				duration: 2000
			})
		}
	});
};
</script>

<template>
	<view class="min-h-screen bg-white flex flex-col items-center justify-center px-4 sm:px-6 md:px-8">
		<div class="max-w-md w-full">
			<!-- 扫码区域 -->
			<div class="bg-gray-50 rounded-2xl p-6 sm:p-8 mb-6 sm:mb-8 shadow-sm">
				<div class="text-center mb-4 sm:mb-6">
					<h2 class="text-lg sm:text-xl font-bold text-gray-800 mb-2">扫码入场</h2>
					<p class="text-sm sm:text-base text-gray-600">请将二维码对准扫描框</p>
				</div>
				<div class="aspect-square bg-white rounded-xl border-2 border-dashed border-gray-300 flex items-center justify-center mb-4 sm:mb-6">
					<view class="text-center">
						<view class="w-16 h-16 sm:w-20 sm:h-20 mx-auto mb-3 sm:mb-4">
							<img src="https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/home/qrcode.svg" alt="扫码图标" class="w-full h-full" />
						</view>
						<text class="text-xs sm:text-sm text-gray-500">点击开始扫码</text>
					</view>
				</div>
				<button 
					@click="scanCodeEvent"
					class="w-full bg-orange-500 text-white py-3 sm:py-4 rounded-lg text-sm sm:text-base font-medium hover:bg-orange-600 active:scale-95 transition-all duration-300 shadow-md"
				>
					开始扫码
				</button>
			</div>

			<!-- 扫码结果 -->
			<div v-if="scanCode" class="bg-gray-50 rounded-2xl p-4 sm:p-6 shadow-sm">
				<h3 class="text-base sm:text-lg font-semibold text-gray-800 mb-2">扫码结果</h3>
				<p class="text-sm sm:text-base text-gray-600 break-all">{{ scanCode }}</p>
			</div>
		</div>
	</view>
</template>

<style scoped>
/* 添加按钮点击动画 */
button:active {
	transform: scale(0.98);
}

/* 添加扫码框悬停效果 */
.aspect-square {
	transition: all 0.3s ease;
}

.aspect-square:hover {
	border-color: #f97316;
	transform: translateY(-2px);
}
</style>