//
//  Extension+iOS.swift
//  RxNetworks
//
//  Created by Condy on 2024/1/1.
//  https://github.com/yangKJ/RxNetworks

import Foundation

#if canImport(UIKit)
import UIKit

extension X {
    public static func topViewController() -> UIViewController? {
        let window = UIApplication.shared.delegate?.window
        guard window != nil, let rootViewController = window?!.rootViewController else {
            return nil
        }
        return self.getTopViewController(controller: rootViewController)
    }
    
    public static func getTopViewController(controller: UIViewController) -> UIViewController {
        if let presentedViewController = controller.presentedViewController {
            return self.getTopViewController(controller: presentedViewController)
        } else if let navigationController = controller as? UINavigationController {
            if let topViewController = navigationController.topViewController {
                return self.getTopViewController(controller: topViewController)
            }
            return navigationController
        } else if let tabbarController = controller as? UITabBarController {
            if let selectedViewController = tabbarController.selectedViewController {
                return self.getTopViewController(controller: selectedViewController)
            }
            return tabbarController
        } else {
            return controller
        }
    }
}

#endif
