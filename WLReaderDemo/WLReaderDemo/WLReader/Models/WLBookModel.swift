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
    /// 书籍更新时间
    public var updateTime: TimeInterval! // 更新时间
    /// 阅读的最后时间
    public var lastTime: String!
    /// 是否已下载
    public var isDownload:Bool! = false
    /// 当前图书类型
    public var bookType:WLBookType!
    private var txtParser:WLTxtParser!
    /// 包含笔记的章节
    public var chapterContainsNote:[WLBookNoteModel]! = [WLBookNoteModel]()
    /// 包含书签的章节
    public var chapterContainsMark:[WLBookMarkModel]! = [WLBookMarkModel]()
    /// 当前所读页面的location
    var currentPageLocation:Int! = 0
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
     private func chapterFromEpub(epub: WLEpubBook) {
        // flatTableOfContents 代表有多少章节
        for (index, item) in epub.flatTableOfContents.enumerated() {
            // 创建章节数据
            let chapter = WLBookChapter()
            chapter.title = item.title
            chapter.isFirstTitle = item.children.count > 0
            chapter.fullHref = URL(fileURLWithPath: item.resource!.fullHref)
            chapter.chapterIndex = index
            chapter.bookType = bookType
            chapters.append(chapter)
        }
    }
    /// txt分章节
    private func chapterFromTxt(txt: WLTxtBook) {
        for (index, txtChapter) in txt.chapters.enumerated() {
            let chapter = WLBookChapter()
            chapter.title = txtChapter.title
            chapter.isFirstTitle = txtChapter.page == 0
            chapter.fullHref = URL(fileURLWithPath: txtChapter.path)
            chapter.chapterIndex = index
            chapter.bookType = bookType
            chapters.append(chapter)
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
        case currentPageLocation
    }
    // MARK - 先读取本地书籍
    func read() {
        let object:WLBookModel? = WLBookModel.read(self.title)
        if let book = object {
            self.currentPageLocation = book.currentPageLocation
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
