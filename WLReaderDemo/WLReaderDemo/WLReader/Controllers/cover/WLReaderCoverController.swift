//
//  WLReaderCoverController.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/26.
//

import UIKit

@objc protocol WLReaderCoverControllerDelegate: NSObjectProtocol {
    /// 切换是否完成
    @objc optional func coverFinished(coverController:WLReaderCoverController, currentVc:UIViewController?, finished:Bool)
    /// 将要显示的控制器
    @objc optional func coverWillTransition(coverController:WLReaderCoverController, pendingController:UIViewController?)
    /// 获取上一个控制器
    @objc optional func coverGetPreviousController(coverController:WLReaderCoverController, currentController:UIViewController?) -> UIViewController?
    /// 获取下一个控制器
    @objc optional func coverGetNextController(coverController:WLReaderCoverController, currentController:UIViewController?) -> UIViewController?
}

enum WLCoverTapDirection {
    case left
    case right
}

class WLReaderCoverController: WLReadBaseController, UIGestureRecognizerDelegate {
    
    public weak var delegate:WLReaderCoverControllerDelegate?
    /// 手势启用状态, 默认是ture
    public var gestureRecognizerEnabled:Bool! {
        didSet {
            self.pan.isEnabled = gestureRecognizerEnabled
            self.tapGestureRecognizerEnabled = gestureRecognizerEnabled
        }
    }
    /// tap手势启用状态, 默认是true
    public var tapGestureRecognizerEnabled:Bool! {
        didSet {
            self.tap.isEnabled = tapGestureRecognizerEnabled
        }
    }
    /// 当前手势操作是否带动画效果，默认是true
    public var openAnimate:Bool! = true
    /// 当前控制器
    public var currentController:UIViewController?
    /// 左右拖动手势
    private var pan:UIPanGestureRecognizer!
    /// 点击手势
    private var tap:UITapGestureRecognizer!
    /// 手势触发点是否在左边
    private var isLeft:Bool! = false
    /// 是否执行pan手势
    private var  isPan:Bool! = false
    /// 手势是否重新开始识别
    private var isPanBegin:Bool! = false
    /// 动画状态
    private var isAnimateChange:Bool! = false
    /// 临时控制器
    private var pendingController:UIViewController?
    /// 移动中的触摸位置
    private var moveTouchPoint:CGPoint!
    /// 移动中的差值
    private var moveSpaceX:CGFloat! = 0
    weak var readerVc:WLReadContainer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didInit()
    }
    
    private func didInit() {
        pan = UIPanGestureRecognizer(target: self, action: #selector(touchPan(pan:)))
        tap = UITapGestureRecognizer(target: self, action: #selector(touchTap(tap:)))
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(pan)
        tap.delegate = self
        view.layer.masksToBounds = true
        gestureRecognizerEnabled = true
        tapGestureRecognizerEnabled = true
    }
    
    private func getPanController(touchPoint:CGPoint) -> UIViewController? {
        var controller:UIViewController? = nil
        if touchPoint.x > 0 {
            isLeft = true
            controller = delegate?.coverGetPreviousController?(coverController: self, currentController: currentController)
        }else {
            isLeft = false
            controller = delegate?.coverGetNextController?(coverController: self, currentController: currentController)
        }
        if controller == nil {
            isAnimateChange = false
        }
        return controller
    }
    
    private func getTapController(touchPoint:CGPoint) -> UIViewController? {
        var controller:UIViewController? = nil
        if touchPoint.x < WL_SCREEN_WIDTH / 3.0 {
            isLeft = true
            controller = delegate?.coverGetPreviousController?(coverController: self, currentController: currentController)
        }else if touchPoint.x > WL_SCREEN_WIDTH - WL_SCREEN_WIDTH / 3.0 {
            isLeft = false
            controller = delegate?.coverGetNextController?(coverController: self, currentController: currentController)
        }
        if controller == nil {
            isAnimateChange = false
        }
        return controller
    }
    private func addController(vc:UIViewController?) {
        if let controller = vc {
            addChild(controller)
            if isLeft {
                view.addSubview(controller.view)
                controller.view.frame = CGRectMake(-WL_SCREEN_WIDTH, 0, WL_SCREEN_WIDTH, WL_SCREEN_HEIGHT)
            }else {
                if let cur = currentController {
                    view.insertSubview(controller.view, belowSubview: cur.view)
                }else {
                    view.addSubview(controller.view)
                }
                controller.view.frame = CGRectMake(0, 0, WL_SCREEN_WIDTH, WL_SCREEN_HEIGHT)
            }
            addShadow(vc: controller)
        }
    }
    private func addShadow(vc:UIViewController!) {
        vc.view.layer.shadowColor = UIColor.black.cgColor; // 阴影颜色
        vc.view.layer.shadowOffset = CGSizeMake(0, 0); // 偏移距离
        vc.view.layer.shadowOpacity = 0.5; // 不透明度
        vc.view.layer.shadowRadius = 10.0; // 半径
    }
    
    private func animateSuccess(success:Bool) {
        if success {
            currentController?.view.removeFromSuperview()
            currentController?.removeFromParent()
            currentController = pendingController
            pendingController = nil
            isAnimateChange = false
        }else {
            pendingController?.view.removeFromSuperview()
            pendingController?.removeFromParent()
            pendingController = nil
            isAnimateChange = false
        }
        delegate?.coverFinished?(coverController: self, currentVc: currentController, finished: success)
    }
    
    public func setController(controller:UIViewController?) {
        setController(controller: controller, animated: false, isAbove: true)
    }
    public func setController(controller:UIViewController?, animated:Bool, isAbove:Bool) {
        if let vc = controller {
            if animated, openAnimate, let _ = currentController {
                if isAnimateChange {
                    return
                }
                isAnimateChange = true
                isLeft = isAbove
                pendingController = controller
                addController(vc: controller)
                gestureSuccess(success: true, animated: true)
            }else {
                addController(vc: controller)
                vc.view.frame = view.bounds
                if let cur = currentController {
                    cur.view.removeFromSuperview()
                    cur.removeFromParent()
                }
                currentController = controller
            }
        }
    }
    
    // 手势结束
    private func gestureSuccess(success:Bool, animated:Bool) {
        if let vc = pendingController {
            if isLeft {
                if animated {
                    UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                        if success {
                            vc.view.frame = CGRectMake(0, 0, WL_SCREEN_WIDTH, WL_SCREEN_HEIGHT)
                        }else {
                            vc.view.frame = CGRectMake(-WL_SCREEN_WIDTH, 0, WL_SCREEN_WIDTH, WL_SCREEN_HEIGHT)
                        }
                    } completion: { finished in
                        self.animateSuccess(success: success)
                    }
                }else {
                    if success {
                        vc.view.frame = CGRectMake(0, 0, WL_SCREEN_WIDTH, WL_SCREEN_HEIGHT)
                    }else {
                        vc.view.frame = CGRectMake(-WL_SCREEN_WIDTH, 0, WL_SCREEN_WIDTH, WL_SCREEN_HEIGHT)
                    }
                    animateSuccess(success: success)
                }
            }else {
                if animated {
                    UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                        if success {
                            self.currentController?.view.frame = CGRectMake(-WL_SCREEN_WIDTH, 0, WL_SCREEN_WIDTH, WL_SCREEN_HEIGHT)
                        }else {
                            self.currentController?.view.frame = CGRectMake(0, 0, WL_SCREEN_WIDTH, WL_SCREEN_HEIGHT)
                        }
                    } completion: { finished in
                        self.animateSuccess(success: success)
                    }
                }else {
                    if success {
                        self.currentController?.view.frame = CGRectMake(-WL_SCREEN_WIDTH, 0, WL_SCREEN_WIDTH, WL_SCREEN_HEIGHT)
                    }else {
                        self.currentController?.view.frame = CGRectMake(0, 0, WL_SCREEN_WIDTH, WL_SCREEN_HEIGHT)
                    }
                    animateSuccess(success: success)
                }
            }
        }
    }
    deinit {
        view.removeGestureRecognizer(tap)
        view.removeGestureRecognizer(pan)
        if let vc = currentController {
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            currentController = nil
        }
        if let vc = pendingController {
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            pendingController = nil
        }
    }
    
    // MARK - 手势处理
    @objc private func touchPan(pan:UIPanGestureRecognizer) {
        let tempPoint = pan.translation(in: view)
        let touchPoint = pan.location(in: view)
        if (moveTouchPoint != nil) && !CGPointEqualToPoint(moveTouchPoint, .zero) && (pan.state == .began || pan.state == .changed) {
            moveSpaceX = touchPoint.x - moveTouchPoint.x
        }
        moveTouchPoint = touchPoint
        if pan.state == .began {
            readerVc.readerMenu.showMenu(show: false)
            if isAnimateChange {
                return
            }
            if openAnimate {
                isAnimateChange = true
            }
            isPanBegin = true
            isPan = true
        }else if pan.state == .changed {
            if abs(tempPoint.x) > 0.01 {
                if isPanBegin {
                    isPanBegin = false
                    pendingController = getPanController(touchPoint: tempPoint)
                    delegate?.coverWillTransition?(coverController: self, pendingController: pendingController)
                    addController(vc: pendingController)
                }
                if openAnimate, isPan {
                    if let pend = pendingController {
                        if isLeft {
                            pend.view.frame = CGRectMake(touchPoint.x - WL_SCREEN_WIDTH, 0, WL_SCREEN_WIDTH, WL_SCREEN_HEIGHT)
                        }else {
                            currentController?.view.frame = CGRectMake(tempPoint.x > 0 ? 0 : tempPoint.x, 0, WL_SCREEN_WIDTH, WL_SCREEN_HEIGHT)
                        }
                    }
                }
            }
        }else {
            if isPan {
                isPan = false
                if openAnimate {
                    if let pend = pendingController {
                        var success = true
                        if isLeft {
                            if pend.view.frame.origin.x <= -(WL_SCREEN_WIDTH - WL_SCREEN_WIDTH * 0.2) {
                                success = false
                            }else {
                                if moveSpaceX < 0 {
                                    success = false
                                }
                            }
                        }else {
                            if currentController!.view.frame.origin.x >= -1 {
                                success = false
                            }
                        }
                        gestureSuccess(success: success, animated: true)
                    }else {
                        isAnimateChange = false
                    }
                }else {
                    gestureSuccess(success: true, animated: openAnimate)
                }
            }
            moveTouchPoint = .zero
            moveSpaceX = 0
        }
    }
    
    @objc private func touchTap(tap:UITapGestureRecognizer) {
        readerVc.readerMenu.showMenu(show: false)
        if isAnimateChange {
            return
        }
        if openAnimate {
            isAnimateChange = true
        }
        let touchPoint = tap.location(in: view)
        pendingController = getTapController(touchPoint: touchPoint)
        delegate?.coverWillTransition?(coverController: self, pendingController: pendingController)
        addController(vc: pendingController)
        gestureSuccess(success: true, animated: openAnimate)
    }
}

extension WLReaderCoverController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) && gestureRecognizer.isEqual(tap) {
            let touchPoint = tap.location(in: view)
            if (touchPoint.x > WL_SCREEN_WIDTH / 3.0 && touchPoint.x < (WL_SCREEN_WIDTH - WL_SCREEN_WIDTH / 3.0)) {
                return true
            }
        }
        return false
    }
}
