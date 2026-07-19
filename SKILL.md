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
