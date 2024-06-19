//
//  WLReaderContainer+Simulatiion.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/31.
//

import UIKit

extension WLReadContainer {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        readViewController = pageViewController.viewControllers?.first as? WLReadViewController
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
    /// 上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        readerMenu.showMenu(show: false)
        let previousModel = getPreviousModel(bookModel: bookModel)
        if WLBookConfig.shared.effetType == .pageCurl { // 仿真
            pageCurlNumber -= 1
            if abs(pageCurlNumber) % 2 == 0 {
                return createBackReadController(bookModel: previousModel)
            }
            return createCurrentReadController(bookModel: previousModel)
        }
        return createCurrentReadController(bookModel: previousModel)
    }
    /// 下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        readerMenu.showMenu(show: false)
        if WLBookConfig.shared.effetType == .pageCurl { // 仿真
            pageCurlNumber += 1
            if abs(pageCurlNumber) % 2 == 0 {
                return createBackReadController(bookModel: bookModel)
            }
            let nextModel = getNextModel(bookModel: bookModel)
            return createCurrentReadController(bookModel: nextModel)
        }
        let nextModel = getNextModel(bookModel: bookModel)
        return createCurrentReadController(bookModel: nextModel)
    }
}
