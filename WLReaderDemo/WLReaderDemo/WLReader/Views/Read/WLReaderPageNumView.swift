//
//  WLReaderPageNumView.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/1.
//  页码,只针对本章节的，为了避免需要解析所有的章节而引发额外性能消耗

import UIKit
import SnapKit

class WLReaderPageNumView: UIView {
    /// 总页码
    public var totalPage:Int?
    /// 当前页码
    public var currentPage:Int? {
        didSet {
            numberLabel.text = String(describing: currentPage!) + " / " + String(describing: totalPage!)
        }
    }
    private var numberLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubviews() {
        numberLabel = UILabel()
        numberLabel.textColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.5)
        numberLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.right.equalTo(-WLBookConfig.shared.readerEdget)
            make.bottom.equalTo(0)
        }
    }
}
