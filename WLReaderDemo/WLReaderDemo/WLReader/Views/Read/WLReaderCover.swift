//
//  WLReaderCover.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/13.
//

import UIKit
import SnapKit

class WLReaderCover: UIView {
    var imageView:UIImageView!
    var chapterModel:WLBookChapter! {
        didSet {
            imageView.image = try? UIImage(contentsOf: chapterModel.fullHref, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
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
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.centerX.width.centerY.equalToSuperview()
        }
    }
}
