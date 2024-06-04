//
//  WLReadScrollController.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/13.
//  滚动阅读控制视图

import UIKit

class WLReadScrollController: WLReadBaseController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    private var tableView:WLReaderBaseTableView!
    /// 是否向上滚动，默认是true
    private var isScrollUp:Bool! = true
    /// 记录滚动坐标
    private var scrollPoint:CGPoint!
    /// 阅读主容器
    public weak var readerVc:WLReadContainer!
    var bookModel:WLBookModel! {
        didSet {
            getCurrentChapterPages()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func addChildViews() {
        super.addChildViews()
        
        tableView = WLReaderBaseTableView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height), style: .plain)
        tableView.contentInset = UIEdgeInsets(top: WL_NAV_BAR_HEIGHT, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        if bookModel != nil {
            tableView.scrollToRow(at: IndexPath(row: bookModel.pageIndex, section: bookModel.chapterIndex), at: .top, animated: false)
        }
    }
    // MARK - 获取当前章节的分页
    func getCurrentChapterPages() {
        // 当前章节
        let currentChapter = bookModel.chapters[bookModel.chapterIndex]
        currentChapter.paging()
        
        // 如果当前章节只有一页，则直接预加载下一章
        if currentChapter.pages.count <= 1 {
            getNextChapterPages()
        }
    }
    // MARK - 获取下一章分页
    func getNextChapterPages() {
        // 如果当前章是最后一章，且是最后一页，则没有下一章了
        let currentChapter = bookModel.chapters[bookModel.chapterIndex]
        if bookModel.chapterIndex == bookModel.chapters.count - 1, bookModel.pageIndex == currentChapter.pages.count {
            return
        }
        // 当前章的最后一页，则进行下一章加载
        if bookModel.pageIndex == currentChapter.pages.count - 1 {
            let nextIndex = bookModel.chapterIndex + 1
            if nextIndex < bookModel.chapters.count {
                let nextChapter = bookModel.chapters[nextIndex]
                if nextChapter.pages.count == 0 {
                    nextChapter.paging()
                    if let tableView = tableView {
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    // MARK - 获取上一章分页
    func getPreviousChapterPages() {
        // 如果当前章是第一章，且是第一页，则往前就没有了
        if bookModel.chapterIndex == 0 && bookModel.pageIndex == 0 {
            return
        }
        // 如果当前页是当前章的第一页，则需要预加载上一章
        if bookModel.pageIndex == 0 {
            let previousIndex = bookModel.chapterIndex - 1
            if previousIndex >= 0 {
                let previousChapter = bookModel.chapters[previousIndex]
                if previousChapter.pages.count == 0 {
                    previousChapter.paging()
                    if let tableView = tableView {
                        CATransaction.begin()
                        CATransaction.setDisableActions(true)
                        tableView.reloadData()
                        CATransaction.commit()
                    }
                }
            }
        }
    }
    private func updateReadRecord(_ isScrollingUp:Bool) {
        let indexPaths = tableView.indexPathsForVisibleRows
        DispatchQueue.global().async { [weak self] in
            if indexPaths != nil && !indexPaths!.isEmpty {
                let indexPath:IndexPath = isScrollingUp ? indexPaths!.last! : indexPaths!.first!
                self?.bookModel.chapterIndex = indexPath.section
                self?.bookModel.pageIndex = indexPath.row
                let chapterModel = self?.bookModel.chapters[indexPath.section]
                let pageModel = chapterModel?.pages[indexPath.row]
                WLBookConfig.shared.currentChapterIndex = indexPath.section
                WLBookConfig.shared.currentPageIndex = indexPath.row
                WLBookConfig.shared.currentPageLocation = pageModel?.pageStartLocation
                WLBookConfig.shared.save()
                // 刷新记录呀
                DispatchQueue.main.async {
                    self?.readerVc.readerMenu.reloadReadProgress()
                }
            }
        }
    }
}

extension WLReadScrollController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return bookModel.chapters.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let chapterModel = bookModel.chapters[section]
        return chapterModel.pages.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chapterModel = bookModel.chapters[indexPath.section]
        let pageModel = chapterModel.pages[indexPath.row]
        return pageModel.contentHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chapterModel = bookModel.chapters[indexPath.section]
        let pageModel = chapterModel.pages[indexPath.row]
        let cell = WLScrollReadCell.cell(tableView)
        cell.pageModel = pageModel
        return cell
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrollUp = true
        scrollPoint = .zero
        readerVc.readerMenu.showMenu(show: false)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateReadRecord(isScrollUp)
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        updateReadRecord(isScrollUp)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateReadRecord(isScrollUp)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollPoint == nil { return }
        
        let point = scrollView.panGestureRecognizer.translation(in: scrollView)
        
        if point.y < scrollPoint.y { // 上滚
            
            isScrollUp = true
            getNextChapterPages()
            
        }else if point.y > scrollPoint.y { // 下滚
            
            isScrollUp = false
            getPreviousChapterPages()
        }
        // 记录坐标
        scrollPoint = point
    }
    
}
