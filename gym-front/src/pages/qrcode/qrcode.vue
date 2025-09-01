<script setup>
import { onLoad } from '@dcloudio/uni-app'
import drawQrcode from '../../utils/weapp.qrcode.esm.js'

let deviceId = '' // 定义一个变量接收 deviceId

onLoad((options) => {
	// 解析参数
	deviceId = options.deviceId || '未知设备'

	const context = wx.createCanvasContext('myQrcode')

	drawQrcode({
		width: 200,
		height: 200,
		canvasId: 'myQrcode',
		ctx: context,
		text: deviceId, // ✅ 设置二维码内容为 deviceId
		callback: () => {
			console.log('二维码绘制完成，内容为：', deviceId)
		}
	})
})
</script>



<template>
	<view class="min-h-screen bg-white flex flex-col items-center justify-center px-4 sm:px-6 md:px-8">
		<div class="max-w-md w-full">
			<!-- 二维码卡片 -->
			<div class="bg-gray-50 rounded-2xl p-6 sm:p-8 shadow-sm">
				<div class="text-center mb-4 sm:mb-6">
					<h2 class="text-lg sm:text-xl font-bold text-gray-800 mb-2">设备码</h2>
					<p class="text-sm sm:text-base text-gray-600">出入请扫描该二维码</p>
				</div>

				<!-- 二维码容器 -->
				<div class="bg-white rounded-xl p-4 sm:p-6 mb-4 sm:mb-6 flex justify-center">
					<canvas canvas-id="myQrcode" class="w-[200px] h-[200px]"
						style="width: 200px; height: 200px;"></canvas>
				</div>

				<!-- 会员信息 -->
				<!-- <div class="bg-white rounded-xl p-4 sm:p-6">
					<div class="flex items-center justify-between mb-3">
						<span class="text-sm sm:text-base text-gray-600">会员类型</span>
						<span class="text-sm sm:text-base font-medium text-gray-800">周卡会员</span>
					</div>
					<div class="flex items-center justify-between">
						<span class="text-sm sm:text-base text-gray-600">有效期</span>
						<span class="text-sm sm:text-base font-medium text-gray-800">2024-03-20</span>
					</div>
				</div> -->
			</div>

			<!-- 提示信息 -->
			<!-- <div class="mt-4 sm:mt-6 text-center">
				<p class="text-xs sm:text-sm text-gray-500">请保持屏幕常亮，以便工作人员扫描</p>
			</div> -->
		</div>
	</view>
</template>

<style scoped>
/* 添加卡片悬停效果 */
.bg-gray-50 {
	transition: all 0.3s ease;
}

.bg-gray-50:hover {
	transform: translateY(-2px);
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}
</style>