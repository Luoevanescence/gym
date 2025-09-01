<template>
  <view class="bg-gray-100 h-screen flex flex-col justify-between">
    <view class="bg-white p-4 m-4 rounded-lg">
      <!-- 头像 -->
      <view class="flex justify-between items-center mb-4">
        <view class="text-gray-600">头像</view>
        <view>
          <image v-if="!isEditing" class="w-12 h-12 rounded-full object-cover" mode="aspectFill" :src="form.avatarUrl"></image>
          <button v-else @click="chooseAvatar" class="text-blue-500 text-sm">
            {{ AvaterIsUpload ? '已上传图片' : '请选择图片' }}
          </button>
        </view>
      </view>

      <!-- 昵称 -->
      <view class="flex justify-between items-center mb-4">
        <view class="text-gray-600">昵称</view>
        <view>
          <input v-if="isEditing" v-model="form.name" class="border px-2 py-1 rounded text-sm w-40"
            placeholder="请输入昵称" />
          <view v-else class="text-gray-800 font-bold">{{ form.name }}</view>
        </view>
      </view>

      <!-- 手机号 -->
      <view class="flex justify-between items-center mb-4">
        <view class="text-gray-600">手机号码</view>
        <view>
          <input v-if="isEditing" v-model="form.phone" class="border px-2 py-1 rounded text-sm w-40"
            placeholder="请输入手机号" />
          <view v-else class="text-gray-800">{{ maskPhone(form.phone) }}</view>
        </view>
      </view>

      <!-- 性别 -->
      <view class="flex justify-between items-center mb-4">
        <view class="text-gray-600">性别</view>
        <view>
          <picker v-if="isEditing" :range="genderOptions" @change="onGenderChange" :value="genderIndex">
            <text class="text-gray-800">{{ genderOptions[genderIndex] }}</text>
          </picker>
          <view v-else class="text-gray-800">{{ displayGender(form.gender) }}</view>
        </view>
      </view>

      <!-- 出生日期 -->
      <view class="flex justify-between items-center mb-4">
        <view class="text-gray-600">出生日期</view>
        <view>
          <picker v-if="isEditing" mode="date" :value="form.birthday" @change="onBirthChange">
            <text class="text-gray-800">{{ form.birthday || '请选择日期' }}</text>
          </picker>
          <view v-else class="text-gray-400">未设置出生日期</view>
        </view>
      </view>

      <!-- 身高 -->
      <view class="flex justify-between items-center mb-4">
        <view class="text-gray-600">身高</view>
        <view>
          <input v-if="isEditing" type="number" v-model="form.height" class="border px-2 py-1 rounded text-sm w-20"
            placeholder="cm" />
          <view v-else class="text-gray-800">{{ form.height }}cm</view>
        </view>
      </view>

      <!-- 体重 -->
      <view class="flex justify-between items-center mb-4">
        <view class="text-gray-600">体重</view>
        <view>
          <input v-if="isEditing" type="number" v-model="form.weight" class="border px-2 py-1 rounded text-sm w-20"
            placeholder="kg" />
          <view v-else class="text-gray-800">{{ form.weight }}kg</view>
        </view>
      </view>
    </view>

    <!-- 按钮区域 -->
    <view class="p-4 flex justify-center space-x-4">
      <button v-if="!isEditing" class="bg-blue-500 text-white py-2 px-6 rounded-full"
        @click="isEditing = true">修改信息</button>
      <template v-else>
        <button class="bg-green-500 text-white py-2 px-6 rounded-full" @click="saveChanges">保存</button>
        <button class="bg-gray-400 text-white py-2 px-6 rounded-full" @click="cancelEdit">取消</button>
      </template>
      <button v-if="!isEditing" class="bg-[#ff7000] text-white py-2 px-6 rounded-full" @click="logout">退出登录</button>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { storeToRefs } from 'pinia'
import { updateUserInfo } from '@/serve/user'
import { useUserStore } from '@/stores/user.js'
import { uploadAvatar } from '@/serve/upload'

const userStore = useUserStore()
const { token, userInfo } = storeToRefs(userStore)

const isEditing = ref(false)
const originalData = ref({})
const AvaterIsUpload = ref(false)

const form = ref({
  userId: userInfo.value.userId,
  avatarUrl: userInfo.value.avatarUrl,
  name: userInfo.value.name || 'xxx',
  phone: userInfo.value.phone || '',
  gender: userInfo.value.gender || 'male',
  birthday: userInfo.value.birthday || '',
  height: userInfo.value.height || 170,
  weight: userInfo.value.weight || 60
})

const genderOptions = ['男', '女', '其他']
const genderEnum = ['male', 'female', 'other']
const genderIndex = ref(genderEnum.indexOf(form.value.gender))
// 性别选择器
const onGenderChange = (e) => {
  genderIndex.value = e.detail.value
  form.value.gender = genderEnum[genderIndex.value]
}
// 修改生日日期
const onBirthChange = (e) => {
  form.value.birthday = e.detail.value
}
// 手机号验证
const maskPhone = (phone) => phone?.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2')
//修改性别
const displayGender = (value) => {
  return genderOptions[genderEnum.indexOf(value)] || '未知'
}
//修改头像
const chooseAvatar = () => {
  uni.chooseImage({
    count: 1,
    success: async (res) => {
      const tempPath = res.tempFilePaths[0];
      console.log('选中图片路径:', tempPath);

      try {
        const result = await uploadAvatar(tempPath);
        form.value.avatarUrl = result.url;
        AvaterIsUpload.value = true;
        uni.showToast({ title: '上传成功', icon: 'success' });
      } catch (err) {
        console.error('上传失败:', err);
        uni.showToast({ title: err.message || '上传失败', icon: 'none' });
      }
    }
  });
};


//保存修改
const saveChanges = async () => {
  if (!form.value.name || !/^1[3-9]\d{9}$/.test(form.value.phone)) {
    return uni.showToast({ title: '请输入有效昵称和手机号', icon: 'none' })
  }
  if (form.value.height <= 0 || form.value.weight <= 0) {
    return uni.showToast({ title: '请输入有效身高和体重', icon: 'none' })
  }

  try {
    await updateUserInfo(form.value)
    // 更新本地存储和store中的用户信息
    const userStore = useUserStore()
    const token = uni.getStorageSync('token')
    const updatedUser = { ...uni.getStorageSync('user'), ...form.value }
    uni.setStorageSync('user', updatedUser)
    userStore.setUser(token, updatedUser)

    uni.showToast({ title: '保存成功', icon: 'success' })
    isEditing.value = false
    originalData.value = { ...form.value }
  } catch (err) {
    uni.showToast({ title: '保存失败', icon: 'none' })
    console.error(err)
  }
}
//取消修改
const cancelEdit = () => {
  form.value = { ...originalData.value }
  isEditing.value = false
}
const logout = () => {
  uni.showModal({
    title: '提示',
    content: '确定要退出登录吗？',
    confirmText: '退出',
    cancelText: '取消',
    success: (res) => {
      if (res.confirm) {
        // 清除本地数据
        uni.removeStorageSync('token')
        uni.removeStorageSync('user')
        userStore.clearUser()

        // 提示
        uni.showToast({ title: '已退出登录', icon: 'none' })

        // 跳转页面：可改成返回登录页或首页
        setTimeout(() => {
          wx.navigateBack()
        }, 500)
      }
    }
  })
}

</script>
