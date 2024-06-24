//
//  WLReaderContainer+Cover.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/31.
//  覆盖翻页

import UIKit

extension WLReadContainer {
    func coverGetPreviousController(coverController: WLReaderCoverController, currentController: UIViewController?) -> UIViewController? {
        return getAboveReadViewController()
    }
    func coverGetNextController(coverController: WLReaderCoverController, currentController: UIViewController?) -> UIViewController? {
        return getBelowReadViewController()
    }
    func coverWillTransition(coverController: WLReaderCoverController, pendingController: UIViewController?) {
        readerMenu.showMenu(show: false)
    }
    func coverFinished(coverController: WLReaderCoverController, currentVc: UIViewController?, finished: Bool) {
        readViewController = currentVc as? WLReadViewController
        // 更新当前阅读记录
        if readViewController != nil {
            bookModel = readViewController.bookModel
            let chapterModel = bookModel.chapters[bookModel.chapterIndex]
            let pageModel = chapterModel.pages[bookModel.pageIndex]
            bookModel.currentPageLocation = pageModel.pageStartLocation
            bookModel.save()
            readerMenu.updateTopView()
        }
    }
}
