//
//  WLReadContainer+Page.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/14.
//  分页管理器的回调代理

import UIKit

extension WLReadContainer {
    /// 创建page容器
    func createPageViewController(displayReadController:WLReadViewController? = nil) {
        clearPageControllers()
        let bookConfig = WLBookConfig.shared
        if bookConfig.effetType == .pageCurl { // 仿真
            let options = [UIPageViewController.OptionsKey.spineLocation : NSNumber(value: UIPageViewController.SpineLocation.min.rawValue)]
            pageController = WLReadPageController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: options)
            container.insertSubview(pageController.view, at: 0)
            pageController.view.backgroundColor = .clear
            pageController.view.frame = container.bounds
            // 翻页背部带文字效果
            pageController.isDoubleSided = true
            pageController.delegate = self
            pageController.dataSource = self
            pageController.setViewControllers(displayReadController == nil ? nil : [displayReadController!], direction: .forward, animated: true)
        }else if bookConfig.effetType == .translation {// 平移
            translationController = WLTranslationController()
            translationController?.delegate = self
            translationController?.allowAnimation = true
            translationController?.view.frame = container.bounds
            container.insertSubview(translationController!.view, at: 0)
            translationController?.readerVc = self
            translationController?.setViewController(controller: displayReadController!, scrollDirection: .left, animated: true, completionHandler: nil)
        }else if bookConfig.effetType == .scroll {// 滚动
            scrollReadController = WLReadScrollController()
            scrollReadController.readerVc = self
            scrollReadController.bookModel = bookModel
            scrollReadController.view.frame = container.bounds
            container.insertSubview(scrollReadController.view, at: 0)
            addChild(scrollReadController)
        }else if bookConfig.effetType == .cover {// 覆盖
            if displayReadController == nil {
                return
            }
            coverController = WLReaderCoverController()
            coverController?.delegate = self
            container.insertSubview(coverController!.view, at: 0)
            coverController!.view.frame = container.bounds
            coverController?.readerVc = self
            coverController!.setController(controller: displayReadController)
            
        }else if bookConfig.effetType == .no {// 无效果
            if displayReadController == nil {
                return
            }
            coverController = WLReaderCoverController()
            coverController?.delegate = self
            container.insertSubview(coverController!.view, at: 0)
            coverController!.view.frame = container.bounds
            coverController?.openAnimate = false
            coverController?.readerVc = self
            coverController!.setController(controller: displayReadController)
        }
        readerMenu.updateTopView()
    }
 
    /// 清理
    public func clearPageControllers() {
        readViewController?.removeFromParent()
        readViewController = nil
        pageCurlNumber = 1
        if pageController != nil {
            pageController.view.removeFromSuperview()
            pageController.removeFromParent()
            pageController = nil
        }
        if scrollReadController != nil {
            scrollReadController.view.removeFromSuperview()
            scrollReadController.removeFromParent()
            scrollReadController = nil
        }
        if coverController != nil {
            coverController?.view.removeFromSuperview()
            coverController?.removeFromParent()
            coverController = nil
        }
        if translationController != nil {
            translationController?.view.removeFromSuperview()
            translationController?.removeFromParent()
            translationController = nil
        }
    }
    // MARK - 跳转到指定章节
    func goToChapter(chapterIndex:Int, toPage:Int = 0) {
        bookModel.chapterIndex = chapterIndex
        bookModel.pageIndex = toPage
        // 检查章节内容是否存在
        let chapterModel = bookModel.chapters[chapterIndex]
        if let content = chapterModel.chapterContentAttr, content.length > 0 {
            // 检查页面是否分页过
            let pages = chapterModel.pages
            if pages?.count == 0 {
                bookModel.paging()
            }
        }else {// 表示之前没有分页，且没有读取章节内容
            bookModel.paging()
        }
        // 创建显示阅读器
        createPageViewController(displayReadController: createCurrentReadController(bookModel: bookModel))
    }
    /// 手动跳转到上一页
    
    /// 手动跳转到下一页
}
