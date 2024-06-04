//
//  WLReaderContainer+Setting.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/26.
//

import UIKit

extension WLReadContainer {
    /// 计算当前的阅读进度
    public func caclCurrentReadProgress() -> Float {
        if bookModel.chapters.count > 1 {
            if bookModel.chapterIndex == bookModel.chapters.count - 1 {
                return 1
            }
            return Float(bookModel.chapterIndex) / Float(bookModel.chapters.count - 1)
        }
        /// 找出当前章节
        let chapterModel = bookModel.chapters[bookModel.chapterIndex]
        if bookModel.pageIndex == chapterModel.pages.count - 1 {
            return 1
        }
        return Float(bookModel.pageIndex) / Float(chapterModel.pages.count - 1)
    }
    // MARK - WLReaderMenuProtocol
    func readerMenuBackEvent() {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK - 点击书签
    func readerMenuMarkEvent(selected:Bool) {
        // 如果selected为false，表示要删除书签
        
        // 否则需要添加书签
        
        // 查看到当前节是否在书签中
        let markModel:WLBookMarkModel? = WLBookMarkModel.readMarkModel()
        if markModel == nil {
            // 需要添加
            let currentMarkModel:WLBookMarkModel = WLBookMarkModel()
            currentMarkModel.chapterIndex = WLBookConfig.shared.currentChapterIndex
            currentMarkModel.pageLocation = WLBookConfig.shared.currentPageLocation
            currentMarkModel.bookName = WLBookConfig.shared.bookName
            currentMarkModel.save()
        }else {// 需要删除
            markModel?.remove()
        }
    }
    func readerMenuClickNoteEvent() {
        print("点击笔记")
    }
    // MARK - 下一章、下一页
    func readerMenuNextEvent() {
        let chapterModel = bookModel.chapters[bookModel.chapterIndex]
        if WLBookConfig.shared.bottomProgressIsChapter {
            let nextIndex = bookModel.chapterIndex + 1
            if nextIndex > bookModel.chapters.count - 1 { // 表示下面没有了
                return
            }
            bookModel.chapterIndex = nextIndex
            bookModel.pageIndex = 0
        }else {
            let nextPageIndex = bookModel.pageIndex + 1
            if nextPageIndex >= chapterModel.pages.count - 1 { // 表示要到下一章节了
                let nextChapterIndex = bookModel.chapterIndex + 1
                if nextChapterIndex > bookModel.chapters.count - 1 { // 表示下面没有了
                    return
                }
                bookModel.chapterIndex = nextChapterIndex
                bookModel.pageIndex = 0
            }else {
                bookModel.pageIndex = nextPageIndex
            }
        }
        createPageViewController(displayReadController: createCurrentReadController(bookModel: bookModel))
        WLBookConfig.shared.currentChapterIndex = bookModel.chapterIndex
        WLBookConfig.shared.currentPageIndex = bookModel.pageIndex
        let pageModel = chapterModel.pages[bookModel.pageIndex]
        WLBookConfig.shared.currentPageLocation = pageModel.pageStartLocation
        WLBookConfig.shared.save()
        readerMenu.updateTopView()
    }
    // MARK - 上一章、上一页
    func readerMenuPreviousEvent() {
        let chapterModel = bookModel.chapters[bookModel.chapterIndex]
        if WLBookConfig.shared.bottomProgressIsChapter {
            let previousIndex = bookModel.chapterIndex - 1
            if previousIndex < 0 {
                return
            }
            bookModel.chapterIndex = previousIndex
            bookModel.pageIndex = 0
        }else {
            let previousPageIndex = bookModel.pageIndex - 1
            if previousPageIndex < 0 {
                let previousChapterIndex = bookModel.chapterIndex - 1
                if previousChapterIndex < 0 {
                    return
                }
                bookModel.chapterIndex = previousChapterIndex
                let previousChapterModel = bookModel.chapters[previousChapterIndex]
                if previousChapterModel.pages.count == 0 {
                    previousChapterModel.paging()
                }
                bookModel.pageIndex = previousChapterModel.pages.count - 1
            }else {
                bookModel.pageIndex = previousPageIndex
            }
        }
        createPageViewController(displayReadController: createCurrentReadController(bookModel: bookModel))
        WLBookConfig.shared.currentChapterIndex = bookModel.chapterIndex
        WLBookConfig.shared.currentPageIndex = bookModel.pageIndex
        let pageModel = chapterModel.pages[bookModel.pageIndex]
        WLBookConfig.shared.currentPageLocation = pageModel.pageStartLocation
        WLBookConfig.shared.save()
        readerMenu.updateTopView()
    }
    // MARK - 拖拽章节进度
    func readerMenuDraggingProgress(progress: Float) {
        let chapterModel = bookModel.chapters[bookModel.chapterIndex]
        if WLBookConfig.shared.bottomProgressIsChapter {
            let count = bookModel.chapters.count - 1
            let index = Int(Float(count) * progress)
            if index > count || index < 0 {
                return
            }
            bookModel.chapterIndex = index
            let chapterModel = bookModel.chapters[bookModel.chapterIndex]
            /// 分页
            if chapterModel.pages.count == 0 {
                chapterModel.paging()
            }
            bookModel.pageIndex = index == count ? chapterModel.pages.count - 1 : 0
        }else {
            let count = chapterModel.pages.count - 1
            let index = Int(Float(count) * progress)
            if index < 0 { // 上一章
                let previousChapterIndex = bookModel.chapterIndex - 1
                if previousChapterIndex < 0 {
                    return
                }
                let previousChapterModel = bookModel.chapters[previousChapterIndex]
                if previousChapterModel.pages.count == 0 {
                    previousChapterModel.paging()
                }
                bookModel.chapterIndex = previousChapterIndex
                bookModel.pageIndex = previousChapterModel.pages.count - 1
            }else if index > count { // 下一章
                let nextChapterIndex = bookModel.chapterIndex + 1
                if nextChapterIndex > bookModel.chapters.count - 1 {
                    return
                }
                bookModel.chapterIndex = nextChapterIndex
                bookModel.pageIndex = 0
            }else { // 当前章
                bookModel.pageIndex = index
            }
        }
        createPageViewController(displayReadController: createCurrentReadController(bookModel: bookModel))
        WLBookConfig.shared.currentChapterIndex = bookModel.chapterIndex
        WLBookConfig.shared.currentPageIndex = bookModel.pageIndex
        let pageModel = chapterModel.pages[bookModel.pageIndex]
        WLBookConfig.shared.currentPageLocation = pageModel.pageStartLocation
        WLBookConfig.shared.save()
        readerMenu.updateTopView()
    }

    // MARK - 点击显示章节列表
    func readerMenuClickCatalogueEvent(menu: WLReaderMenu!) {
        menu.showMenu(show: false)
        showChapterListView(show: true)
    }
    // MARK - 行间距更改
    func readerMenuChangeLineSpacing(menu: WLReaderMenu!) {
        forceUpdateReader()
        WLBookConfig.shared.save()
    }
    // MARK - 字体大小更改
    func readerMenuChangeFontSize(menu: WLReaderMenu!) {
        forceUpdateReader()
        WLBookConfig.shared.save()
    }
    // MARK - 字体类型更改
    func readerMenuChangeFontType(menu: WLReaderMenu!) {
        forceUpdateReader()
        WLBookConfig.shared.save()
    }
    // MARK - 翻页方式更改
    func readerMenuChangeEffectType(menu: WLReaderMenu!) {
        forceUpdateReader()
        WLBookConfig.shared.save()
    }
    // MARK - 更改阅读背景
    func readerMenuChangeBgColor(menu: WLReaderMenu!) {
        view.backgroundColor = WL_READER_BG_COLOR
        forceUpdateReader()
        WLBookConfig.shared.save()
        chapterListView.updateMainColor()
    }
}
