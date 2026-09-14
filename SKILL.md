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
- 底层 Chromium **108**+ Node.js **16**，ES2021 及以下特性均可使用（需以实际版本为准，官方日志 v4 之后不再披露内核版本）；ES2022+ 特性以 Chromium 108 实际支持为准，不确定时标注"需验证"
- uTools 插件**通常不需要考虑跨浏览器兼容性问题**，仅在涉及特定 Chromium 版本不支持的特性时才需检查

## 角色定义

你同时具备以下两个专家角色的能力。根据用户问题涉及的领域，激活对应的角色视角来回答。

### Agent 1：uTools 插件开发专家

**职责**：回答 uTools 插件开发全流程问题，提供可直接运行的示例代码和配置。

**核心领域**：
- `utools.*` 全系列 API（事件、窗口、数据存储、AI、ubrowser 等）
- `plugin.json` 配置（features/cmds、tools、development 字段）
- `preload.js` 编写与 CommonJS 规范
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
2. 涉及版本敏感特性时，以 **Chromium 108 + Node.js 16** 为基准判断可用性，不确定时明确标注"需验证"
3. 解释 Electron 机制时（如 preload 沙箱、contextIsolation），说明其原理但不要求用户修改 uTools 固有行为

### 角色切换规则

| 用户问题涉及 | 激活角色 |
|-------------|---------|
| `plugin.json`、`preload.js`、`utools.*` API、`ubrowser`、构建配置、打包发布 | Agent 1：uTools 插件开发专家 |
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
- 本地参考文档未收录目标 API / 特性：先按"查证完成判定"的否定协议检索确证，再指引查阅 uTools 官方开发者文档核实最新版本支持情况
- 涉及 uTools 未公开的内部机制
- 需要反编译或修改 uTools 主程序才能实现的功能
- 问题描述模糊、无法确定是 uTools 层还是框架层的问题

## 开发参考
提供完整 API 文档路径（utools.*、ubrowser.*）、preload.js CommonJS 约束、plugin.json 配置要点。
仅遇到具体 API 用法疑问时再查阅 reference 文件，避免每次加载全部读取。

API 参考：
`references/uTools-Dev-Doc.md`
顶部有自动生成的"**符号索引**"——查 API **先查索引表按行号直达条目**；编辑该文档后运行 `bash scripts/build-symbol-index.sh` 刷新行号（`--check` 校验是否最新）

服务端 API 参考：
`references/uTools-Server-API.md`

开发记录参考：
`references/uTools-Plugin-Dev-Record.md`

常见问题：
`references/uTools-FAQ.md`

遇到 `utools.*` / `ubrowser.*` / `plugin.json` / `preload.js` 相关问题时，**必须先查阅该文档对应章节**再回答（API 使用、uTools 开发等官方规范问题查看 API 参考，实际可能遇到的问题查看开发记录参考）。

## 查证完成判定

宣布任何基于参考文档的结论前，逐项自检；未通过就继续查证，或降低结论强度：

1. **检索有效**：区分"命令失败"与"未命中"。搜索命令报错、非零退出码、或空输出但连 `utools` 这类必命中关键词也搜不到时，说明是命令或路径错了——先修检索，不得据此下任何结论
2. **边界完整**：优先用 Dev-Doc 顶部"符号索引"按行号直达条目；定位到章节后从节首标题读到下一同级标题才算读完（读单个 API 须读到末尾的参数说明和示例），**禁止只读半节就下结论**
3. **否定从严**：宣布"无此 API / 文档未提及 X"前，必须已 (a) 用至少 2 组不同关键词检索过（符号名 + 功能同义词），(b) 浏览过所属大类章节整节，(c) 在回答中列出已检关键词与范围。说不出检索记录就只能表述为"我在 X 范围内未找到"；确认本地未收录时统一措辞为"**本地参考文档未收录**"，并指引查阅 uTools 官方文档（见"超出范围时的处理"）

