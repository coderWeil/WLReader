//
//  WLBookModel.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/17.
//

import Foundation
import DTCoreText
import WCDBSwift

final class WLBookModel: TableCodable {
    /// 目前使用文件名作为唯一ID，因为发现有的电子书没有唯一ID
    public var bookId: String!
    /// 书名
    public var title: String!
    /// 作者
    public var author: String!
    public var directory: URL!
    public var contentDirectory: URL!
    public var coverImg: String!
    public var desc: String!
    /// 当前是第几章
    public var chapterIndex:Int! = 0
    /// 当前是第几页
    public var pageIndex:Int! = 0
    /// 所有的章节
    public var chapters:[WLBookChapter]! = [WLBookChapter]()
    /// 章节目录
    public var catalogues:[WLBookCatalogueModel]! = [WLBookCatalogueModel]()
    /// 书籍更新时间
    public var updateTime: TimeInterval! // 更新时间
    /// 阅读的最后时间
    public var lastTime: String!
    /// 是否已下载
    public var isDownload:Bool! = false
    /// 当前图书类型
    public var bookType:WLBookType!
    private var txtParser:WLTxtParser!
    /// 当前所读页面的location
    var currentPageStartLocation:Int! = 0
    // 当前所读页面的结束location
    var currentPageEndLocation:Int! = 0
    /// 底部进度条是显示章节，还是页码, 默认是显示章节 true
    var bottomProgressIsChapter:Bool! = true
    /// 标记是否读完, 这个只有手动标记读完的时候才会是true，如果这个为true，则优先以这个字段标识进度
    var markFinished:Bool! = false
    
    required init() {
    }
    init(epub: WLEpubBook) {
        self.title = epub.title
        self.bookId = epub.directory.lastPathComponent // epub.bookId
        self.author = epub.metadata.creators.first?.name
        self.coverImg = epub.coverImage?.fullHref
        self.directory = epub.directory
        self.contentDirectory = epub.directory
        self.desc = epub.metadata.descriptions.first
        self.pageIndex = 0
        self.chapterIndex = 0
        self.bookType = .Epub
        self.chapterFromEpub(epub: epub)
        self.catalogueFromEpub(epub: epub)
    }
    
    
    init(txt: WLTxtBook) {
        self.title = txt.title
        self.bookId = txt.bookId
        self.author = txt.author
        self.directory = txt.directory
        self.contentDirectory = txt.directory
        self.pageIndex = 0
        self.chapterIndex = 0
        self.bookType = .Txt
        self.txtParser = WLTxtParser()
        self.chapterFromTxt(txt: txt)
    }
    // MARK - 解析epub章节
    // 获取章节目录列表
    private func catalogueFromEpub(epub: WLEpubBook) {
        catalogues = getCatalogue(items: epub.tableOfContents, level: 0)
    }
    private func getCatalogue(items:[WLTocReference], level:Int = 0, parent:WLBookCatalogueModel? = nil) -> [WLBookCatalogueModel]! {
        var catalogues:[WLBookCatalogueModel]! = []
        for item in items {
            let catalogue = WLBookCatalogueModel()
            catalogue.level = level
            catalogue.catalogueName = item.title
            catalogue.catalogId = item.resource?.id
            catalogue.chapterHref = URL(fileURLWithPath: item.resource!.fullHref)
            catalogue.fragmentID = item.fragmentID
            catalogue.link = item.resource?.href
            if !item.children.isEmpty {
                catalogue.children = getCatalogue(items: item.children, level: level + 1, parent: catalogue)
            }
            catalogue.parent = parent
            // 找出对应的章节directory
            catalogue.chapterIndex = findCatalogueChapterIndex(catalogue: catalogue)
            catalogues.append(catalogue)
        }
        return catalogues
    }
    private func findCatalogueChapterIndex(catalogue:WLBookCatalogueModel) -> Int? {
        for chapter in self.chapters {
            if chapter.href == catalogue.link {
                return chapter.chapterIndex
            }
        }
        return nil
    }
    // 获取实际的章节，它包含所有的内容
     private func chapterFromEpub(epub: WLEpubBook) {
        // 获取章节
         chapters.removeAll()
         let filterChapters = epub.spine.spineReferences.filter { $0.linear}
         for (index, spin) in filterChapters.enumerated() {
             let chapter = WLBookChapter()
             let resource = spin.resource
             chapter.chapterId = resource.id
             chapter.title = resource.id
             chapter.chapterIndex = index
             chapter.href = resource.href
             chapter.fullHref = URL(fileURLWithPath: resource.fullHref)
             chapter.bookType = bookType
             chapter.chapterSrc = resource.href
             chapters.append(chapter)
         }
    }
    // MARK - TXT
    /// txt分章节
    private func chapterFromTxt(txt: WLTxtBook) {
        for (index, txtChapter) in txt.chapters.enumerated() {
            let chapter = WLBookChapter()
            chapter.chapterId = txtChapter.title
            chapter.isFirstTitle = txtChapter.page == 0
            chapter.fullHref = URL(fileURLWithPath: txtChapter.path)
            chapter.chapterIndex = index
            chapter.bookType = bookType
            chapters.append(chapter)
            
            let catalogue = WLBookCatalogueModel()
            catalogue.catalogueName = txtChapter.title
            catalogue.chapterHref = URL(fileURLWithPath: txtChapter.path)
            catalogue.level = 0
            catalogue.chapterIndex = index
            catalogues.append(catalogue)
        }
    }
    /// 对当前章节分页
    public func paging(with currentChapterIndex:Int! = 0) {
        let chapter = self.chapters[safe: currentChapterIndex]
        chapter?.paging(self)
    }
    /// 复制出来一份数据
    func copyReadModel() -> WLBookModel {
        let readModel = WLBookModel()
        readModel.bookId = bookId
        readModel.title = title
        readModel.chapterIndex = chapterIndex
        readModel.pageIndex = pageIndex
        readModel.contentDirectory = contentDirectory
        readModel.directory = directory
        readModel.chapters = chapters
        readModel.bookType = bookType
        readModel.catalogues = catalogues
        return readModel
    }
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WLBookModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
  
