//
//  WLNoteTextImageQuoteText.swift
//  DuKu
//
//  Created by 李伟 on 2024/7/2.
//  引用部分是文本，笔记包含图片和文本

import UIKit
import SnapKit

class WLNoteTextImageQuoteText: WLNoteBaseView {
    override func setupConstraints() {
        super.setupConstraints()
        
        quoteTextLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalToSuperview()
        }
        noteImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.quoteTextLabel.snp.bottom).offset(10)
            make.width.equalTo(0)
            make.height.equalTo(0)
        }
        noteTextLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(-10)
            make.top.equalTo(self.noteImageView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        quoteLineView.snp.makeConstraints { make in
            make.left.equalTo(self.noteTextLabel.snp.left)
            make.width.equalTo(2)
            make.top.equalTo(self.quoteTextLabel.snp.top)
            make.bottom.equalTo(self.quoteTextLabel.snp.bottom).priority(.low)
        }
    }
    override func configSubviews() {
        super.configSubviews()
        quoteTextLabel.text = noteModel.sourceContent?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        noteTextLabel.text = noteModel.noteContent?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        noteImageView.kf.setImage(with: URL(string: noteModel.noteContent!.imageUrl!), completionHandler: { result in
            switch result {
            case .success(let value):
                self.updateImageViewFrame(image: value.image, imageView: self.noteImageView)
            case .failure(let error):
                print("下载图片失败: \(error)")
            }
        })
    }
}
