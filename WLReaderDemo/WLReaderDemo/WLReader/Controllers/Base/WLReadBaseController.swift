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
        setupCustomBackButton()
    }
    /// 添加子视图，由子类去实现
    public func addChildViews() {}
    /// 更新阅读视图的背景图
    public func updateBackground() {
        view.backgroundColor = WL_READER_BG_COLOR
    }
    private func setupCustomBackButton() {
        self.navigationItem.hidesBackButton = true // 隐藏系统默认的返回按钮
       let backButton = UIButton(type: .system)
       backButton.setImage(UIImage(named: "reader_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
       backButton.sizeToFit()
        backButton.tintColor = WL_READER_TEXT_COLOR
       backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

       let leftBarButtonItem = UIBarButtonItem(customView: backButton)
       self.navigationItem.leftBarButtonItem = leftBarButtonItem
       
   }

   @objc private func backButtonTapped() {
       self.navigationController?.popViewController(animated: true)
   }
}