        case bookId
        case title
        case chapterIndex
        case pageIndex
        case markFinished
        case currentPageStartLocation
        case currentPageEndLocation
    }
    // MARK - 先读取本地书籍
    func read() {
        let object:WLBookModel? = WLBookModel.read(self.title)
        if let book = object {
            self.currentPageStartLocation = book.currentPageStartLocation
            self.currentPageEndLocation = book.currentPageEndLocation
            self.pageIndex = book.pageIndex
            self.chapterIndex = book.chapterIndex
            self.markFinished = book.markFinished
        }else { // 如果本地没有，则插入数据
            WLDataBase.shared.insertOrReplace([self], WLBookModel.Properties.all, tableName: WLBOOK_TABLE_NAME)
        }
    }
    // MARK - 将当前书籍存储
    func save() {
        self.markFinished = false
        WLDataBase.shared.update(WLBOOK_TABLE_NAME, on: WLBookModel.Properties.all, with: self)
    }
    // MARK - 根据书名读取书籍模型
    class func read(_ title:String) -> WLBookModel? {
        let object:WLBookModel? = WLDataBase.shared.getObject(WLBOOK_TABLE_NAME, where: WLBookModel.Properties.title == title)
        return object
    }
    // MARK - 将当前书籍手动标记读取完毕
    class func save(_ markFinished:Bool, title: String) {
        // 先读取书籍
        let object:WLBookModel? = WLBookModel.read(title)
        guard let book = object else { return } // 如果书籍不存在，不处理
        book.markFinished = markFinished
        // 之后保存
        WLDataBase.shared.update(WLBOOK_TABLE_NAME, on: WLBookModel.Properties.all, with: book)
    }
}
