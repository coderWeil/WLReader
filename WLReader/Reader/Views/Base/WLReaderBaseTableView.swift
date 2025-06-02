//
//  WLReaderBaseTableView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/25.
//

import UIKit

class WLReaderBaseTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = UIColor.clear
        separatorStyle = .none
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
            estimatedRowHeight = 0
            estimatedSectionFooterHeight = 0
            estimatedSectionHeaderHeight = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
