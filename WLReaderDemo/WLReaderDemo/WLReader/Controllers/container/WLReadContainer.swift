//
//  WLReadContainer.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/13.
//  阅读器容器控制器

import UIKit
import Toast_Swift

class WLReadContainer: WLReadBaseController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, WLTranslationDelegate, WLReaderMenuProtocol, WLContainerDelegate, WLChapterListViewDelegate, WLReaderCoverControllerDelegate{
    /// 默认阅读主视图
    var readViewController:WLReadViewController!
    /// 滚动阅读视图
    var scrollReadController:WLReadScrollController!
    /// 阅读对象
    var bookModel:WLBookModel!
    /// 翻页控制器
    var pageController:WLReadPageController!
    /// 内容容器，实际承载阅读主视图的容器视图
    var container:WLContainerView!
    /// 用于区分仿真翻页的正反面
    var pageCurlNumber:Int! = 1
    /// 平移控制器
    var translationController:WLTranslationController?
    /// 覆盖控制器
    var coverController:WLReaderCoverController?
    /// 图书路径
    var bookPath:String!
    /// 图书解析类
    var bookParser:WLBookParser!
    /// 阅读菜单
    var readerMenu:WLReaderMenu!
    /// 章节列表
    var chapterListView:WLChapterListView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.isHidden = false
    }
    deinit {
        clearPageControllers()
        pageCurlNumber = 0
        // 取消当前下载
        WLFileManager.shared.suspend(filePath: bookPath)
        
    }
    override func viewDidLoad() {
        // 初始化数据库
        WLDataBase.shared.connectDB()
        super.viewDidLoad()
        readerMenu = WLReaderMenu(readerVc: self, delegate: self)
    }
    
    override func addChildViews() {
        super.addChildViews()
        // 添加容器
        container = WLContainerView()
        container.delegate = self
        view.addSubview(container)
        container.frame = view.bounds
        
        // 章节列表
        chapterListView = WLChapterListView()
        chapterListView.isHidden = true
        chapterListView.delegate = self
        view.addSubview(chapterListView)
        chapterListView.frame = CGRectMake(-WL_READER_CHAPTERLIST_WIDTH, 0, WL_READER_CHAPTERLIST_WIDTH, view.bounds.height)
        
        handleFile(bookPath)
    }
    /// 处理文件
    private func handleFile(_ path:String) {
        let exist = WLFileManager.fileExist(filePath: path)
        // 读取配置
        WLBookConfig.shared.readDB()
        chapterListView.updateMainColor()
        if !exist { // 表明没有下载并解压过，需要先下载, 下载成功之后获取下载的文件地址，进行解析
            downloadBook(path: path)
        }else {
            var fileName = path.lastPathComponent
            if path.hasPrefix("http") {
                let fileURL = URL(string: path)
                fileName = fileURL!.lastPathComponent
            }
            parseBook(path, fileName, removeEpub: path.hasPrefix("http"))
        }
    }
    // MARK - 下载书籍数据
    private func downloadBook(path:String) {
        WLFileManager.shared.sessionManager.progress {(manager) in
            print(manager.progress.totalUnitCount)
        }.completion { [weak self] manager in
            if manager.status == .succeeded {
                self?.view.hideToastActivity()
                var fileName = path.tr.md5
                if !path.pathExtension.isEmpty {
                    fileName += ".\(path.pathExtension)"
                }
                let filePath = manager.cache.filePath(fileName: fileName)!
                let fileURL = URL(string: path)
                let _fileName = fileURL!.lastPathComponent
                // 下载完成后解析
                self?.parseBook(filePath, _fileName, removeEpub: true)
                // 删除下载任务记录
                WLFileManager.shared.remove(filePath: path)
                print(filePath)
            }
        }
        view.makeToastActivity(.center)
        
        // 根据网络连接下载数据
        WLFileManager.shared.start(filePath: path)
    }
    /// 根据path进行解析,解析完成之后再添加阅读容器视图
    private func parseBook(_ path:String, _ fileName:String, removeEpub:Bool) {
        bookParser = WLBookParser(path, fileName, removeOrigin: removeEpub)
        bookParser.parseBook { [weak self] (bookModel, result) in
            if self == nil {
                return
            }
            if result {
                self!.bookModel = bookModel!
                // 需要从本地读取之间的阅读记录，将对应的章节和page的起始游标读取出来，根据起始游标来算出是本章节的第几页
                let chapterIndex = WLBookConfig.shared.currentChapterIndex!
                bookModel?.paging(with: chapterIndex)
                self!.bookModel.pageIndex = WLBookConfig.shared.currentPageIndex
                self!.bookModel.chapterIndex = chapterIndex
                self!.chapterListView.bookModel = bookModel
                WLBookConfig.shared.bottomProgressIsChapter = self!.bookModel.chapters.count > 1
                if bookModel?.chapters.count == 0 {
                    self!.showParserFaultPage()
                }else {
                    self!.showReadContainerView()
                }
            }else {
                self!.showParserFaultPage()
            }
        }
    }
    // MARK - 请求当前章节的笔记数据
    private func fetchNotesData() {
        
    }
    // MARK - 请求当前章节的书签数据
    private func fetchMarksData() {
        
    }
    /// 添加阅读容器视图
    private func showReadContainerView() {
        // 这里需要创建真正的阅读视图
        createPageViewController(displayReadController: createCurrentReadController(bookModel: bookModel))
    }
    /// 解析失败，展示解析失败页面
    private func showParserFaultPage() {
        
    }
    /// 是否显示章节列表
    func showChapterListView(show:Bool) {
        if show {
            chapterListView.isHidden = false
            chapterListView.chapterList.reloadData()
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.chapterListView.frame.origin.x = 0
                self.container.frame.origin.x = WL_READER_CHAPTERLIST_WIDTH
            }
            readerMenu.showMenu(show: false)
            container.showCover(show: true)
        }else {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.chapterListView.frame.origin.x = -WL_READER_CHAPTERLIST_WIDTH
                self.container.frame.origin.x = 0
            } completion: { finished in
                if finished {
                    self.chapterListView.isHidden = true
                }
            }
        }
    }
    func forceUpdateReader() {
        bookModel.chapters.forEach { item in
            item.forcePaging = true
        }
        createPageViewController(displayReadController: createCurrentReadController(bookModel: bookModel))
        // 刷新进度
        bookModel.pageIndex = WLBookConfig.shared.currentPageIndex
        createPageViewController(displayReadController: createCurrentReadController(bookModel: bookModel))
    }
    // MARK - WLContainerDelegate
    func didClickCover(container: WLContainerView) {
        showChapterListView(show: false)
    }
}
