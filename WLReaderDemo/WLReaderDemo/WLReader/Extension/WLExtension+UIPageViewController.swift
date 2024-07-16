//
//  WLExtension+UIPageViewController.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/30.
//

import UIKit

private var isGestureEnabledKey: UInt8 = 0
private var isTapGestureEnabledKey: UInt8 = 1

extension UIPageViewController {
    // 是否开启手势
    var gestureEnabled:Bool {
        get { return (objc_getAssociatedObject(self, &isGestureEnabledKey) as? Bool) ?? true }
        set {
            for ges in gestureRecognizers {
                ges.isEnabled = newValue
            }
            objc_setAssociatedObject(self, &isGestureEnabledKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    /// tap手势
    var tapGestureRecognizer:UITapGestureRecognizer? {
        for ges in gestureRecognizers {
            if ges.isKind(of: UITapGestureRecognizer.classForCoder()) {
                return ges as? UITapGestureRecognizer
            }
        }
        
        return nil
    }
    /// tap手势启用
    var tapGestureRecognizerEnabled:Bool {
        get{ return (objc_getAssociatedObject(self, &isTapGestureEnabledKey) as? Bool) ?? true }
        set{
            tapGestureRecognizer?.isEnabled = newValue
            objc_setAssociatedObject(self, &isTapGestureEnabledKey, newValue , objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
