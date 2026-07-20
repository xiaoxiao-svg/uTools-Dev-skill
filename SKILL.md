---
name: utools-dev
description: uTools 插件开发规范。当项目含 plugin.json、用户提及 uTools/utools 开发、编写 preload.js 时激活。
keywords: [utools, ubrowser, preload.js, plugin.json, uTools插件]
---

# uTools 插件开发规范

## 开发参考
提供完整 API 文档路径（utools.*、ubrowser.*）、preload.js CommonJS 约束、plugin.json 配置要点。
仅遇到具体 API 用法疑问时再查阅 reference 文件，避免每次加载全部读取。

API 参考：
`references/uTools-Dev-Doc.md`

开发记录参考：
`references/uTools-Plugin-Dev-Record.md`

遇到 `utools.*` / `ubrowser.*` / `plugin.json` / `preload.js` 相关问题时，**必须先查阅该文档对应章节**再回答（API 使用、uTools开发等官方规范问题查看 API 参考，实际可能遇到的问题查看开发记录参考）。

## 核心 API 速览

| 模块 | 关键 API |
|------|----------|
| 事件 | `utools.onPluginEnter`、`onPluginOut`、`onMainPush`、`onDbPull` |
| 窗口 | `utools.setSubInput`、`hideMainWindow`、`setExpendHeight`、`createBrowserWindow` |
| 数据 | `utools.db.put/get/remove` |
| 浏览器 | `ubrowser.goto().click().value().run()` |
| AI | `utools.ai({messages})`、`utools.allAiModels()` |
| 媒体 | `utools.runFFmpeg(args)`、`utools.screenCapture()` |

## 关键约束
- `preload.js` 遵循 CommonJS 规范，**不可混淆、压缩、打包**
- 引入的第三方 npm 模块源码必须清晰可读，连同源码一起提交
- `plugin.json` 是唯一入口配置文件，`features.cmds` 定义搜索指令
- 正则表达式中的反斜杠 `\` 需写成 `\\`
- 发布前检查移除 `.git/`、`.vscode/`、`*.js.map`、`*.css.map`

## Vite + Vue 项目结构（现代前端开发）

### 目录规范
```
background-removal/
├── public/                    # 静态资源，构建时原样复制到 dist/
│   ├── plugin.json
│   ├── preload.js
│   └── logo.png
├── src/                       # Vue 源码
│   ├── components/
│   ├── composables/
│   ├── App.vue
│   └── main.ts
├── index.html                 # Vite 入口
├── vite.config.ts
└── package.json
```

### vite.config.ts 关键配置
```typescript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  base: './',                   // 必须，适配 uTools file:// 协议
  plugins: [vue()],
  build: {
    outDir: 'dist',
    rollupOptions: {
      input: resolve(__dirname, 'index.html'),
      output: {
        entryFileNames: 'assets/[name].js',
        chunkFileNames: 'assets/[name].js',
        assetFileNames: 'assets/[name].[ext]'
      }
    }
  }
})
```
- `base: './'` — 必须，适配 uTools 的 `file://` 协议
- `outDir: 'dist'` — 构建产物输出目录
- 构建产物路径使用 `assets/[name].js` 避免缓存问题

### 开发流程
1. `pnpm dev` 启动开发服务器
2. plugin.json 增加 `development.main` 指向 `http://localhost:5173`
3. uTools 开发者工具 → 接入开发

### 构建与发布流程
1. `pnpm build` → 产物输出到 `dist/`
2. public/ 内容自动复制到 dist/
3. preload 依赖安装到 dist/ 同级（不打包，源码可读）
4. 在开发者工具中选择 `dist/plugin.json` 打包

### preload.js 依赖处理
| 类型 | 处理方式 |
|------|---------|
| 前端依赖（vue、element-plus） | 正常 npm 安装，Vite 自动打包 |
| Node.js 依赖（background-removal-node、sharp 等） | 源码放在 preload.js 同级 node_modules，不编译不打包 |

## preload.js 常见陷阱

### 模块导入
```js
// 错误：解构导入
const { fs } = require('fs')

// 正确：整体导入
const fs = require('fs')
```

### package.json type 字段
同级目录必须存在 `package.json` 且设置 `"type": "commonjs"`：
```json
{ "type": "commonjs" }
```
否则 Node.js 可能以 ESM 模式解析导致 require 报错。

### iframe 中 API 调用
HTML 中嵌入 iframe 时，uTools API 在 iframe 中不可用：
```js
// 在 iframe 中通过 parent 访问
window.parent.utools.redirect('备忘录')
window.parent.preload.yourMethod()
```

### 文件路径引用
开发中涉及文件地址引用**使用相对地址**，uTools 打包后绝对路径失效。

## features.cmds 匹配指令类型

| type 值 | 用途 | 示例 |
|---------|------|------|
| 无（纯字符串）| 关键词搜索进入 | `["去背景", "remove bg"]` |
| `img` | 剪贴板图片匹配 | `[{ "type": "img", "label": "移除背景" }]` |
| `files` | 文件/文件夹匹配 | `[{ "type": "files", "extensions": ["png","jpg"] }]` |
| `regex` | 正则匹配特定文本 | `[{ "type": "regex", "match": "/^https?:\\/\\//" }]` |
| `over` | 任意文本匹配 | `[{ "type": "over", "label": "文本处理" }]` |
| `window` | 活动窗口匹配 | `[{ "type": "window", "match": { "app": ["chrome.exe"] } }]` |

## plugin.json development 字段（开发模式）

开发阶段配置热更新入口：
```json
{
  "development": {
    "main": "http://127.0.0.1:5173/index.html"
  }
}
```
构建发布前需移除或注释此字段。

## 移植第三方库 checklist

评估第三方库是否可移植到 uTools：

- [ ] **运行环境**：区分 browser / Node.js，preload.js 走 Node.js
- [ ] **依赖是否纯 JS**：含 C++ addon（.node 二进制）需确认源码可读性要求
- [ ] **网络依赖**：运行时从 CDN 下载的资源需改为本地打包或启动时缓存
- [ ] **ESM/CommonJS**：ESM 模块需构建工具转为 CommonJS 才能在 preload.js 使用
- [ ] **模型/资源文件**：大文件（如 AI 模型）建议启动时下载缓存，不打包入插件
- [ ] **Web API 依赖**：WebGPU/WebAssembly/Worker 等在 Node.js/Electron 环境下的可用性
