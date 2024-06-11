//
//  WLAttributedView+Image.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/2.
//

import UIKit
import DTCoreText

extension WLAttributedView {
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if attachment.isKind(of: DTImageTextAttachment.self) {
            let imageView = DTLazyImageView()
            imageView.url = attachment.contentURL
            imageView.contentMode = .scaleAspectFit
            imageView.frame = frame
            imageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(_onTapImage(tap:)))
            imageView.addGestureRecognizer(tap)
            return imageView
        }
        return nil
    }
    
    @objc private func _onTapImage(tap:UITapGestureRecognizer) {
        let imageView = tap.view as! DTLazyImageView
        let transitionParam = WLReaderPhotoTransition()
        transitionParam.transitionImage = imageView.image
        transitionParam.sourceFrames = sourceFrames(imageView: imageView)
        transitionParam.transitionIndex = 0
        transitionParam.openSpring = false
        transitionParam.duration = 0.25
        animatedTransition = nil
        animatedTransition = WLReaderPhotoInteractive()
        animatedTransition?.transition = transitionParam
        
        let browser = WLReaderPhotoBroswer()
        browser.showPageIndicator = true
        browser.photos = photos(image: imageView.image!)
        browser.animationTransition = animatedTransition
        browser.transitioningDelegate = animatedTransition
        browser.modalPresentationStyle = .fullScreen
        NSObject.wl_topController()?.present(browser, animated: true)
        browser.reload()
    }
    private func sourceFrames(imageView:DTLazyImageView) -> [CGRect] {
        let viewFrame = imageView.convert(imageView.bounds, to: NSObject.wl_topController()?.view)
        return [viewFrame]
    }
    private func photos(image:UIImage) -> [WLReaderPhotoModel] {
        let model = WLReaderPhotoModel()
        model.image = image
        return [model]
    }
   
}
