## 开发基础知识

### utools基础文件

开发一个 uTools 插件时，需要创建一些文件以实现插件的功能，以下是一些基础文件功能展示，下面四项插件缺一不可：

#### 1、plugin.json：

`plugin.json`是插件的核心文件，它包含了插件的元数据和配置信息。该文件用于指定插件的名称、版本、作者、描述、依赖项和其他配置项。定义了插件的入口文件，通常是index.html文件。

#### 2、logo.png：

`logo`是插件的图标文件，常见图片格式均支持，但推荐 `PNG`格式

注意事项：

1、`logo`图片的像素需是`256*256`，尺寸过大 uTools 不允许打包上传

2、开发过程中如果更改了 `logo`，需要重启 uTools 才能生效

#### 3、index.html：

正常的HTML页面，插件显示的页面文件，位置需要相对于 `plugin.json` 的路径(即与定义的入口文件路径一致)

#### 4、preload.js：

`preload.js`文件是一个特殊的JavaScript文件，它可以在uTools启动时预加载插件。在此文件中可以访问 `nodejs`、`electron`、`uTools` 提供的 api，并挂载到 `window` 对象中，这样其他普通的 javascript 代码就可以使用这些 api。

##### 获取文件对象

```javascript
const fs = require('fs')

function readFile(path) {
	const res = fs.readFileSync(path);
	return new Blob([res])
}

window.preload = {
	readFile
}
```

##### 注意事项：

0、开发中涉及 文件地址引用 使用 【相对地址】

1、不能在HTML页面中引用该文件，仅需在`plugin.json`中添加即可

```markdown
# 引用页面后控制台如下报错：
Uncaught ReferenceError:require is not defined at preload.js:1
```

2、导入模块时不能使用 `{ }` 导入模块

> **错误示范**：`const { fs } = require('fs');` 正确导入：`const fs = require('fs');`

3、Html里面嵌入了另一个html，uTools的API不生效

```javascript
//可以在iframe中拿到parent，然后就可以使用API了

// 在iframe中获取父级窗口
var parentWindow = window.parent;
// 在iframe中调用utools API
parentWindow.utools.redirect('备忘录')

// 更简洁得写法：
window.parent.utools.redirect('备忘录')
```

以上文件是开发 uTools 插件的基本文件，每个文件都有其特定的作用和功能。通过这些文件，可以实现插件的各种功能和特性。

### uTools开发文档：

