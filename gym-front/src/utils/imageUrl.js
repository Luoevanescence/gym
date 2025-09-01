/**
 * 拼接图片资源路径（支持 ES6 模块导出）
 * @param {string} basePath - 基础路径（如：https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static）
 * @param {string} [fileName='home/single.svg'] - 文件名（默认值为目标 SVG 路径）
 * @returns {string} 完整的图片资源 URL
 */
export function getImageUrl(basePath, fileName = '/home/single.svg') {
  // 去除基础路径末尾可能存在的斜杠
  const cleanBasePath = basePath.replace(/\/+$/, '');
  // 拼接路径并返回
  return `${cleanBasePath}/${fileName}`;
}
