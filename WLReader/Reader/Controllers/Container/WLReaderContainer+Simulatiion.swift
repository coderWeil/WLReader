//
//  WLReaderContainer+Simulatiion.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/31.
//  仿真翻页

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
            bookModel.currentPageStartLocation = pageModel.pageStartLocation
            bookModel.currentPageEndLocation = pageModel.pageEndLocation
            bookModel.save()
            WLBookConfig.shared.bookModel = bookModel
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
    func pageViewController(_ pageViewController: WLReadPageController, getViewControllerAfter viewController: UIViewController!) {
        // 获取下一页
        let nextModel = getNextModel(bookModel: bookModel)
        let readVC = createCurrentReadController(bookModel: nextModel)
        
        // 手动设置
        setViewController(displayController:readVC, isAbove: false, animated: true)
        
        bookModel = readViewController.bookModel
        let chapterModel = bookModel.chapters[bookModel.chapterIndex]
        let pageModel = chapterModel.pages[bookModel.pageIndex]
        bookModel.currentPageStartLocation = pageModel.pageStartLocation
        bookModel.currentPageEndLocation = pageModel.pageEndLocation
        bookModel.save()
        WLBookConfig.shared.bookModel = bookModel
        readerMenu.updateTopView()
        
        readerMenu.showMenu(show: false)
    }
    func pageViewController(_ pageViewController: WLReadPageController, getViewControllerBefore viewController: UIViewController!) {
        let previousModel = getPreviousModel(bookModel: bookModel)
        let readVC = createCurrentReadController(bookModel: previousModel)
        // 手动设置
        setViewController(displayController: readVC, isAbove: true, animated: true)
        
        bookModel = readViewController.bookModel
        let chapterModel = bookModel.chapters[bookModel.chapterIndex]
        let pageModel = chapterModel.pages[bookModel.pageIndex]
        bookModel.currentPageStartLocation = pageModel.pageStartLocation
        bookModel.currentPageEndLocation = pageModel.pageEndLocation
        bookModel.save()
        WLBookConfig.shared.bookModel = bookModel
        readerMenu.updateTopView()
        
        readerMenu.showMenu(show: false)
    }
    
    func showMenu(_ pageViewController: WLReadPageController) {
        readerMenu.showMenu(show: !readerMenu.isMenuShow)
    }
    
    /// 手动设置翻页(注意: 非滚动模式调用)
    func setViewController(displayController:WLReadViewController!, isAbove:Bool, animated:Bool) {
        
        if displayController != nil {
            // 仿真
            if pageController != nil {
                if (WLBookConfig.shared.effetType == .translation) { // 平移
                    let direction:UIPageViewController.NavigationDirection = isAbove ? .reverse : .forward
                    pageController.setViewControllers([displayController], direction: direction, animated: animated, completion: nil)
                    
                } else { // 仿真
                    
                    let direction:UIPageViewController.NavigationDirection = isAbove ? .reverse : .forward
                    pageController.setViewControllers([displayController,
                                                        createBackReadController(bookModel: displayController.bookModel)!],
                                                     direction: direction, animated: animated, completion: nil)
                }
                return
            }
            // 覆盖 无效果
            if coverController != nil {
                coverController?.setController(controller: displayController!, animated: animated, isAbove: isAbove)
                
                return
            }
            // 记录
            readViewController = displayController
        }
    }
}
