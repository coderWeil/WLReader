//
//  WLReaderPhotoPush.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/9.
//

import UIKit

class WLReaderPhotoPush: NSObject, UIViewControllerAnimatedTransitioning {
    public var transition:WLReaderPhotoTransition!
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return transition.duration
    }
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        toView?.isHidden = true
        containerView.addSubview(toView!)
        let imageWithBgView = UIView(frame: transition.sourceFrames![transition.transitionIndex!])
        imageWithBgView.backgroundColor = .white
        containerView.addSubview(imageWithBgView)
        let blackBgView = UIView(frame: containerView.bounds)
        blackBgView.backgroundColor = .black
        blackBgView.alpha = 0
        containerView.addSubview(blackBgView)
        let transitionImageView = UIImageView(image: transition.transitionImage)
        transitionImageView.contentMode = .scaleAspectFit
        transitionImageView.frame = transition.sourceFrames![transition.transitionIndex!]
        containerView.addSubview(transitionImageView)
        if transition.openSpring {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveLinear) {
                transitionImageView.frame = containerView.bounds
                blackBgView.alpha = 1.0
            } completion: { _ in
                toView?.isHidden = false
                imageWithBgView.removeFromSuperview()
                transitionImageView.removeFromSuperview()
                blackBgView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                transitionImageView.frame = containerView.bounds
                blackBgView.alpha = 1.0
            } completion: { _ in
                toView?.isHidden = false
                imageWithBgView.removeFromSuperview()
                transitionImageView.removeFromSuperview()
                blackBgView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