正向结论不要求附检索记录，但第 1、2 条仍须满足。

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
- **两次 db 操作之间的时间间隔不能小于 300ms**，否则会触发 uTools 数据存储无限循环，导致 uTools 卡死无响应（包括 `utools.db.*`、`utools.dbStorage.*`、`utools.dbCryptoStorage.*` 的所有写操作；约束出处与高频写入场景见 `references/uTools-Plugin-Dev-Record.md` 场景 1）
- **插件窗口高度保持默认**：不要设置 `pluginSetting.height` 固定高度——不同屏幕比例/系统缩放下显示异常（内容裁切或留白过大）。确需调整时，进入插件后用 `utools.setExpendHeight` 按内容/屏幕动态设置（详见 `references/uTools-Plugin-Dev-Record.md` 场景 3）

## 激活契约

当本 Skill 激活时，必须遵守以下全局规则，具体约束详见各章节：

1. **查文档优先**：`utools.*` / `ubrowser.*` / `plugin.json` / `preload.js` 相关疑问，先读 `references/uTools-Dev-Doc.md` 对应章节再回答，不凭记忆编造 API
2. **区分 dev/build 模式**：开发期用 `public/` + `development.main` 接入热更新；发布产物 `dist/` 不得包含 `development` 字段，由 vite 插件构建后自动清理
3. **preload 透明**：preload 遵循 CommonJS，源码必须清晰可读，不压缩、不混淆、不打包
4. **DB 合规**：`utools.db` 只存用户主动创建的数据；缓存、日志、临时状态禁止写入（可能导致审核拒绝或下架），改用 `utools.dbStorage` 或内存变量
5. **平台兼容**：文件路径用 `path.join()` 或相对地址拼接，不硬编码路径分隔符
6. **查证完整**：基于文档下结论前按上方"查证完成判定"自检；否定性结论（无此 API / 未收录）必须附检索记录

## 项目模板

uTools 插件本质是编译为纯 HTML/CSS/JS 的 Web 应用，任何前端框架均可。官方提供 **Vue 3 + Vite** 与 **React + Vite** 两套模板，可在 uTools 开发者工具中通过"新建 Vue+Vite 工程" / "新建 React+Vite 工程"按钮一键创建。

### 模板选择

| 模板 | 来源 | 依赖量 | 适合 |
|------|------|--------|------|
| Vue 3 + Vite | uTools 官方（开发者工具一键创建） | 少（vue + vite） | 大多数插件（默认推荐） |
| React + Vite | uTools 官方（开发者工具一键创建） | 少（react + vite） | React 技术栈团队 |
| uTools Vite 模板 | gitee: q2316367743/vite-utools-template | 较重（+tdesign +pinia +router +unocss） | 复杂交互、需要成熟 UI 组件 |

默认推荐官方 **Vue 3 + Vite** 模板。

### Vue 3 + Vite 模板（官方）

#### 目录结构

静态文件（`plugin.json` / `preload.js` / `logo.png`）放在 `public/`，Vite 构建时自动复制到 `dist/`：

```
project/
├── public/                     # 静态文件，构建时自动复制到 dist/
│   ├── plugin.json
│   ├── preload.js
│   └── logo.png                # 256×256
├── dist/                       # 构建产物（可拖入开发者工具打包）
├── src/                        # Vue 源码
│   ├── components/
│   ├── App.vue
│   └── main.ts
├── index.html                  # Vite 入口
├── vite.config.ts
└── package.json
```

`public/plugin.json` 中 `main` 直接写 `"index.html"`，不需要特殊处理。

#### vite.config.ts 关键配置

```typescript
import { defineConfig, type Plugin } from 'vite'
import vue from '@vitejs/plugin-vue'
import fs from 'node:fs'
import path from 'node:path'

// 必须：构建后自动移除 plugin.json 的 development 字段，保证发布版干净
const stripDevelopmentField = (): Plugin => ({
  name: 'strip-development-field',
  closeBundle() {
    const p = path.resolve(process.cwd(), 'dist', 'plugin.json')
    if (!fs.existsSync(p)) return
    const json = JSON.parse(fs.readFileSync(p, 'utf8'))
    delete json.development
    fs.writeFileSync(p, JSON.stringify(json, null, 2) + '\n', 'utf8')
  },
})

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
  plugins: [vue(), stripDevelopmentField(), validatePluginJson()],
  base: './',                    // 必须，适配 uTools 的 file:// 协议
  publicDir: 'public',           // public/ 中的文件构建时自动复制到 dist/
  build: {
    outDir: 'dist',
    emptyOutDir: true,           // 每次构建前清空 dist/，防止残留旧文件
    target: 'es2021',            // 匹配 Chromium 91 的完整 JS 支持范围（ES2022 仅部分支持）
  },
  server: {
    host: '127.0.0.1',
    port: 5173,
    strictPort: true,            // 端口被占用时报错，不自动换端口
  },
})
```

