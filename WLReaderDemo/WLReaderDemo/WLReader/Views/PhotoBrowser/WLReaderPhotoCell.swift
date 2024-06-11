//
//  WLReaderPhotoCell.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/10.
//

import UIKit

@objc protocol WLReaderPhotoCellDelegate: NSObjectProtocol {
    @objc optional func didClickImageView(index: Int)
}

class WLReaderPhotoCell: UICollectionViewCell {
    public var index:Int?
    public var zoomImageView:WLReaderPhotoZoomView?
    weak var delegate:WLReaderPhotoCellDelegate?
    public var model:WLReaderPhotoModel? {
        didSet {
            zoomImageView?.image = model?.image
            changeImageViewFrame(with: model!.image)
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
        zoomImageView = WLReaderPhotoZoomView(frame: CGRect(x: 0, y: 0, width: WL_SCREEN_WIDTH, height: WL_SCREEN_HEIGHT))
        zoomImageView?.backgroundColor = .black
        zoomImageView?.zoomScale = 1.0
        contentView.addSubview(zoomImageView!)
        zoomImageView?.tapImageBlock = { [weak self] in
            self?.delegate?.didClickImageView!(index: self!.index!)
        }
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
        zoomImageView!.contentSize = CGSizeMake(newSize.width, newSize.height);
        zoomImageView!.contentOffset = CGPointMake(0, 0);
        var imageY = (zoomImageView!.frame.size.height - newSize.height) * 0.5;
        imageY = imageY > 0 ? imageY: 0;
        zoomImageView!.zoomImageView.frame = CGRectMake(0, imageY, zoomImageView!.frame.size.width, newSize.height);
        zoomImageView!.adjustImageViewFrame()
    }

}
