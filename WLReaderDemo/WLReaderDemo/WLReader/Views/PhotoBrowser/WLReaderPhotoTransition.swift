//
//  WLReaderPhotoTransition.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/9.
//

import UIKit

class WLReaderPhotoTransition: NSObject {
    /// 专场需要的图片
    var transitionImage:UIImage? {
        didSet {
            self.destFrame = self.backScreenImage(with: transitionImage!)
        }
    }
    /// 浏览图片的下标
    var transitionIndex:Int? {
        didSet {
            self.sourceFrame = self.sourceFrames![transitionIndex!]
        }
    }
    /// 图片的原始位置
    var sourceFrames:[CGRect]?
    /// 退出图片浏览的滑动手势
    var panGesture:UIPanGestureRecognizer?
    /// 退出时，当前滑动对应的frame
    var currentPanGestureFrame:CGRect?
    var sourceFrame:CGRect?
    var destFrame:CGRect?
    /// 是否开启弹簧效果
    var openSpring:Bool! = true
    /// 动画时长
    var duration:CGFloat! = 0.25
    
    private func backScreenImage(with image:UIImage!) -> CGRect? {
        let size = image.size
        var newSize = CGSize()
        if size.width > WL_SCREEN_WIDTH {
            newSize.width = WL_SCREEN_WIDTH
        }else {
            newSize.width = size.width
        }
        newSize.height = newSize.width / size.width * size.height
        var imageY = (WL_SCREEN_HEIGHT - newSize.height) * 0.5
        var imageX = (WL_SCREEN_WIDTH - newSize.width) * 0.5
        imageX = max(imageX, 0)
        imageY = max(imageY, 0)
        return CGRect(x: imageX, y: imageY, width: newSize.width, height: newSize.height)
    }
    
}