#### package.json 关键依赖

```json
{
  "type": "module",
  "dependencies": { "vue": "^3.5.13" },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.2.1",
    "vite": "^6.0.11"
  }
}
```

#### 入口组件（功能路由）

入口组件必须在 `onMounted`（Vue）/ `useEffect`（React）中注册 `utools.onPluginEnter`，接收 `action.code` 做功能路由：

```typescript
// src/main.ts
import { createApp } from 'vue'
import App from './App.vue'
createApp(App).mount('#app')
```

```vue
<!-- src/App.vue -->
<script setup lang="ts">
import { onMounted } from 'vue'

onMounted(() => {
  utools.onPluginEnter(({ code, payload }) => {
    // 按 action.code 分发到对应功能
  })
})
</script>
```

#### 初始化流程

1. 在 uTools 开发者工具中"新建 Vue+Vite 工程"一键创建，或按上述目录结构手动搭建
2. 编写 `public/plugin.json`（main/preload/logo/features）与 `public/preload.js`（CommonJS，挂载到 `window.preload`）
3. 编写 `src/main.ts` + `src/App.vue`（最小可运行示例）
4. 安装依赖：`pnpm install`
5. 开发：`pnpm dev`，`plugin.json` 增加 `development.main` 指向 `http://127.0.0.1:5173/index.html`，在开发者工具中"接入开发"
6. 构建：`pnpm build`，产物在 `dist/`
7. 打包：在 uTools 开发者工具中选择 `dist/plugin.json`

> **调试**：进入插件后按 `Ctrl+Shift+I` 打开开发者工具；在开发者工具中开启"退出到后台立即结束运行"，确保每次重新进入都加载最新代码。

**验证清单**（完成后逐项确认）：
- [ ] `pnpm dev` 能正常启动，浏览器可打开 `http://127.0.0.1:5173`
- [ ] `pnpm build` 成功，`dist/` 内存在 `plugin.json` / `preload.js` / `index.html`，且 `dist/plugin.json` 中 `development` 字段已被自动移除
- [ ] 在 uTools 开发者工具中能正常加载 `dist/plugin.json`

### React + Vite 模板（官方）

#### 目录结构

与 Vue 模板一致，仅前端源码与构建插件不同：

```
project/
├── public/
│   ├── plugin.json
│   ├── preload.js
│   └── logo.png
├── dist/                       # 构建产物
├── src/                        # React 源码
│   ├── App.jsx
│   └── main.jsx
├── index.html                  # script 指向 /src/main.jsx
├── vite.config.js
└── package.json
```

#### vite.config.js 关键配置

与 Vue 模板相同的 `stripDevelopmentField` / `validatePluginJson` 插件，仅构建插件换为 `@vitejs/plugin-react`：

```javascript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
// 插件定义与 Vue 模板相同，从上方"Vue 3 + Vite 模板"章节复制
// stripDevelopmentField / validatePluginJson 两个函数定义后使用

export default defineConfig({
  plugins: [react(), stripDevelopmentField(), validatePluginJson()],
  base: './',
  publicDir: 'public',
  build: {
    outDir: 'dist',
    emptyOutDir: true,
    target: 'es2021',            // 匹配 Chromium 91
  },
  server: {
    host: '127.0.0.1',
    port: 5173,
    strictPort: true,
  },
})
```

#### package.json 关键依赖

```json
{
  "type": "module",
  "dependencies": { "react": "^18.3.1", "react-dom": "^18.3.1" },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.3.4",
    "vite": "^5.4.11"
  }
}
```

