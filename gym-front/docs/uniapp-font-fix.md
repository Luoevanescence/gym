
# uni-app 小程序字体无法引入的终极解决方案

## 1. 问题现象

在 uni-app 项目中，给小程序加载自定义字体时，出现如下错误：

```
[渲染层网络层错误] Failed to load local font resource /static/fonts/AlimamaFangYuanTiVF-Thin.ttf-do-not-use-local-path-./app.wxss&1442&7
the server responded with a status of 500 (HTTP/1.1 500 Internal Server Error)
(env: Windows,mp,1.06.2409131; lib: 3.7.12)
```

## 2. 原因分析

- 小程序编译后，不支持 `@` 别名去访问静态文件。
- 小程序不支持 `./` 相对路径引入字体资源。
- 静态资源如果没有放到 `static` 目录下，编译时不会被正确打包。
- HBuilderX 部分版本存在静态资源未打包的 bug。

## 3. 正确解决方案

### ✅ 路径写法要绝对：

```css
@font-face {
  font-family: 'AlimamaFangYuanTi';
  src: url('/static/fonts/AlimamaFangYuanTiVF-Thin.woff2') format('woff2'),
       url('/static/fonts/AlimamaFangYuanTiVF-Thin.woff') format('woff'),
       url('/static/fonts/AlimamaFangYuanTiVF-Thin.ttf') format('truetype');
  font-display: swap;
}
```

### ❗【不要这样写】

```css
src: url('@/static/fonts/xxx.ttf');  // ❌ 错误
src: url('./static/fonts/xxx.ttf');  // ❌ 错误
src: url(../fonts/xxx.ttf);          // ❌ 错误
```

### ✅ 【要这样写】

```css
src: url('/static/fonts/xxx.ttf');   // ✅ 正确
```

### ✅ 文件位置一定要对：

```
/static/fonts/AlimamaFangYuanTiVF-Thin.ttf
```

## 4. HBuilderX 打包注意

- 关闭 HBuilderX，重启后重新编译。
- 检查打包后 `dist/dev/mp-weixin/static/fonts/` 目录下是否存在字体文件。
- 小程序打包后字体路径 `/static/fonts/xxx.ttf` 会被映射，无需修改。

## 5. 最终总结

| 错误原因 | 解决方法 |
|----------|----------|
| 小程序不认 `@/static` | 用 `/static/` 绝对路径 |
| 不支持 `./` 相对路径 | 改成 `/static/xxx` |
| 静态资源没打包 | 重启 HBuilderX，检查 `dist/` 目录 |
| 文件路径写错 | 确保放在 `/static/fonts/` |

---

## 6. demo 示例

> 直接在 `App.vue` 或公共样式中引入：

```css
@font-face {
  font-family: 'AlimamaFangYuanTi';
  src: url('/static/fonts/AlimamaFangYuanTiVF-Thin.woff2') format('woff2');
}

.page-title {
  font-family: 'AlimamaFangYuanTi';
  font-size: 24px;
}
```

> 页面调用示例：

```vue
<template>
  <view class="page-title">自定义字体示例</view>
</template>
```

---
以上方法适用于 **微信小程序、字节小程序、H5、App** 统一适配。