[快速上手 | uTools 开发文档 | 开发过程中遇到问题可参考官网demo](https://u.tools/docs/developer/api.html)

### uTools插件开发工具

插件应用市场搜索：uTools开发者工具

进入到开发者工具，填入基本信息即可快速创建一个基础的项目：[参考官网示例完成第一个插件！](https://u.tools/docs/developer/welcome.html)

### uTools API

下面给出常用API的示例说明，具体可查文档注释

#### onPluginEnter(callback) 

> 插件进入

```javascript
/**
 * 当插件被触发时，此API会根据用户的输入或选择调用相应的处理函数
 * @param {Object} context - 进入插件时触发的上下文对象
 * @param {string} context.code - 对应 plugin.json 中配置的 feature.code，标识触发的功能
 * @param {string} context.type - 对应 plugin.json 中配置的 feature.cmd.type，表示触发类型
 * @param {string|Object|Array} context.payload - 根据 type 类型，这里是匹配到的数据，可能是文本、图片、文件等
 */
utools.onPluginEnter(({ code, type, payload }) => {
  console.log('用户进入插件应用', code, type, payload)
})
```

#### onPluginOut(callback)

> 插件退出，区分插件退出和进入后台

```javascript
/**
 * 处理插件退出时的资源清理。区分插件完全退出和进入后台
 * @param {boolean} processExit - 如果插件完全退出，则为True；如果插件进入后台，则为false
 */
utools.onPluginOut((processExit) => {
  if (processExit) {
    console.log('插件完全退出')
  } else {
    console.log('插件进入后台')
  }
});
```

#### uTools.getUser()

> 获取用户头像、昵称

```javascript
const user = utools.getUser();
console.log(user);        // 获取用户信息
if (user) {
  const nickname = user.nickname;
  console.log(nickname);  // 输出用户昵称
} else {
  console.log('用户未登录');
}
```

#### utools.showOpenDialog()

> uTools 提供的文件选择，选择文件时不会隐藏插件，造成使用体验割裂

备注说明：如需获取文件对象，可使用 `preload.js` 拿到选择的文件对象

```javascript
const selectedFiles = utools.showOpenDialog({ 
  filters: [{ 'name': 'Excel 文件', extensions: ['xlsx', 'xls', 'csv'] }], 
  properties: ['openFile'] 
});

if (selectedFiles) {
  const firstFilePath = selectedFiles[0];
  console.log(firstFilePath);
} else {
  console.log('用户取消了文件选择');
}
```

#### utools.redirect()

> 携带数据跳转其他插件处理

注意事项：

1、示例中的 `"{{MatchedFiles[0].path}}"` 为快捷命令 API，实际使用需进行替换

2、说明数组的第一项为插件名称，第二项为插件关键字(对应插件智能匹配的关键字)，需确认跳转的插件支持【智能匹配】才能携带数据跳转

```javascript
/**
 * 跳转到插件应用进行处理
 * @param {Array|String} label - 插件应用名称和功能关键字，或者仅为功能关键字
 * @param {String|Object} payload - 携带的数据
 * @returns {Boolean} - 返回跳转是否成功
 */
const selectedFiles = "{{MatchedFiles[0].path}}"
console.log(selectedFiles)
// 跳转到插件应用「万能文件浏览器」找到 “本地文件预览” 关键字查看 Excel 文件
utools.redirect(['万能文件浏览器', '本地文件预览'], {
  'type': 'files',
  'data': selectedFiles
})
```

#### utools.isDarkColors()

> 当前是否深色模式

注意事项：还需额外添加事件监听器，确保插件运行过程中自动切换主题；也可选择媒介查询来查看当前系统所处模式

```javascript
const isDarkMode = utools.isDarkColors() ? 'dark-mode' : 'light-mode'
console.log('当前模式为：' + `${isDarkMode}`)
```

其他 uTools API 的使用可参考插件【自动化助手】中的脚本，快速掌握 API 使用

## 实战进阶

常规的 Web 开发插件模式，结合 HTML + CSS + JavaScript 构建插件，需自己规划页面结构、设置页面样式，完善插件逻辑

开发之前快速了解一下可能需要使用到的技术，通用场景可采用落雨大佬制作的模块，对常用 uTools 操作进行封装，简化准入门槛，快速导入即可使用

### uTools 模块

#### uTools 数据库

[落雨大佬制作-uTools 数据库：https://www.codecopy.cn/post/2hwiyx](https://www.codecopy.cn/post/2hwiyx)

<br/>

#### uTools 页面搜索

[落雨大佬制作-uTools页面搜索hook：https://codecopy.cn/post/ef6zqt](https://codecopy.cn/post/ef6zqt)

基于大佬的 uTools 页面搜索改编的 JS 版本（见下方 `PageSearch` 类）

```javascript
class PageSearch {
    constructor() {
        this.keyword = '';
    }

    init() {
        this.setupSubInput();
        this.setupListeners();
    }

    setupListeners() {
        window.addEventListener('keydown', this.onKeyDown.bind(this));
    }

    removeListeners() {
        window.removeEventListener('keydown', this.onKeyDown.bind(this));
    }

    setupSubInput() {
        utools.setSubInput(({ text }) => {
            this.setKeyword(text);
        }, '请输出搜索内容');
    }

    watchKeyword() {
        if (this.keyword) {
            utools.findInPage(this.keyword, {
                matchCase: false,
                wordStart: true
            });
        } else {
            utools.stopFindInPage('clearSelection');
        }
    }

    forward() {
        if (this.keyword) {
            utools.findInPage(this.keyword, {
                matchCase: false,
                forward: false,
                findNext: true
            });
        }
    }

    findNext() {
        if (this.keyword) {
            utools.findInPage(this.keyword, {
                matchCase: false,
                forward: true,
                findNext: false,
            });
        }
    }

    onKeyDown(e) {
        if (e.key === 'Enter') {
            if (this.keyword) {
                if (e.shiftKey) {
                    this.forward();
                } else {
                    this.findNext();
                }
            }
        }
    }

    setKeyword(text) {
        this.keyword = text;
        this.watchKeyword();
    }

    close() {
        this.keyword = '';
        utools.setSubInputValue('');
    }

    destroy() {
        this.removeListeners();
        utools.removeSubInput();
    }
}

const pageSearch = new PageSearch();


/**
 * 已封装为模块，页面引入后，可供其他JS使用 
 * 注意事项：在iframe中需修改监听部分的代码
 */
pageSearch.init();
```

### 开发思想

#### 高内聚，低耦合

简单理解就是，高内聚：即相同的功能封装成一个模块；低耦合：各模块间依赖关系少；

现代前端开发时不太会遇到此类问题，因为前端开发均已使用了 Vue、React 等模块化、组件化的开发方式（需要注意的是即使使用这些框架，如果设计不当，也可能出现高耦合的问题），有助于提高内聚性和降低耦合性。如果使用原生JS开发则很容易遇到这种问题。因为这些通常需要自行进行模块化处理。

场景举例：当写了一大堆代码实现功能后，如果此时新增需求，修改代码会很麻烦，则需要解耦，将原先的代码抽离成一个个模块，方便后期维护及新增需求。

#### 初始化注册策略

在策略模式（Strategy Pattern）中一个类的行为或其算法可以在运行时更改。这种类型的设计模式属于行为型模式。
在策略模式定义了一系列算法或策略，并将每个算法封装在独立的类中，使得它们可以互相替换。通过使用策略模式，可以在运行时根据需要选择不同的算法，而不需要修改客户端代码。
在策略模式中，我们创建表示各种策略的对象和一个行为随着策略对象改变而改变的 context 对象。策略对象改变 context 对象的执行算法。

### 开发技巧

#### 精简代码

推荐：单文件代码控制在200行左右

#### 文档注释：

> 文档注释格式是使用`/** */`包裹注释内容， `@param` 标签来描述函数的参数， `@returns` 标签描述函数的返回值

```javascript
/**
 * 这个函数用来将两个数字相加。
 * 
 * @param {number} a - 第一个数字。
 * @param {number} b - 第二个数字。
 * @returns {number} 两个数字的和。
 */
function add(a, b) {
  return a + b;
}
```

#### 三元表达式：

```javascript
function showTooltip() {
  tooltip.style.opacity = 1;
}
function hideTooltip() {
  tooltip.style.opacity = 0;
}

/**
 * 精简逻辑，优化代码
 * 1、定义了一个新函数 toggleTooltip，它接受一个布尔值参数 show
 * 2、使用三元运算符来设置 tooltip 元素的不透明度。如果 show 为 true，则设置不透明度为 1（显示提示）；否则，设置不透明度为 0（隐藏提示）。
 * 3、最后再调用的时候就可以使用 布尔值 来显示/隐藏提示
 */
function toggleTooltip(show) {
  tooltip.style.opacity = show ? 1 : 0;
}
```

#### 提取重复代码

> 采用一种更加通用和可扩展的方式对代码进行重构；效果类似`python`，封装通用代码为列表

```javascript
// 优化前：
document.getElementById('inputIP').addEventListener('input', function() {
  this.value = this.value.replace(/[^0-9.\s]/g, '');
});
document.getElementById('inputBinary').addEventListener('input', function() {
  this.value = this.value.replace(/[^01\s]/g, '');
});
document.getElementById('inputOctal').addEventListener('input', function() {
  this.value = this.value.replace(/[^0-7\s]/g, '');
});
document.getElementById('inputDecimal').addEventListener('input', function() {
  this.value = this.value.replace(/[^\d\s]/g, '');
});
document.getElementById('inputHex').addEventListener('input', function() {
  this.value = this.value.replace(/[^0-9A-Fa-f\s]/g, '');
});

// 优化后：
[
  { id: 'inputIP', regex: /[^0-9.\s]/g },
  { id: 'inputBinary', regex: /[^01\s]/g },
  { id: 'inputOctal', regex: /[^0-7\s]/g },
  { id: 'inputDecimal', regex: /[^\d\s]/g },
  { id: 'inputHex', regex: /[^0-9A-Fa-f\s]/g }
].forEach(function({ id, regex }) {
  document.getElementById(id).addEventListener('input', function() {
    this.value = this.value.replace(regex, '');
  });
});
```

### 传统前端开发

开发目录：

```text
├─js
│  └─index.js
├─css
│  └─style.css
├─html
│  └─index.html
└─src
   └─logo.png 
```

纯 HTML + CSS + JavaScript 开发，无框架、无构建工具，适合简单工具类插件。以**本地书签管理器**为例：

**开发目录：**
```
├── plugin.json
├── preload.js
├── index.html
├── style.css
└── logo.png
```

**plugin.json**
```json
{
  "logo": "logo.png",
  "preload": "preload.js",
  "features": [
    {
      "code": "bookmark",
      "explain": "本地书签管理器",
      "cmds": ["书签管理"]
    }
  ]
}
```

**preload.js** — 通过 `utools.db` 进行 CRUD，避免用 `fs` 自行管理文件
```javascript
const DB_PREFIX = 'bookmark/'

window.bookmarkAPI = {
  list: () => {
    const docs = utools.db.allDocs(DB_PREFIX)
    return docs.sort((a, b) => b.createdAt - a.createdAt)
  },
  add: ({ title, url, desc }) => {
    return utools.db.put({
      _id: DB_PREFIX + Date.now(),
      title, url, desc: desc || '',
      createdAt: Date.now()
    })
  },
  remove: (id) => utools.db.remove(utools.db.get(id)),
  update: (doc) => utools.db.put(doc)
}
```

**index.html** — 标准 HTML，通过 `window.bookmarkAPI` 调用 preload 能力
```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>书签管理</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div id="app">
    <header><h1>书签</h1></header>
    <form id="addForm">
      <input id="inputTitle" placeholder="标题" required>
      <input id="inputUrl" type="url" placeholder="https://..." required>
      <input id="inputDesc" placeholder="备注（可选）">
      <button type="submit">添加</button>
    </form>
    <ul id="list"></ul>
  </div>
  <script src="preload.js"></script>
  <script src="index.js"></script>
</body>
</html>
```

**index.js** — 原生 DOM 操作，无框架依赖
```javascript
const form = document.getElementById('addForm')
const list = document.getElementById('list')

function render() {
  const data = window.bookmarkAPI.list()
  list.innerHTML = data.map(item => `
    <li>
      <a href="${item.url}" target="_blank">${item.title}</a>
      ${item.desc ? `<p>${item.desc}</p>` : ''}
      <button class="del" data-id="${item._id}">删除</button>
    </li>
  `).join('')
}

form.addEventListener('submit', (e) => {
  e.preventDefault()
  window.bookmarkAPI.add({
    title: document.getElementById('inputTitle').value,
    url: document.getElementById('inputUrl').value,
    desc: document.getElementById('inputDesc').value
  })
  form.reset()
  render()
})

list.addEventListener('click', (e) => {
  if (e.target.classList.contains('del')) {
    window.bookmarkAPI.remove(e.target.dataset.id)
    render()
  }
})

render()
```

**style.css** — 极简样式
```css
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font: 14px/1.6 system-ui; padding: 16px; }
#addForm { display: flex; gap: 8px; margin-bottom: 16px; flex-wrap: wrap; }
#addForm input { flex: 1; min-width: 120px; padding: 6px 10px; border: 1px solid #ddd; border-radius: 4px; }
#addForm button { padding: 6px 16px; background: #07c; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
#list { list-style: none; }
#list li { padding: 10px 0; border-bottom: 1px solid #eee; display: flex; align-items: center; gap: 12px; }
#list li a { color: #07c; text-decoration: none; font-weight: 500; }
#list li .del { margin-left: auto; padding: 2px 8px; background: #e54; color: #fff; border: none; border-radius: 3px; cursor: pointer; }
```

**核心要点：** 传统开发模式无需构建工具，`plugin.json` 的 `main` 指向 `index.html` 即可。所有数据操作走 `utools.db`，利用其内置的文档型数据库替代文件 I/O，既简化代码又获得自动同步能力。

### 现代前端开发

使用框架（React / Vue）配合构建工具，适合复杂交互场景。以下分两种路线：

---

#### 路线 A：React + webpack（官方参考）

uTools 官方开源密码管理器 [utools-upassword](https://github.com/uTools-Labs/utools-upassword) 是此路线的生产级标杆。

**项目结构：**
```
├── public/                  # 静态资源，构建时原样复制
│   ├── bcrypt/bcrypt.js     # BCrypt 库（preload 引入，不可混淆/打包）
│   ├── index.html
│   ├── logo.png
│   ├── plugin.json
│   └── preload.js           # 加密层 + 数据操作接口
├── src/                     # React 源码（webpack 构建）
│   ├── index.js             # 入口
│   ├── App.js               # 按 feature.code 分发路由
│   ├── Passwords.js         # 密码容器（开门 → 首页）
│   ├── Door.js / Home.js    # 验证 / 主页
│   ├── Tree.js / TreeNode.js / TreeRoot.js   # 分组树
│   ├── AccountArea.js / AccountForm.js / AccountItem.js  # 账号 CRUD
│   ├── Search.js / Setting.js / Reset.js / Random.js
│   └── home.less / index.less
├── webpack.config.js        # CopyWebpackPlugin 复制 public/ → dist/
├── package.json
└── tsconfig.json
```

**数据安全架构（preload.js）**：开门密码 BCrypt 加密 → `utools.db`；账号数据 AES-256-CBC 加密，密钥由开门密码 MD5 派生。

```javascript
const crypto = require('crypto')
const bcrypt = require('./bcrypt/bcrypt.js')

const getKeyIv = (passphrase) => {
  const h1 = crypto.createHash('md5').update(passphrase).digest('hex')
  const h2 = crypto.createHash('md5').update(h1 + passphrase).digest('hex')
  const h3 = crypto.createHash('md5').update(h2 + passphrase).digest('hex')
  return { key: h2, iv: h3.substr(16) }
}

window.services = {
  setBcryptPass: (pw) => { /* bcrypt.hashSync → utools.db.put */ },
  verifyPassword: (pw) => { /* bcrypt.compareSync → getKeyIv */ },
  encryptValue: (keyiv, data) => { /* createCipheriv('aes-256-cbc') */ },
  decryptValue: (keyiv, data) => { /* createDecipheriv('aes-256-cbc') */ }
}
```

**构建配置（webpack.config.js）：**
```javascript
const CopyWebpackPlugin = require('copy-webpack-plugin')

module.exports = {
  entry: './src/index.js',
  output: { filename: '[name].js', path: outputPath },
  plugins: [new CopyWebpackPlugin({ patterns: [{ from: 'public', to: outputPath }] })],
  module: {
    rules: [
      { test: /\.js$/, use: { loader: 'babel-loader', options: { presets: ['@babel/preset-react'] } } },
      { test: /\.(less|css)$/, use: ['style-loader', 'css-loader', 'less-loader'] }
    ]
  }
}
```

完整源码见 [utools-upassword](https://github.com/uTools-Labs/utools-upassword)，建议直接 clone 作为脚手架。

---

#### 路线 B：Vite + Vue

适合偏好 Vue 生态的开发者。关键在 `vite.config.ts` 配置，确保构建产物适配 uTools 的 `file://` 协议。

**项目结构：**
```
├── public/                  # 静态资源（plugin.json、preload.js、logo.png）
│                            # Vite 构建时自动复制到 dist/
├── src/
│   ├── components/
│   ├── composables/
│   ├── App.vue
│   └── style.css
├── index.html               # Vite 入口
├── vite.config.ts
└── package.json
```

**vite.config.ts**
```typescript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import fs from 'node:fs'
import path from 'node:path'

// 可选：构建前检查 plugin.json 是否合法
export default defineConfig({
  plugins: [vue()],
  base: './',
  publicDir: 'public',          // public/ 中的文件自动复制到 dist/
  build: {
    outDir: 'dist',
    emptyOutDir: true,
  },
  server: {
    host: '127.0.0.1',
    port: 5173,
    strictPort: true,
  },
})
```

> 注意：`plugin.json` 的 `main` 字段写 `"index.html"` 即可，无需前缀路径。静态文件（`plugin.json` / `preload.js` / `logo.png`）放 `public/` 下，Vite 构建时自动复制到 `dist/`。

**构建与打包流程：**
1. 开发：`npm run dev`，`plugin.json` 中 `development.main` 指向 `http://localhost:5173`
2. 构建：`npm run build`，产物输出到 `dist/`，`public/` 中的静态文件自动复制
3. 确保 `dist/` 内有 `package.json`（`{ "type": "commonjs" }`）
4. 在开发者工具中选择 `dist/plugin.json` 打包

**第三方依赖处理：**

| 类型 | 处理方式 |
|------|---------|
| 前端依赖（vue、element-plus） | 正常 npm 安装，构建工具自动打包 |
| Node.js 依赖（fs-extra、sqlite3、bcrypt） | 模块放在 `preload.js` 同级，不编译不打包，源码清晰可读 |

#### 社区模板：vite-utools-template

社区开发者 [q2316367743](https://gitee.com/q2316367743) 提供了一个功能更完整的模板 [vite-utools-template](https://gitee.com/q2316367743/vite-utools-template)，适合复杂交互场景。

该模板**与本路线默认方案的详细对比、初始化流程和验证清单，统一以 SKILL.md 的"项目初始化"章节为准**。本节仅补充差异概览：

| | 默认方案（上方） | uTools Vite 模板（落雨大佬开发） |
|---|---|---|
| 构建输出 | dist/ | src-utools/dist/ |
| UI 库 | 无（自选） | TDesign Vue Next |
| 路由/状态管理 | 无（自选） | Vue Router + Pinia |
| 样式方案 | 无（自选） | UnoCSS + Less |
| preload.js | 手写最小实现 | 完整 API 代理层（inject.js） |
| 平台兼容 | 仅 uTools | uTools + ZTools 双平台 |
| 依赖数量 | ~5 | ~25 |

> ⚠️ 该模板依赖较重，简单插件建议用上方默认方案。

---

## 实战场景案例

### 场景 1：剪贴板历史管理器

**需求**：监听剪贴板变化，保存历史记录，支持搜索和重新复制。

**核心思路**：
1. 剪贴板历史属于高频数据，**不能**通过 `utools.db` 存储，应写本地文件（如 JSON 文件）
2. 进入插件时展示历史列表，支持搜索过滤
3. 点击条目复制到剪贴板

**关键注意**：剪贴板变化频率极高，写入同步 db 会触发 300ms 间隔约束导致卡死，必须使用本地文件存储。

### 场景 2：本地文档搜索插件

**需求**：索引本地 Markdown 文档，支持全文搜索。

**核心思路**：
1. 使用 Node.js `fs` 模块遍历指定目录
2. 索引数据存入 `utools.db`（文档内容属于用户数据，适合同步）
3. 进入插件时展示搜索结果列表

**关键注意**：索引构建只需在首次启动或手动触发时执行，不要每次进入插件都重建。

---

## 附录

### 语义化版本

语义化版本不是前端的概念，属于软件管理领域里边的一个概念，指使用字符串来描述一个软件的版本，官方的说法是一种软件版本号的标准化方案，旨在使软件版本号的管理更加透明和可预测。

默认从1.0.0开始（代表正式版本），如遇见从0.1.0开始的版本代表该插件/库为测试版本，还未正式发布

格式：`x.y.z`，（整体上只能增不能减，即使后续某一项版本的功能和前面某次版本的功能一致，也必须增加版本号，不能回退（强制性），中间可跳过但不建议）

x：主版本；代表截断式更新，如 vue2 更新到 vue3 ，再写法上及使用层面都会有巨大的变化，增加很多新功能的同时也不再支持以前老旧的特性。

y：次版本；代表再之前的基础上增加了部分功能。

z：修订版本；代表再前一次的基础上修复了 bug 等，`即功能上无变化，修正了一些错误、隐患等`

在 uTools 中插件版本已经做了上述的基础限制（如回退，撤回版本发布会跳过当前版本等）仅需了解即可
