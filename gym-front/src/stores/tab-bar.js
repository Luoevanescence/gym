import { defineStore } from 'pinia'
import { ref, watch } from 'vue'

export const useTabBarStore = defineStore('tabBar', () => {
  // 当前路由
  const currentPath = ref('')

  const tabList = [
    {
      text: "首页",
      pagePath: "/pages/index/index",
      iconPath: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/tabs/home_default.png",
      selectedIconPath: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/tabs/home_selected.png"
    },
    {
      text: "门店",
      pagePath: "/pages/store/store",
      iconPath: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/tabs/store_default.png",
      selectedIconPath: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/tabs/store_selected.png"
    },
    {
      text: "会员",
      pagePath: "/pages/member/member",
      iconPath: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/tabs/member__default.png",
      selectedIconPath: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/tabs/member_selected.png"
    }, {

      text: "我的",
      pagePath: "/pages/profile/profile",
      iconPath: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/tabs/profile_default.png",
      selectedIconPath: "https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/tabs/profile_selected.png"
    },
  ]

  // 监听路由变化
  watch(() => {
    const pages = getCurrentPages()
    const currentPage = pages[pages.length - 1]
    return '/' + currentPage.route
  }, (newPath) => {
    currentPath.value = newPath
  }, { immediate: true })

  // 切换标签页
  function switchTab(path) {
    uni.switchTab({
      url: path
    })

    currentPath.value = path
  }

  return {
    currentPath,
    tabList,
    switchTab
  }
}) 