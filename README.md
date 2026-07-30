# uTools-Dev Skill

uTools 插件开发的 AI skill —— 让 AI 助手（Claude / OpenAI Codex / OpenCode）快速掌握 uTools 插件开发规范、API 用法和实战经验。

## 内容

```
├── SKILL.md                        # Skill 定义（角色定义 + API 速览 + 关键约束 + Vite 配置）
├── references/
│   ├── uTools-Dev-Doc.md           # uTools API 完整参考（utools.* / ubrowser.*）
│   ├── uTools-Server-API.md        # uTools 服务端 API（用户信息、支付）
│   └── uTools-Plugin-Dev-Record.md # 开发实战记录（模板 / 进阶 / 最佳实践）
```

- **SKILL.md** — 定义 skill 的触发条件和角色体系，提供核心 API 速览、关键约束、Vite 项目配置
- **uTools-Dev-Doc.md** — 完整的 uTools API 文档，涵盖事件、窗口、数据库、ubrowser、AI、FFmpeg 等
- **uTools-Server-API.md** — 服务端 API 文档（获取用户信息、订单查询、支付回调）
- **uTools-Plugin-Dev-Record.md** — 社区开发实战记录
  - 开发基础知识（plugin.json / preload.js / 基础 API）
  - 三种模板模式（无 UI / 列表 / 文档）的完整示例代码
  - 传统前端开发（纯 HTML/CSS/JS + `utools.db`）
  - 现代前端开发（React + webpack / Vite + Vue）
  - 开发思想与技巧（高内聚低耦合、代码重构）

## 使用方式

### Claude / OpenCode

将 `SKILL.md` 和 `references/` 目录放入 AI 客户端的 skills 目录：

```bash
# 例如 Claude Desktop / OpenCode 的 skills 目录
~/.claude/skills/uTools-Dev/
```

配置后，当用户提到 uTools 插件开发相关问题时，AI 助手会自动加载此 skill 并查阅参考文档。

### 作为开发参考

也可直接阅读 `references/` 下的文档：

- `references/uTools-Dev-Doc.md` — 适合按 API 模块查阅
- `references/uTools-Plugin-Dev-Record.md` — 适合项目实战参考

## 参考资源

- [uTools 开发者文档](https://u.tools/docs/developer/api.html)
- [uTools 官方类型定义](https://github.com/uTools-Labs/utools-api-types)
- [uTools 密码管理器（官方开源示例）](https://github.com/uTools-Labs/utools-upassword)
- [vite-utools-template（落雨大佬开发的 Vite + Vue 模板）](https://gitee.com/q2316367743/vite-utools-template)

## License

MIT
