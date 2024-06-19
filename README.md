# WLReader
epub, txt reader, swift

## 功能概括

* html解析，采用DTCoreText库，包含对图片，链接等各种特殊标签的特殊定制样式，展示等
* epub,txt解析
* 翻页方式：仿真，平移，覆盖，无效果，滚动
* 字体，字号切换
* 背景色更换
* 长按选中
* 笔记划线，笔记列表
* 书签功能（收藏）
* 书籍列表
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

[博客地址](https://juejin.cn/user/3192637497028621/posts)
