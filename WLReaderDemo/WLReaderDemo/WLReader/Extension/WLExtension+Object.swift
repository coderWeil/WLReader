//
//  WLExtension+Object.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/25.
//

import UIKit

extension NSObject {
    class func wl_mainWindow() -> UIWindow? {
        return UIApplication.shared.windows.first ?? nil
    }
    public func wl_mainWindow() -> UIWindow? {
        return UIApplication.shared.windows.first ?? nil
    }
    class func wl_topController() -> UIViewController? {
        let window = wl_mainWindow()!
        return _topViewController(root: window.rootViewController)
    }
    public func wl_topController() -> UIViewController? {
        let window = wl_mainWindow()!
        return NSObject._topViewController(root: window.rootViewController)
    }
    class private func _topViewController(root:UIViewController!) -> UIViewController? {
        if let present = root.presentingViewController {
            return _topViewController(root: present.presentedViewController)
        }
        if root.isKind(of: UISplitViewController.self) {
            let svc = root as! UISplitViewController
            if svc.viewControllers.count > 0 {
                return _topViewController(root: svc.viewControllers.last)
            }
            return root
        }
        if root.isKind(of: UINavigationController.self) {
            let nav = root as! UINavigationController
            if nav.viewControllers.count > 0 {
                return _topViewController(root: nav.topViewController)
            }
            return root
        }
        if root.isKind(of: UITabBarController.self) {
            let tab = root as! UITabBarController
            if tab.viewControllers!.count > 0 {
                return _topViewController(root: tab.selectedViewController)
            }
            return root
        }
        return root
    }
}
