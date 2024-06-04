//
//  WLChapterListView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/23.
//  章节列表

import UIKit
import SnapKit

@objc protocol WLChapterListViewDelegate: NSObjectProtocol {
    @objc optional func chapterListViewClickChapter(chapterListView:WLChapterListView, chapterModel:WLBookChapter)
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
            chapterList.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        return bookModel == nil ? 0 : bookModel.chapters.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WLChapterListCell.cell(tableView: tableView)
        cell.chapterModel = bookModel.chapters[indexPath.row]
        cell.isReadingCurrentChapter = bookModel.chapterIndex == indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.chapterListViewClickChapter?(chapterListView: self, chapterModel: bookModel.chapters[indexPath.row])
        chapterList.reloadData()
    }
}
