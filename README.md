# WLReader
epub, txt reader, swift


## 说明
`WLReader` 中只提供了阅读器实现方式，关于笔记，划线，书签等功能需要和业务关联，调用接口相关操作，这里只给出实现方式，有使用到的可以根据自己业务场景调试即可

## 功能概括

* html解析，采用DTCoreText库，包含对图片，链接等各种特殊标签的特殊定制样式，展示等
* epub,txt解析
* 翻页方式：仿真，平移，覆盖，无效果，滚动
* 字体，字号切换
* 背景色更换
* 长按选中
* 笔记划线，笔记列表
* 书签功能（收藏）
* 书籍列表（包含章节中分小节的，目前只支持二级章节）
* 网络下载，本地书籍的解析
* 阅读进度的缓存


### 使用方式

将demo中的WLReader拖入项目中，配置好Pofile依赖库：
```
  pod 'SnapKit'
  pod 'DTCoreText'
  pod 'SSZipArchive'
  pod 'AEXML'
  pod 'WCDB.swift'
```
执行pod install 即可

```
    @objc private func fastRead() {
        let path = Bundle.main.path(forResource: "xxx", ofType: "epub")
        let read = WLReadContainer()
        read.bookPath = path
        self.navigationController?.pushViewController(read, animated: true)
        
    }

```
下面是针对不同功能点，可以去具体博客查看：
* 图片相关处理，包括对图片做笔记后的样式调整，长按，点击查看大图等功能
[图片处理](https://juejin.cn/post/7390769366427729947)

* 笔记划线功能实现思路
[笔记划线](https://juejin.cn/post/7388063496199749670)

* 长按选中文本的相关处理
[长按选中文本](https://juejin.cn/post/7388063496199667750)

* 章节中有小章节划分的多级目录处理
[多级目录处理](https://juejin.cn/post/7383737173910470671)

* WLReader 简介
[WLReader简介](https://juejin.cn/user/3192637497028621/posts)
