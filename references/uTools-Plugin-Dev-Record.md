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

## 插件开发模板

uTools 提供了3种开发模板，分别是无 UI 模式、列表模式和文档模式。具有可参考[官网模板应用demo：https://u.tools/docs/developer/template.html](https://u.tools/docs/developer/template.html)

<u>注意事项</u>：使用 uTools 模版，需要删除 plugin.json 文件中的 main 属性（main 属性为空时，表示插件为模板插件应用）

开始开发之前推荐使用 [uTools 官方类型辅助文件](https://github.com/uTools-Labs/utools-api-types) 和 [落雨大佬制作-原生 uTools 开发类型定义：https://codecopy.cn/post/vgtg1c](https://codecopy.cn/post/vgtg1c)

在根目录创建文件type.d.ts，粘贴代码进去，会有语法提示，方便快速开发 uTools 插件

> 以下三种模板模式使用 `window.exports` 旧 API 风格（`mode: "none"` / `mode: "list"` / `mode: "doc"`），该方式仍有效。新项目也可选择标准 HTML 页面 + `utools.onPluginEnter` 的开发方式，参考 SKILL.md 中的核心 API 速览。

### 无 UI 模式

最简单的插件开发模式，不推荐，原因：`大概率会打回，此类插件作用都可以使用脚本代替，做成插件的意义不大`，可作为练习学习，或者前往【自动化脚本】，该插件核心逻辑即为无UI模式插件（脚本就是preload.js，推测脚本运行在函数中，Window 对象为公用模板调用，对后续 `preload.js` 的使用会有深入的认识）

#### 脚本转 `preload.js` ：

遇到得第一个问题：需要手写延时，原因是：sleep 为【自动化脚本】&【快捷命令】的内置命令。非通用命令

可选择使用 Electron 的延迟命令或使用现有的第三方库来实现精确延时的功能【强烈推荐！nodejs 原生提供 timers 库】

##### 手写延时命令：sleep

```javascript
// 思路：使用Promise结合setTimeout来实现
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function myFunction() {
  await sleep(500);
  XXX.XXX('需要延迟执行得命令')
}

myFunction();
```

方案优点：使用时就像正常得sleep函数那样，await sleep(xxx)；即可

存在问题：setTimeout在electron中存在限制，当应用隐藏到后台时延时会被拉长，例如输入300，意味着会等待300毫秒后再执行后续代码，但实际electron应用隐藏到后台后会被拉长到1秒多，无法实现精确延时

改进方案：使用 notejs 的  timers 库 实现更精确的延时

##### 异步延时实现：setTimeout

```javascript
setTimeout(function () {
  XXX.XXX('需要延迟执行得命令')
}, 1000);
```

存在问题：它是一个异步版本，比如 setTimeout 函数下面还存在其他命令，则会同时执行它下面得命令，但 setTimeout 函数中因存延时时间，所以会等延时时间到达后再执行命令；同样代码无法实现精确延时

#### 无UI模式示例代码：

##### 截图示例：

> 脚本作用：截图后粘贴剪贴板

###### plugin.json:

```json
{
    "logo": "截图.png",
    "preload": "preload.js",
    "features": [
        {
            "code": "CaptureDemo",
            "explain": "CaptureDemo",
            "cmds": [
                "CaptureDemo"
            ]
        }
    ]
}
```

###### preload.js:

```javascript
window.exports = {
  "CaptureDemo": {
    mode: "none",
    args: {
      enter: (action) => {
        utools.hideMainWindow();
        setTimeout(function () {
          utools.screenCapture(function (base64Str) {
            utools.copyImage(base64Str);
            utools.showNotification("已复制到剪贴板");
          })
        }, 500);
        utools.outPlugin();
      }
    }
  }
}
```

##### 窗口示例：

> **脚本作用：登录特定的WEB页面，免去输入密码**

###### plugin.json:

```json
{   
  "pluginName": "XXXX脚本",
  "logo": "logo.png",
  "preload": "preload.js",
  "features": [
    {
      "code": "test",
      "explain": "无UI测试",
      "cmds": [
        {
          "type": "window",
          "label": "页面登录",
          "match": {
            "app": ["msedge.exe"],
            "title": "/登录/"
          }
        }
      ]
    }
  ]
}
```

###### preload.js:

```javascript
function test_func() {
  console.log('已进入test_func')
  utools.hideMainWindowTypeString(`admin`)
  setTimeout(function () {
    utools.simulateKeyboardTap('tab')
    utools.hideMainWindowTypeString(`password`)
  }, 500);
  console.log('已退出test_func')
}

window.exports = {
  "test": {
    mode: "none",
    args: {
      enter: (action) => {
        test_func()
      }
    }
  }
}
```

### 列表模式

下述代码的核心部分来自快捷脚本，可到【快捷命令】--【分享中心】-- 搜索 -- 【文本操作】，稍微变通了下输出 uTools 列表开发示例，很简单，没啥可说的

#### plugin.json：

> JSON文件只能包含数据，不允许包含任何代码或注释，因为JSON解析器只能解析符合JSON规范的数据结构

```json
{
  "logo": "测试.png",
  "preload": "preload.js",
  "author": "潇潇",
  "pluginDescription": "这是一个列表测试项目",
  "features": [
    {
      "code": "list_test",
      "explain": "列表测试",
      "cmds": [
        {
          "type": "over",
          "label": "文本操作"
        }
      ]
    }
  ]
}
```

#### preload.js：

```javascript
let textManipulation = [
    {
        title: '添加直角',
        description: text => text.split('\n').map(line => `「${line.trim()}」`).join('\n')
    },
    {
        title: '添加空行',
        description: text => text.split('\n').join('\n\n')
    },
    {
        title: '添加尖括号',
        description: text => text.split('\n').map(line => `<${line.trim()}>`).join('\n')
    },
    {
        title: '添加双引号',
        description: text => text.split('\n').map(line => `“${line.trim()}”`).join('\n')
    },
    {
        title: '添加方括号',
        description: text => text.split('\n').map(line => `【${line.trim()}】`).join('\n')
    },
    {
        title: '添加书名号',
        description: text => text.split('\n').map(line => `⟪${line.trim()}⟫`).join('\n')
    },
    {
        title: '添加括号-EN',
        description: text => text.split('\n').map(line => `(${line.trim()})`).join('\n')
    },
    {
        title: '添加括号-CN',
        description: text => text.split('\n').map(line => `（${line.trim()}）`).join('\n')
    },
    {
        title: '空格替换为.',
        description: text => text.split('\n').map(line => line.includes(" ") ? line.replace(/ /g, ".") : line).join('\n')
    },
    {
        title: '去除空格',
        description: text => text.split('\n').map(line => line.includes(" ") ? line.replace(/ /g, "") : line).join('\n')
    },
    {
        title: '盘古之白',
        description: text => text.split('\n').map(line => {
            return line.replace(/([a-zA-Z0-9])([\u4e00-\u9fa5])/g, '\$1 \$2').replace(/([\u4e00-\u9fa5])([a-zA-Z0-9])/g, '\$1 \$2');
        }).join('\n')
    },
    {
        title: '查找不同',
        description: text => {
            const lines = text.split('\n').filter(line => line.trim() !== ''); // 过滤掉空行
            let lineFrequencies = {}; // 记录每行出现的频率

            // 统计每行出现的频率，忽略行尾的空白字符
            lines.forEach(line => {
                const trimmedLine = line.trim();
                if (lineFrequencies.hasOwnProperty(trimmedLine)) {
                    lineFrequencies[trimmedLine]++;
                } else {
                    lineFrequencies[trimmedLine] = 1;
                }
            });

            // 找出出现频率最高的行
            let mostCommonLine = '';
            let highestFrequency = 0;
            for (let line in lineFrequencies) {
                if (lineFrequencies[line] > highestFrequency) {
                    mostCommonLine = line;
                    highestFrequency = lineFrequencies[line];
                }
            }

            // 计算最长一行的长度
            const maxLength = Math.max(...lines.map(line => line.length));

            // 标记不同的行，按照最长一行的位置添加标记
            const markedLines = lines.map(line => {
                const trimmedLine = line.trim();
                if (trimmedLine !== mostCommonLine) {
                    const diffLength = maxLength - trimmedLine.length;
                    const diffSpace = ' '.repeat(diffLength);
                    return trimmedLine + diffSpace + ' ––––→ 此处不同';
                } else {
                    return line;
                }
            });

            return markedLines.join('\n');
        }
    },
    {
        title: '值内容取反',
        description: text => {
            const replacements = {
                '↑': '↓',
                '↓': '↑',
                '←': '→',
                '→': '←',
                '上': '下',
                '下': '上',
                '左': '右',
                '右': '左'
            };
            // 使用正则表达式匹配所有需要替换的字符
            const regex = new RegExp(Object.keys(replacements).join('|'), 'g');
            // 替换文本中的所有匹配项
            return text.replace(regex, match => replacements[match]);
        }
    },
    {
        title: '提取URL',
        description: text => {
            const urlRegex = /((http|https):\/\/[^\s]+)/g;
            const urls = text.match(urlRegex);
            return urls ? urls.join('\n') : '文本中没有对应关键词';
        }
    },
    {
        title: '提取日期',
        description: text => {
            const dateRegex = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{2,4}\b/g;
            const dates = text.match(dateRegex);
            return dates ? dates.join('\n') : '文本中没有对应关键词';
        }
    },
    {
        title: '提取邮箱地址',
        description: text => {
            const emailRegex = /[\w.-]+@[\w.-]+\.[a-zA-Z]{2,6}/g;
            const emails = text.match(emailRegex);
            return emails ? emails.join('\n') : '文本中没有对应关键词';
        }
    },
    {
        title: '提取电话号码',
        description: text => {
            const phoneRegex = /(\(?\d{3}\)?\s?-?\d{3,4}-?\d{4})/g;
            const phones = text.match(phoneRegex);
            return phones ? phones.join('\n') : '文本中没有对应关键词';
        }
    }
];

window.exports = {
    "list_test": {  // 注意：键对应的是plugin.json中的features.code
        mode: "list",  // 列表模式
        args: {
            // 进入插件时调用
            enter: (action, callbackSetList) => {
                let text = action.payload;
                // 显示所有文本操作选项
                let options = textManipulation.map(manipulation => {
                    return {
                        title: manipulation.title,
                        description: manipulation.description(text)
                    };
                });
                callbackSetList(options);
            },
            
            // 搜索框内容变化时被调用
            search: (action, searchWord, callbackSetList) => {
                // 根据搜索词筛选操作选项
                let filteredOptions = textManipulation.filter(manipulation => 
                    manipulation.title.includes(searchWord)
                ).map(manipulation => {
                    return {
                        title: manipulation.title,
                        description: manipulation.description(action.payload || '')
                    };
                });
                callbackSetList(filteredOptions);
            },
            
            // 用户选择列表中某个条目时被调用
            select: (action, itemData, callbackSetList) => {
                // 用户选择列表中某个条目时执行复制的操作
                utools.copyText(itemData.description);
                utools.hideMainWindow(); // 隐藏插件窗口
                utools.outPlugin(); // 退出插件
            },
            
            // 子输入框为空时的占位符，默认为字符串"搜索"
            placeholder: "输入关键词过滤文本操作"
        } 
    }
}
```

### 文档模式

可快速开发本地文档插件，方便预览查看，搭配插件【自动化脚本】/【快捷命令】中的脚本【输出文档代码】可快速生成文档索引，实现快速开发；

以开发本地文档插件举例，如需在线网页的资源，需自行爬取下载资源内容：

#### plugin.json：

```json
{
  "pluginName": "XXXX文档",
  "pluginDescription": "这是一个测试项目",
  "logo": "文档.png",
  "preload": "preload.js",
  "pluginSetting": {
    "single": true
  },
  "features": [
    {
      "code": "doc_test",
      "explain": "文档测试",
      "cmds": ["XXXX文档"]
    }
  ]
}
```

#### preload.js：

```javascript
window.exports = {
  "doc_test": { 
    mode: "doc",
    args: {
      indexes:require('./indexes.json'),
      enter: (action, callbackSetList) => {
        const searchContent = utools.getInputValue();
        utools.findInPage(searchContent);
        callbackSetList([{title: '搜索结果1'}, {title: '搜索结果2'}]);
      }
    }
  }
}
```

#### indexes.json：

> **标准的json文件,参考下述格式或使用脚本【输出文档代码】快速输出**

```markdown
[
  {
    "t": "2023-08-21_xxx",
    "d": "这是描述",
    "p": "./doc/2023-08-21_xxx.html"
  },
  {
    "t": "2023-10-29_xxx",
    "d": "这是描述",
    "p": "./doc/2023-10-29_xxx.html"
  }
]
```

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

现代前端开发时不太会遇到此类问题，因为前端开发均已使用了 Vue、React 等模块化、组件化的开发方式（需要注意的是即使使用这些框架，如果设计不当，也可能出现高耦合的问题），有助于提高内聚性和降低耦合性。如果使用原生JS开发则很容易遇到这种问题。因为这些通常需要你自己进行模块化处理

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
