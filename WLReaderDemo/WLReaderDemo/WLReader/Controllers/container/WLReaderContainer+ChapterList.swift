//
//  WLReaderContainer+ChapterList.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/26.
//

import UIKit

extension WLReadContainer {
    // MARK - WLChapterListViewDelegate
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
