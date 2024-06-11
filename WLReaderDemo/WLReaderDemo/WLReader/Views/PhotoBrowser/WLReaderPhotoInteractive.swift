//
//  WLReaderPhotoInteractive.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/10.
//

import UIKit

class WLReaderPhotoInteractive: NSObject, UIViewControllerTransitioningDelegate {
    public var transition:WLReaderPhotoTransition! {
        didSet {
            self.push?.transition = transition
            self.pop?.transition = transition
            self.intractivePercent = WLReaderPhotoDrivenInteractive(with: transition)
        }
    }
    private var push:WLReaderPhotoPush? = WLReaderPhotoPush()
    private var pop:WLReaderPhotoPop? = WLReaderPhotoPop()
    public var intractivePercent:WLReaderPhotoDrivenInteractive?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        return push
    }
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        return pop
    }
    func interactionControllerForPresentation(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        return nil
    }
    func interactionControllerForDismissal(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        if transition.panGesture != nil {
            return intractivePercent
        }
        return nil
    }
    
}
