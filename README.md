# uTools-Dev Skill

uTools 插件开发的 AI skill —— 让 AI 助手（Claude / OpenAI Codex / OpenCode）快速掌握 uTools 插件开发规范、API 用法和实战经验。

## 内容

```
uTools-Dev/
├── SKILL.md                        # Skill 定义（角色定义 + API 速览 + 关键约束 + 使用方式 + 能力边界）
├── README.md                       # 本文件
├── scripts/
│   └── build-symbol-index.sh       # 生成/校验 Dev-Doc 顶部的符号索引（编辑文档后运行刷新行号）
└── references/
    ├── uTools-Dev-Doc.md           # uTools API 完整参考（顶部含自动生成的符号索引；utools.* / ubrowser.*）
    ├── uTools-Server-API.md        # uTools 服务端 API（用户信息、支付）
    ├── uTools-Plugin-Dev-Record.md # 开发实战记录（基础知识 / 进阶 / 最佳实践）
    └── uTools-FAQ.md               # 常见问题汇总（开发调试 / 数据存储 / 打包发布 / 付费 / 运行时错误）
```

- **SKILL.md** — 定义 skill 的触发条件、角色体系、使用方式、能力边界，提供核心 API 速览、关键约束、激活契约（含"查证完成判定"）、项目模板（Vue/React）、核心规范、API 分类索引、AI 行为准则
- **uTools-Dev-Doc.md** — 完整的 uTools API 文档，涵盖事件、窗口、数据库、ubrowser、AI、FFmpeg 等
- **uTools-Server-API.md** — 服务端 API 文档（获取用户信息、订单查询、支付回调）
- **uTools-Plugin-Dev-Record.md** — 社区开发实战记录
  - 开发基础知识（plugin.json / preload.js / 基础 API）
  - 传统前端开发（纯 HTML/CSS/JS + `utools.db`）
  - 现代前端开发（React + webpack / Vite + Vue）
  - 开发思想与技巧（高内聚低耦合、代码重构）
  - 实战场景案例（剪贴板管理器 / 本地文档搜索）
- **uTools-FAQ.md** — 常见问题汇总
  - 开发与调试（跨域 / 兼容性 / 外部资源 / 白屏排查）
  - 数据存储（db 限制 / 同步问题）
  - 打包与发布（资源清理 / 审核被拒原因）
  - 付费相关（申请条件 / 服务费率 / 结算规则）
  - 运行时错误速查表

## 使用方式

### Claude / OpenCode

将 `SKILL.md` 和 `references/` 目录放入 AI 客户端的 skills 目录：

```bash
# 例如 Claude Desktop / OpenCode 的 skills 目录
~/.claude/skills/uTools-Dev/
```

配置后，当用户提到 uTools 插件开发相关问题时，AI 助手会自动加载此 skill 并查阅参考文档。

### 直接提问示例

| 场景 | 提问示例 |
|------|---------|
| 创建新项目 | "帮我创建一个 uTools 插件项目" |
| 查询 API 用法 | "utools.db.put 怎么用？" |
| 配置问题 | "plugin.json 的正则匹配怎么配？" |
| 代码报错 | "preload.js 报错 require is not defined" |
| 数据存储 | "两次 db 操作有什么限制？" |
| Electron 能力 | "如何创建独立窗口？" |

### 作为开发参考

也可直接阅读 `references/` 下的文档：

- `references/uTools-Dev-Doc.md` — 适合按 API 模块查阅（先查顶部"符号索引"，按行号直达条目；编辑后运行 `bash scripts/build-symbol-index.sh` 刷新行号）
- `references/uTools-Plugin-Dev-Record.md` — 适合项目实战参考
- `references/uTools-FAQ.md` — 适合遇到问题时快速查找

## 能力边界

### 本 Skill 擅长
- uTools 插件开发全流程（环境搭建 → 编码 → 构建 → 打包 → 发布）
- `utools.*` / `ubrowser.*` API 用法与配置
- preload.js 编写、plugin.json 配置
- Electron 底层能力在插件中的接入方式

### 本 Skill 不覆盖
- uTools 主程序本身的 Bug 或功能限制
- 纯前端框架问题（Vue/React 自身的运行时错误）
- 原生 Node.js 模块编译（C++ addon）
- 插件市场审核被拒后的申诉

## 参考资源

- [uTools 开发者文档](https://u.tools/docs/developer/api.html)
- [uTools 官方类型定义](https://github.com/uTools-Labs/utools-api-types)
- [uTools 密码管理器（官方开源示例）](https://github.com/uTools-Labs/utools-upassword)
- [vite-utools-template（gitee: q2316367743 的 Vite + Vue 模板）](https://gitee.com/q2316367743/vite-utools-template)
- [Electron 中文网](https://electronjs.cn)（国内访问）
- [MDN 中文镜像](https://developer.mozilla.org/zh-CN)（国内访问）

## License

MIT