> **版本说明**：React 以 uTools 官方模板当前版本为准。手写骨架建议 React 18 + Vite 5（React 18 与 Vite 5 在 Chromium 91 环境兼容性更稳妥）；React 19 / Vite 6 在 Chromium 91 上的兼容性需验证。

#### 入口组件

```jsx
// src/main.jsx
import React from 'react'
import { createRoot } from 'react-dom/client'
import App from './App.jsx'
createRoot(document.getElementById('app')).render(<App />)
```

```jsx
// src/App.jsx
import { useEffect } from 'react'

export default function App() {
  useEffect(() => {
    utools.onPluginEnter(({ code, payload }) => {
      // 按 action.code 分发到对应功能
    })
  }, [])
  return <div>Hello uTools</div>
}
```

初始化流程与验证清单同 Vue 模板（仅 `index.html` 的 script 指向 `/src/main.jsx`）。

### uTools Vite 模板（gitee，进阶）

> 适合复杂交互、需要成熟 UI 组件的场景；简单插件优先选官方模板。

1. 克隆模板：`git clone https://gitee.com/q2316367743/vite-utools-template.git <项目名>`
2. 进入目录：`cd <项目名>`
3. 安装依赖：`pnpm install`
4. 检查安全漏洞：`pnpm audit`
   - 预期结果：模板依赖版本可能落后，通常仅报 low/moderate 级别警告，可忽略
   - 如果报 critical 级别，请反馈给仓库维护者或选择官方模板
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
- [ ] `pnpm dev` 能正常启动，浏览器可打开 `http://127.0.0.1:5173`
- [ ] `pnpm build` 成功，`src-utools/dist/` 内存在 `plugin.json` / `preload.js` / `index.html`
- [ ] 在 uTools 开发者工具中能正常加载 `src-utools/dist/plugin.json`

## 核心规范

### plugin.json 配置参考

#### 关键字段

| 字段 | 说明 |
|------|------|
| `main` | 入口页面，相对 `plugin.json` 的路径，必须 `.html`（如 `"index.html"`） |
| `preload` | preload 脚本路径，可选但几乎所有实用插件都需要 |
| `logo` | 插件图标（256×256 PNG） |
| `pluginSetting` | 窗口行为配置（`single` 单实例；**不要设置 `height`**，保持默认高度，见"关键约束"） |
| `features` | 功能定义，`cmds` 定义搜索指令 |
| `development` | 仅开发期字段，构建发布前必须移除（由 vite 插件自动处理，见 dev/build 双模式） |
| `tools` | 将插件能力暴露给 AI Agent（需搭配 `utools.registerTool`） |

#### features.cmds 匹配指令类型

| type 值 | 用途 | 示例 |
|---------|------|------|
| 无（纯字符串）| 关键词搜索进入 | `["去背景", "remove bg"]` |
| `img` | 剪贴板图片匹配 | `[{ "type": "img", "label": "移除背景" }]` |
| `files` | 文件/文件夹匹配 | `[{ "type": "files", "extensions": ["png","jpg"] }]` |
| `regex` | 正则匹配特定文本 | `[{ "type": "regex", "match": "/^https?:\\/\\//" }]` |
| `over` | 任意文本匹配 | `[{ "type": "over", "label": "文本处理" }]` |
| `window` | 活动窗口匹配 | `[{ "type": "window", "match": { "app": ["chrome.exe"] } }]` |

#### development 字段（开发模式）

开发阶段配置热更新入口：

```json
{
  "development": {
    "main": "http://127.0.0.1:5173/index.html"
  }
}
```

#### tools 字段（AI Agent 工具）

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

#### AI Agent 专用模式（无 UI）

当插件仅服务 AI Agent 时，可采用最小配置：
- **无需** `main` 字段和 `features` 数组
- **必需** `logo`、`preload`、`tools`

### preload.js 规范

#### 铁律

1. **CommonJS 规范**：使用 `require` / `module.exports`，**不可混淆、压缩、打包**
2. **源码透明**：引入的第三方 npm 模块源码必须清晰可读，连同源码一起提交
3. **最小权限**：只暴露必要的函数，不要把整个 `fs` 模块暴露给渲染进程
4. **能力暴露**：通过 `window.preload = {...}` 注入渲染进程

