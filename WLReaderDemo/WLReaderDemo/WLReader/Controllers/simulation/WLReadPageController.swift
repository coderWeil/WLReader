//
//  WLReadPageController.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/13.
//  翻页控制器容器,仿真翻页

import UIKit

// 左边上一页点击区域
private let LeftWidth:CGFloat = WL_SCREEN_WIDTH / 3

// 右边下一页点击区域
private let RightWidth:CGFloat = WL_SCREEN_WIDTH / 3

@objc protocol WLReadPageControllerDelegate: NSObjectProtocol {
    
    /// 获取上一页
    @objc optional func pageViewController(_ pageViewController: WLReadPageController, getViewControllerBefore viewController: UIViewController!)
    
    /// 获取下一页
    @objc optional func pageViewController(_ pageViewController: WLReadPageController, getViewControllerAfter viewController: UIViewController!)
    
    @objc optional func showMenu(_ pageViewController: WLReadPageController)
}

class WLReadPageController: UIPageViewController, UIGestureRecognizerDelegate {
    
    // 自定义tap手势的相关代理
    weak var aDelegate:WLReadPageControllerDelegate?
    
    // 自定义Tap手势
    public var customTapGestureRecognizer: UITapGestureRecognizer!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        tapGestureRecognizerEnabled = false
        
        customTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchTap(tap:)))

        customTapGestureRecognizer.delegate = self

        view.addGestureRecognizer(customTapGestureRecognizer)
        
        // 寻找并设置手势识别器代理
        for recognizer in gestureRecognizers {
            if let panGestureRecognizer = recognizer as? UIPanGestureRecognizer {
                panGestureRecognizer.delegate = self
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(readViewLongPress(notify:)), name: .readViewLongPress, object: nil)

    }
    
    @objc func readViewLongPress(notify:Notification) {
        let gest = notify.userInfo!["longPress"] as! UILongPressGestureRecognizer
        customTapGestureRecognizer.require(toFail: gest)
        
    }
    // tap事件
    @objc func touchTap(tap: UIGestureRecognizer) {
        
        let touchPoint = tap.location(in: view)
        
        if (touchPoint.x < LeftWidth) { // 左边
            
            aDelegate?.pageViewController?(self, getViewControllerBefore: viewControllers?.first)
            
        }else if (touchPoint.x > (WL_SCREEN_WIDTH - RightWidth)) { // 右边
            
            aDelegate?.pageViewController?(self, getViewControllerAfter: viewControllers?.first)
        }else {
            // 中间的话需要显示和隐藏菜单
            aDelegate?.showMenu?(self)
        }
    }
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if (gestureRecognizer.isKind(of: UITapGestureRecognizer.classForCoder()) && gestureRecognizer.isEqual(customTapGestureRecognizer)) {
            let touchPoint = customTapGestureRecognizer.location(in: view)
            if (touchPoint.x > LeftWidth && touchPoint.x < (WL_SCREEN_WIDTH - RightWidth)) {
                return true
            }
        }

        return false
    }

    // 下面这几个方法是为了处理pan手势向上的时候
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGesture.translation(in: self.view)
            // 禁用垂直方向上的滑动手势
            if abs(translation.y) > abs(translation.x) {
                return false
            }
        }
        return true
    }
}
