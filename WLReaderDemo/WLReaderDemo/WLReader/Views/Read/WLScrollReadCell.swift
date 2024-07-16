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

    private var contentTextView:WLAttributedView!
  
    var pageModel:WLBookPage! {
        didSet {
            contentTextView.attributedString = pageModel.content
            contentTextView.contentRange = pageModel.contentRange
            contentTextView.reloadNotes()
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
        selectionStyle = .none
        contentTextView = WLAttributedView()
        contentTextView.shouldDrawImages = false
        contentTextView.shouldDrawLinks = true
        contentTextView.backgroundColor = .clear
        contentTextView.edgeInsets = UIEdgeInsets(top: 0, left: WLBookConfig.shared.readerEdget, bottom: 0, right: WLBookConfig.shared.readerEdget)
        contentView.addSubview(contentTextView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentTextView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
