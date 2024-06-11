//
//  WLReaderPhotoDrivenInteractive.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/10.
//

import UIKit

class WLReaderPhotoDrivenInteractive: UIPercentDrivenInteractiveTransition {
    private var transition:WLReaderPhotoTransition!
    weak private var transitionContext:(any UIViewControllerContextTransitioning)?
    private var blackBgView:UIView?
    private var whitBgView:UIView?
    private var fromView:UIView?
    private var bgView:UIView?
    public var panGesture:UIPanGestureRecognizer? {
        didSet {
            panGesture?.addTarget(self, action: #selector(gestureRecognizeDidUpdate(pan:)))
        }
    }
    
    deinit {
        self.panGesture?.removeTarget(self, action: #selector(gestureRecognizeDidUpdate(pan:)))
    }
    init(with transition:WLReaderPhotoTransition) {
        super.init()
        self.transition = transition
   }
    
    private func percent(for gesture:UIPanGestureRecognizer) -> CGFloat {
        let translation = gesture.translation(in: gesture.view)
        var scale = 1 - CGFloat(translation.y) / WL_SCREEN_HEIGHT
        scale = scale < 0 ? 0 : scale
        scale = scale > 1 ? 1 : scale
        return scale
    }
    
    @objc private func gestureRecognizeDidUpdate(pan:UIPanGestureRecognizer) {
        let scale = percent(for: pan)
        switch pan.state {
          case .began:
            break
          case .changed:
            self.update(scale)
            updateInterPercent(scale: scale)
            break
          case .ended:
            if scale > 0.8 {
                self.cancel()
                interPercentCancel()
            }else {
                self.finish()
                interPercentFinished(scale: scale)
            }
          default:
            self.cancel()
            interPercentCancel()
            break
        }
    }
    
    private func updateInterPercent(scale: CGFloat) {
        blackBgView?.alpha = scale * scale * scale
    }
    private func interPercentCancel() {
        let containerView = transitionContext?.containerView
        let fromView = transitionContext?.view(forKey: .from)
        fromView?.backgroundColor = .black
        containerView?.addSubview(fromView!)
        blackBgView?.removeFromSuperview()
        whitBgView?.removeFromSuperview()
        blackBgView = nil
        whitBgView = nil
        transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled)
    }
    private func interPercentFinished(scale: CGFloat) {
        let containerView = transitionContext?.containerView
        let toView = transitionContext?.view(forKey: .to)
        containerView?.addSubview(toView!)
        let imageWhitBgView = UIView(frame: transition.sourceFrame!)
        imageWhitBgView.backgroundColor = .white
        containerView?.addSubview(imageWhitBgView)
        let bgView = UIView(frame: containerView!.bounds)
        bgView.backgroundColor = .black
        bgView.alpha = blackBgView!.alpha
        containerView?.addSubview(bgView)
        let transitionImageView = UIImageView(image: transition.transitionImage)
        transitionImageView.clipsToBounds = true
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.frame = transition.currentPanGestureFrame!
        containerView?.addSubview(transitionImageView)
        if transition.openSpring {
            UIView.animate(withDuration: transition.duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveLinear) {
                transitionImageView.frame = self.transition.sourceFrame!
                bgView.alpha = 0
            } completion: { _ in
                self.blackBgView?.removeFromSuperview()
                self.whitBgView?.removeFromSuperview()
                self.blackBgView = nil
                self.whitBgView = nil
                bgView.removeFromSuperview()
                imageWhitBgView.removeFromSuperview()
                transitionImageView.removeFromSuperview()
                self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled)
            }
        }else {
            UIView.animate(withDuration: transition.duration) {
                transitionImageView.frame = self.transition.sourceFrame!
                bgView.alpha = 0
            } completion: { _ in
                self.blackBgView?.removeFromSuperview()
                self.whitBgView?.removeFromSuperview()
                self.blackBgView = nil
                self.whitBgView = nil
                bgView.removeFromSuperview()
                imageWhitBgView.removeFromSuperview()
                transitionImageView.removeFromSuperview()
                self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled)
            }
        }
    }
    
    override func startInteractiveTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        beginTransition()
    }
    private func beginTransition() {
        let containerView = transitionContext?.containerView
        let toView = transitionContext?.view(forKey: .to)
        guard let toView = toView else { return }
        containerView?.addSubview(toView)
        whitBgView = UIView(frame: transition.sourceFrame!)
        whitBgView?.backgroundColor = .clear
        containerView?.addSubview(whitBgView!)
        blackBgView = UIView(frame: containerView!.bounds)
        blackBgView?.backgroundColor = .black
        containerView?.addSubview(blackBgView!)
        let fromView = transitionContext?.view(forKey: .from)
        fromView?.backgroundColor = .clear
        containerView?.addSubview(fromView!)
    }
}
