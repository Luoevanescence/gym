# GitHub + PicList + jsDelivr 图床搭建教程

## 1. 前言

图床是将图片上传到公网可访问的位置并生成链接的工具，适合博客、文档、项目中引用图片。本文将教你如何用 **GitHub 仓库 + PicList 工具 + jsDelivr CDN** 搭建一个**永久免费、稳定、免备案**的个人图床。

## 2. 准备工作

### 2.1 你需要：

- 一个 **GitHub 账号**
- 一台 **Windows 或 Mac 电脑**
- 安装好 **Node.js (建议 16.x 版本)**

### 2.2 工具简介

| 工具     | 作用                            |
| -------- | ------------------------------- |
| GitHub   | 存储图片，免费公开仓库          |
| PicList  | 上传图片到 GitHub 的客户端工具  |
| jsDelivr | 免费 CDN 加速，生成直链访问图片 |

## 3. 创建 GitHub 图床仓库

1. 打开 [GitHub](https://github.com) 并登录。
2. 点击右上角 **"New repository"** 新建仓库。
3. 仓库名称建议如：`pic-bed`。
4. 选择 **Public（公开）**。
5. 初始化选项可以勾选 `Add a README file`。
6. 创建完成后记下这个仓库地址，如：
   ```
   https://github.com/你的用户名/pic-bed
   ```

## 4. 安装 PicList

### 4.1 全局安装

```bash
npm install -g @picgo/piclist
```

### 4.2 验证安装

```bash
piclist -v
```

## 5. 配置 GitHub 图床

### 5.1 获取 GitHub Token

1. 访问 [https://github.com/settings/tokens](https://github.com/settings/tokens)。
2. 点击 **"Generate new token (classic)"**。
3. 权限勾选：
   - `repo`
   - `workflow`
4. 生成后记下这个 Token（只会显示一次）。

### 5.2 配置 PicList

```bash
piclist set uploader github
```

输入信息：

- **repo**: `用户名/仓库名` （例如：`myusername/pic-bed`）
- **branch**: `main`
- **token**: 粘贴你的 GitHub Token
- **path**: 存储图片的文件夹路径（如 img/）

## 6. 上传图片到图床

### 6.1 上传图片

```bash
piclist upload 图片路径
```

### 6.2 生成 jsDelivr CDN 链接

GitHub 原始链接格式：

```
https://raw.githubusercontent.com/用户名/仓库名/分支名/路径/文件名
```

使用 jsDelivr 格式加速：

```
https://cdn.jsdelivr.net/gh/用户名/仓库名@分支名/路径/文件名
```

示例：

```
https://cdn.jsdelivr.net/gh/myusername/pic-bed@main/img/demo.png
```

## 7. PicList 快捷上传配置（可选）

### 7.1 配置 PicList 快捷命令

```bash
piclist set proxy false
piclist set messageFormat '[url]'
```

### 7.2 结合剪贴板自动上传

```bash
piclist upload
```

## 8. 总结

通过 GitHub 存储图片，PicList 简化上传流程，jsDelivr 提供高速访问的图床搭建完成。

| 工具     | 作用                |
| -------- | ------------------- |
| GitHub   | 免费存储图片        |
| PicList  | 快速上传 & 管理图片 |
| jsDelivr | 免费 CDN 全球加速   |

## 9. 附录

- PicList 官方文档：[https://piclist.github.io](https://piclist.github.io)
- jsDelivr 官方网站：[https://www.jsdelivr.com/](https://www.jsdelivr.com/)


