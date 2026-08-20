# uTools 开发者文档

> **国内访问提示**：以下文档中引用的部分外部链接（electronjs.org、developer.mozilla.org、github.com 等）可能需要代理访问。国内替代方案：
> - Electron 文档 → [Electron 中文网](https://electronjs.cn)
> - MDN Web Docs → [MDN 中文镜像](https://developer.mozilla.org/zh-CN)
> - npm → [淘宝镜像](https://npmmirror.com)
> - GitHub → [Gitee](https://gitee.com) 或 [ghproxy](https://ghproxy.com)

## 一、开发流程

### 1.1 快速开始

hey，开发者，终于和你见面了。

从这里开始，将会慢慢的给你介绍如何开发一个 uTools 插件应用，帮助你一步步的完成开发、构建和发布。

#### 插件应用是什么

Node.js 本地原生能力 + Web 前端网页。（本地软件能做到的，理论上它也能做到）

#### 环境要求

在开始开发你的第一个插件应用之前，请保证你已经做好以下准备：

- uTools ([下载地址](https://www.u.tools/download/))
- uTools 开发者工具 ([下载地址](https://www.u.tools/plugins/detail/uTools%20%E5%BC%80%E5%8F%91%E8%80%85%E5%B7%A5%E5%85%B7/))
- 一个好用的代码编辑器(推荐 [VSCode](https://code.visualstudio.com/) 或者 [WebStorm](https://www.jetbrains.com/zh-cn/webstorm/))
- 熟悉 [JavaScript](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript)，基础开发语言
- 熟悉 HTML 和 CSS，掌握基础的界面构建能力
- 了解 [Node.js](https://nodejs.org/zh-cn/)，接入强大的本地原生能力

#### 进阶

可借助 [Vue](https://cn.vuejs.org/) 或者 [React](https://react.docschina.org/) 等主流的 Web 前端开发框架，增强你的应用界面

---

### 1.2 第一个插件应用

现在，开始创建你的第一个插件应用

#### 打开 uTools 开发者工具

开发者工具主界面（截图略，以开发者工具实际界面为准）

#### 新建项目

点击开发者工具左下侧 `新建项目` 按钮，即可弹出新建项目相关的配置界面。

根据表单的字段要求，分别填写对应内容。
勾选"同意 uTools 开发者协议"，点击右下角的确定，完成创建。

- **插件应用名称**: 为了保证插件能够被 [Web 端的插件应用市场](https://www.u-tools.cn/plugins/) 正确收录，请尽量：**不使用特殊的符号，比如操作系统不支持的文件名符号以及 emoji 等**
- **插件应用描述**：可以帮助其他用户快速的了解应用包含的功能，尽量简洁且清晰
- **运行平台**：支持的操作系统平台。(uTools 是跨平台的)
- **开发者名称**：插件应用市场会显示该应用开发者名称
- **插件应用所属团队**：创建属于团队的私有插件应用

> **TIP**：如需创建团队，请前往 [团队版](https://www.u-tools.cn/team/)

#### 创建工程文件夹

- 通过 `uTools 开发者工具` "新建 React+Vite 工程" / "新建 Vue+Vite 工程" 按钮，根据步骤自动创建。
- 或手动创建工程文件夹

> **TIP**：文件夹的名字可以是任意的，但是我们尽量保证跟插件应用有一定关联性以及尽量使用英文。比如你的第一个插件应用名字可能是"第一个插件"，文件夹名字可以是"my-first-plugin"。

#### 工程文件夹下的文件

plugin.json 示例：

```json
{
  "logo": "logo.png",
  "main": "index.html",
  "features": [
    {
      "code": "test",
      "cmds": ["第一个插件"],
      "explain": "第一个插件"
    }
  ]
}
```

#### 开始编写插件应用

index.html 示例：

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>我的第一个插件应用</title>
</head>
<body>
  <h1>Hello World</h1>
</body>
</html>
```

#### 接入开发

选择 plugin.json 配置文件，点击接入开发，工程文件夹将被识别为开发中的插件应用接入 uTools。

---

### 1.3 调试插件应用

#### 每次进入插件应用加载最新代码

在项目的应用开发界面，点击右上角设置图标弹出的菜单中选择开启 **退出到后台立即结束运行**

#### 使用开发者调试工具

进入开发中的插件应用后，点击右上角应用 Logo - 点击 **开发者工具** 或者按快捷键 `Ctrl` + `Shift` + `I` 打开

#### 进阶(代码热更新)

在开发模式下，入口文件是支持 URL 协议的，可配合 Vite、Webpack 等工具，在开发阶段进行热更新。

##### Vite

1. 启动项目 `npm run dev`
2. plugin.json 增加 development 配置：

```json
{
  "development": {
    "main": "http://127.0.0.1:5173/index.html"
  }
}
```

3. 进入 uTools 开发工具，点击接入开发后观察效果

##### Webpack

1. 安装 webpack-dev-server

```shell
npm install webpack-dev-server --save-dev
```

2. 入口 index.js 增加监听代码

```js
if (module.hot) {
    module.hot.accept();
}
```

3. 启动 webpack-dev-server

```shell
npm run serve
```

4. plugin.json 增加 development 配置：

```json
{
  "development": {
    "main": "http://127.0.0.1:8080/index.html"
  }
}
```

5. 进入 uTools 开发工具，点击接入开发后观察效果

> 注意：preload.js 代码变更后无法自动热更新，在应用开发点击设置开启 **退出到后台立即结束运行**

---

### 1.4 打包为离线安装包

当你的插件开发完成后，你可以选择将其打包成离线插件安装包（UPXS）。

这种方式下的插件应用，无需通过审核即可分享给其他人使用，不过在安装时会被 uTools 弹出安全提示，需要用户确认安装。

> 注意：离线插件应用安装更多用于方便测试或者自己内部分享或使用，而不是用于发布。
>
> 若想要更多人使用你的插件应用，请参考 [uTools 开发者文档](https://u.tools/docs/developer/api.html) 中的发布章节。

通过 uTools 开发者工具插件，点击 **打包** 按钮，填写版本信息后，点击 **确认** 按钮后，在弹出的文件保存窗口选择保存路径即可完成打包。

> WARNING
>
> 插件应用打包与发布时，都需要填写对应的版本号，这两个版本号并没有关联。
>
> 版本号遵守 [semver 部分规范](https://semver.org/lang/zh-CN/) ，在修改过程中要注意确认。

---

### 1.5 发布到应用市场

当你的插件应用完成开发，并且完成测试没有问题之后，就可以发布到插件应用市场了。

> **小提示**：发布到市场能让你的插件应用被更多用户使用，也可以强化 uTools 的生态。

#### 发布前的准备

- 发布插件信息
- 发布版本信息
- 插件应用的截图
- 检查代码是否符合规范
- 插件应用介绍中提供用户手册

> **提供用户手册**：插件应用发布时，请尽量提供足够详细的用户使用手册，这将会降低你的插件应用使用门槛。
>
> 插件应用的功能尽量简洁，易上手会让你的插件应用变得更受欢迎。
>
> 而更加详细的用户手册，会让你的插件应用在功能定位上减少歧义，并大大的提升用户体验。

#### 发布流程

1. 在 uTools 开发者工具 中，点击 `发布` 按钮
2. 点击发布版本，确认版本号
3. 填写发布信息，完善版本说明、插件应用介绍以及插件应用截图
4. 点击 提交审核，等待审核通过

#### 查看审核结果

通过开发者工具，在插件信息页面切换标签到 `发布历史` ，即可看到当前插件的审核结果。

当显示 `审核通过` 后，代表你的插件已经进入插件应用市场。

#### 微信公众号

uTools 通过微信公众号推送用户信息，开发者也可以通过关注微信公众号获取审核信息。

关注 uTools 公众号，可以直接在微信搜索 uTools，也可以通过二维码关注。

---

## 二、插件应用基础

### 2.1 插件应用目录结构

一个相对完整可打包成插件应用的目录：

```
/{plugin}
|-- plugin.json
|-- preload.js
|-- index.html
|-- index.js
|-- index.css
|-- logo.png
```

#### 源码编译

uTools 仅识别 html + css + javascript，使用 vite、webpack 等工具时，先将框架代码编译成普通 html、css、js 文件，将编译输出到 dist 文件夹打包。

#### 第三方依赖

- 前端依赖：在项目根目录安装，正常编译输出到 dist
- Node.js 依赖：保证模块存在于 preload.js 同级目录，不要编译，保证源码清晰可读

---

### 2.2 plugin.json 核心配置

`plugin.json` 是插件应用的核心配置文件，用于定义插件的运行入口、功能指令、匹配指令，以及插件应用与 uTools 的集成方式。每个插件应用都必须包含一个 `plugin.json` 文件。

#### 配置文件格式

```json
{
  "main": "index.html",
  "logo": "logo.png",
  "preload": "preload.js",
  "features": [
    {
      "code": "hello",
      "explain": "hello world",
      "cmds": ["hello", "你好"]
    }
  ]
}
```

#### 基础字段说明

##### `main`

> 类型：`string`
> 必填：是（AI Agent 无 UI 模式除外，见下文）

必须指定为相对于 `plugin.json` 的 **相对路径**，且文件类型必须为 `.html`

##### `logo`

> 类型：`string`
> 必填：是

插件应用 Logo 文件，必须指定为相对于 `plugin.json` 的 **相对路径**

##### `preload`

> 类型：`string`
> 必填：否

指定一个将在窗口加载前执行的预加载脚本（.js 文件）。该脚本运行在独立的预加载环境，可使用 **Node.js 原生能力** 与 **Electron 渲染进程 API**。

#### 插件应用设置字段说明

##### `pluginSetting`

> 类型：`object`
> 必填：否

##### `pluginSetting.single`

> 类型：`boolean`
> 默认值：`true`

用于控制插件应用是否以单例模式运行。默认为 `true`。

##### `pluginSetting.height`

> 类型：`number`
> 默认值：`544`

配置插件应用初始高度，可以通过 api `utools.setExpendHeight` 动态修改。

> ⚠️ **建议保持默认，不要配置此字段**：固定高度在不同屏幕比例/系统缩放下显示异常（内容裁切或留白过大）。确需调整时，进入插件后调用 `utools.setExpendHeight` 动态设置（见 3.2 窗口章节）。

#### 插件应用功能字段说明

##### `features`

> 类型：`Array<object>`
> 必填：是（AI Agent 无 UI 模式除外，见下文）
> 最小长度：`1`

features 定义插件应用的指令集合，一个插件应用可定义多个功能，一个功能可配置多条指令。

##### `feature.code`

> 类型：`string`
> 必填：是

功能编码，且必须唯一。用户进入插件应用时，uTools 会将该编码传入应用，用于区分不同功能并执行对应的逻辑。

##### `feature.explain`

> 类型：`string`
> 必填：否

功能描述

##### `feature.icon`

> 类型：`string`
> 必填：否

功能图标文件，支持 `.png`、`.jpg`、`.svg` 格式。指定为相对于 `plugin.json` 的 **相对路径**。

##### `feature.mainPush`

> 类型：`boolean`
> 必填：否

是否向搜索框推送内容。

##### `feature.mainHide`

> 类型：`boolean`
> 必填：否

当配置为 `true` 时，触发该功能的指令将不会主动显示主搜索框。适用于需要直接执行功能的场景。

##### `feature.cmds`

> 类型：`Array<string|object>`
> 必填：是
> 最小长度：`1`

配置该功能的指令集合，指令分「功能指令」和「匹配指令」

#### 功能指令

功能指令用于在 uTools 搜索框直接搜索并打开插件应用功能。

**要求**:

- 功能指令名称必须**简短、明确、唯一**；禁止无意义、重复或模糊名称。
- 中文指令无需额外配置拼音或首字母，uTools 会自动支持拼音和首字母搜索。

示例：

```json
{
  "features": [
    {
      "code": "foo",
      "cmds": ["测试"]
    }
  ]
}
```

#### 匹配指令

在 uTools 搜索框输入特定文本或粘贴图片、文件（或文件夹）时，匹配出可处理该内容的指令。

##### `regex` - 正则匹配

```json
{
  "features": [
    {
      "code": "regex",
      "cmds": [
        {
          "type": "regex",
          "label": "打开网址",
          "match": "/^https?:\\/\\/[^\\s/$.?#]\\S+$|^[a-z0-9][-a-z0-9]{0,62}(\\.[a-z0-9][-a-z0-9]{0,62}){1,10}(:[0-9]{1,5})?$/i",
          "minLength": 1,
          "maxLength": 1000
        }
      ]
    }
  ]
}
```

> WARNING
>
> 正则表达式存在斜杠 `\` 需要多加一个，`\\`

##### `over` - 匹配任意文本

```json
{
  "features": [
    {
      "code": "over",
      "cmds": [
        {
          "type": "over",
          "label": "百度一下",
          "exclude": "/\\n/",
          "minLength": 1,
          "maxLength": 500
        }
      ]
    }
  ]
}
```

##### `img` - 匹配图像

```json
{
  "features": [
    {
      "code": "img",
      "cmds": [
        {
          "type": "img",
          "label": "图像保存为文件"
        }
      ]
    }
  ]
}
```

##### `files` - 匹配文件(夹)

```json
{
  "features": [
    {
      "code": "files",
      "cmds": [
        {
          "type": "files",
          "label": "图片批量处理",
          "fileType": "file",
          "extensions": ["png", "jpg", "jpeg", "svg", "webp", "tiff", "avif", "heic", "bmp", "gif"],
          "minLength": 1,
          "maxLength": 100
        }
      ]
    }
  ]
}
```

##### `window` - 匹配当前活动的系统窗口

```json
{
  "features": [
    {
      "code": "window",
      "cmds": [
        {
          "type": "window",
          "label": "窗口置顶",
          "match": {
            "app": ["xxx.app", "xxx.exe"],
            "title": "/xxx/",
            "class": ["xxx"]
          }
        }
      ]
    }
  ]
}
```

#### 插件应用为 AI Agent 提供能力

通过配置 `tools`，可以将插件应用能力以标准化工具的形式暴露给 AI Agent（如 OpenClaw、Claude Code 等），使其在执行过程中能够自主决策并调用相应能力完成任务。

> ⚠️ **重要约束**
>
> 配置 `tools` 后，必须在运行时代码中通过 `utools.registerTool` 完成注册，否则 AI Agent 无法实际调用该工具。
>
> ```js
> utools.registerTool('say_hi', async () => { return 'hi' })
> ```

##### `tools`

> 类型：`object`
> 必填：否

用于向 AI Agent 暴露可调用的工具集合，每个工具以键值对形式定义。键名必须为小写 `snake_case`，用于唯一标识工具。

###### 工具对象字段

- **description** (`string`)：工具功能说明，便于 AI 理解和调用。
- **inputSchema** (`object`)：JSON Schema 定义工具输入参数结构。必须为有效对象，不能为 `null`。无参数工具推荐使用 `{ "type": "object", "additionalProperties": false }`（仅允许空对象）或 `{ "type": "object" }`（允许任意对象）。
- **outputSchema** (`object`, 可选)：JSON Schema 定义工具输出结果结构。

##### `tools` 配置示例

```json
"tools": {
  "say_hi": {
    "description": "向用户打个招呼",
    "inputSchema": { "type": "object", "additionalProperties": false }
  },
  "video_convert": {
    "description": "视频格式转换",
    "inputSchema": {
      "type": "object",
      "additionalProperties": false,
      "properties": {
        "inputPath": {
          "type": "string",
          "description": "输入视频文件绝对路径"
        },
        "format": {
          "type": "string",
          "enum": ["mp4", "mkv", "mov", "webm", "avi", "flv", "wmv"],
          "description": "目标视频格式"
        }
      },
      "required": ["inputPath", "format"]
    },
    "outputSchema": {
      "type": "object",
      "properties": {
        "outputPath": {
          "type": "string",
          "description": "输出视频文件绝对路径"
        }
      },
      "required": ["outputPath"]
    }
  }
}
```

##### AI Agent 专用（无 UI 模式）

当插件应用仅给 AI Agent 使用，可采用最小配置模式：

- 无需配置：`main`、`features`（不提供界面能力）
- 必需配置：`logo`、`preload`、`tools`

#### plugin.json 配置完整示例

```json
{
  "main": "index.html",
  "logo": "logo.png",
  "preload": "preload.js",
  "features": [
    {
      "code": "test-text",
      "explain": "功能指令 —— 可搜索打开的指令示例",
      "cmds": ["功能指令"]
    },
    {
      "code": "test-regex",
      "explain": "匹配指令 —— 正则匹配示例",
      "cmds": [
        {
          "type": "regex",
          "label": "打开链接",
          "match": "/^(?:(http|https|ftp):\\/\\/)?((?:[\\w-]+\\.)+[a-z0-9]+)((?:\\/[^\\/?#]*)+)?(\\?[^#]+)?(#.+)?$/i",
          "minLength": 7,
          "maxLength": 2000
        },
        {
          "type": "regex",
          "label": "身份证号查询",
          "match": "/^[1-9]\\d{5}(19|20)\\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\\d|3[01])\\d{3}(\\d|X)$/",
          "minLength": 18,
          "maxLength": 18
        },
        {
          "type": "regex",
          "label": "手机号查询",
          "match": "/^1[3456789]\\d{9}$/",
          "minLength": 11,
          "maxLength": 11
        },
        {
          "type": "regex",
          "match": "/^\\(*[+-]?(?:\\d{1,15}|\\d{1,3}(?:,\\d\\d\\d){1,4})(?:\\.\\d{1,15})?%?\\)*(?:\\s*[+*/^%-]\\s*\\(*[+-]?(?:\\d{1,15}|\\d{1,3}(?:,\\d\\d\\d){1,4})(?:\\.\\d{1,15})?%?\\)*)+$/",
          "label": "公式计算",
          "maxLength": 1000
        }
      ]
    },
    {
      "code": "test-files",
      "explain": "匹配指令 —— 文件(夹)匹配示例",
      "cmds": [
        {
          "type": "files",
          "label": "任意文件重命名"
        },
        {
          "type": "files",
          "fileType": "file",
          "extensions": ["png", "jpg", "jpeg", "svg", "webp", "tiff", "avif", "heic", "bmp", "gif"],
          "label": "图片批量处理"
        },
        {
          "type": "files",
          "fileType": "directory",
          "label": "读取文件夹内所有文件",
          "maxLength": 1
        },
        {
          "type": "files",
          "fileType": "file",
          "extensions": ["pdf", "md", "doc", "docx", "xls", "xlsx", "txt"],
          "label": "AI 文档处理",
          "maxLength": 50
        },
        {
          "type": "files",
          "fileType": "file",
          "extensions": ["mp4", "webm", "avi", "flv", "mkv", "mov", "wmv"],
          "label": "视频批量处理"
        }
      ]
    },
    {
      "code": "test-img",
      "explain": "匹配指令 —— 图像匹配示例",
      "cmds": [
        {
          "type": "img",
          "label": "OCR 文字识别"
        },
        {
          "type": "img",
          "label": "保存为图片文件"
        }
      ]
    },
    {
      "code": "test-over",
      "explain": "匹配指令 —— 任意文本匹配示例",
      "cmds": [
        {
          "type": "over",
          "label": "问问 AI"
        },
        {
          "type": "over",
          "label": "Google 搜索",
          "exclude": "/\\n/",
          "minLength": 1,
          "maxLength": 500
        }
      ]
    },
    {
      "code": "test-window",
      "explain": "匹配指令 —— 当前活动应用窗口匹配示例",
      "cmds": [
        {
          "type": "window",
          "match": {
            "app": ["explorer.exe", "SearchApp.exe", "SearchHost.exe", "FESearchHost.exe", "prevhost.exe"],
            "class": ["CabinetWClass", "ExploreWClass"]
          },
          "label": "终端中打开当前目录"
        },
        {
          "type": "window",
          "match": {
            "app": ["chrome.exe", "firefox.exe", "msedge.exe", "Safari.app", "Google Chrome.app", "Microsoft Edge.app"],
            "title": "/^(?:GitHub - )?[A-Za-z0-9][A-Za-z0-9-]+\\//"
          },
          "label": "Github Clone"
        }
      ]
    }
  ]
}
```

---

### 2.3 preload 预加载脚本 / 使用 Node.js

#### 认识 preload

当你在 `plugin.json` 文件配置了 `preload` 字段，指定的 js 文件将被预加载，该 js 文件可以调用 Node.js API 的本地原生能力和 Electron 渲染进程 API。

#### 为什么需要 preload

在传统的 web 开发中，为了保持用户运行环境的安全，JavaScript 被做了很强的沙箱限制，比如不能访问本地文件，不能访问跨域网络资源，不能访问本地存储等。

uTools 基于 Electron 构建，通过 preload 机制，在渲染线程中，释放了沙箱限制，使得用户可以通过调用 Node.js 的 API 来访问本地文件、跨域网络资源、本地存储等。

#### preload 的定义

`preload` 是完全独立于前端项目的一个特殊文件，它应当与 `plugin.json` 位于同一目录或其子目录下，保证可以在打包插件应用时可以被一起打包。

`preload` js 文件遵循 `CommonJS` 规范，因此你可以使用 `require` 来引入 Node.js 模块。

#### 前端使用 preload

只需给 `window` 对象自定义一个属性，前端就可直接访问该属性。

**preload.js**

```js
const fs = require("fs");
window.customApis = {
  readFile: async (path) => {
    return fs.promises.readFile(path, "utf8");
  },
};
```

**App.jsx**

```jsx
import { useEffect, useState } from "react";
export default function App() {
  const [file, setFile] = useState("");
  useEffect(() => {
    window.customApis.readFile("/path/to/README.md").then((data) => {
      setFile(data);
    });
  }, []);
  return (
    <div>
      <pre>{file}</pre>
    </div>
  );
}
```

#### preload js 规范

由于 `preload` js 文件可使用本地原生能力，为了防止开发者滥用各种读写文件、网络等能力，uTools 规定：

- `preload` js 文件代码不能进行打包/压缩/混淆等操作，要保证每一行代码清晰可读。
- 引入的第三方模块也必须清晰可读，在提交时将源码一同提交，同样不允许压缩/混淆。

#### 使用 Node.js

`preload` js 文件遵循 `CommonJS` 规范，通过 `require` 引入 Node.js (14.x 版本) 模块。

##### 引入 Node.js 原生模块

**preload.js**

```js
const fs = require("node:fs");
const path = require("node:path");
const os = require("node:os");
const { execSync } = require("node:child_process");

window.services = {
  readFile: (filename) => {
    return fs.readFileSync(filename, { encoding: "utf-8" });
  },
  getFolder: (filepath) => {
    return path.dirname(filepath);
  },
  getOSInfo: () => {
    return { arch: os.arch(), cpus: os.cpus(), release: os.release() };
  },
  execCommand: (command) => {
    execSync(command);
  },
};
```

##### 引入自己编写的模块

**preload.js**

```js
const writeText = require("./libs/writeText.js");
window.services = {
  writeText,
};
```

**libs/writeText.js**

```js
const fs = require("fs");
const path = require("path");

module.exports = function writeText(text, filePath) {
  const dir = path.dirname(filePath);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
  fs.writeFileSync(filePath, text);
  return true;
};
```

##### 引入第三方模块

**通过 npm 安装**

在 `preload.js` 同级目录下，保证存在一个独立的 `package.json`，并且设置 `type` 为 `commonjs`。

```json
{
  "type": "commonjs",
  "dependencies": {}
}
```

在 `preload.js` 同级目录下，执行 `npm install` 安装第三方模块，保证 `node_modules` 目录存在。

以下是通过 `npm` 引入 `colord` 的示例:

```bash
npm install colord
```

**preload.js**

```js
const { getFormat, colord } = require("colord");

window.services = {
  colord: {
    darken(text) {
      const fmt = getFormat(text);
      if (!fmt) {
        return [null, "请输入一个有效的颜色值，比如 #000 或 rgb(0,0,0)"];
      } else {
        const darkColor = colord(text).darken(0.1);
        return [darkColor, null];
      }
    },
  },
};
```

**通过源码引入**

在 `preload.js` 同级目录下，下载源码，并使用 `require` 引入。

```bash
git clone https://github.com/nodemailer/nodemailer.git
```

**preload.js**

```js
const nodemailer = require("./nodemailer");
const _setImmediate = setImmediate;
process.once("loaded", function () {
  global.setImmediate = _setImmediate;
});
const sendMail = () => {
  let transporter = require("./nodemailer").createTransport({
    host: "smtp.qq.com",
    port: 465,
    secure: true,
    auth: {
      user: "aaa@qq.com",
      pass: "xxx",
    },
  });
  let mailOptions = {
    from: "aaa@qq.com",
    to: "bbb@gmail.com",
    subject: "Sending Email using Node.js",
    text: "That was easy!",
  };
  transporter.sendMail(mailOptions, function (error, info) {
    if (error) {
      console.log(error);
    } else {
      console.log("Email sent: " + info.response);
    }
  });
};
window.services = {
  sendMail: () => {
    return sendMail();
  },
};
```

##### 引入 Electron 渲染进程 API

**preload.js**

```js
const { clipboard, nativeImage } = require("electron");

window.services = {
  copyImage: (imageFilePath) => {
    clipboard.writeImage(nativeImage.createFromPath(imageFilePath));
  },
};
```

---

## 三、API 参考

### 3.1 事件

你可以根据需要，事先传递一些回调函数给这些事件，uTools 会在对应事件被触发时调用它们。

#### `utools.onPluginEnter(callback)`

进入插件应用时，uTools 将会主动调用这个方法。

**类型定义**

```ts
function onPluginEnter(callback: (action: PluginEnterAction) => void): void;
```

- `callback` 进入插件应用触发的回调函数

`PluginEnterAction` 类型定义

```ts
interface PluginEnterAction {
  code: string;
  type: "text" | "img" | "file" | "regex" | "over" | "window";
  payload: string | MatchFile[] | MatchWindow;
  from: "main" | "panel" | "hotkey" | "redirect";
  option?: {
    mainPush: boolean;
  };
}
```

**字段说明**

- `code`: plugin.json 配置的 feature.code
- `type`: plugin.json 配置的 feature.cmd.type
- `payload`: feature.cmd.type 对应匹配的数据
- `option`: feature.mainPush 设置为 true，且当用户选择 onMainPush 返回的选项进入时
- `from`: 根据不同触发来源提供：`main` 主面板, `panel` 超级面板, `hotkey` 快捷键, `redirect` 重定向

`MatchFile` 类型定义

```ts
interface MatchFile {
  isFile: boolean;
  isDirectory: boolean;
  name: string;
  path: string;
}
```

`MatchWindow` 类型定义

```ts
interface MatchWindow {
  id: number;
  class: string;
  title: string;
  x: number;
  y: number;
  width: number;
  height: number;
  appPath: string;
  pid: number;
  app: string;
}
```

**示例代码**

```js
utools.onPluginEnter(({ code, type, payload, option, from }) => {
  console.log("用户进入插件应用", code, type, payload);
  console.log("用户进入插件的方式：", from);
});
```

#### `utools.onPluginOut(callback)`

插件应用退出时触发

**类型定义**

```ts
function onPluginOut(callback: (isKill: boolean) => void): void;
```

- `callback` 退出插件应用时触发的回调函数
  - `isKill` 为 `true` 时，表示插件应用结束运行(进程结束)

**示例代码**

```js
utools.onPluginOut((isKill) => {
  if (isKill) {
    console.log("用户结束运行插件应用");
  } else {
    console.log("插件应用被隐藏后台");
  }
});
```

#### `utools.onMainPush(callback, onSelect)`

推送内容到搜索框，并设置从推送的内容选项中打开插件应用的回调

> 注意：向搜索框推送消息前，需要将 feature.mainPush 设置为 true

**类型定义**

```ts
function onMainPush(
  callback: (action: MainPushAction) => MainPushResult[],
  onSelect: (action: PluginEnterAction) => boolean | undefined
): void;
```

`MainPushAction` 类型定义

```ts
interface MainPushAction {
  code: string;
  type: "text" | "img" | "file" | "regex" | "over" | "window";
  payload: string | MatchFile[] | MatchWindow;
}
```

`MainPushResult` 类型定义

```ts
interface MainPushResult {
  icon?: string;
  title?: string;
  text: string;
}
```

**示例代码**

```js
function callback({ code, type, payload }) {
  return [
    {
      icon: "icon.png",
      text: "选项1",
      title: "help text",
    },
    {
      text: "选项2",
      anyField: "xxxx",
    },
  ];
}
function selectCallback({ code, type, payload, option }) {
  if (option.xxx) {
    return true;
  }
  utools.hideMainWindowPasteText(option.text);
}
utools.onMainPush(callback, selectCallback);
```

#### `utools.onPluginDetach(callback)`

用户对插件应用进行分离操作时触发

**类型定义**

```ts
function onPluginDetach(callback: () => void): void;
```

**示例代码**

```js
utools.onPluginDetach(() => {
  console.log("插件应用分离为独立窗口");
});
```

#### `utools.onDbPull(callback)`

当此插件应用的数据在其他设备上被更改后同步到此设备时触发

**类型定义**

```ts
function onDbPull(callback: (docs: DbDoc[]) => void): void;
```

**示例代码**

```js
utools.onDbPull((docs) => {
  console.log(docs);
});
```

---

### 3.2 窗口

用来实现一些跟 uTools 窗口相关的功能

#### `utools.hideMainWindow(isRestorePreWindow)`

执行该方法将会隐藏 uTools 主窗口，包括此时正在主窗口运行的插件应用，分离的插件应用不会被隐藏。

**类型定义**

```ts
function hideMainWindow(isRestorePreWindow?: boolean): boolean;
```

- `isRestorePreWindow` 表示是否焦点回归到前面的活动窗口，默认 true

**示例代码**

```js
utools.hideMainWindow();
```

#### `utools.showMainWindow()`

执行该方法将会显示 uTools 主窗口，包括此时正在主窗口运行的插件应用。

**类型定义**

```ts
function showMainWindow(): boolean;
```

**示例代码**

```js
utools.showMainWindow();
```

#### `utools.setExpendHeight(height)`

设置插件应用在主窗口中的高度，单位为像素。

> ⚠️ **动态高度是唯一推荐的高度调整方式**：不要通过 `pluginSetting.height` 固定窗口高度（不同屏幕比例/缩放下显示异常）。确需更大显示空间时，进入插件后按内容或屏幕自适应调用本方法。

**类型定义**

```ts
function setExpendHeight(height: number): boolean;
```

**示例代码**

```js
utools.setExpendHeight(300);
```

#### `utools.setSubInput(onChange[, placeholder[, isFocus]])`

设置子输入框，进入插件应用后，原本 uTools 的搜索条主输入框将会变成子输入框。

**类型定义**

```ts
function setSubInput(onChange: (details: { text: string }) => void, placeholder?: string, isFocus?: boolean): boolean;
```

**示例代码**

```js
utools.setSubInput(({ text }) => {
  console.log(text);
}, "搜索");
```

#### `utools.removeSubInput()`

移除子输入框。

**类型定义**

```ts
function removeSubInput(): boolean;
```

**示例代码**

```js
utools.removeSubInput();
```

#### `utools.setSubInputValue(text)`

直接对子输入框的值进行设置。

**类型定义**

```ts
function setSubInputValue(text: string): boolean;
```

**示例代码**

```js
utools.setSubInputValue("hello world");
```

#### `utools.subInputFocus()`

聚焦子输入框。

**类型定义**

```ts
function subInputFocus(): boolean;
```

#### `utools.subInputBlur()`

子输入框失去焦点，插件应用获得焦点。

**类型定义**

```ts
function subInputBlur(): boolean;
```

#### `utools.subInputSelect()`

子输入框获得焦点并选中子输入框的内容。

**类型定义**

```ts
function subInputSelect(): boolean;
```

#### `utools.outPlugin([isKill])`

退出插件应用，默认将插件应用隐藏后台。

**类型定义**

```ts
function outPlugin(isKill?: boolean): boolean;
```

- `isKill` 为 `true` 时，将结束运行插件应用(杀死进程)

**示例代码**

```js
utools.outPlugin();
```

#### `utools.redirect(label[, payload])`

跳转到另一个插件应用，并可以携带匹配指令的内容，如果插件应用不存在，则跳转到插件应用市场进行下载。

**类型定义**

```ts
function redirect(label: string | [string, string], payload?: any): boolean;
```

- `label` 为 `string` 时参数为指令名称。若传递数组，则第一个元素为插件应用名称，第二个元素为指令名称

**示例代码**

```js
// 跳转到插件应用「聚合翻译」并翻译内容
utools.redirect(["聚合翻译", "翻译"], "hello world");
// 找到 "翻译" 指令，并自动跳转到对应插件应用
utools.redirect("翻译", "hello world");
// 跳转到插件应用「OCR 文字识别」并识别图片中文字
utools.redirect(["OCR 文字识别", "OCR 文字识别"], {
  type: "img",
  data: "data:image/png;base64,",
});
// 跳转到插件应用「JSON 编辑器」查看 Json 文件
utools.redirect(["JSON 编辑器", "Json"], {
  type: "files",
  data: "/path/to/test.json",
});
```

#### `utools.showOpenDialog(options)`

弹出文件选择框

**类型定义**

```ts
function showOpenDialog(options: OpenDialogOptions): string[] | undefined;
```

- `OpenDialogOptions` 与 [Electron `showOpenDialogSync#options`](https://www.electronjs.org/docs/api/dialog#dialogshowopendialogsyncbrowserwindow-options) 一致

**示例代码**

```js
const files = utools.showOpenDialog({
  filters: [{ name: "plugin.json", extensions: ["json"] }],
  properties: ["openFile"],
});
console.log(files);
```

#### `utools.showSaveDialog(options)`

弹出文件保存框

**类型定义**

```ts
function showSaveDialog(options: SaveDialogOptions): string | undefined;
```

- `SaveDialogOptions` 与 [Electron `showSaveDialogSync#options`](https://www.electronjs.org/docs/api/dialog#dialogshowsavedialogsyncbrowserwindow-options) 一致

**示例代码**

```js
const savePath = utools.showSaveDialog({
  title: "保存位置",
  defaultPath: utools.getPath("downloads"),
  buttonLabel: "保存",
});
console.log(savePath);
```

#### `utools.findInPage(text[, options])`

在当前页面中查找文本

**类型定义**

```ts
function findInPage(text: string, options?: FindInPageOptions): void;
```

**示例代码**

```js
utools.findInPage("hello world");
```

#### `utools.stopFindInPage(action)`

停止查找

**类型定义**

```ts
function stopFindInPage(action: "clearSelection" | "keepSelection" | "activateSelection"): void;
```

**示例代码**

```js
utools.stopFindInPage("clearSelection");
```

#### `utools.startDrag(filePath)`

从插件中拖拽文件到其他窗口

**类型定义**

```ts
function startDrag(filePath: string | string[]): void;
```

**示例代码**

```js
utools.startDrag("/path/to/abc.txt");
utools.startDrag(["/path/to/1.txt", "/path/to/2.txt"]);
```

#### `utools.createBrowserWindow(url[, options][, callback])`

创建一个独立窗口

**类型定义**

```ts
function createBrowserWindow(url: string, options?: BrowserWindowConstructorOptions, callback?: Function): BrowserWindow;
```

- `url` 相对路径的 html 文件
- `options` 参数参考 Electron 的 [BrowserWindowConstructorOptions](https://electronjs.org/docs/api/browser-window#new-browserwindowoptions)。注意：preload 配置也是相对路径。
- `callback` 在页面加载完成后调用
- 返回的 `BrowserWindow` 由 uTools 定制，大部分的函数和属性都是继承 Electron 的 [BrowserWindow](https://electronjs.org/docs/api/browser-window)。注意：不包含 BrowserWindow 和 webContents 的实例事件。

**示例代码**

主窗口：

```js
const win = utools.createBrowserWindow(
  "test.html",
  {
    show: false,
    title: "测试窗口",
    webPreferences: {
      preload: "test_preload.js",
    },
  },
  () => {
    win.show();
    win.setAlwaysOnTop(true);
    win.setFullScreen(true);
    win.webContents.send("ping", "test");
    win.webContents
      .executeJavaScript(
        'fetch("https://jsonplaceholder.typicode.com/users/1").then(resp => resp.json())'
      )
      .then((result) => {
        console.log(result);
      });
  }
);
```

独立窗口 preload.js：

```js
const { ipcRenderer } = require("electron");
ipcRenderer.on("ping", (event, data) => {
  console.log(data);
});
utools.sendToParent("pong", "hello world");
```

创建全屏透明置顶窗口：

```js
function createFullScreenTransparentWindow() {
  const cursorPoint = window.utools.getCursorScreenPoint();
  const currentDisplay = window.utools.getDisplayNearestPoint(cursorPoint);
  const displayBounds = currentDisplay.bounds;
  const fullscreenable = window.utools.isWindows();
  const regionWindow = window.utools.createBrowserWindow(
    "foo.html?params=",
    {
      show: true,
      x: displayBounds.x,
      y: displayBounds.y,
      width: displayBounds.width,
      height: displayBounds.height,
      backgroundColor: "#00000000",
      thickFrame: false,
      resizable: false,
      fullscreenable,
      fullscreen: fullscreenable,
      minimizable: false,
      maximizable: false,
      movable: false,
      autoHideMenuBar: true,
      frame: false,
      transparent: true,
      skipTaskbar: true,
      enableLargerThanScreen: true,
      alwaysOnTop: true,
      roundedCorners: false,
      hasShadow: false,
      webPreferences: {
        preload: "foo_preload.js",
      },
    }
  );
  try {
    regionWindow.setAlwaysOnTop(true, "screen-saver");
  } catch {}
}
```

##### 主窗口 ↔ 独立窗口通信说明

主窗口：通过 API `utools.createBrowserWindow(...)` 创建独立窗口的进程，通常为插件应用主进程。

**核心规则**

- 独立窗口 → 主窗口：只能用 `utools.sendToParent`
- 主窗口 → 独立窗口：只能用 `win.webContents.send`
- 消息接收：统一使用 `ipcRenderer.on`

主窗口 → 独立窗口：

```js
// 发送（主窗口）
const win = utools.createBrowserWindow("foo.html");
win.webContents.send("channelName", { foo: "bar" });
```

```js
// 接收（独立窗口 preload）
const { ipcRenderer } = require("electron");
ipcRenderer.on("channelName", (event, data) => {});
```

独立窗口 → 主窗口：

```js
// 发送（独立窗口）
utools.sendToParent("channelName", { foo: "bar" });
```

```js
// 接收（主窗口 preload）
const { ipcRenderer } = require("electron");
ipcRenderer.on("channelName", (event, data) => {});
```

##### 独立窗口关闭方式

1. 独立窗口自行关闭：`window.close()`（注意：窗口必须在创建时设置可关闭 `closable: true`）
2. 由主窗口关闭：独立窗口发送关闭请求，主窗口接收并执行关闭

#### `utools.sendToParent(channel[, ...args])`

发送消息到父窗口

**类型定义**

```ts
function sendToParent(channel: string, ...args: any[]): void;
```

**示例代码**

```js
utools.sendToParent("pong", "hello", 123);
```

#### `utools.getWindowType()`

获取当前窗口类型

**类型定义**

```ts
function getWindowType(): "main" | "detach" | "browser";
```

**示例代码**

```js
utools.onPluginEnter(({ code, type, payload }) => {
  if (utools.getWindowType() === "main") {
    utools.showNotification("当前窗口为主窗口");
  }
});
```

#### `utools.isDarkColors()`

获取是否深色主题

**类型定义**

```ts
function isDarkColors(): boolean;
```

**示例代码**

```js
utools.onPluginEnter(({ code, type, payload }) => {
  document.body.className = utools.isDarkColors() ? "dark-mode" : "";
});
```

> 推荐：更推荐 web 原生方式判断
>
> ```js
> let theme;
> const isDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
> theme = isDark ? "dark" : "light";
> window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", (e) => {
>   theme = e.matches ? "dark" : "light";
> });
> ```

---

### 3.3 复制

#### `utools.copyText(text)`

复制文本

**类型定义**

```ts
function copyText(text: string): boolean;
```

**示例代码**

```js
utools.copyText("Hello World!");
```

#### `utools.copyFile(filePath)`

复制文件

**类型定义**

```ts
function copyFile(filePath: string | string[]): boolean;
```

**示例代码**

```js
utools.copyFile("C:\\Users\\Administrator\\Desktop\\test.txt");
```

#### `utools.copyImage(image)`

复制图像

**类型定义**

```ts
function copyImage(image: string | Uint8Array): boolean;
```

**示例代码**

```js
// base64
utools.copyImage("data:image/png;base64,......");
// 路径
utools.copyImage("/path/to/img.png");
```

#### `utools.getCopyedFiles()`

获取系统剪贴板中复制的文件列表

**类型定义**

```ts
function getCopyedFiles(): CopiedFile[];
```

`CopiedFile` 类型定义

```ts
interface CopiedFile {
  path: string;
  isDiractory: boolean;
  isFile: boolean;
  name: string;
}
```

---

### 3.4 输入

对外部应用进行一些输入操作，粘贴文本、粘贴图像、粘贴文件。

#### `utools.hideMainWindowPasteFile(filePath)`

先复制文件再执行粘贴操作

**类型定义**

```ts
function hideMainWindowPasteFile(filePath: string | string[]): boolean;
```

**示例代码**

```js
utools.hideMainWindowPasteFile("C:\\Users\\Administrator\\Desktop\\test.txt");
```

#### `utools.hideMainWindowPasteImage(image)`

先复制图像再执行粘贴操作

**类型定义**

```ts
function hideMainWindowPasteImage(image: string | Uint8Array): boolean;
```

**示例代码**

```js
// base64
utools.hideMainWindowPasteImage("data:image/png;base64,......");
// 路径
utools.hideMainWindowPasteImage("/path/to/test.png");
```

#### `utools.hideMainWindowPasteText(text)`

先复制文本再执行粘贴操作

**类型定义**

```ts
function hideMainWindowPasteText(text: string): boolean;
```

**示例代码**

```js
utools.hideMainWindowPasteText("Hello World!");
```

#### `utools.hideMainWindowTypeString(text)`

输入文本，与输入法原理类似

**类型定义**

```ts
function hideMainWindowTypeString(text: string): boolean;
```

**示例代码**

```js
utools.hideMainWindowTypeString("uTools 新一代效率工具平台 - 🐼👏🦄👨‍👩‍👧‍👦🚵🏻");
```

---

### 3.5 系统

> 注：本页内容来源于 uTools 开发者文档「系统」章节及 GitHub API 文档整合

#### `utools.showNotification(body[, clickFeatureCode])`

弹出系统通知

**类型定义**

```ts
function showNotification(body: string, clickFeatureCode?: string): void;
```

- `body` 通知的内容
- `clickFeatureCode` 对应 plugin.json 配置的 feature.code，点击通知进入插件应用

**示例代码**

```js
utools.showNotification("hello test");
```

#### `utools.shellOpenPath(fullPath)`

系统默认方式打开给定的文件

**类型定义**

```ts
function shellOpenPath(fullPath: string): void;
```

**示例代码**

```js
utools.shellOpenPath("C:\\Users\\Public\\Desktop\\test.txt");
```

#### `utools.shellTrashItem(fullPath)`

删除文件到回收站

**类型定义**

```ts
function shellTrashItem(fullPath: string): void;
```

**示例代码**

```js
utools.shellTrashItem("C:\\Users\\Public\\Desktop\\test.txt");
```

#### `utools.shellShowItemInFolder(fullPath)`

在文件管理器中显示文件

**类型定义**

```ts
function shellShowItemInFolder(fullPath: string): void;
```

**示例代码**

```js
utools.shellShowItemInFolder("C:\\Users\\Public\\Desktop\\test.txt");
```

#### `utools.shellOpenExternal(url)`

系统默认的协议打开 URL

**类型定义**

```ts
function shellOpenExternal(url: string): void;
```

**示例代码**

```js
utools.shellOpenExternal("https://www.u-tools.cn");
```

#### `utools.shellBeep()`

播放系统提示音

**类型定义**

```ts
function shellBeep(): void;
```

#### `utools.getNativeId()`

获取设备 ID，用于区别设备

**类型定义**

```ts
function getNativeId(): string;
```

**示例代码**

```js
const nativeId = utools.getNativeId();
utools.dbStorage.setItem(nativeId + "/key", "native value");
```

#### `utools.getAppName()`

获取软件名称

**类型定义**

```ts
function getAppName(): string;
```

#### `utools.getAppVersion()`

获取软件版本

**类型定义**

```ts
function getAppVersion(): string;
```

#### `utools.getPath(name)`

获取路径，提供了一些特殊的路径获取方法

**类型定义**

```ts
function getPath(name: string): string;
```

- `name` 可以是以下特定的值：
  - `home` 用户主目录
  - `appData` 应用程序数据目录
  - `userData` 应用程序用户数据目录
  - `temp` 临时目录
  - `exe` 当前可执行文件的绝对路径
  - `desktop` 用户桌面目录
  - `documents` 用户文档目录
  - `downloads` 用户下载目录
  - `music` 用户音乐目录
  - `pictures` 用户图片目录
  - `videos` 用户视频目录
  - `logs` 用户日志目录

**示例代码**

```js
console.log(utools.getPath("downloads"));
```

#### `utools.getFileIcon(filePath)`

获取系统图标

**类型定义**

```ts
function getFileIcon(filePath: string): string;
```

**示例代码**

```js
utools.getFileIcon(".txt");
utools.getFileIcon("folder");
utools.getFileIcon("D:\\test.url");
```

#### `utools.readCurrentFolderPath()`

读取当前文件管理器窗口路径 (linux 不支持)

**类型定义**

```ts
function readCurrentFolderPath(): Promise<string>;
```

**示例代码**

```js
utools.readCurrentFolderPath().then((dir) => {
  console.log(dir);
});
```

#### `utools.readCurrentBrowserUrl()`

读取当前浏览器窗口 URL (linux 不支持)

> MacOS 支持浏览器 Safari、Chrome、Microsoft Edge、Opera、Vivaldi、Brave
> Windows 支持浏览器 Chrome、Firefox、Edge、IE、Opera、Brave

**类型定义**

```ts
function readCurrentBrowserUrl(): Promise<string>;
```

**示例代码**

```js
const url = await utools.readCurrentBrowserUrl();
console.log(url);
```

#### `utools.isDev()`

判断插件应用是否在开发环境

**类型定义**

```ts
function isDev(): boolean;
```

**示例代码**

```js
if (utools.isDev()) {
  console.log("插件应用开发环境");
}
```

#### `utools.isMacOS()`

判断当前系统是否是 macOS

**类型定义**

```ts
function isMacOS(): boolean;
```

#### `utools.isWindows()`

判断当前系统是否是 Windows

**类型定义**

```ts
function isWindows(): boolean;
```

#### `utools.isLinux()`

判断当前系统是否是 Linux

**类型定义**

```ts
function isLinux(): boolean;
```

---

### 3.6 屏幕

提供一些针对用户屏幕的操作

#### `utools.screenColorPick(callback)`

屏幕取色

**类型定义**

```ts
function screenColorPick(callback: (colors: { hex: string; rgb: string }) => void): void;
```

**示例代码**

```js
utools.screenColorPick((colors) => {
  const { hex, rgb } = colors;
  console.log(hex, rgb);
});
```

#### `utools.screenCapture(callback)`

屏幕截图

**类型定义**

```ts
function screenCapture(callback: (image: string) => void): void;
```

**示例代码**

```js
utools.screenCapture((image) => {
  utools.redirect(["OCR 文字识别", "文字识别+翻译"], image);
});
```

#### `utools.getPrimaryDisplay()`

获取主显示器

**类型定义**

```ts
function getPrimaryDisplay(): Display;
```

> `Display` 类型定义见 [Electron screen.getPrimaryDisplay](https://www.electronjs.org/docs/api/screen#screengetprimarydisplay)

#### `utools.getAllDisplays()`

获取所有显示器

**类型定义**

```ts
function getAllDisplays(): Display[];
```

#### `utools.getCursorScreenPoint()`

获取鼠标当前位置

**类型定义**

```ts
function getCursorScreenPoint(): { x: number; y: number };
```

#### `utools.getDisplayNearestPoint(point)`

获取点位置所在的显示器

**类型定义**

```ts
function getDisplayNearestPoint(point: { x: number; y: number }): Display;
```

#### `utools.getDisplayMatching(rect)`

获取矩形所在的显示器

**类型定义**

```ts
function getDisplayMatching(rect: { x: number; y: number; width: number; height: number }): Display;
```

#### `utools.screenToDipPoint(point)`

屏幕物理坐标转 DIP 坐标

**类型定义**

```ts
function screenToDipPoint(point: { x: number; y: number }): { x: number; y: number };
```

#### `utools.dipToScreenPoint(point)`

屏幕 DIP 坐标转物理坐标

**类型定义**

```ts
function dipToScreenPoint(point: { x: number; y: number }): { x: number; y: number };
```

#### `utools.screenToDipRect(rect)`

屏幕物理区域转 DIP 区域

**类型定义**

```ts
function screenToDipRect(rect: { x: number; y: number; width: number; height: number }): { x: number; y: number; width: number; height: number };
```

#### `utools.dipToScreenRect(rect)`

DIP 区域转屏幕物理区域

**类型定义**

```ts
function dipToScreenRect(rect: { x: number; y: number; width: number; height: number }): { x: number; y: number; width: number; height: number };
```

#### `utools.desktopCaptureSources(options)`

获取录屏源

**类型定义**

```ts
function desktopCaptureSources(options: { types: string[]; thumbnailSize?: { width: number; height: number }; fetchWindowIcons?: boolean }): Promise<DesktopCaptureSource[]>;
```

**示例代码 - webm 录屏**

```js
async function screenRecording() {
  const sources = await utools.desktopCaptureSources({ types: ["window", "screen"] });
  const stream = await navigator.mediaDevices.getUserMedia({
    audio: false,
    video: {
      mandatory: {
        chromeMediaSource: "desktop",
        chromeMediaSourceId: sources[0].id,
        minWidth: 1280,
        maxWidth: 1280,
        minHeight: 720,
        maxHeight: 720,
      },
    },
  });
  const video = document.querySelector("video");
  video.srcObject = stream;
  video.onloadedmetadata = (e) => video.play();
}
```

**示例代码 - 屏幕截图（截取整个屏幕）**

```js
async function captureScreen() {
  const sources = await utools.desktopCaptureSources({ types: ["screen"] });
  const screenSource = sources[0];
  const stream = await navigator.mediaDevices.getUserMedia({
    audio: false,
    video: {
      mandatory: {
        chromeMediaSource: "desktop",
        chromeMediaSourceId: screenSource.id,
      },
    },
  });
  const video = document.createElement("video");
  video.srcObject = stream;
  await video.play();
  await new Promise((resolve) => (video.onplaying = resolve));
  const canvas = document.createElement("canvas");
  canvas.width = video.videoWidth;
  canvas.height = video.videoHeight;
  const ctx = canvas.getContext("2d");
  ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
  const imageData = canvas.toDataURL("image/png");
  stream.getTracks().forEach((track) => track.stop());
  console.log("截图完成:", imageData);
  return imageData;
}
```

---

### 3.7 用户

#### `utools.getUser()`

获取当前登录的用户信息

**类型定义**

```ts
function getUser(): UserInfo | null;
```

`UserInfo` 类型定义

```ts
interface UserInfo {
  avatar: string;
  nickname: string;
  type: "member" | "user";
}
```

**示例代码**

```js
const user = utools.getUser();
if (user) {
  console.log(user);
}
```

#### `utools.fetchUserServerTemporaryToken()`

获取用户服务端临时令牌

**类型定义**

```ts
function fetchUserServerTemporaryToken(): Promise<TempToken>;
```

`TempToken` 类型定义

```ts
interface TempToken {
  token: string;
  expired_at: number;
}
```

**示例代码**

```js
const { token, expired_at } = await utools.fetchUserServerTemporaryToken();
console.log(token, expired_at);
```

---

### 3.8 数据存储

#### 本地数据库 (db)

uTools 提供了本地数据库的 API，通过它可以实现一些简单的数据存储和读取。它可以很方便的使用，数据存储在本地计算机系统，如果用户开启数据同步，可**备份**到 uTools 服务端同时可在用户的多个设备间实现**秒级同步**。

> 注意：在多个设备编辑同一个数据库文档时，将产生冲突，数据库会统一选择一个版本作为最终版本，为了尽可能避免冲突，应该将内容合理的分散在多个文档，而不是都存放在一个数据库文档中。

> ⚠️ **严重警告：两次 db 写操作间隔必须 ≥ 300ms**
>
> 连续两次 db 写操作之间的时间间隔**不能小于 300ms**。如果小于该阈值，会触发 uTools 底层数据存储的无限同步循环，导致 uTools 主进程卡死、界面无响应。（约束出处：`references/uTools-Plugin-Dev-Record.md` 场景 1）
>
> **影响范围**（写操作）：
> - `utools.db.*`：`put`、`remove`、`bulkDocs`、`postAttachment`（含 `utools.db.promises.*` 异步版本）
> - `utools.dbStorage.*`：`setItem`、`removeItem`
> - `utools.dbCryptoStorage.*`：`setItem`、`removeItem`
>
> **不受限操作**（读操作）：`get`、`allDocs`、`getItem`、`getAttachment`、`getAttachmentType`、`replicateStateFromCloud` 等读操作可任意调用。
>
> **注意**：`bulkDocs` 本身也是写操作，连续两次 `bulkDocs` 之间同样需要 ≥ 300ms 间隔。

> **警告 - 请避免将高频变化的临时性数据写入同步数据库。**
>
> 反复创建、删除、修改文档会导致同步过程中产生大量变更记录，增加冲突检测、版本确认和数据传输次数，会严重影响用户的同步速度和使用体验。
>
> 以下类型的数据请勿写入同步 DB，否则可能导致插件被下架（依据 uTools 官方同步数据库使用规范，具体以官方审核为准）：
>
> 1. 临时性数据：缓存数据、运行状态、窗口状态、临时配置、中间计算结果等；
> 2. 高频变化数据：日志、调试信息、访问记录、统计计数、实时状态等；
> 3. 剪贴板相关数据：剪贴板历史、剪贴板监听结果、临时复制内容等；
> 4. 系统监听产生的数据：文件监听事件、文件变化记录、其他程序自动监听变化写入等；
> 5. 用户操作轨迹数据：鼠标位置、光标位置、滚动位置等；
> 6. 自动生成数据：缩略图、索引缓存、搜索缓存、临时元数据等；
> 7. 可通过本地重新生成的数据：任何丢失后可以通过重新计算、扫描或下载恢复的数据，不应进入同步数据库。
>
> 同步 DB 应只保存用户明确创建、需要跨设备同步、且具有长期价值的数据，例如：
>
> 1. 用户创建的文档、笔记、收藏等核心内容；
> 2. 用户主动修改的配置；
> 3. 需要在多设备之间保持一致的数据。
>
> 如果某类数据需要记录，请优先考虑：
>
> 1. 存储在本地文件中；
> 2. 基于特定情况事件出现再写入，而不是任何变化实时写入；
> 3. 采用聚合、压缩后的结果数据，而不是保存每一次变化；
>
> 原则：同步 DB 只存储"用户数据"，不要存储"程序运行数据"。

##### `utools.db.put(doc)` / `utools.db.promises.put(doc)`

创建或更新数据库文档，文档内容不超过 **1M**

**类型定义**

```ts
// 同步版本
function put(doc: DbDoc): DbResult;
// 异步版本
function put(doc: DbDoc): Promise<DbResult>;
```

`DbDoc` 类型定义

```ts
interface DbDoc {
  _id: string;
  _rev?: string;
  [key: string]: unknown;
}
```

`DbResult` 类型定义

```ts
interface DbResult {
  id: string;
  rev?: string;
  ok?: boolean;
  error?: boolean;
  name?: string;
  message?: string;
}
```

**示例代码**

```ts
// 新建文档
const doc = {
  _id: "test/doc-1",
  a: "value 1",
  b: "value 2",
};
let result = utools.db.put(doc);
if (result.ok) {
  doc._rev = result.rev;
}

// 修改文档
doc.a = "updated value 1";
result = utools.db.put(doc);
if (result.ok) {
  doc._rev = result.rev;
}
```

##### `utools.db.get(id)` / `utools.db.promises.get(id)`

根据文档 ID 获取文档

**类型定义**

```ts
function get(id: string): DbDoc | null;
function get(id: string): Promise<DbDoc | null>;
```

##### `utools.db.remove(doc)` / `utools.db.promises.remove(doc)`

删除数据库文档

**类型定义**

```ts
function remove(doc: DbDoc): DbResult;
function remove(id: string): DbResult;
function remove(doc: DbDoc): Promise<DbResult>;
function remove(id: string): Promise<DbResult>;
```

##### `utools.db.bulkDocs(docs)` / `utools.db.promises.bulkDocs(docs)`

批量创建或更新数据库文档

**类型定义**

```ts
function bulkDocs(docs: DbDoc[]): DbResult[];
function bulkDocs(docs: DbDoc[]): Promise<DbResult[]>;
```

##### `utools.db.allDocs([idStartsWith])` / `utools.db.promises.allDocs([idStartsWith])`

筛选并获取插件应用文档数组

**类型定义**

```ts
function allDocs(idStartsWith?: string): DbDoc[];
function allDocs(ids: string[]): DbDoc[];
function allDocs(idStartsWith?: string): Promise<DbDoc[]>;
function allDocs(ids: string[]): Promise<DbDoc[]>;
```

##### `utools.db.postAttachment(id, attachment, type)` / `utools.db.promises.postAttachment(id, attachment, type)`

存储附件到新文档，附件只能被创建不能被更新，创建的附件最大不超过 10M

**类型定义**

```ts
function postAttachment(id: string, attachment: Buffer | Uint8Array, type: string): DbResult;
function postAttachment(id: string, attachment: Buffer | Uint8Array, type: string): Promise<DbResult>;
```

##### `utools.db.getAttachment(id)` / `utools.db.promises.getAttachment(id)`

获取附件

**类型定义**

```ts
function getAttachment(id: string): Uint8Array;
function getAttachment(id: string): Promise<Uint8Array>;
```

##### `utools.db.getAttachmentType(id)` / `utools.db.promises.getAttachmentType(id)`

获取附件类型

**类型定义**

```ts
function getAttachmentType(id: string): string;
function getAttachmentType(id: string): Promise<string>;
```

##### `utools.db.replicateStateFromCloud()` / `utools.db.promises.replicateStateFromCloud()`

云端同步数据到本地的状态

**类型定义**

```ts
function replicateStateFromCloud(): State;
function replicateStateFromCloud(): Promise<State>;
```

```ts
type State = null | 0 | 1;
```

- `null`: 未开启数据同步
- `0`: 已完成同步
- `1`: 同步中

#### dbStorage

dbStorage 是基于**本地数据库**基础上，封装的一套类似 [LocalStorage](https://developer.mozilla.org/zh-CN/docs/Web/API/Window/localStorage) 的 API。

##### `utools.dbStorage.setItem(key, value)`

存储一个键值对数据

**类型定义**

```ts
function setItem(key: string, value: any): void;
```

##### `utools.dbStorage.getItem(key)`

获取一个键值对数据

**类型定义**

```ts
function getItem(key: string): any;
```

##### `utools.dbStorage.removeItem(key)`

删除一个键值对数据

**类型定义**

```ts
function removeItem(key: string): void;
```

#### dbCryptoStorage

dbCryptoStorage 是基于**本地数据库**基础上，封装的一套类似 [LocalStorage](https://developer.mozilla.org/zh-CN/docs/Web/API/Window/localStorage) 的 API，通过键值对形式加密存储数据。

##### `utools.dbCryptoStorage.setItem(key, value)`

存储一个加密的键值对数据

**类型定义**

```ts
function setItem(key: string, value: any): void;
```

##### `utools.dbCryptoStorage.getItem(key)`

获取一个键值对数据（自动解密）

**类型定义**

```ts
function getItem(key: string): any;
```

##### `utools.dbCryptoStorage.removeItem(key)`

删除一个键值对数据

**类型定义**

```ts
function removeItem(key: string): void;
```

---

### 3.9 动态指令

很多时候，插件应用中会提供一些功能供用户进行个性化设置，这部分配置无法在 `plugin.json` 事先定义好，所以我们提供了以下方法对插件应用功能进行动态增减。

#### `utools.getFeatures([codes])`

获取所有动态指令

**类型定义**

```ts
function getFeatures(codes?: string[]): Feature[];
```

`Feature` 类型定义

```ts
interface Feature {
  code: string;
  explain?: string;
  icon?: string;
  platform?: string | string[];
  mainHide?: boolean;
  mainPush?: boolean;
  cmds: Cmd[];
}
```

**示例代码**

```js
// 获取所有动态功能
const features = utools.getFeatures();
console.log(features);
// 获取特定 code
const specific = utools.getFeatures(["code-1", "code-2"]);
console.log(specific);
```

#### `utools.setFeature(feature)`

设置动态指令

**类型定义**

```ts
function setFeature(feature: Feature): void;
```

**示例代码**

```js
utools.setFeature({
  code: Date.now().toString(),
  explain: "测试动态功能",
  cmds: ["测试"],
});
```

#### `utools.removeFeature(code)`

删除动态指令

**类型定义**

```ts
function removeFeature(code: string): boolean;
```

**示例代码**

```js
utools.removeFeature("code");
```

#### `utools.redirectHotKeySetting(cmdLabel[, autocopy])`

跳转(前往) uTools 设置界面，引导用户配置指令全局快捷键

**类型定义**

```ts
function redirectHotKeySetting(cmdLabel: string, autocopy?: boolean): void;
```

**示例代码**

```js
utools.redirectHotKeySetting("剪贴板");
utools.redirectHotKeySetting("问 AI", true);
```

#### `utools.redirectAiModelsSetting()`

跳转(前往) uTools 自定义 AI 模型设置界面

**类型定义**

```ts
function redirectAiModelsSetting(): void;
```

---

### 3.10 模拟按键

#### `utools.simulateKeyboardTap(key[, ...modifiers])`

模拟键盘按键

**类型定义**

```ts
function simulateKeyboardTap(key: string, ...modifiers: string[]): void;
```

**示例代码**

```js
// 模拟键盘敲击 Enter
utools.simulateKeyboardTap("enter");
// Windows/Linux 模拟粘贴
utools.simulateKeyboardTap("v", "ctrl");
// macOS 模拟粘贴
utools.simulateKeyboardTap("v", "command");
// 模拟 Ctrl + Alt + A
utools.simulateKeyboardTap("a", "ctrl", "alt");
```

#### `utools.simulateMouseMove(x, y)`

模拟鼠标移动到指定位置

**类型定义**

```ts
function simulateMouseMove(x: number, y: number): void;
```

#### `utools.simulateMouseClick(x, y)`

模拟鼠标左键点击

**类型定义**

```ts
function simulateMouseClick(x: number, y: number): void;
```

#### `utools.simulateMouseDoubleClick(x, y)`

模拟鼠标左键双击

**类型定义**

```ts
function simulateMouseDoubleClick(x: number, y: number): void;
```

#### `utools.simulateMouseRightClick(x, y)`

模拟鼠标右键点击

**类型定义**

```ts
function simulateMouseRightClick(x: number, y: number): void;
```

---

### 3.11 用户付费

#### `utools.isPurchasedUser()`

是否付费用户

**类型定义**

```ts
function isPurchasedUser(): boolean | string;
```

- 返回 `false` 表示非付费用户，返回 `true` 表示永久授权用户（付费买断），返回 `"yyyy-mm-dd hh:mm:ss"` 日期字符串表示授权到期时间

**示例代码**

```js
const purchasedUser = utools.isPurchasedUser();
if (purchasedUser) {
  // purchasedUser === true 永久授权
  // purchasedUser === "yyyy-mm-dd hh:mm:ss", 授权到期时间
} else {
  utools.openPurchase({ goodsId: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }, () => {
    console.log("付费成功");
  });
}
```

#### `utools.openPurchase(options, callback)`

打开付费 (适用软件付费模式)

> 软件付费指的是，用户按天数购买授权，在授权生效期内，可以使用对应的插件应用功能

**类型定义**

```ts
function openPurchase(options: OpenPurchaseOptions, callback?: () => void): void;
```

`OpenPurchaseOptions` 类型定义

```ts
interface OpenPurchaseOptions {
  goodsId: string;
  outOrderId?: string;
  attach?: string;
}
```

#### `utools.openPayment(options, callback)`

打开支付 (适用服务付费模式)

> 服务付费指的是，用户按使用量购买应用服务

**类型定义**

```ts
function openPayment(options: OpenPaymentOptions, callback?: () => void): void;
```

`OpenPaymentOptions` 类型定义

```ts
interface OpenPaymentOptions {
  goodsId: string;
  outOrderId?: string;
  attach?: string;
}
```

#### `utools.fetchUserPayments()`

获取用户支付记录

**类型定义**

```ts
function fetchUserPayments(): Promise<Payment[]>;
```

`Payment` 类型定义

```ts
interface Payment {
  order_id: string;
  out_order_id: string;
  open_id: string;
  pay_fee: number;
  body: string;
  attach: string;
  goods_id: string;
  paid_at: string;
  created_at: string;
}
```

---

### 3.12 ubrowser (可编程自动化浏览器)

ubrowser（uTools browser）是基于 uTools 特性量身打造的 **可编程自动化浏览器**。它不仅能以自动化方式连接任意互联网服务，并与 uTools 深度集成，更重要的是它依然是 **一个可视的浏览器窗口**，可以像普通浏览器一样打开网页供用户直接操作。

ubrowser 提供了优雅的 **链式调用方法**，只需几行类似自然语言的代码，即可完成一系列复杂操作。例如：

```js
utools.ubrowser
  .goto("https://www.baidu.com")
  .input("uTools")
  .press("enter")
  .run({ width: 1200, height: 800 });
```

#### 链式方法说明

##### `ubrowser.goto(url[, headers][, timeout])`

打开一个 ubrowser 窗口，并跳转到指定网页

```ts
function goto(url: string, headers?: Record<string, string>, timeout?: number): UBrowser;
```

##### `ubrowser.useragent(ua)`

设置用户代理（User-Agent）

```ts
function useragent(ua: string): UBrowser;
```

##### `ubrowser.viewport(width, height)`

设置浏览器视窗大小

```ts
function viewport(width: number, height: number): UBrowser;
```

##### `ubrowser.hide()` / `ubrowser.show()`

隐藏/显示 ubrowser 窗口

```ts
function hide(): UBrowser;
function show(): UBrowser;
```

##### `ubrowser.css(css)`

添加自定义 CSS

```ts
function css(css: string): UBrowser;
```

##### `ubrowser.evaluate(func[, params])`

在网页中执行自定义 JS 代码

```ts
function evaluate(func: Function, params?: any[]): UBrowser;
```

##### `ubrowser.press(key[, modifiers])`

模拟键盘按键

```ts
function press(key: string, ...modifiers: string[]): UBrowser;
```

##### `ubrowser.click(selector[, mouseButton])`

鼠标点击

```ts
// 点击元素
function click(selector: string, mouseButton?: "left" | "middle" | "right"): UBrowser;
// 在坐标位置点击
function click(x: number, y: number, mouseButton?: "left" | "middle" | "right"): UBrowser;
```

##### `ubrowser.mousedown(selector[, mouseButton])`

鼠标按下

```ts
function mousedown(selector: string, mouseButton?: "left" | "middle" | "right"): UBrowser;
function mousedown(x: number, y: number, mouseButton?: "left" | "middle" | "right"): UBrowser;
```

##### `ubrowser.mouseup(selector[, mouseButton])`

鼠标按键抬起

```ts
function mouseup(selector: string, mouseButton?: "left" | "middle" | "right"): UBrowser;
function mouseup(x: number, y: number, mouseButton?: "left" | "middle" | "right"): UBrowser;
```

##### `ubrowser.dblclick(selector[, mouseButton])`

鼠标双击

```ts
function dblclick(selector: string, mouseButton?: "left" | "middle" | "right"): UBrowser;
function dblclick(x: number, y: number, mouseButton?: "left" | "middle" | "right"): UBrowser;
```

##### `ubrowser.hover(selector)`

鼠标移动到元素或坐标位置悬停

```ts
function hover(selector: string): UBrowser;
function hover(x: number, y: number): UBrowser;
```

##### `ubrowser.file(selector, payload)`

上传文件

```ts
function file(selector: string, payload: string | string[] | Buffer): UBrowser;
```

##### `ubrowser.drop(selector, payload)`

拖放文件

```ts
function drop(selector: string, payload: string | string[] | Buffer): UBrowser;
function drop(x: number, y: number, payload: string | string[] | Buffer): UBrowser;
```

##### `ubrowser.input([selector?, ]payload)`

输入文本，模拟输入法输入

```ts
// 输入文本
function input(text: string): UBrowser;
// 元素获得焦点，再输入文本
function input(selector: string, text: string): UBrowser;
```

##### `ubrowser.value(selector, payload)`

对 `input`、`textarea`、`select` 元素赋值

```ts
function value(selector: string, value: string): UBrowser;
```

##### `ubrowser.check(selector, checked)`

对 `checkbox`、`radio` 元素勾选和取消勾选

```ts
function check(selector: string, checked: boolean): UBrowser;
```

##### `ubrowser.focus(selector)`

执行聚焦操作

```ts
function focus(selector: string): UBrowser;
```

##### `ubrowser.scroll(selector)` / `scroll(y)` / `scroll(x, y)`

执行滚动操作

```ts
// 元素滚动到可见位置
function scroll(selector: string, optional?: boolean | ScrollIntoViewOptions): UBrowser;
// 滚动 y 轴到指定位置
function scroll(y: number): UBrowser;
// 滚动 x 轴和 y 轴到指定位置
function scroll(x: number, y: number): UBrowser;
```

##### `ubrowser.download(url[, savePath])`

执行下载操作

```ts
function download(url: string, savePath?: string): UBrowser;
function download(func: (...params: any[]) => string, savePath: string | null, ...params: any[]): UBrowser;
```

##### `ubrowser.paste(text)`

先复制再执行粘贴操作

```ts
function paste(text: string): UBrowser;
```

##### `ubrowser.screenshot(target[, savePath])`

对网页进行截图

```ts
function screenshot(target?: string | Rect, savePath?: string): UBrowser;
```

`Rect` 类型定义

```ts
interface Rect {
  x: number;
  y: number;
  width: number;
  height: number;
}
```

##### `ubrowser.markdown([selector])`

将当前网页内容转换为 markdown

```ts
function markdown(selector?: string): UBrowser;
```

##### `ubrowser.pdf(options[, savePath])`

将网页保存为 PDF

```ts
function pdf(options: PdfOptions, savePath?: string): UBrowser;
```

##### `ubrowser.device(options)`

模拟移动设备

```ts
function device(options: DeviceOptions): UBrowser;
```

`DeviceOptions` 类型定义

```ts
interface DeviceOptions {
  userAgent: string;
  size: {
    width: number;
    height: number;
  };
}
```

##### `ubrowser.wait(ms)` / `wait(selector)` / `wait(func)`

执行等待操作

```ts
// 等待时间
function wait(ms: number): this;
// 等待元素
function wait(selector: string, result?: boolean): this;
function wait(selector: string, timeout?: number): this;
function wait(selector: string, option?: { timeout?: number; interval?: number; result?: boolean }): this;
// 等待函数执行结果返回 true
function wait(func: (...params: any[]) => boolean, timeout?: number, ...params: any[]): this;
```

##### `ubrowser.when(selector[, result])`

条件判断

```ts
// 判断元素是否存在
function when(selector: string, result?: boolean): UBrowser;
// 判断函数返回的结果为 true 时
function when(func: (...params: any[]) => boolean, ...params: any[]): UBrowser;
```

##### `ubrowser.end()`

结束上一个 `when`

```ts
function end(): UBrowser;
```

##### `ubrowser.devTools([mode])`

打开 ubrowser 开发者工具

```ts
function devTools(mode?: string): void;
```

##### `ubrowser.cookies([name])`

获取 ubrowser cookie

```ts
// 在当前 url 根据名称获取 cookie, 为空获取当前 url 全部 cookie
function cookies(name?: string): UBrowser;
// 根据条件获取 Cookie
function cookies(filter: CookieFilter): UBrowser;
```

`CookieFilter` 类型定义

```ts
interface CookieFilter {
  url?: string;
  name?: string;
  domain?: string;
  path?: string;
  secure?: boolean;
  session?: boolean;
  httpOnly?: boolean;
}
```

##### `ubrowser.setCookies`

设置 ubrowser 的 cookie

```ts
function setCookies(name: string, value: string): UBrowser;
function setCookies(cookies: { name: string; value: string }[]): UBrowser;
```

##### `ubrowser.removeCookies(name)`

删除 ubrowser 的 cookie

```ts
function removeCookies(name: string): UBrowser;
```

##### `ubrowser.clearCookies([url])`

清空 ubrowser 的 cookie 信息

```ts
function clearCookies(url?: string): UBrowser;
```

##### `ubrowser.run()`

开始运行 ubrowser 实例，并返回执行结果

```ts
function run(ubrowserId?: number, options?: UBrowserOptions): Promise<[...any, UBrowserInstance]>;
```

`UBrowserOptions` 类型定义

```ts
interface UBrowserOptions {
  show?: boolean;
  width?: number;
  height?: number;
  x?: number;
  y?: number;
  center?: boolean;
  minWidth?: number;
  minHeight?: number;
  maxWidth?: number;
  maxHeight?: number;
  resizable?: boolean;
  movable?: boolean;
  minimizable?: boolean;
  maximizable?: boolean;
  alwaysOnTop?: boolean;
  fullscreen?: boolean;
  fullscreenable?: boolean;
  enableLargerThanScreen?: boolean;
  opacity?: number;
  frame?: boolean;
  closable?: boolean;
  focusable?: boolean;
  skipTaskbar?: boolean;
  backgroundColor?: string;
  hasShadow?: boolean;
  transparent?: boolean;
  titleBarStyle?: string;
  thickFrame?: boolean;
}
```

`UBrowserInstance` 类型定义

```ts
interface UBrowserInstance {
  id: string;
  url: string;
  title: string;
  width: number;
  height: number;
  x: number;
  y: number;
}
```

#### 示例代码

```js
// 在地图上显示地址位置
const address = "福州烟台山";
utools.ubrowser
  .goto("https://map.baidu.com")
  .input("#sole-input", address)
  .wait(300)
  .press("enter")
  .run({ width: 1200, height: 800 });
```

```js
// 快递 100 查询快递单号
const expressNo = "YT8933937901850";
utools.ubrowser
  .goto("https://www.kuaidi100.com/")
  .scroll(0, 450)
  .input("#input", expressNo)
  .click("#query")
  .run({ width: 1200, height: 800 });
```

```js
// 发送文件到微信文件传输助手
const filePath = `/path/to/test.zip`;
utools.ubrowser
  .goto("https://filehelper.weixin.qq.com")
  .wait("textarea")
  .file("#btnFile", filePath)
  .run({ width: 720, height: 680 });
```

```js
// 网盘自动提取
const text = `https://pan.baidu.com/s/1ekPm-ooS0uvVA_J7ZqVGDQ 提取码: kvr5`;
const matchs = text.match(
  /(https?:\/\/[a-z0-9-._~:/?=#]+)\s*(?:\(|（)?(?:提取密?码?|访问密?码|密码)\s*(?::|：)?\s*([a-z0-9]{4,6})/i
);
utools.ubrowser
  .clearCookies(matchs[1])
  .goto(matchs[1])
  .wait("input")
  .focus("//input[contains(@placeholder, '提取码') or contains(@placeholder, '访问码')]")
  .input(matchs[2])
  .press("enter")
  .run({ width: 1200, height: 800 });
```

```js
// iframe 嵌套支持
utools.ubrowser
  .goto("https://container.iframe.test.web")
  .wait("iframe#outer >> iframe#inner >> button.login")
  .click("iframe#outer >> iframe#inner >> button.login")
  .run({ width: 1200, height: 800 });
```

#### ubrowser 管理

##### `utools.getIdleUBrowsers()`

获取所有空闲的 ubrowser 实例对象

```ts
function getIdleUBrowsers(): UBrowserInstance[];
```

##### `utools.setUBrowserProxy(config)`

设置 ubrowser 的代理

```ts
function setUBrowserProxy(config: ProxyConfig): boolean;
```

##### `utools.clearUBrowserCache()`

清除 ubrowser 的缓存

```ts
function clearUBrowserCache(): boolean;
```

---

### 3.13 工具注册 (为 AI Agent 提供能力)

#### `utools.registerTool(name, handler)`

注册一个工具方法，使其能够在运行时被 AI Agent 自动调用。

> ⚠️ **注册时机要求**
>
> `registerTool` 必须在页面初始化阶段执行：
>
> - ✅ 推荐：`preload.js`
> - ✅ 或与 `onPluginEnter` 同级作用域
> - ❌ 不可写在 `onPluginEnter` 内部，AI Agent 调用时不会触发 `onPluginEnter`

**类型定义**

```ts
function registerTool(name: string, handler: (params: Record<string, any>, ctx: ToolContext) => any): void;
```

`ToolContext` 类型定义

```ts
interface ToolContext {
  requestId: string | number;
  sendProgress?: (options: { progress: number; total?: number; message?: string }) => Promise<void>;
}
```

**示例代码**

```js
// 简单工具
utools.registerTool("say_hi", async () => {
  return "hi";
});

// 带进度上报的长任务
utools.registerTool("video_convert", async ({ inputPath, format }, ctx) => {
  const outputPath = `${window.utools.getPath("downloads")}/${Date.now()}.${format}`;
  const args =
    format === "webm"
      ? ["-i", inputPath, "-c:v", "libvpx-vp9", "-crf", "30", "-b:v", "0", outputPath]
      : ["-i", inputPath, outputPath];
  await window.utools.runFFmpeg(args, (progress) => {
    if (!ctx.sendProgress || progress.percent === undefined) return;
    ctx.sendProgress({
      progress: progress.percent,
      total: 100,
      message: `视频处理中 ${progress.percent.toFixed(1)}%`,
    });
  });
  return { outputPath };
});
```

#### 最佳实践

1. **工具设计保持单一职责** - 一个工具只解决一个明确问题
2. **工具应避免动态注册** - 避免在运行时通过条件判断动态注册工具
3. **参数必须与 `inputSchema` 严格一致** - AI Agent 会基于 `plugin.json` 中的 `inputSchema` 自动构造参数
4. **长任务必须提供进度反馈** - 适用于执行时间 ≥ 5s 的任务
5. **返回值保持结构化** - 统一返回对象，避免返回原始类型
6. **错误处理要明确** - 直接抛出错误，由 AI Agent 感知并处理

---

### 3.14 AI

#### `utools.ai(option[, streamCallback])`

调用 AI 大模型能力，支持 **Function Calling**

**类型定义**

```ts
// 流式调用
function ai(option: AiOption, streamCallback: (chunk: Message) => void): AiPromise<void>;
// 非流式调用
function ai(option: AiOption): AiPromise<Message>;
```

`AiOption` 类型定义

```ts
interface AiOption {
  model?: string;
  messages: Message[];
  tools?: Tool[];
}
```

`Message` 类型定义

```ts
interface Message {
  role: "system" | "user" | "assistant";
  content?: string;
  reasoning_content?: string;
}
```

`Tool` 类型定义

```ts
interface Tool {
  type: "function";
  function?: {
    name: string;
    description: string;
    parameters: {
      type: "object";
      properties: Record<string, any>;
    };
    required?: string[];
  };
}
```

`AiPromise` 类型定义

```ts
interface AiPromise<T> extends Promise<T> {
  abort(): void;
}
```

**示例代码 - AI 对话**

```js
const messages = [
  {
    role: "system",
    content: "你是一个英文翻译专家，将用户的任何内容都翻译成英文，翻译结果要符合英文语言习惯",
  },
  {
    role: "user",
    content: "uTools 是一种高效工作方式",
  },
];
// 流式调用
await utools.ai({ messages }, (chunk) => {
  console.log(chunk);
});
// 非流式调用
const result = await utools.ai({ messages });
console.log(result.content);
```

**示例代码 - Function Calling**

> WARNING
>
> **Function Calling** 功能调用的函数**必须**挂到 `window` 对象上，例如：`window.getSystemInfo`

**App.jsx**

```js
const messages = [
  {
    role: "user",
    content: "我电脑的 CPU 是什么，内存多大",
  },
];
const tools = [
  {
    type: "function",
    function: {
      name: "getSystemInfo",
      description: "获取用户的电脑信息",
      parameters: {
        type: "object",
        properties: {},
      },
    },
  },
];
await utools.ai({ messages, tools }, (delta) => {
  console.log(delta);
});
```

**preload.js**

```js
window.getSystemInfo = () => {
  const os = require("node:os");
  return {
    platform: os.platform(),
    type: os.type(),
    release: os.release(),
    arch: os.arch(),
    cpus: os.cpus(),
    cpuCount: os.cpus().length,
    totalMemory: (os.totalmem() / (1024 * 1024)).toFixed(2) + " MB",
    freeMemory: (os.freemem() / (1024 * 1024)).toFixed(2) + " MB",
    uptime: (os.uptime() / 3600).toFixed(2) + " 小时",
    homedir: os.homedir(),
    userInfo: os.userInfo(),
    networkInterfaces: os.networkInterfaces(),
    loadavg: os.loadavg(),
    currentTime: new Date().toLocaleString(),
    hostname: os.hostname(),
    tempDir: os.tmpdir(),
  };
};
```

#### `utools.allAiModels()`

获取所有可用 AI 模型

**类型定义**

```ts
function allAiModels(): Promise<AiModel[]>;
```

`AiModel` 类型定义

```ts
interface AiModel {
  id: string;
  label: string;
  description: string;
  icon: string;
  cost: number;
}
```

**示例代码**

```js
const models = await utools.allAiModels();
console.log(models);
```

---

### 3.15 Sharp 集成

[Sharp](https://sharp.pixelplumbing.com/) 是高性能 Node.js 图像处理库。在 uTools 中已内置 **Sharp v0.34.5**，插件应用可通过 `utools.sharp` 快速调用。

#### `utools.sharp([input], [options])`

获取 Sharp 实例对象。

**类型定义**

```ts
function sharp(input?: Buffer | Uint8Array | ArrayBuffer | string | object | any[], options?: SharpOptions): Sharp;
```

**参数说明**

- **input**（可选）：输入图片数据，支持多种方式：
  - `Buffer`：Node.js Buffer，包含图片二进制数据
  - `Uint8Array` / `ArrayBuffer`：二进制图片数据
  - `string`：图片文件路径或 URL
  - `object`：
    - `text`：生成文本图片 `{ text: string; width?: number; height?: number; channels?: number; rgba?: boolean }`
    - `raw`：原始像素数据 `{ width: number; height: number; channels: number }`
  - `any[]`：输入源集合，可用于生成多帧动画
- **options**（可选）：配置 Sharp 实例行为。常用字段：
  - `raw`：处理原始像素数据时使用
  - `create`：生成新图像
  - `limitInputPixels`：限制输入像素总量
  - `animated`：处理多帧输入（GIF/WebP 动画）
  - `density`：处理 PDF 或 SVG 时的像素密度
  - `background`：图像操作时的背景色

**返回值**：`Sharp` 实例

**常用链式方法示例**

- `.resize(width, height)`：调整图像尺寸
- `.rotate(angle)`：旋转图像
- `.flip()`：垂直翻转图像
- `.flop()`：水平翻转图像
- `.grayscale()`：灰度化图像
- `.negate()`：反相处理图像颜色
- `.blur(sigma?)`：高斯模糊
- `.sharpen(sigma?, flat?, jagged?)`：锐化图像
- `.threshold(threshold?)`：二值化图像
- `.normalize()`：自动调整图像对比度
- `.gamma(gamma)`：应用 gamma 校正
- `.median(size?)`：中值滤波降噪
- `.tint(color)`：给图像添加颜色滤镜
- `.flatten([background])`：去除 alpha 通道，添加背景色
- `.extend({ top, bottom, left, right, background })`：扩展画布边界
- `.trim(tolerance?)`：裁剪图片边缘的相同颜色区域
- `.extract({ left, top, width, height })`：裁剪指定区域
- `.composite([{ input, top, left, blend }])`：图像合成
- `.jpeg(options)` / `.png(options)` / `.webp(options)` / `.tiff(options)`：转换图像格式
- `.toBuffer()`：获取处理后的图片二进制数据
- `.toFile(path)`：将处理后的图片保存到文件
- `.metadata()`：获取图像元信息
- `.clone()`：复制 Sharp 实例

**示例代码**

```js
// 修改 JPG 尺寸
await utools.sharp("/path/to/input.jpg").resize(300, 200).toFile("/path/to/output.jpg");

// 创建空的 PNG 图像
await utools
  .sharp({
    create: {
      width: 300,
      height: 200,
      channels: 4,
      background: { r: 255, g: 0, b: 0, alpha: 0.5 },
    },
  })
  .png()
  .toBuffer();

// 将 GIF 动画转为 webp 格式
await utools.sharp("/path/to/in.gif", { animated: true }).toFile("/path/to/out.webp");

// 读取像素的原始数组并将其保存为 PNG 格式
const input = Uint8Array.from([255, 255, 255, 0, 0, 0]);
const image = utools.sharp(input, { raw: { width: 2, height: 1, channels: 3 } });
await image.toFile("/path/to/my-two-pixels.png");

// 生成 RGB 高斯噪声
await utools
  .sharp({
    create: {
      width: 300,
      height: 200,
      channels: 3,
      noise: { type: "gaussian", mean: 128, sigma: 30 },
    },
  })
  .toFile("/path/to/noise.png");

// 根据文本生成图像
await utools
  .sharp({ text: { text: "Hello, world!", width: 400, height: 300 } })
  .toFile("/path/to/text_bw.png");

// 生成 GIF 动画
const images = ["😀", "😛"].map((text) => ({
  text: { text, width: 64, height: 64, channels: 4, rgba: true },
}));
await utools.sharp(images, { join: { animated: true } }).toFile("/path/to/out.gif");

// 根据图片 metadata 处理
const image = utools.sharp("/path/to/input.jpg");
image
  .metadata()
  .then(function (metadata) {
    return image.resize(Math.round(metadata.width / 2)).webp().toBuffer();
  })
  .then(function (data) {
    // data contains a WebP image
  });
```

**Sharp 官方文档参考**

- [Constructor](https://sharp.pixelplumbing.com/api-constructor/)
- [Input metadata](https://sharp.pixelplumbing.com/api-input/)
- [Output options](https://sharp.pixelplumbing.com/api-output/)
- [Resizing images](https://sharp.pixelplumbing.com/api-resize/)
- [Compositing images](https://sharp.pixelplumbing.com/api-composite/)
- [Image operations](https://sharp.pixelplumbing.com/api-operation/)
- [Colour manipulation](https://sharp.pixelplumbing.com/api-colour/)
- [Channel manipulation](https://sharp.pixelplumbing.com/api-channel/)
- [Global properties](https://sharp.pixelplumbing.com/api-utility/)

---

### 3.16 FFmpeg 集成

[FFmpeg](https://ffmpeg.org) 是功能强大的开源音视频处理工具，uTools 以独立扩展的形式提供 FFmpeg 能力。用户首次调用 `utools.runFFmpeg` 时，uTools 会自动引导下载并集成 **FFmpeg 命令行工具**。

> 注意：FFmpeg 版本为 v7.1

#### `utools.runFFmpeg(args[, onProgress])`

执行 FFmpeg 命令

**类型定义**

```ts
function runFFmpeg(args: string[], onProgress?: (progress: RunProgress) => void): FfmpegPromise;
function runFFmpeg(args: string[], options: { onProgress?: (progress: RunProgress) => void; onLog?: (text: string) => void }): FfmpegPromise;
```

`FfmpegPromise` 类型定义

```ts
interface FfmpegPromise extends Promise<void> {
  kill(): void;
  quit(): void;
}
```

`RunProgress` 类型定义

```ts
interface RunProgress {
  bitrate: string;
  fps: number;
  frame: number;
  percent?: number;
  q: number | string;
  size: string;
  speed: string;
  time: string;
}
```

**示例代码 - 视频压缩**

```js
utools
  .runFFmpeg(
    [
      "-i", "/path/to/input.mp4",
      "-c:v", "libx264",
      "-crf", "30",
      "-preset", "fast",
      "-tag:v", "avc1",
      "-movflags", "faststart",
      "-c:a", "aac",
      "-b:a", "128k",
      "-map", "0:v",
      "-map", "0:a?",
      "/path/to/output.mp4",
    ],
    (progress) => {
      console.log("压缩中 " + progress.percent + "%");
    }
  )
  .then(() => {
    console.log("压缩完成");
  })
  .catch((error) => {
    console.log("出错了：" + error.message);
  });
```

**示例代码 - 视频转 GIF**

```js
function getConvertToGifArgs(inputVideo, outputGif, fps = 15, width = 200, loop = true, type = "gif") {
  const args = [
    "-i", inputVideo,
    "-vf",
    `fps=${fps},${
      width ? `scale=${width || -1}:-1:flags=lanczos${type === "gif" ? "," : ""}` : ""
    }${type === "gif" ? "split[s0][s1];[s0]palettegen=[p];[s1][p]paletteuse" : ""}`,
    "-loop", loop ? "0" : "-1",
  ];
  if (type === "webp") {
    args.push("-an", "-preset", "picture");
  }
  args.push(outputGif);
  return args;
}
const args = getConvertToGifArgs("/path/to/input.mp4", "/path/to/output.gif");
const runPromise = utools.runFFmpeg(args, (progress) => {
  console.log("转换中 " + progress.percent + "%");
});
runPromise.then(() => console.log("转换完成")).catch((error) => console.log("出错了：" + error.message));
```

**示例代码 - 音频提取**

```js
utools
  .runFFmpeg(["-i", "/path/to/input.mp4", "-q:a", "0", "-map", "a", "/path/to/output.mp3"])
  .then(() => console.log("提取完成"))
  .catch((error) => console.log("出错了：" + error.message));
```

**示例代码 - 获取视频信息**

```js
utools.runFFmpeg(["-i", "/path/to/source.mp4"]).catch((error) => {
  const videoStream = error.message.match(/Stream #\d+:\d+.*Video: ([^\n]+)/);
  const audioStream = error.message.match(/Stream #\d+:\d+.*Audio: ([^\n]+)/);
  const durationMatch = error.message.match(/Duration: ([^,]+)/);
  const bitrateMatch = error.message.match(/bitrate:\s*(\d+ kb\/s)/);
  const videoMetadata = {
    duration: durationMatch?.[1] || null,
    bitrate: bitrateMatch?.[1] || null,
    video: videoStream?.[1] || null,
    audio: audioStream?.[1] || null,
  };
});
```

**示例代码 - 录屏**

```js
function ffmpegRecorder(speaker, microphone, captureMouse, area, outputFile) {
  if (utools.isWindows()) {
    if (speaker && typeof speaker !== "string") {
      throw new Error('扬声器录制需要启用「立体声混音」');
    }
    return utools.runFFmpeg([
      ...(microphone ? ["-f", "dshow", "-i", `audio=${microphone}`] : []),
      ...(speaker ? ["-f", "dshow", "-i", `audio=${speaker}`] : []),
      "-f", "gdigrab",
      "-framerate", "30",
      "-draw_mouse", captureMouse ? "1" : "0",
      ...(area
        ? ["-offset_x", String(Math.round(area.x)), "-offset_y", String(Math.round(area.y)), "-video_size", `${Math.round(area.width)}x${Math.round(area.height)}`]
        : []),
      "-i", "desktop",
      ...(microphone && speaker
        ? ["-filter_complex", "[0:a][1:a]amix=inputs=2:duration=longest:dropout_transition=2[aout]", "-map", "2:v", "-map", "[aout]"]
        : []),
      "-r", "30",
      "-c:v", "libx264",
      "-pix_fmt", "yuv420p",
      "-preset", "ultrafast",
      "-crf", "23",
      ...(microphone || speaker ? ["-c:a", "aac", "-b:a", "192k"] : []),
      outputFile,
    ]);
  }
  if (utools.isMacOS()) {
    if (speaker || microphone) {
      throw new Error("不支持录制声音");
    }
    return utools.runFFmpeg([
      "-f", "avfoundation",
      "-framerate", "30",
      "-capture_cursor", captureMouse ? "1" : "0",
      ...(typeof area === "object"
        ? ["-i", String(area.screenId), "-vf", `crop=${area.width}:${area.height}:${area.x}:${area.y}`]
        : ["-i", String(area)]),
      "-c:v", "libx264",
      "-pix_fmt", "yuv420p",
      "-preset", "ultrafast",
      "-crf", "23",
      outputFile,
    ]);
  }
}

const recorder = ffmpegRecorder(false, false, true, null, "/path/to/capture_desktop.mp4");
setTimeout(() => {
  recorder.quit();
}, 10000);
```

---

## 四、代码提示

### 4.1 使用 uTools API 提示 (TypeScript)

当你需要在项目中使用 TypeScript 时，一般会遇到无法正常使用 `utools` 的 API 的情况。因此 uTools 官方推出了完整的类型定义文件。

#### utools-api-types

`utools-api-types` 是官方开源的一个 TypeScript 类型定义代码库，你可以直接访问 [https://github.com/uTools-Labs/utools-api-types](https://github.com/uTools-Labs/utools-api-types) 进行查看相关信息。

##### 安装

```shell
npm install utools-api-types --save-dev
```

##### 配置 tsconfig

```json5
{
  "compilerOptions": {
    "types": ["utools-api-types"]
  },
  "include": [
    // 如果使用ts或者框架，请添加需要类型提示的文件范围
    // src/**/*.ts
    // preload.js
  ]
}
```

---

### 4.2 plugin.json 配置提示 (JSON Schema)

为了提高开发效率，uTools 官方开源了 `plugin.json` 相关的 JSONSchema 文件。

#### 远程地址

```json
{
  "$schema": "https://raw.githubusercontent.com/uTools-Labs/utools-api-types/refs/heads/main/resource/utools.schema.json"
}
```

#### 本地访问

```json
{
  "$schema": "../resource/utools.schema.json"
}
```

#### 跟随 `utools-api-types` 安装

```json
{
  "$schema": "../node_modules/utools-api-types/resource/utools.schema.json"
}
```

---

## 五、服务端 API

服务端 API 的内容已移出主文档，详见独立文件：

**`references/uTools-Server-API.md`**

涵盖：获取用户基础信息、支付订单查询、创建商品、支付回调等。
