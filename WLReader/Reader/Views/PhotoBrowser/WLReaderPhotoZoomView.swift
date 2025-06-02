//
//  WLReaderPhotoZoomView.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/5.
//

import UIKit

class WLReaderPhotoZoomView: UIScrollView, UIScrollViewDelegate {
    public var zoomImageView:UIImageView!
    public var tapImageBlock:(() -> Void)?
    public var image:UIImage! {
        didSet {
            zoomImageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.delegate = self
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 3.0
        zoomImageView = UIImageView()
        zoomImageView.contentMode = .scaleAspectFill
        zoomImageView.clipsToBounds = true
        zoomImageView.isUserInteractionEnabled = true
        addSubview(zoomImageView)
    }
    
    public func adjustImageViewFrame() {
        if let image = zoomImageView.image {
            let viewSize = bounds.size
            var imageSize = image.size
            if (imageSize.width > viewSize.width || imageSize.height > viewSize.height) {
                let imageScale = imageSize.width / imageSize.height
                let viewScale = viewSize.width / viewSize.height
                if (viewScale > imageScale) {
                    imageSize = CGSizeMake(viewSize.height * imageSize.width / imageSize.height, viewSize.height)
                }else {
                    imageSize = CGSizeMake(viewSize.width, viewSize.width * imageSize.height / imageSize.width)
                }
            }
            zoomImageView.frame = CGRectMake((viewSize.width - imageSize.width) / 2, (viewSize.height - imageSize.height) / 2.0, imageSize.width, imageSize.height);
            self.contentSize = imageSize;
            scrollViewDidZoom(self)
        }
    }
    public func cancelTapEvent() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomImageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var rect = zoomImageView.frame
        rect.origin.x = 0
        rect.origin.y = 0
        if (rect.size.width < self.frame.size.width) {
            rect.origin.x = floor((self.frame.size.width - rect.size.width) / 2.0)
        }
        if (rect.size.height < self.frame.size.height) {
            rect.origin.y = floor((self.frame.size.height - rect.size.height) / 2.0)
        }
        zoomImageView.frame = rect
        self.isScrollEnabled = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if (touch.tapCount == 1) {
            perform(#selector(singleTapClick), with: self, afterDelay: 0.2)
        }else if (touch.tapCount == 2) {
            cancelTapEvent()
            let touchPoint = touch.location(in: zoomImageView)
            zoomDoubleTap(with: touchPoint)
        }
    }
    @objc private func singleTapClick() {
        tapImageBlock?()
    }
    private func zoomDoubleTap(with point:CGPoint) {
        if zoomScale > minimumZoomScale {
            setZoomScale(minimumZoomScale, animated: true)
            isScrollEnabled = false
        }else {
            isScrollEnabled = true
            let newZoomScale = (minimumZoomScale + maximumZoomScale) / 2.0
            let width = bounds.width / newZoomScale
            let height = bounds.height / newZoomScale
            zoom(to: CGRect(x: point.x - width / 2.0, y: point.y - height / 2.0, width: width, height: height), animated: true)
        }
    }
}
