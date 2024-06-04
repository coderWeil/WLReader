//
//  WLReaderTitleView.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/1.
//

import UIKit
import SnapKit

class WLReaderTitleView: UIView {
    /// 左侧标题部分
    private var titleLabel:UILabel!
    public var title:String? {
        didSet {
            titleLabel.text = title
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
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.5)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(WLBookConfig.shared.readerEdget)
            make.top.equalTo(0)
        }
    }
}
