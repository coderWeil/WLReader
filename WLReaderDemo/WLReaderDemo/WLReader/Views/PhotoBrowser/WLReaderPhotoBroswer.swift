//
//  WLReaderPhotoBroswer.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/5.
//  阅读器大图查看

import UIKit

class WLReaderPhotoBroswer: UIView {
    public var model:WLReaderPhotoModel! {
        didSet {
            imageView.image = model.image
            changeImageViewFrame(with: model.image!)
        }
    }
    private var imageView:WLReaderPhotoZoomView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubviews() {
        self.backgroundColor = .black.withAlphaComponent(0)
        imageView = WLReaderPhotoZoomView(frame: bounds)
        imageView.backgroundColor = .black
        imageView.zoomScale = 1.0
        imageView.tapImageBlock = { [weak self] in
            self?.removeFromSuperview()
            self = nil
        }
        addSubview(imageView)
    }
    private func changeImageViewFrame(with image:UIImage!) {
        let imageSize = image.size
        var newSize = CGSize()
        if (WL_SCREEN_WIDTH < imageSize.width) {
            newSize.width = WL_SCREEN_WIDTH
        }else {
            newSize.width = imageSize.width
        }
        newSize.height = newSize.width / imageSize.width * imageSize.height
        imageView.contentSize = CGSizeMake(newSize.width, newSize.height);
        imageView.contentOffset = CGPointMake(0, 0);
        var imageY = (imageView.frame.size.height - newSize.height) * 0.5;
        imageY = imageY > 0 ? imageY: 0;
        imageView.zoomImageView.frame = CGRectMake(0, imageY, imageView.frame.size.width, newSize.height);
        imageView.adjustImageViewFrame()
    }
    
    public func show() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = .black.withAlphaComponent(0.8)
        }
    }
}
