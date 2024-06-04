//
//  WLScrollReadCell.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/23.
//

import UIKit
import DTCoreText

class WLScrollReadCell: UITableViewCell {
    static let WLScrollReadCellIdentifier = "WLScrollReadCellIdentifier"

    private var contentTextView:DTAttributedTextView!
  
    var pageModel:WLBookPage! {
        didSet {
            contentTextView.attributedString = pageModel.content
        }
    }
    class func cell(_ tableView:UITableView) -> WLScrollReadCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: WLScrollReadCell.WLScrollReadCellIdentifier)
        if cell == nil {
            cell = WLScrollReadCell.init(style: .default, reuseIdentifier: WLScrollReadCell.WLScrollReadCellIdentifier)
        }
        return cell as! WLScrollReadCell
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }
    private func addSubviews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentTextView = DTAttributedTextView()
        contentTextView.shouldDrawImages = true
        contentTextView.shouldDrawLinks = true
        contentTextView.isScrollEnabled = false
        contentTextView.backgroundColor = .clear
        contentView.addSubview(contentTextView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentTextView.frame = CGRectMake(10, 0, contentView.bounds.width - 20, pageModel.contentHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
