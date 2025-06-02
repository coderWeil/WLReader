//
//  WLNoteNullQuoteText.swift
//  DuKu
//
//  Created by 李伟 on 2024/7/7.
//

import UIKit
import SnapKit

class WLNoteNullQuoteText: WLNoteBaseView {
    override func setupConstraints() {
        super.setupConstraints()
        quoteTextLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        quoteLineView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(2)
            make.top.equalTo(self.quoteTextLabel.snp.top)
            make.bottom.equalTo(self.quoteTextLabel.snp.bottom).priority(.low)
        }
    }
    override func configSubviews() {
        super.configSubviews()
        quoteTextLabel.text = noteModel.sourceContent?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
