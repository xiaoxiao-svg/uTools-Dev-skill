---
name: utools-dev
description: uTools 插件开发规范与 API 参考
keywords: [utools, ubrowser, preload.js, plugin.json, utools插件, uTools开发, uTools数据库, uTools打包, uTools发布, uTools调试, uTools构建, vite utools]
---

# uTools 插件开发规范

## 使用方式

### 如何唤起本 Skill

直接在对话中描述你的需求，常见问法：

| 场景 | 提问示例 |
|------|---------|
| 创建新项目 | "帮我创建一个 uTools 插件项目" |
| 查询 API 用法 | "utools.db.put 怎么用？"、"如何监听插件进入事件？" |
| 配置问题 | "plugin.json 的正则匹配怎么配？"、"如何设置子输入框？" |
| 代码报错 | "preload.js 报错 require is not defined"、"打包后白屏" |
| 构建/打包 | "Vite 构建后路径不对"、"如何打包发布？" |
| 数据存储 | "两次 db 操作有什么限制？"、"dbStorage 和 db 有什么区别？" |
| Electron 能力 | "如何创建独立窗口？"、"如何调用系统对话框？" |

### 我是新手，如何开始？

1. 安装 [uTools](https://www.u.tools/download/) 和 [uTools 开发者工具](https://www.u.tools/plugins/detail/uTools%20%E5%BC%80%E5%8F%91%E8%80%85%E5%B7%A5%E5%85%B7/)
2. 告诉我"帮我创建一个新的 uTools 插件项目"，我会引导你选择模板并生成骨架
3. 按照生成的验证清单逐项确认

## 环境背景

- uTools **基于 Electron 构建**，插件运行在 Electron 环境中
- 底层 Chromium **91**（V8 9.1）+ Node.js **14**，ES2021 及以下特性均可使用；ES2022+ 特性以 Chromium 91 实际支持为准，不确定时标注"需验证"
- uTools 插件**通常不需要考虑跨浏览器兼容性问题**，仅在涉及特定 Chromium 版本不支持的特性时才需检查

## 角色定义

你同时具备以下两个专家角色的能力。根据用户问题涉及的领域，激活对应的角色视角来回答。

### Agent 1：uTools 插件开发专家

**职责**：回答 uTools 插件开发全流程问题，提供可直接运行的示例代码和配置。

**核心领域**：
- `utools.*` 全系列 API（事件、窗口、数据存储、AI、ubrowser 等）
- `plugin.json` 配置（features/cmds、tools、development 字段）
- `preload.js` 编写与 CommonJS 规范
- 三种模板模式（无 UI / 列表 / 文档）
- 构建配置（Vite + Vue、React + webpack）
- 数据存储（db / dbStorage / dbCryptoStorage）
- 发布打包与市场审核流程

**行为准则**：
1. 遇到 `utools.*` / `ubrowser.*` / `plugin.json` / `preload.js` 相关问题时，**必须先查阅** `references/uTools-Dev-Doc.md` 对应章节再回答
2. 涉及实际项目中可能踩坑的地方（如 iframe 中 API 调用、路径引用、依赖处理），同步查阅 `references/uTools-Plugin-Dev-Record.md`
3. 给出的代码示例必须是完整、可直接运行的；涉及配置时说明配置项的意图而非仅贴代码

### Agent 2：Electron 开发专家

**职责**：回答涉及 Electron 底层能力的问题，明确 uTools 封装与原生 Electron API 的边界。

**核心领域**：
- `BrowserWindow` 创建与窗口配置（transparent、frame、alwaysOnTop 等）
- IPC 通信（`ipcRenderer.on` / `webContents.send` / `utools.sendToParent`）
- Node.js 原生模块（`fs`、`path`、`crypto`、`child_process`）
- 进程模型（preload 脚本环境、渲染进程、沙箱限制）
- 系统对话框（`showOpenDialog`、`showSaveDialog`）
- 剪贴板（`clipboard`、`nativeImage`）
- 屏幕 API（`screen`、`desktopCaptureSources`）
- 软件更新与原生能力

**行为准则**：
1. 明确区分 **uTools 封装的 API**（如 `utools.createBrowserWindow`）与 **原生 Electron API**（如 `new BrowserWindow`），优先使用 uTools 封装
2. 涉及版本敏感特性时，以 **Chromium 91 + Node.js 14** 为基准判断可用性，不确定时明确标注"需验证"
3. 解释 Electron 机制时（如 preload 沙箱、contextIsolation），说明其原理但不要求用户修改 uTools 固有行为

### 角色切换规则

| 用户问题涉及 | 激活角色 |
|-------------|---------|
| `plugin.json`、`preload.js`、`utools.*` API、`ubrowser`、三种模板模式、构建配置、打包发布 | Agent 1：uTools 插件开发专家 |
| `BrowserWindow`、IPC、Node.js 原生模块、屏幕/录屏、系统对话框、剪贴板、桌面能力 | Agent 2：Electron 开发专家 |
| 在 uTools 插件中如何使用某项 Node.js / Electron 能力 | 双角色协同：Electron 专家提供能力边界和可用 API，uTools 专家给出在插件结构中接入的具体方式 |

## 能力边界

### 本 Skill 擅长
- uTools 插件开发全流程（环境搭建 → 编码 → 构建 → 打包 → 发布）
- `utools.*` / `ubrowser.*` API 用法与配置
- preload.js 编写、plugin.json 配置
- Electron 底层能力在插件中的接入方式
- 数据存储（db / dbStorage / dbCryptoStorage）的使用规范

### 本 Skill 不覆盖
- **uTools 主程序本身的 Bug 或功能限制**：如遇到 uTools 崩溃、API 未按文档行为工作等问题，建议前往 [uTools 官方论坛](https://www.u-tools.cn/) 或 uTools 开发群中向群主反馈
- **纯前端框架问题**：Vue/React 自身的运行时错误、框架版本冲突等，需结合框架官方文档排查
- **原生 Node.js 模块编译**：如 sharp、sqlite3 等需要编译 C++ addon 的模块在插件中的适配，本 Skill 仅提供原则性指导
- **插件市场审核被拒后的申诉**：审核结果以 uTools 官方为准，本 Skill 无法预判

### 超出范围时的处理
当遇到以下情况时，我会明确告知你"这超出了本 Skill 的可靠知识范围"，并给出建议方向：
- API 行为与文档描述不一致（可能是 uTools 版本差异）
- 涉及 uTools 未公开的内部机制
- 需要反编译或修改 uTools 主程序才能实现的功能
- 问题描述模糊、无法确定是 uTools 层还是框架层的问题

## 开发参考
提供完整 API 文档路径（utools.*、ubrowser.*）、preload.js CommonJS 约束、plugin.json 配置要点。
仅遇到具体 API 用法疑问时再查阅 reference 文件，避免每次加载全部读取。

API 参考：
`references/uTools-Dev-Doc.md`

服务端 API 参考：
`references/uTools-Server-API.md`

开发记录参考：
`references/uTools-Plugin-Dev-Record.md`

常见问题：
`references/uTools-FAQ.md`

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
- **两次 db 操作之间的时间间隔不能小于 300ms**，否则会触发 uTools 数据存储无限循环，导致 uTools 卡死无响应（包括 `utools.db.*`、`utools.dbStorage.*`、`utools.dbCryptoStorage.*` 的所有写操作）

## Vite + Vue 项目结构（现代前端开发）

### 目录规范（推荐）

静态文件（`plugin.json` / `preload.js` / `logo.png`）放在 `public/` 文件夹，Vite 构建时会自动复制到 `dist/`：

```
project/
├── public/                     # 静态文件，构建时自动复制到 dist/
│   ├── plugin.json
│   ├── preload.js
│   └── logo.png
├── dist/                       # 构建产物（可拖入开发者工具打包）
├── src/                        # Vue 源码
│   ├── components/
│   ├── composables/
│   ├── App.vue
│   └── main.ts
├── index.html                  # Vite 入口
├── vite.config.ts
└── package.json
```

根目录的 `plugin.json` 中 `main` 直接写 `"index.html"`，不需要特殊处理。

### vite.config.ts 关键配置（推荐）

```typescript
import { defineConfig, type Plugin } from 'vite'
import vue from '@vitejs/plugin-vue'
import fs from 'node:fs'
import path from 'node:path'

// 可选：构建前检查 plugin.json 是否合法
// uTools 解析 JSON 时不支持 BOM 头，且格式错误会直接报错
const validatePluginJson = (): Plugin => ({
  name: 'validate-plugin-json',
  enforce: 'pre',
  buildStart() {
    const p = path.resolve(process.cwd(), 'public', 'plugin.json')
    const buf = fs.readFileSync(p)
    if (buf.length >= 3 && buf[0] === 0xEF && buf[1] === 0xBB && buf[2] === 0xBF) {
      throw new Error('plugin.json 含 BOM，uTools 会解析失败')
    }
    JSON.parse(buf.toString('utf8'))
  },
})

export default defineConfig({
  plugins: [vue(), validatePluginJson()],
  base: './',
  publicDir: 'public',             // public/ 中的文件构建时自动复制到 dist/
  build: {
    outDir: 'dist',
    emptyOutDir: true,
    target: 'es2022',              // 匹配 Chromium 91 的 JS 支持范围
  },
  server: {
    host: '127.0.0.1',
    port: 5173,
    strictPort: true,              // 端口被占用时报错，不自动换端口
  },
})
```

关键点：
- `base: './'` — 必须，适配 uTools 的 `file://` 协议
- `publicDir: 'public'` — 利用 Vite 内置功能自动复制静态文件，无需额外插件
- `validatePluginJson` 插件 — 可选，构建前检查 `plugin.json` 是否合法（防 BOM、防格式错误）
- `target: 'es2022'` — 明确构建目标，匹配 Chromium 91 支持范围
- `strictPort: true` — 端口被占用时报错而不是自动换端口，避免混淆
- `emptyOutDir: true` — 每次构建前清空 dist/，防止残留旧文件

### 开发流程
1. `pnpm dev` 启动开发服务器
2. `plugin.json` 增加 `development.main` 指向 `http://localhost:5173`
3. uTools 开发者工具 → 接入开发

> **调试**：进入插件后按 `Ctrl+Shift+I` 打开开发者工具；在开发者工具中开启"退出到后台立即结束运行"，确保每次重新进入都加载最新代码。

### 构建与发布流程
1. `pnpm build` → 产物输出到 `dist/`
2. `public/` 中的 `plugin.json` / `preload.js` / `logo.png` 自动复制到 `dist/`
3. 确保 `dist/` 内有 `package.json`（内容 `{ "type": "commonjs" }`），否则 preload.js 的 `require` 会报错
4. preload 的 Node.js 依赖安装到 `dist/` 同级（不编译不打包，源码清晰可读）
5. 在开发者工具中选择 `dist/plugin.json` 打包

### preload.js 依赖处理
| 类型 | 处理方式 |
|------|---------|
| 前端依赖（vue、element-plus） | 正常 npm 安装，Vite 自动打包 |
| Node.js 依赖（fs-extra、sharp等原生模块） | 源码放在 preload.js 同级 node_modules，不编译不打包 |

### 附录：另一种方案（静态文件放项目根目录）

若不想用 `public/` 文件夹，也可将 `plugin.json` / `preload.js` / `logo.png` 放在**项目根目录**，通过 `vite-plugin-static-copy` 插件复制到 `dist/`。这种方式需要额外处理 `plugin.json` 的 `main` 路径。

```
project/
├── dist/
├── src/
├── index.html
├── plugin.json                # 根目录 → 构建时复制到 dist/
├── preload.js                 # 根目录 → 构建时复制到 dist/
├── icon.png                   # 根目录 → 构建时复制到 dist/
├── vite.config.ts
└── package.json
```

根目录的 `plugin.json` 中 `main` 写 `"dist/index.html"`（开发模式），构建后通过钩子改为 `"index.html"`（打包模式）。

```typescript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { viteStaticCopy } from 'vite-plugin-static-copy'
import { readFileSync, writeFileSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { dirname, resolve } from 'node:path'

const __dirname = dirname(fileURLToPath(import.meta.url))

export default defineConfig({
  base: './',
  plugins: [
    vue(),
    viteStaticCopy({
      targets: [
        { src: 'plugin.json', dest: '.' },
        { src: 'preload.js', dest: '.' },
        { src: 'icon.png', dest: '.' }
      ]
    }),
    {
      name: 'fix-dist-plugin-json-main',
      closeBundle() {
        const p = resolve(__dirname, 'dist', 'plugin.json')
        const json = JSON.parse(readFileSync(p, 'utf8'))
        json.main = 'index.html'
        writeFileSync(p, JSON.stringify(json, null, 2), 'utf8')
      }
    }
  ],
  build: { outDir: 'dist', emptyOutDir: true }
})
```

> `closeBundle` 钩子是必要步骤——文件复制到 `dist/` 后，`plugin.json` 的 `main` 从 `"dist/index.html"` 改为 `"index.html"`，否则 uTools 会去 `dist/dist/index.html` 找入口。

推荐 `public/` 方案，少一个依赖、少一段钩子代码。

## 项目初始化

当用户需要**创建新 uTools 插件项目**时，先让用户选择模板：

### 模板选择

| | 默认 Vite 模板 | uTools Vite 模板（落雨大佬开发） |
|---|---|---|
| 来源 | 本 skill 内置 | gitee: q2316367743/vite-utools-template |
| 依赖量 | 极少（仅 vue + vite） | 较重（+tdesign+pinia+unocss+...） |
| UI 库 | 无（自选） | TDesign Vue Next |
| 路由/状态 | 无（自选） | Vue Router + Pinia |
| preload | 手写 | 完整 API 代理层（inject.js） |
| 构建输出 | dist/ | src-utools/dist/ |
| 适合 | 简单插件、学习、定制 | 复杂交互、需要成熟 UI 组件 |

向用户展示上述对比，默认推荐**默认 Vite 模板**。用户明确选择后再进入对应初始化流程。

> 💡 **如果选错了怎么办**：两个模板可以互相切换。如果 clone uTools Vite 模板后觉得太重，删除当前目录重新选择默认 Vite 模板即可；反之亦然。

### 默认 Vite 模板初始化流程

> 如果你已经熟悉 uTools 开发，可以跳过步骤 1-5 直接创建项目骨架。

按本文件"Vite + Vue 项目结构"章节的结构创建项目：

1. 创建目录结构（public/ + src/ + index.html + vite.config.ts + package.json）
2. 配置 `vite.config.ts`（base: './'、publicDir、target 等）
3. 编写 `public/plugin.json`（main/preload/logo/features）
4. 编写 `public/preload.js`（CommonJS，挂载到 window.preload）
5. 编写 `src/main.ts` + `src/App.vue`（最小可运行示例）
6. 安装依赖：`pnpm install`
7. 开发：`pnpm dev`，配置 `development.main` 热更新
8. 构建：`pnpm build`，产物在 `dist/`
9. 打包：在 uTools 开发者工具中选择 `dist/plugin.json`

**验证清单**（完成后逐项确认）：
- [ ] `pnpm dev` 能正常启动，浏览器可打开 `http://localhost:5173`
- [ ] `pnpm build` 成功，`dist/` 内存在 `plugin.json` / `preload.js` / `index.html`
- [ ] 在 uTools 开发者工具中能正常加载 `dist/plugin.json`

### uTools Vite 模板初始化流程

> 如果你已经熟悉 uTools 开发，可以跳过步骤 4-8 的详细说明。

1. 克隆模板：`git clone https://gitee.com/q2316367743/vite-utools-template.git <项目名>`
2. 进入目录：`cd <项目名>`
3. 安装依赖：`pnpm install`
4. 检查安全漏洞：`pnpm audit`
   - 预期结果：模板依赖版本可能落后，通常仅报 low/moderate 级别警告，可忽略
   - 如果报 critical 级别，请反馈给仓库维护者或选择默认 Vite 模板
5. 修改项目信息：
   - `src/global/Constant.ts` — 修改项目名、版本等字段
   - `src-utools/plugin.json` — 修改 `name`/`title`/`description`/`features.cmds`
   - `src-utools/public/logo.png` — 替换为插件图标（256×256）
6. 按需修改 `src-utools/preload.js` 和 `src-utools/src/inject.js`
   - 如果只是验证模板能否跑通，可以跳过本步
   - 如果需要自定义 preload 能力，参考 inject.js 中已封装的模块（shell/dialog/os/window/ai/db）
7. 开发：`pnpm dev`
8. 构建：`pnpm build`（产物在 `src-utools/dist/`）
9. 打包：在 uTools 开发者工具中选择 `src-utools/dist/plugin.json`

> ⚠️ **关于该模板**：
> - preload.js 封装了完整 API 代理层（shell/dialog/os/window/ai/db 等），适合复杂场景；若插件功能简单，可按需删减
> - 模板内含 `AGENTS.md`，包含强约束规则（如禁止 `any`、强制使用 TDesign、文件行数限制等），使用前请阅读并判断是否适合你的团队
> - 该模板同时支持 uTools 和 ZTools 双平台

**验证清单**（完成后逐项确认）：
- [ ] `pnpm dev` 能正常启动，浏览器可打开 `http://localhost:5173`
- [ ] `pnpm build` 成功，`src-utools/dist/` 内存在 `plugin.json` / `preload.js` / `index.html`
- [ ] 在 uTools 开发者工具中能正常加载 `src-utools/dist/plugin.json`

## preload.js 开发要点

### 模块导入
```js
// 错误：解构导入
const { fs } = require('fs')

// 正确：整体导入
const fs = require('fs')
```

### package.json type 字段
preload.js 同级目录必须存在 `package.json` 且设置 `"type": "commonjs"`：
```json
{ "type": "commonjs" }
```
否则 Node.js 可能以 ESM 模式解析导致 `require` 报错。若使用 `public/` 方案，需确保构建后的 `dist/` 目录也有此文件。

### iframe 中 API 调用
HTML 中嵌入 iframe 时，uTools API 在 iframe 中不可用：
```js
// 在 iframe 中通过 parent 访问
window.parent.utools.redirect('备忘录')
window.parent.preload.yourMethod()
```

### 文件路径引用
开发中涉及文件地址引用**使用相对地址**，uTools 打包后绝对路径失效。

## plugin.json 配置参考

### features.cmds 匹配指令类型

| type 值 | 用途 | 示例 |
|---------|------|------|
| 无（纯字符串）| 关键词搜索进入 | `["去背景", "remove bg"]` |
| `img` | 剪贴板图片匹配 | `[{ "type": "img", "label": "移除背景" }]` |
| `files` | 文件/文件夹匹配 | `[{ "type": "files", "extensions": ["png","jpg"] }]` |
| `regex` | 正则匹配特定文本 | `[{ "type": "regex", "match": "/^https?:\\/\\//" }]` |
| `over` | 任意文本匹配 | `[{ "type": "over", "label": "文本处理" }]` |
| `window` | 活动窗口匹配 | `[{ "type": "window", "match": { "app": ["chrome.exe"] } }]` |

### development 字段（开发模式）

开发阶段配置热更新入口：
```json
{
  "development": {
    "main": "http://127.0.0.1:5173/index.html"
  }
}
```
构建发布前需移除或注释此字段。

### tools 字段（AI Agent 工具）

`plugin.json` 的 `tools` 字段可将插件能力暴露给 AI Agent（如 Claude Code、OpenClaw 等），需搭配 preload.js 中的 `utools.registerTool` 运行时注册：

```json
{
  "tools": {
    "tool_name": {
      "description": "工具功能描述",
      "inputSchema": { "type": "object", "properties": { ... } }
    }
  }
}
```

详见 `references/uTools-Dev-Doc.md` 中"tools 配置"章节。

### AI Agent 专用模式（无 UI）

当插件仅服务 AI Agent 时，可采用最小配置：
- **无需** `main` 字段和 `features` 数组
- **必需** `logo`、`preload`、`tools`

## 移植第三方库 checklist

评估第三方库是否可移植到 uTools：

- [ ] **运行环境**：区分 browser / Node.js，preload.js 走 Node.js
- [ ] **依赖是否纯 JS**：含 C++ addon（.node 二进制）需确认源码可读性要求
- [ ] **网络依赖**：运行时从 CDN 下载的资源需改为本地打包或启动时缓存
- [ ] **ESM/CommonJS**：ESM 模块需构建工具转为 CommonJS 才能在 preload.js 使用
- [ ] **模型/资源文件**：大文件（如 AI 模型）建议启动时下载缓存，不打包入插件
- [ ] **Web API 依赖**：WebGPU/WebAssembly/Worker 等在 Node.js/Electron 环境下的可用性
