//
//  WLNoteImageQuoteText.swift
//  DuKu
//
//  Created by 李伟 on 2024/7/2.
//  引用部分是文本，笔记是图片

import UIKit
import SnapKit

class WLNoteImageQuoteText: WLNoteBaseView {

    // MARK - 设置约束
    override func setupConstraints() {
        super.setupConstraints()
        quoteTextLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        noteImageView.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.quoteTextLabel.snp.bottom).offset(10)
            make.width.equalTo(0)
            make.height.equalTo(0)
            make.bottom.equalToSuperview().offset(-10).priority(.low)
        })
        quoteLineView.snp.makeConstraints({ make in
            make.top.equalTo(self.quoteImageView.snp.top)
            make.left.equalTo(self.noteImageView.snp.left)
            make.width.equalTo(2)
            make.bottom.equalTo(self.quoteTextLabel.snp.bottom).priority(.low)
        })
    }
}
