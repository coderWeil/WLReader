//
//  WLReaderMenuBaseView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/25.
//

import UIKit

class WLReaderMenuBaseView: UIView {
    weak var menu:WLReaderMenu!
    /// 系统初始化
    override init(frame: CGRect) { super.init(frame: frame) }
    /// 初始化
    convenience init(menu:WLReaderMenu!) {
        self.init(frame: CGRect.zero)
        self.menu = menu
        addSubviews()
    }
    func addSubviews() {
        backgroundColor = WL_READER_MENU_BG_COLOR
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
