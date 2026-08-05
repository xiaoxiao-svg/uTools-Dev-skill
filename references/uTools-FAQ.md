# uTools 插件开发常见问题

## 开发与调试

### 插件可以跨域请求吗
uTools 的插件通常不受跨域的影响，可以访问任意跨域或者非跨域的资源（开发阶段；发布后不允许直接请求网络资源，见下文）。

### 代码兼容性有什么要求
uTools 的实现基于 Chromium 91 和 Node.js 14，ES2021 及以下的语法都可以直接使用；较新的语法建议在目标环境实测。

### 可以加载外部网络资源吗
uTools 基于对用户安全性的考虑，**发布后**不允许直接请求网络资源（包括 css、js、图片等），也不允许动态加载和运行外部 js 文件。

但开发阶段允许访问 `http://` 跟 `https://` 的资源，并支持各类开发工具的热更新（HMR）。**发布前必须将这些资源替换成本地资源。**

### 插件进入后白屏
**常见原因**：
1. preload.js 报错 → 按 `Ctrl+Shift+I` 打开开发者工具查看控制台
2. plugin.json 的 main 路径错误 → 确认相对路径与构建产物一致
3. 使用了 Chromium 91 不支持的较新语法（ES2022+ 中未落地部分）→ 降低构建 target 至 `es2021`

### preload.js 修改后不生效
preload.js 不支持热更新。在开发者工具设置中开启 **"退出到后台立即结束运行"**，每次重新进入插件即可加载最新代码。

### 如何调试 preload.js
preload.js 运行在独立环境，无法直接断点调试。可用 `console.log` 输出，在开发者工具 Console 中查看。

### 发布时需要清理哪些文件
为了防止不必要的漏洞问题，发布代码时请检查并移除以下文件或文件夹：
- `.git/`
- `.gitignore`
- `.gitmodules`
- `.github/`
- `.vscode/`
- `*.js.map`
- `*.css.map`

### 插件支持 SPA 吗
uTools 更支持插件以单一入口的形式启动，不推荐动态加载 HTML 或 JS 文件，因此插件页面使用 SPA 模式打包更加合理。

## 数据存储

### db 操作报"文档内容超过限制"
单文档不超过 1M，附件不超过 10M。大文件请存储到本地文件系统（通过 `fs` 模块）。

### 数据没有同步到其他设备
排查步骤：
1. 用户是否开启数据同步（uTools 设置中）
2. 是否登录同一账号
3. 调用 `utools.db.replicateStateFromCloud()` 查看同步状态（`null` 表示未开启数据同步，`0` 表示已完成同步，`1` 表示同步中）

### dbStorage 和 db 有什么区别
- `utools.db`：文档型数据库，支持复杂查询、批量操作、附件存储
- `utools.dbStorage`：键值对存储，API 类似 LocalStorage，适合简单配置
- `utools.dbCryptoStorage`：加密键值对存储，适合敏感数据

### 两次 db 操作有什么限制
连续两次 db 写操作（put / remove / bulkDocs / postAttachment / dbStorage.setItem / dbStorage.removeItem / dbCryptoStorage.setItem / dbCryptoStorage.removeItem 等）间隔不能小于 300ms，否则会触发 uTools 数据存储无限循环，导致主进程卡死。读操作（get / allDocs / getItem 等）不受此限制。

详见 `SKILL.md` 关键约束和 `references/uTools-Dev-Doc.md` 数据存储章节。

## 打包与发布

### 打包时提示"preload.js 不可读"
preload.js 及其依赖的模块源码必须清晰可读，不能混淆/压缩。检查：
- preload.js 是否经过 webpack/rollup 打包
- node_modules 中的依赖是否被压缩

### 审核被拒常见原因
1. 插件功能过于简单（可用脚本替代）
2. 权限申请未说明理由
3. 未提供用户手册或使用说明
4. 图标尺寸不是 256×256
5. 功能描述与实际不符

## 付费相关

### 申请付费功能的条件
插件已经通过审核，上架到插件市场，并累计获得 1000 个有效下载（以官方最新政策为准）。

### 如何申请付费功能
1. 企业在「uTools 开发者工具」中提交企业开发者认证，并发送邮件到 service@u.tools 申请开通
2. 个人开发者将以下信息发邮件到 service@u.tools 申请开通

**邮件需包含信息**：
- 邮件标题：申请 uTools 插件应用付费权限
- 开发者姓名
- 身份证正反面照片
- 手机号码
- 插件应用名称以及插件应用 ID
- 描述插件付费的功能
- 结算银行卡信息（开户行，银行卡号）

### 服务费率是多少
uTools 将收取收款金额的 30%（**推广期 15%**，以官方最新公告为准，当前内容来源于官方文档）作为平台服务费。

### 结算规则
1. 待结算的金额需至少达到 100 元
2. 插件应用获取的收益，将在扣除服务费后，于每月 10 号统一支付上一月的收益到你的结算银行卡中

## 运行时错误速查

| 错误信息 | 原因 | 解决方案 |
|---------|------|---------|
| `require is not defined` | preload.js 被当作 ESM 解析 | 确认同级有 `package.json` 且 `"type": "commonjs"` |
| `utools is not defined` | 在非 uTools 环境运行代码 | 确保在 uTools 插件环境中执行 |
| `Cannot find module 'xxx'` | 依赖未安装或路径错误 | 在 preload.js 同级目录执行 `npm install` |
| `plugin.json parse error` | JSON 格式错误或含 BOM | 检查 JSON 语法，确保无 BOM 头 |
| 构建后页面空白 | base 路径未配置 | vite.config.ts 中设置 `base: './'` |
| API 在 iframe 中不可用 | 沙箱隔离 | 通过 `window.parent.utools.*` 访问 |
