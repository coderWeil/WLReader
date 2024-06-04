//
//  WLChapterListCell.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/25.
//

import UIKit
import SnapKit

class WLChapterListCell: UITableViewCell {
    static let WLChapterListCellIdentifier = "WLChapterListCellIdentifier"
    
    private var chapterNameLabel:UILabel!
    public var chapterModel:WLBookChapter! {
        didSet {
            chapterNameLabel.text = chapterModel.title
        }
    }
    /// 当前是否在读章节
    public var isReadingCurrentChapter:Bool! {
        didSet {
            chapterNameLabel.textColor = isReadingCurrentChapter ? WL_READER_SLIDER_MINTRACK : WL_READER_TEXT_COLOR
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public class func cell(tableView:UITableView) -> WLChapterListCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: WLChapterListCell.WLChapterListCellIdentifier)
        if cell == nil {
            cell = WLChapterListCell(style: .default, reuseIdentifier: WLChapterListCell.WLChapterListCellIdentifier)
        }
        return cell as! WLChapterListCell
    }
    private func addSubviews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        chapterNameLabel = UILabel()
        chapterNameLabel.font = WL_READER_FONT_14
        chapterNameLabel.textColor = WL_READER_TEXT_COLOR
        contentView.addSubview(chapterNameLabel)
        
        chapterNameLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
}
