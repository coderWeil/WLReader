//
//  WLReadBaseController.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/13.
//

import UIKit

class WLReadBaseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) { } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        updateBackground()
        addChildViews()
    }
    /// 添加子视图，由子类去实现
    public func addChildViews() {}
    /// 更新阅读视图的背景图
    public func updateBackground() {
        view.backgroundColor = WL_READER_BG_COLOR
    }
}
