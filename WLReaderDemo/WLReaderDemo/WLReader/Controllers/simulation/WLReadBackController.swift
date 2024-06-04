//
//  WLReadBackController.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/14.
//  仿真翻页的背面

import UIKit

class WLReadBackController: WLReadBaseController {
    /// 背景图片
    private var backImageView:UIImageView!
    /// 目标视图
    var targetView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backImageView = UIImageView(frame: view.bounds)
        backImageView.backgroundColor = WL_READER_BG_COLOR
        view.addSubview(backImageView)
        drawTargetBack()
    }
    /// 绘制目标视图的反面
    private func drawTargetBack() {
        // 展示图片
        if targetView != nil {
            let rect = targetView.frame
            UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
            let context = UIGraphicsGetCurrentContext()
            let transform = CGAffineTransform(a: -1.0, b: 0.0, c: 0.0, d: 1.0, tx: rect.size.width, ty: 0.0)
            context?.concatenate(transform)
            targetView.layer.render(in: context!)
            backImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
}
