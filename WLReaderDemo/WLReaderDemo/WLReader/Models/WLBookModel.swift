//
//  WLBookModel.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/17.
//

import Foundation
import DTCoreText

class WLBookModel: NSObject {
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
    /// 笔记内容
    public var notes:[WLBookNoteModel]?
    
    override init() {
        super.init()
    }
    init(epub: WLEpubBook) {
        super.init()
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
        super.init()
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
            chapter.chapterContentAttr = WLTxtParser.attributeText(with: chapter)
            chapters.append(chapter)
        }
    }
    /// 对当前章节分页
    public func paging(with currentChapterIndex:Int! = 0) {
        let chapter = self.chapters[safe: currentChapterIndex]
        chapter?.paging()
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
}
