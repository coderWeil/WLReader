//
//  WLTranslationController.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/15.
//  平移动画的控制器

import UIKit

let animationDuration = 0.2
let limitRate = 0.05

enum WLTransitionDirection {
    case left
    case right
}

protocol WLTranslationDelegate: NSObjectProtocol {
    
    func translationController(with translationController: WLTranslationController, controllerAfter controller:UIViewController) -> UIViewController?
    func translationController(with translationController: WLTranslationController, controllerBefore controller:UIViewController) -> UIViewController?
    func translationController(with translationController: WLTranslationController, willTransitionTo controller:UIViewController) -> Void
    func translationController(translationController: WLTranslationController, didFinishAnimating finished: Bool, previousController: UIViewController, transitionCompleted completed: Bool) -> Void
}


class WLTranslationController: WLReadBaseController, UIGestureRecognizerDelegate {
    var delegate: WLTranslationDelegate?
    var pendingController: UIViewController?
    var currentController: UIViewController?
    var startPoint:CGPoint!
    var scrollDirection = 0
    var allowRequestNewController:Bool = true
    var isPanning = false
    var allowAnimation = true //true 平移效果 false 无效果
    weak var readerVc:WLReadContainer!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        if allowAnimation {
            let panGes = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGes(gesture:)))
            self.view.addGestureRecognizer(panGes)
        }
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGes(gesture:)))
        self.view.addGestureRecognizer(tapGes)
        tapGes.delegate = self
    }
    
    // MARK - 私人
    @objc private func handlePanGes(gesture: UIPanGestureRecognizer) -> Void {
        let basePoint = gesture.translation(in: gesture.view)
        if gesture.state == .began {
            currentController = self.children.first
            startPoint = gesture.location(in: gesture.view)
            isPanning = true
            allowRequestNewController = true
            readerVc.readerMenu.showMenu(show: false)
        } else if gesture.state == .changed {
            
            if basePoint.x > 0 {
                if scrollDirection == 0 {
                    scrollDirection = 1
                }
                else if scrollDirection == -1 {
                    scrollDirection = 1
                    self.removeController(controller: pendingController!)
                    allowRequestNewController = true
                }
                // go to right
                if allowRequestNewController {
                    allowRequestNewController = false
                    pendingController = self.delegate?.translationController(with: self, controllerBefore: currentController!)
                    pendingController?.view.transform = CGAffineTransform(translationX: -WL_SCREEN_WIDTH, y: 0)
                    if pendingController != nil {
                        self.delegate?.translationController(with: self, willTransitionTo: pendingController!)
                        self.addController(controller: pendingController!)
                    }
                }
                
            }
            else if basePoint.x < 0 {
                if scrollDirection == 0 {
                    scrollDirection = -1
                }
                else if scrollDirection == 1 {
                    scrollDirection = -1
                    self.removeController(controller: pendingController!)
                    allowRequestNewController = true
                }
                // go to left
                if allowRequestNewController {
                    allowRequestNewController = false
                    pendingController = self.delegate?.translationController(with: self, controllerAfter: currentController!)
                    pendingController?.view.transform = CGAffineTransform(translationX: WL_SCREEN_WIDTH, y: 0)
                    if pendingController != nil {
                        self.delegate?.translationController(with: self, willTransitionTo: pendingController!)
                        self.addController(controller: pendingController!)
                    }
                }
                
            }
            
            if pendingController == nil {
                return
            }

            
            let walkingPoint = gesture.location(in: gesture.view)
            let offsetX = walkingPoint.x - startPoint.x
            currentController?.view.transform = CGAffineTransform(translationX: offsetX, y: 0)
            pendingController?.view.transform = offsetX < 0 ? CGAffineTransform(translationX: WL_SCREEN_WIDTH + offsetX, y: 0) : CGAffineTransform(translationX: -WL_SCREEN_WIDTH + offsetX, y: 0)
        } else{
            
            isPanning = false
            allowRequestNewController = true
            scrollDirection = 0
            if pendingController == nil {
                return
            }
            
            let endPoint = gesture.location(in: gesture.view)
            let finalOffsetRate = (endPoint.x - startPoint.x)/WL_SCREEN_WIDTH
            var currentEndTransform: CGAffineTransform = .identity
            var pendingEndTransform: CGAffineTransform = .identity
            var removeController: UIViewController? = nil
            var transitionFinished = false
            
            if finalOffsetRate >= limitRate {
                transitionFinished = true
                currentEndTransform = CGAffineTransform(translationX: WL_SCREEN_WIDTH, y: 0)
                removeController = self.currentController
            }
            else if finalOffsetRate < limitRate && finalOffsetRate >= 0 {
                pendingEndTransform = CGAffineTransform(translationX: -WL_SCREEN_WIDTH, y: 0)
                removeController = pendingController
            }
            else if finalOffsetRate < 0 && finalOffsetRate > -limitRate {
                pendingEndTransform = CGAffineTransform(translationX: WL_SCREEN_WIDTH, y: 0)
                removeController = pendingController
            }
            else {
                transitionFinished = true
                currentEndTransform = CGAffineTransform(translationX: -WL_SCREEN_WIDTH, y: 0)
                removeController = self.currentController
            }
            
            UIView.animate(withDuration: animationDuration, animations: {
                self.pendingController?.view.transform = pendingEndTransform
                self.currentController?.view.transform = currentEndTransform
            }, completion: { (complete) in
                if complete {
                    self.removeController(controller: removeController!)
                }
                self.delegate?.translationController(translationController: self, didFinishAnimating: complete, previousController: self.currentController!, transitionCompleted: transitionFinished)
            })
            
        }
    }
    
    /// 处理点击手势
    ///
    /// - Parameter gesture: 点击手势识别器
    @objc func handleTapGes(gesture: UITapGestureRecognizer) -> Void {
        let hitPoint = gesture.location(in: gesture.view)
        let curController = self.children.first!
        if hitPoint.x < gesture.view!.frame.size.width/3 {
//            滑向上一个controller
            let lastController = self.delegate?.translationController(with: self, controllerBefore: curController)
            if lastController != nil {
                self.delegate?.translationController(with: self, willTransitionTo: lastController!)
                self.setViewController(controller: lastController!, scrollDirection: .right, animated: allowAnimation,  completionHandler: {(complete) in
                    self.delegate?.translationController(translationController: self, didFinishAnimating: complete, previousController: curController, transitionCompleted: complete)
                })
            }
            
        }
        if hitPoint.x > gesture.view!.frame.size.width*2/3 {
//            滑向下一个controller
            let nextController: UIViewController? = self.delegate?.translationController(with: self, controllerAfter: self.children.first!)
            if nextController != nil {
                self.delegate?.translationController(with: self, willTransitionTo: nextController!)
                self.setViewController(controller: nextController!, scrollDirection: .left, animated: allowAnimation) { (complete) in
                    self.delegate?.translationController(translationController: self, didFinishAnimating: complete, previousController: curController, transitionCompleted: complete)

                }
            }
            
        }
        readerVc.readerMenu.showMenu(show: false)
    }
    
    //    MAEK: 添加删除controller
    func addController(controller: UIViewController) -> Void {
        self.addChild(controller)
        controller.didMove(toParent: self)
        self.view.addSubview(controller.view)
    }
    
    func removeController(controller: UIViewController?) -> Void {
        if let controller = controller {
            controller.view.removeFromSuperview()
            controller.willMove(toParent: nil)
            controller.removeFromParent()
        }
    }
    

    //    MARK: gesture delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            let tempWidth = WL_SCREEN_WIDTH/3
            let hitPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            if hitPoint.x > tempWidth && hitPoint.x < (WL_SCREEN_WIDTH - tempWidth) {
                return true
            }
        }
        
        return false
    }
    
    // MARK - 对外
    func setViewController(controller: UIViewController, scrollDirection: WLTransitionDirection, animated:Bool, completionHandler:((Bool) -> Void)?) -> Void {
        if animated == false {
            for controller in self.children {
                self.removeController(controller: controller)
            }
            self.addController(controller: controller)
            if completionHandler != nil {
                completionHandler!(true)
            }
        }else {
            let oldController = self.children.first
            self.addController(controller: controller)
            var newVCEndTransform: CGAffineTransform
            var oldVCEndTransform: CGAffineTransform
            controller.view.transform = .identity
            if oldController != nil {
                if scrollDirection == .left {
                    controller.view.transform = CGAffineTransform(translationX: WL_SCREEN_WIDTH, y: 0)
                    newVCEndTransform = .identity
                    oldController?.view.transform = .identity
                    oldVCEndTransform = CGAffineTransform(translationX: -WL_SCREEN_WIDTH, y: 0)
                }else {
                    controller.view.transform = CGAffineTransform(translationX: -WL_SCREEN_WIDTH, y: 0)
                    newVCEndTransform = .identity
                    oldController?.view.transform = .identity
                    oldVCEndTransform = CGAffineTransform(translationX: WL_SCREEN_WIDTH, y: 0)
                }
                
                UIView.animate(withDuration: animationDuration, animations: {
                    oldController?.view.transform = oldVCEndTransform
                    controller.view.transform = newVCEndTransform
                }, completion: { (complete) in
                    if complete {
                        self.removeController(controller: oldController)
                    }
                    if completionHandler != nil {
                        completionHandler!(complete)
                    }
                    
                })
            }
            
        }
    }
}
