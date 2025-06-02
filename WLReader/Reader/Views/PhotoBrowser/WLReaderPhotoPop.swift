//
//  WLReaderPhotoPop.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/10.
//

import UIKit

class WLReaderPhotoPop: NSObject, UIViewControllerAnimatedTransitioning {
    public var transition:WLReaderPhotoTransition!
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return transition.duration
    }
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        containerView.addSubview(toView!)
        let fromFrame = CGRect(x: (WL_SCREEN_WIDTH - transition.destFrame!.width) * 0.5, y: transition.destFrame!.origin.y, width: transition.destFrame!.width, height: transition.destFrame!.height)
        let toFrame = transition.sourceFrames![transition.transitionIndex!]
        let whitBgView = UIView(frame: toFrame)
        whitBgView.backgroundColor = .white
        containerView.addSubview(whitBgView)
        let blackBgView = UIView(frame: containerView.bounds)
        blackBgView.backgroundColor = .black
        blackBgView.alpha = 0
        containerView.addSubview(blackBgView)
        let transitionImageView = UIImageView(image: transition.transitionImage)
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.clipsToBounds = true
        transitionImageView.frame = fromFrame
        containerView.addSubview(transitionImageView)
        if transition.openSpring {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveLinear) {
                var imageFrame = toFrame
                if imageFrame.width == 0 && imageFrame.height == 0 {
                    let defaultWidth:CGFloat = 10
                    imageFrame = CGRect(x: (WL_SCREEN_WIDTH - defaultWidth) * 0.5, y: (WL_SCREEN_HEIGHT - defaultWidth) * 0.5, width: defaultWidth, height: defaultWidth)
                }
                transitionImageView.frame = imageFrame
                blackBgView.alpha = 0
            } completion: { _ in
                whitBgView.removeFromSuperview()
                transitionImageView.removeFromSuperview()
                blackBgView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                var imageFrame = toFrame
                if imageFrame.width == 0 && imageFrame.height == 0 {
                    let defaultWidth:CGFloat = 10
                    imageFrame = CGRect(x: (WL_SCREEN_WIDTH - defaultWidth) * 0.5, y: (WL_SCREEN_HEIGHT - defaultWidth) * 0.5, width: defaultWidth, height: defaultWidth)
                }
                transitionImageView.frame = imageFrame
                blackBgView.alpha = 0
            } completion: { _ in
                whitBgView.removeFromSuperview()
                transitionImageView.removeFromSuperview()
                blackBgView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
