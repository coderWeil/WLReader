//
//  WLReaderPhotoPush.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/9.
//

import UIKit

class WLReaderPhotoPush: NSObject, UIViewControllerAnimatedTransitioning {
    weak var transition:WLReaderPhotoTransition!
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return transition.duration
    }
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        toView?.isHidden = true
        containerView.addSubview(toView!)
    }
}
