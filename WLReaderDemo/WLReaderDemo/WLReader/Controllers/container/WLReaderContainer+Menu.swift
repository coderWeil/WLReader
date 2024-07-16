//
//  WLReaderContainer+Setting.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/26.
//  阅读菜单设置

import UIKit

extension WLReadContainer {
    // MARK - 点击分享
    func readerMenuShareEvent() {
//        self.definesPresentationContext = true
//        let share = DKSharePannelController()
//        share.modalPresentationStyle = .overCurrentContext
//        share.modalTransitionStyle = .crossDissolve
//        present(share, animated: false)
    }
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
        let note = WLBookNoteModel()
        note.chapterNumber = self.bookModel.chapterIndex
        note.noteType = .mark
        note.startLocation = self.bookModel.currentPageStartLocation
        note.endLocation = self.bookModel.currentPageEndLocation
        if selected {
            WLNoteConfig.shared.addNote(note: note, nil)
        }else {
            // 找出符合条件的note，并删除
            // 读取笔记内容
            guard let notes = WLNoteConfig.shared.readChapterNotes() else { return }
            // 当前阅读章节
            let chapterIndex = WLBookConfig.shared.bookModel.chapterIndex
            let chapterModel = WLBookConfig.shared.bookModel.chapters[chapterIndex!]
            // 当前阅读的page
            let pageIndex = WLBookConfig.shared.bookModel.pageIndex
            let pageModel = chapterModel.pages[pageIndex!]
            var markNote:WLBookNoteModel?
            for note in notes {
                if note.noteType == .mark &&
                    note.chapterNumber == chapterIndex &&
                    note.startLocation == pageModel.pageStartLocation &&
                    note.endLocation == pageModel.pageEndLocation  {
                    markNote = note
                    break
                }
            }
            WLNoteConfig.shared.removeNote(note: markNote)
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
        clearPageControllers()
        createPageViewController(displayReadController: createCurrentReadController(bookModel: bookModel))
        let pageModel = chapterModel.pages[bookModel.pageIndex]
        bookModel.currentPageStartLocation = pageModel.pageStartLocation
        bookModel.currentPageEndLocation = pageModel.pageEndLocation
        bookModel.save()
        WLBookConfig.shared.bookModel = bookModel
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
                    bookModel.paging(with: previousPageIndex)
                }
                bookModel.pageIndex = previousChapterModel.pages.count - 1
            }else {
                bookModel.pageIndex = previousPageIndex
            }
        }
        clearPageControllers()
        createPageViewController(displayReadController: createCurrentReadController(bookModel: bookModel))
        let pageModel = chapterModel.pages[bookModel.pageIndex]
        bookModel.currentPageStartLocation = pageModel.pageStartLocation
        bookModel.currentPageEndLocation = pageModel.pageEndLocation
        bookModel.save()
        WLBookConfig.shared.bookModel = bookModel
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
                bookModel.paging()
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
                    bookModel.paging(with: previousChapterIndex)
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
        clearPageControllers()
        createPageViewController(displayReadController: createCurrentReadController(bookModel: bookModel))
        let pageModel = chapterModel.pages[bookModel.pageIndex]
        bookModel.currentPageStartLocation = pageModel.pageStartLocation
        bookModel.currentPageEndLocation = pageModel.pageEndLocation
        bookModel.save()
        WLBookConfig.shared.bookModel = bookModel
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
