//
//  WLReaderContainer+ChapterList.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/26.
//  章节列表

import UIKit

extension WLReadContainer {
    // MARK - WLChapterListViewDelegate
    func chapterListViewClickChapter(chapterListView: WLChapterListView, catalogueModel: WLBookCatalogueModel) {
        // 将章节列表和cover都去掉
        showChapterListView(show: false)
        container.showCover(show: false)
        // 先看下点击的是否是二级标题
        if catalogueModel.level == 0 {
            if bookModel.chapterIndex == catalogueModel.chapterIndex {
                return
            }
            goToChapter(chapterIndex: catalogueModel.chapterIndex, toPage: 0)
            return
        }
        // 二级
        if let pageIndex = catalogueModel.pageChapterIndex {
            if catalogueModel.chapterIndex == bookModel.chapterIndex {
                if pageIndex == bookModel.pageIndex {
                    return
                }
                goToChapter(chapterIndex: catalogueModel.chapterIndex, toPage: pageIndex)
                return
            }
            goToChapter(chapterIndex: catalogueModel.chapterIndex, toPage: 0)
        }else {
            if catalogueModel.chapterIndex == bookModel.chapterIndex {
                
                return
            }
            goToChapter(chapterIndex: catalogueModel.chapterIndex, toPage: 0)
        }
    }
    func chapterListViewClickChapter(chapterListView: WLChapterListView, chapterModel: WLBookChapter) {
        // 将章节列表和cover都去掉
        showChapterListView(show: false)
        container.showCover(show: false)
        // 判断点击的章节是否是阅读的章节
        if chapterModel.chapterIndex == bookModel.chapterIndex {
            return
        }
        goToChapter(chapterIndex: chapterModel.chapterIndex, toPage: 0)
    }

}