#### 模块导入

```js
// 错误：解构导入
const { fs } = require('fs')

// 正确：整体导入
const fs = require('fs')
```

#### package.json type 字段

preload.js 同级目录必须存在 `package.json` 且设置 `"type": "commonjs"`：

```json
{ "type": "commonjs" }
```

否则 Node.js 可能以 ESM 模式解析导致 `require` 报错。若使用 `public/` 方案，需确保构建后的 `dist/` 目录也有此文件。

#### 依赖处理

| 类型 | 处理方式 |
|------|---------|
| 前端依赖（vue、element-plus） | 正常 npm 安装，Vite 自动打包 |
| Node.js 依赖（fs-extra 等纯 JS 模块） | 源码放在 preload.js 同级 node_modules，不编译不打包 |

#### iframe 中 API 调用

HTML 中嵌入 iframe 时，uTools API 在 iframe 中不可用：

```js
// 在 iframe 中通过 parent 访问
window.parent.utools.redirect('备忘录')
window.parent.preload.yourMethod()
```

#### 文件路径引用

开发中涉及文件地址引用**使用相对地址**，uTools 打包后绝对路径失效；preload 内拼接路径用 `path.join()`，不硬编码分隔符。

### dev/build 双模式

| 模式 | plugin.json | 接入目录 | 依赖 |
|------|-------------|----------|------|
| dev（开发） | 保留 `development.main` 指向 dev server | `public/` | 开发服务器运行中 |
| build（发布） | 无 `development` 字段 | `dist/` | 无 |

开发期流程：`pnpm dev` 启动开发服务器 → `public/plugin.json` 配置 `development.main` 指向 `http://127.0.0.1:5173/index.html` → 开发者工具"接入开发"，代码改动热更新。

发布期流程：`pnpm build` → `dist/` 内为发布产物（`public/` 镜像 + 编译后的 `assets/`），由 vite 插件自动移除 `development` 字段 → 开发者工具选择 `dist/plugin.json` 打包。

创建项目时**必须**配置 `stripDevelopmentField` 插件，确保 `dist/plugin.json` 自动干净。

**打包前检查**：`dist/` 必须存在 `plugin.json`、`logo.png`、`preload.js`（及 `package.json`，内容 `{ "type": "commonjs" }`——将该文件放入 `public/` 即可随构建自动复制）。如果用户报告"插件打不开"，先检查这几个文件是否缺失。

### 数据存储

#### 三种存储的分工

| 存储 | 特点 | 适合 |
|------|------|------|
| `utools.db` | 同步数据库，**跨设备同步** | 用户主动创建的数据（笔记、收藏、文档、配置） |
| `utools.dbStorage` | 本地 KV 存储，不同步 | 缓存、临时状态、非关键数据 |
| `utools.dbCryptoStorage` | 加密 KV 存储，不同步 | 敏感配置（密钥、token） |

#### DB 合规红线

`utools.db`（同步数据库）**只允许存**：
- 用户主动创建的内容（笔记、收藏、文档）
- 用户主动修改的配置
- 需要跨设备保持一致的数据

**禁止存入 `utools.db`**：
- 缓存、运行状态、临时配置
- 日志、统计计数、访问记录
- 缩略图、搜索索引等可重新生成的数据
- 剪贴板数据、系统监听数据

违反此红线可能导致**审核拒绝或下架**。临时数据用 `utools.dbStorage`（不同步）或内存变量。

#### db 操作约束

- **写操作间隔 ≥ 300ms**：两次写操作之间的间隔不能小于 300ms，否则会触发数据存储无限循环导致 uTools 卡死（详见"关键约束"；出处与高频写入场景见 `references/uTools-Plugin-Dev-Record.md` 场景 1）
- **文档组织**：用 `_id` 前缀组织分类（如 `memo/20240819-001`），便于按前缀批量查询；一条记录一个文档，避免多设备冲突
- **更新文档需带版本字段**，否则更新失败（具体字段名查 `references/uTools-Dev-Doc.md` 3.8 数据存储章节）

