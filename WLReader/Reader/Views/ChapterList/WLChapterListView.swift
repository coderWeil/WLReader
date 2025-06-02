//
//  WLChapterListView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/23.
//  章节列表

import UIKit
import SnapKit

@objc protocol WLChapterListViewDelegate: NSObjectProtocol {
    @objc optional func chapterListViewClickChapter(chapterListView:WLChapterListView, catalogueModel:WLBookCatalogueModel)
}

class WLChapterListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    /// 章节列表
    public var chapterList:WLReaderBaseTableView!
    /// 书签列表
    private var markList:UITableView!
    /// 代理
    public weak var delegate:WLChapterListViewDelegate?
    /// 书籍数据

    public var bookModel:WLBookModel! {
        didSet {
            self.catalogues.removeAll()
            generateCatalogues(items: bookModel.catalogues)
            chapterList.reloadData()
        }
    }
    // 书籍目录
    private var catalogues:[WLBookCatalogueModel]! = [WLBookCatalogueModel]()
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 处理目录数据
    private func generateCatalogues(items:[WLBookCatalogueModel]!) {
        for (_, item) in items.enumerated() {
            self.catalogues.append(item)
            if let child = item.children {
                generateCatalogues(items: child)
            }
        }
    }
    
    // MARK - 添加子视图
    private func addSubviews() {
        backgroundColor = WL_READER_BG_COLOR
        chapterList = WLReaderBaseTableView(frame: .zero, style: .plain)
        chapterList.contentInset = UIEdgeInsets(top: WL_NAV_BAR_HEIGHT, left: 0, bottom: 0, right: 0)
        chapterList.showsVerticalScrollIndicator = false
        chapterList.showsHorizontalScrollIndicator = false
        chapterList.delegate = self
        chapterList.dataSource = self
        chapterList.separatorStyle = .singleLine
        chapterList.separatorColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.5)
        chapterList.backgroundColor = .clear
        addSubview(chapterList)
        
        chapterList.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(0)
            make.right.equalTo(-WL_READER_HORIZONTAL_MARGIN)
        }
    }
    public func updateMainColor() {
        backgroundColor = WL_READER_BG_COLOR
        chapterList.reloadData()
    }
}

extension WLChapterListView {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogues.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WLChapterListCell.cell(tableView: tableView)
        let catalogueModel = catalogues[indexPath.row]
        cell.catalogueModel = catalogueModel
        if catalogueModel.level == 0 {
            cell.isReadingCurrentChapter = bookModel.chapterIndex == catalogues[indexPath.row].chapterIndex
        }else {            
            cell.isReadingCurrentChapter = (bookModel.chapterIndex == catalogueModel.chapterIndex &&
                                            bookModel.pageIndex >= catalogueModel.pageIndexRange.location &&
                                            bookModel.pageIndex <= catalogueModel.pageIndexRange.location + catalogueModel.pageIndexRange.length)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let catalogue = catalogues[indexPath.row]
        delegate?.chapterListViewClickChapter?(chapterListView: self, catalogueModel: catalogue)
        chapterList.reloadData()
    }
}
