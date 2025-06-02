//
//  WLReadContainer+DataSource.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/15.
//  数据源处理，包括对数据的获取和控制器的创建等

import UIKit

extension WLReadContainer {
    /// 获取当前页的上一页数据
    func getPreviousModel(bookModel:WLBookModel!) -> WLBookModel! {
        let previousModel = bookModel.copyReadModel()
        // 判断当前页是否是第一页
        if previousModel.pageIndex <= 0 {
            // 判断当前是否是第一章
            if previousModel.chapterIndex <= 0 { // 表示前面没有了
                return nil
            }
            // 进入到上一章
            previousModel.chapterIndex -= 1
            // 进入到最后一页
            if previousModel.chapters[previousModel.chapterIndex].pages.count == 0 {
                previousModel.paging(with: previousModel.chapterIndex)
            }
            previousModel.pageIndex = previousModel.chapters[previousModel.chapterIndex].pages.count - 1
        }else {
            // 直接回到上一页
            previousModel.pageIndex -= 1
        }
        return previousModel
    }
    /// 获取当前页的下一页数据
    func getNextModel(bookModel:WLBookModel!) -> WLBookModel! {
        let nextModel = bookModel.copyReadModel()
        // 当前页是本章的最后一页
        if nextModel.pageIndex >= nextModel.chapters[nextModel.chapterIndex].pages.count - 1 {
            // 判断当前章是否是最后一章
            if nextModel.chapterIndex >= nextModel.chapters.count - 1 {
                // 如果是最后一页，表明后面没了
                return nil
            }
           // 直接进入下一章的第一页
            nextModel.chapterIndex += 1
            if nextModel.chapters[nextModel.chapterIndex].pages.count == 0 {
                nextModel.paging(with: nextModel.chapterIndex)
            }
            nextModel.pageIndex = 0
        }else {// 说明不是最后一页，则直接到下一页
            nextModel.pageIndex += 1
        }
        return nextModel
    }
    /// 获取当前阅读的主页面
    func createCurrentReadController(bookModel:WLBookModel!) -> WLReadViewController? {
        // 提前预加载下一章，上一章数据
        if bookModel == nil {
            return nil
        }
        // 刷新阅读进度
        readerMenu.reloadReadProgress()
        // 刷新章节列表
        chapterListView.bookModel = bookModel
        // 如果不是滚动状态，则需要提前预加载上一章与下一章内容
        if WLBookConfig.shared.effetType != .scroll {
            let readVc = WLReadViewController()
            let chapterModel = bookModel.chapters[bookModel.chapterIndex]
            readVc.bookModel = bookModel
            readVc.chapterModel = chapterModel
            
            let nextIndex = bookModel.chapterIndex + 1
            let previousIndex = bookModel.chapterIndex - 1
            if nextIndex <= bookModel.chapters.count - 1 {
                bookModel.paging(with: nextIndex)
            }
            if previousIndex >= 0 {
                bookModel.paging(with: previousIndex)
            }
            self.readViewController = readVc
            readerMenu.readerViewController = readVc
            if WLNoteConfig.shared.currentChapterModel == nil || chapterModel.chapterIndex != WLNoteConfig.shared.currentChapterModel.chapterIndex {
                WLNoteConfig.shared.currentChapterModel = chapterModel
//                fetchNotesData()
            }
            return readVc
        }
        return nil
    }
    /// 获取背面阅读控制器，主要用于仿真翻页
    func createBackReadController(bookModel:WLBookModel!) -> WLReadBackController? {
        if WLBookConfig.shared.effetType == .pageCurl {
            if bookModel == nil {
                return nil
            }
            let vc = WLReadBackController()
            vc.targetView = createCurrentReadController(bookModel: bookModel)?.view
            return vc
        }
        return nil
    }
}
