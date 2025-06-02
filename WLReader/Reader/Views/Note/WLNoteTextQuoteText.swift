//
//  WLNoteTextQuoteText.swift
//  DuKu
//
//  Created by 李伟 on 2024/7/2.
//  引用部分和评论部分都是文本的

import UIKit
import SnapKit

class WLNoteTextQuoteText: WLNoteBaseView {
    // MARK - 设置约束
    override func setupConstraints() {
        super.setupConstraints()
        quoteTextLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        })
        noteTextLabel.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.quoteTextLabel.snp.bottom).offset(10).priority(.low)
        })
        quoteLineView?.snp.makeConstraints({ make in
            make.top.equalTo(self.quoteTextLabel.snp.bottom).priority(.low)
            make.width.equalTo(2)
            make.left.equalTo(self.noteTextLabel.snp.left)
            make.bottom.equalTo(self.quoteTextLabel.snp.bottom).priority(.low)
        })
    }
    override func configSubviews() {
        super.configSubviews()
        quoteTextLabel.text = noteModel.sourceContent?.text
        noteTextLabel.text = noteModel.noteContent?.text
    }
}
