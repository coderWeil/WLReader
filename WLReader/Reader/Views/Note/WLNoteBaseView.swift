//
//  WLNoteBaseView.swift
//  DuKu
//
//  Created by 李伟 on 2024/7/7.
//  基类

import UIKit
import Kingfisher
import SnapKit

class WLNoteBaseView: UIView {
    // 引用文本
    public var quoteTextLabel:UILabel!
    // 引用图片
    public var quoteImageView:UIImageView!
    // 引用左侧的细线
    public var quoteLineView:UIView!
    // 笔记文本
    public var noteTextLabel:UILabel!
    // 笔记图片
    public var noteImageView:UIImageView!
    // 列表视图
    public var tableView:UITableView!
    // 笔记数据
    public var noteModel:WLBookNoteModel! {
        didSet {
            configSubviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK - 初始化子视图
    private func initSubviews() {
        quoteTextLabel = UILabel()
        quoteTextLabel.font = UIFont.systemFont(ofSize: 16)
        quoteTextLabel.textColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.8)
        quoteTextLabel.numberOfLines = 0
        addSubview(quoteTextLabel)
        
        quoteImageView = UIImageView()
        quoteImageView.contentMode = .scaleAspectFill
        quoteImageView.clipsToBounds = true
        addSubview(quoteImageView)
        
        quoteLineView = UIView()
        quoteLineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
        addSubview(quoteLineView)
        
        noteTextLabel = UILabel()
        noteTextLabel.font = UIFont.systemFont(ofSize: 18)
        noteTextLabel.textColor = WL_READER_TEXT_COLOR
        noteTextLabel.numberOfLines = 0
        addSubview(noteTextLabel)
        
        noteImageView = UIImageView()
        noteImageView.contentMode = .scaleAspectFill
        noteImageView.clipsToBounds = true
        addSubview(noteImageView)
        
    }
    // MARK - 设置子视图约束，由子类实现
    public func setupConstraints() {
        
    }
    // MARK - 由子类自己实现
    public func configSubviews() {
        
    }
    public func updateImageViewFrame(image:KFCrossPlatformImage?, imageView:UIImageView!) {
        var displayWidth:CGFloat?
        var displayHeight:CGFloat?
        guard let image = image else { return }
        
        if displayWidth == nil || displayHeight == nil {
            // 根据画布宽度和图片的实际尺寸调整显示尺寸
            // 图片的宽高比
            let aspectRatio = image.size.width / image.size.height
            if displayWidth == nil, let height = displayHeight {
                displayWidth = height * aspectRatio
            } else if displayHeight == nil, let width = displayWidth {
                displayHeight = width / aspectRatio
            } else {
                displayWidth = min(WL_SCREEN_WIDTH - 2 * 20 - 2*10, image.size.width)
                displayHeight = displayWidth! / aspectRatio
            }
        }
        guard let finalWidth = displayWidth, let finalHeight = displayHeight else { return }
        imageView.snp.updateConstraints({ make in
            make.height.equalTo(finalHeight)
            make.width.equalTo(finalWidth)
        })
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