## API 分类索引

以下只列大类，**具体 API 签名和用法必须查 `references/uTools-Dev-Doc.md` 对应章节**：

| 分类 | 说明 | 查阅章节 |
|------|------|----------|
| 事件 | 插件生命周期回调（进入/退出/分离/同步） | 3.1 事件 |
| 窗口 | 主窗口控制、子输入框、独立窗口创建 | 3.2 窗口 |
| 复制 | 文本/图片/文件复制到剪贴板 | 3.3 复制 |
| 输入 | 向外部应用粘贴文本/图片/文件 | 3.4 输入 |
| 系统 | 通知、文件操作、路径获取、系统信息 | 3.5 系统 |
| 屏幕 | 取色、截图、显示器信息 | 3.6 屏幕 |
| 用户 | 获取用户信息、临时 token | 3.7 用户 |
| 数据存储 | `db` / `dbStorage` / `dbCryptoStorage` CRUD | 3.8 数据存储 |
| 动态指令 | 运行时增删 feature | 3.9 动态指令 |
| 模拟按键 | 键盘/鼠标模拟 | 3.10 模拟按键 |
| 用户付费 | 付费/支付/订单 | 3.11 用户付费 |
| ubrowser | 可编程自动化浏览器（链式 API） | 3.12 ubrowser |
| 工具注册 | 为 AI Agent 提供能力（`registerTool`） | 3.13 工具注册 |
| AI | 调用 uTools 内置 AI 能力 | 3.14 AI |
| Sharp | 图像处理 | 3.15 Sharp 集成 |
| FFmpeg | 音视频处理 | 3.16 FFmpeg 集成 |

## AI 行为准则

当本 Skill 激活并编写 uTools 插件代码时，必须遵守：

### 必须做

1. 创建项目时配置 `stripDevelopmentField` 插件与 `base: './'`，确保构建产物干净
2. preload 保持源码可读，同级目录放 `{"type": "commonjs"}` 的 `package.json`
3. 入口组件注册 `utools.onPluginEnter`，接收 `action.code` 做功能路由
4. 用 `path.join()` 或相对地址处理路径，不硬编码分隔符
5. db 文档用前缀 `_id` 组织（如 `memo/20240819-001`），更新时带版本字段
6. 需要具体 API 时先查 `references/uTools-Dev-Doc.md` 顶部的符号索引、再精读对应章节，不凭记忆猜

### 禁止做

1. 禁止把缓存/日志/临时数据写入 `utools.db`（可能导致审核拒绝或下架）
2. 禁止在 preload 中使用 ES module 语法（`import` / `export`）
3. 禁止压缩/混淆 preload 代码
4. 禁止发布版 `plugin.json` 保留 `development` 字段
5. 禁止在发布版中加载外部网络资源（`http://` / `https://`），开发期可以
6. 禁止把整个 `fs` 模块暴露给渲染进程（最小权限原则）
7. 禁止不查文档直接编写 uTools API 调用
8. 禁止设置 `pluginSetting.height` 固定窗口高度（不同屏幕比例/缩放下显示异常，保持默认；确需调整时用 `utools.setExpendHeight` 动态设置）
9. 禁止未经"查证完成判定"自检就宣布否定性结论（"没有此 API"、"文档不支持此功能"）；确认本地未收录时，表述为"本地参考文档未收录"

## 移植第三方库 checklist

评估第三方库是否可移植到 uTools：

- [ ] **运行环境**：区分 browser / Node.js，preload.js 走 Node.js
- [ ] **依赖是否纯 JS**：含 C++ addon（.node 二进制）需确认源码可读性要求
- [ ] **网络依赖**：运行时从 CDN 下载的资源需改为本地打包或启动时缓存
- [ ] **ESM/CommonJS**：ESM 模块需构建工具转为 CommonJS 才能在 preload.js 使用
- [ ] **模型/资源文件**：大文件（如 AI 模型）建议启动时下载缓存，不打包入插件
- [ ] **Web API 依赖**：WebGPU/WebAssembly/Worker 等在 Node.js/Electron 环境下的可用性
