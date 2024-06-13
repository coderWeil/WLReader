//
//  WLReadViewController.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/13.
//  默认的阅读页面，带长按控制功能

import UIKit

class WLReadViewController: WLReadBaseController {
    /// 阅读模型
    var bookModel:WLBookModel! {
        didSet {
            bookModel.paging()
        }
    }
    /// 章节数据模型
    var chapterModel:WLBookChapter! {
        didSet {
            chapterModel.paging()
        }
    }
    
    var readView:WLReadView!
    private var numberPageView:WLReaderPageNumView!
    private var titleView:WLReaderTitleView!

    override func addChildViews() {
        super.addChildViews()
        createReadView()
        createPageNumberView()
        createTitleView()
    }
    /// 初始化阅读视图
    private func createReadView() { 
        if bookModel.pageIndex > chapterModel.pages.count - 1 {
            return
        }
        let pageModel = chapterModel.pages[bookModel.pageIndex]
        let readView = WLReadView(frame: CGRectMake(0, WL_NAV_BAR_HEIGHT, view.bounds.width, WLBookConfig.shared.readContentRect.size.height))
        readView.pageModel = pageModel
        self.readView = readView
        view.addSubview(readView)
    }
    /// 初始化页码视图
    private func createPageNumberView() {
        numberPageView = WLReaderPageNumView()
        numberPageView.frame = CGRectMake(0, view.bounds.height - WL_BOTTOM_HOME_BAR_HEIGHT - WL_READER_BOTTOM_PAGENUMBER_HEIGHT, view.bounds.width, WL_READER_BOTTOM_PAGENUMBER_HEIGHT)
        view.addSubview(numberPageView)
        numberPageView.totalPage = chapterModel.pages.count
        numberPageView.currentPage = bookModel.pageIndex + 1
    }
    private func createTitleView() {
        titleView = WLReaderTitleView()
        titleView.frame = CGRectMake(0, WL_STATUS_BAR_HEIGHT + 10, view.bounds.width, 30)
        view.addSubview(titleView)
        titleView.title = chapterModel.title
    }
}
