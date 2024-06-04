//
//  WLReaderShareController.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/1.
//

import UIKit

class WLReaderShareController: WLReadBaseController {
    /// 顶部生成的可滚动查看的图片，图片包含本页所有内容，读者的头像，名称，推荐，和二维码
    private var contentView:WLShareContentView!
    /// 底部需要弹出分享到微信，朋友圈，保存相册，分享到其他的弹层
    private var panelView:WLSharePanelView!
    override func addChildViews() {
        super.addChildViews()
    }
    
}
