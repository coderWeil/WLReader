//
//  WLReadContainer+Transition.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/22.
//

import UIKit

extension WLReadContainer {
    
    /// 获取上一页控制器
    func getAboveReadViewController() ->UIViewController? {
        let recordModel = getPreviousModel(bookModel: bookModel)
        if recordModel == nil { return nil }
        return createCurrentReadController(bookModel: recordModel)
    }
    /// 获取下一页控制器
    func getBelowReadViewController() ->UIViewController? {
        
        let recordModel = getNextModel(bookModel: bookModel)
        
        if recordModel == nil { return nil }
        
        return createCurrentReadController(bookModel: recordModel)
    }
    
    func translationController(with translationController: WLTranslationController, controllerBefore controller: UIViewController) -> UIViewController? {
        readerMenu.showMenu(show: false)
        return getAboveReadViewController()
    }
    
    func translationController(with translationController: WLTranslationController, controllerAfter controller: UIViewController) -> UIViewController? {
        return getBelowReadViewController()
    }
    func translationController(translationController: WLTranslationController, didFinishAnimating finished: Bool, previousController: UIViewController, transitionCompleted completed: Bool) {
        readViewController = translationController.children.first as? WLReadViewController
        if readViewController != nil {
            bookModel = readViewController.bookModel
            let chapterModel = bookModel.chapters[bookModel.chapterIndex]
            let pageModel = chapterModel.pages[bookModel.pageIndex]
            bookModel.currentPageLocation = pageModel.pageStartLocation
            bookModel.save()
            readerMenu.updateTopView()
        }
    }
    func translationController(with translationController: WLTranslationController, willTransitionTo controller:UIViewController) -> Void {
        
    }
}
