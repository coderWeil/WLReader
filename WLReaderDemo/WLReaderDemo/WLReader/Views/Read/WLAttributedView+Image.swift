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
        let photoBrowser = WLReaderPhotoBroswer(frame: window!.bounds)
        let photoModel = WLReaderPhotoModel()
        photoModel.image = imageView.image
        photoBrowser.model = photoModel
        window?.addSubview(photoBrowser)
        photoBrowser.show()
    }
   
}
