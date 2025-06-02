//
//  WLNoteTextQuoteImage.swift
//  DuKu
//
//  Created by 李伟 on 2024/7/2.
//  引用部分是图片，笔记部分是文本

import UIKit
import SnapKit
import Kingfisher

class WLNoteTextQuoteImage: WLNoteBaseView {
    
    // MARK - 设置约束
    override func setupConstraints() {
        super.setupConstraints()
        quoteImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalTo(0)
        }
        noteTextLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.quoteImageView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        quoteLineView.snp.makeConstraints { make in
            make.left.equalTo(self.noteTextLabel.snp.left)
            make.width.equalTo(2)
            make.top.equalTo(self.quoteImageView.snp.top)
            make.bottom.equalTo(self.quoteImageView.snp.bottom).priority(.low)
        }
    }
    override func configSubviews() {
        super.configSubviews()
        
        quoteImageView.kf.setImage(with: URL(string: noteModel.sourceContent!.imageUrl!), completionHandler: { result in
            switch result {
            case .success(let value):
                self.updateImageViewFrame(image: value.image, imageView: self.quoteImageView)
            case .failure(let error):
                print("下载图片失败: \(error)")
            }
        })
    }
}
