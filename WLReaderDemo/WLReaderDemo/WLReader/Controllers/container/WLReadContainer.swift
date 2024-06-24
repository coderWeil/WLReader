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
        // 如果是网络地址
        if bookPath.hasPrefix("http") {
            // 取消当前下载
            WLFileManager.shared.suspend(filePath: bookPath)
        }
        // 要将本书籍对应的临时缓存笔记清空
        WLNoteConfig.clear()
        
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        // 初始化数据库
        WLDataBase.shared.connectDB()
        super.viewDidLoad()
        readerMenu = WLReaderMenu(readerVc: self, delegate: self)
        addNotifications()
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
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(toNextPage), name: .toNextPage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toPreviousPage), name: .toPreviousPage, object: nil)
        
    }
    @objc private func toNextPage() {
        gotoNextPage()
    }
    @objc private func toPreviousPage() {
        gotoPreviousPage()
    }
    /// 处理文件
    private func handleFile(_ path:String) {
        
        // 读取配置
        WLBookConfig.shared.readDB()
        chapterListView.updateMainColor()
        let exist = WLFileManager.fileExist(filePath: path)

        if !exist { // 不存在
            if path.hasPrefix("http") { // 网络地址
                downloadBook(path: path) // 下载
            }else {
               handleLocalFile(path)
            }
        }else { // 存在
            handleLocalFile(path)
        }
    }
    /// 处理本地文件
    private func handleLocalFile(_ path:String) {
        var fileName = ""
        if path.hasPrefix("http") {
            fileName = URL(string: path)!.lastPathComponent
        }else {
            fileName = URL(fileURLWithPath: path).lastPathComponent
        }
        parseBook(path, fileName, removeEpub: path.hasPrefix("http"))
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
                // 需要从本地读取之间的阅读记录，将对应的章节和page的起始游标读取出来，根据起始游标来算出是本章节的第几页
                bookModel?.read()
                let chapterIndex = bookModel!.chapterIndex!
                bookModel?.paging(with: chapterIndex)
                if bookModel!.markFinished { // 如果是手动标记读完，则需要标记章节index为最后一章，最后一页
                    bookModel!.chapterIndex = bookModel!.chapters.count - 1
                    let chapterModel = bookModel!.chapters[chapterIndex]
                    bookModel!.pageIndex = chapterModel.pages.count - 1
                }
                self!.chapterListView.bookModel = bookModel
                WLBookConfig.shared.bottomProgressIsChapter = bookModel!.chapters.count > 1
                self!.bookModel = bookModel!
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
    public func fetchNotesData() { // 请求完成之后需要刷新本章节的富文本，重新显示
        // 先读取本地数据，在获取网络数据
        let notes = WLNoteConfig.shared.readNotes()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            let chapterIndex = self.bookModel.chapterIndex
            WLNoteConfig.shared.removeNotes(chapteModel: self.bookModel.chapters[chapterIndex!])
            WLNoteConfig.shared.addNotes(notes: notes)
        }
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
    }
    // MARK - WLContainerDelegate
    func didClickCover(container: WLContainerView) {
        showChapterListView(show: false)
    }
}
