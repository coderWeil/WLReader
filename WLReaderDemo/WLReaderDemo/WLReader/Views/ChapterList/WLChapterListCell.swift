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
    public var catalogueModel:WLBookCatalogueModel! {
        didSet {
            chapterNameLabel.text = catalogueModel.catalogueName
            chapterNameLabel.snp.updateConstraints { make in
                make.left.equalTo((catalogueModel.level == 0 ? 20 : 40))
            }
        }
    }
    /// 当前是否在读章节
    public var isReadingCurrentChapter:Bool! {
        didSet {
            chapterNameLabel.textColor = isReadingCurrentChapter ? WL_READER_SLIDER_MINTRACK : (catalogueModel.level == 0 ? WL_READER_TEXT_COLOR : WL_READER_TEXT_COLOR.withAlphaComponent(0.6))
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
