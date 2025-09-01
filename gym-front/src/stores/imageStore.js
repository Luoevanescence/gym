import {ref} from 'vue';
import { defineStore } from 'pinia';
import { getImageUrl } from '../utils/imageUrl.js';

export const useImageStore = defineStore('image', () => {
  // 基础路径（使用 ref 使其可响应式更新）
  const basePath = ref('https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static');
  
  // 获取完整图片 URL 的方法
  const getUrl = (fileName = 'home/single.svg') => getImageUrl(basePath.value, fileName);
  
  // 动态更新基础路径的方法（可选）
  const setBasePath = (newPath) => {
    basePath.value = newPath;
  };

  return { basePath, getUrl, setBasePath };
});