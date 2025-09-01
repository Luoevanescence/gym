<template>
	<view class="p-4 bg-[#f5f6fa]">
		<!-- 维修申请表单 -->
		<view class="bg-white rounded-lg p-4 mb-6 shadow-sm">
			<view class="font-bold text-base mb-4">提交维修申请</view>

			<!-- 设备编号 -->
			<view class="mb-3">
				<text class="text-sm text-[#555]">设备编号：</text>
				<input v-model="repairForm.deviceId" class="rounded p-2 text-sm bg-[#f0f2f5]" placeholder="请输入设备编号" />
			</view>

			<!-- 问题描述 -->
			<view class="mb-3">
				<textarea v-model="repairForm.remarks" class="rounded p-2 text-sm bg-[#f0f2f5]" placeholder="请输入故障描述"
					rows="4" />
			</view>

			<!-- 联系方式 -->
			<view class="mb-3">
				<input v-model="repairForm.contactPhone" class="rounded p-2 text-sm bg-[#f0f2f5]" placeholder="联系电话"
					@blur="validatePhone" />
			</view>

			<!-- 图片上传 -->
			<view class="mb-3">
				<button class="bg-[#00b894] text-white text-sm py-1 px-4 rounded" @click="chooseImage">
					{{ imageUploaded ? '图片已上传' : '上传故障图片（选填）' }}
				</button>
			</view>

			<view v-if="repairForm.imageUrl" class="flex justify-center flex-wrap gap-2 mb-3">
				<view class="relative w-full">
					<ImageWithError :src="repairForm.imageUrl" :wrapperClass="'w-full h-50 rounded'" />
					<view @click="deleteImage"
						class="z-2 absolute top-0 right-0 text-white bg-black rounded-full w-4 h-4 flex items-center justify-center text-lg">
						×
					</view>
				</view>
			</view>

			<button class="bg-[#1a73e8] text-white py-2 rounded text-sm w-full" @click="submitRepair">提交维修</button>
		</view>

		<!-- 用户提交记录 -->
		<view class="font-bold text-base mb-3">我的维修记录</view>
		<view v-for="record in repairList" :key="record.monitorId" class="bg-white rounded-lg p-4 mb-4 shadow-sm">
			<view class="flex justify-between items-center text-xs text-[#999] mb-2">
				<text>{{ formatTime(record.createdAt) }}</text>
				<text :class="record.status === 1 ? 'text-[#2e7d32]' : 'text-[#f39c12]'">
					{{ record.status === 1 ? '已处理' : '待处理' }}
				</text>
			</view>
			<view class="text-sm mb-1">设备编号：{{ record.deviceId }}</view>
			<view class="text-sm text-[#444] mb-2">描述：{{ record.remarks }}</view>
			<view v-if="record.imageUrl" class="flex flex-wrap gap-2">
				<ImageWithError :src="record.imageUrl" :wrapperClass="'w-24 h-24 rounded-lg bg-[#f8f9fa]'" />
			</view>
		</view>
	</view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { uploadAvatar } from '@/serve/upload'
import { submitRepairRequest, getRepairList } from '@/serve/security'
import { validatePhoneOptional } from '@/utils/validate'
const { userInfo } = storeToRefs(userStore)


const userStore = useUserStore()

const imageUploaded = ref(false)
const repairList = ref([])

const repairForm = ref({
	deviceId: '',
	remarks: '',
	contactPhone: userInfo.value.phone || '',
	imageUrl: 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/feedbacks/dumbbell.jpg'
})

const validatePhone = () => {
	const isValid = validatePhoneOptional(repairForm.value.contactPhone)
	if (!isValid) {
		uni.showToast({ title: '请输入有效手机号', icon: 'none' })
		return false
	}
	return true
}

const chooseImage = () => {
	uni.chooseImage({
		count: 1,
		success: async (res) => {
			const tempPath = res.tempFilePaths[0]
			try {
				const result = await uploadAvatar(tempPath)
				repairForm.value.imageUrl = result.url
				imageUploaded.value = true
				uni.showToast({ title: '上传成功', icon: 'success' })
			} catch (err) {
				console.error('上传失败:', err)
				uni.showToast({ title: '上传失败', icon: 'none' })
			}
		}
	})
}

const deleteImage = () => {
	repairForm.value.imageUrl = ''
	imageUploaded.value = false
}

const loadRepairs = async () => {
	const res = await getRepairList(userInfo.value.userId)
	if (res.success) {
		repairList.value = res.data
	}
}

const submitRepair = async () => {
	if (!repairForm.value.deviceId.trim()) {
		return uni.showToast({ title: '请输入设备编号', icon: 'none' })
	}
	if (!repairForm.value.remarks.trim()) {
		return uni.showToast({ title: '请输入故障描述', icon: 'none' })
	}
	if (!validatePhone()) return

	const res = await submitRepairRequest({
		...repairForm.value,
		userName: userInfo.value.name || '用户',
	})

	if (res.success) {
		uni.showToast({ title: '提交成功', icon: 'success' })
		Object.assign(repairForm.value, {
			deviceId: '',
			remarks: '',
			contactPhone: userInfo.value.phone || '',
			imageUrl: ''
		})
		imageUploaded.value = false
		await loadRepairs()
	} else {
		uni.showToast({ title: '提交失败', icon: 'none' })
	}
}

const formatTime = (time) => {
	const date = new Date(time)
	return `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()} ${date.getHours()}:${date.getMinutes()}`
}

onMounted(() => {
	if (userInfo.value?.userId) {
		loadRepairs()
	}
})
</script>
