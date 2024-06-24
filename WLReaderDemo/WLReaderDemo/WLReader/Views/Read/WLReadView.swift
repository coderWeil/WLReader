//
//  WLReadView.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/14.
//  阅读视图

import UIKit
import DTCoreText

/// 光标拖拽触发范围
let WL_READ_LONG_PRESS_CURSOR_VIEW_OFFSET:CGFloat = -20

class WLReadView: UIView, DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate {
    /// 显示内容视图
    public var contentView:WLAttributedView!    /// 这个是用于除滚动模式之外的
    public var pageModel:WLBookPage! {
        didSet {
            contentView.attributedString = pageModel.content
            contentView.contentRange = pageModel.contentRange
            contentView.attributedString = pageModel.chapterContent
            var rect = contentView.bounds
            let insets = contentView.edgeInsets
            rect.origin.x    += insets.left;
            rect.origin.y    += insets.top;
            rect.size.width  -= (insets.left + insets.right);
            rect.size.height -= (insets.top  + insets.bottom);
            let layoutFrame = contentView.layouter.layoutFrame(with: rect, range: pageModel.contentRange)
            contentView.layoutFrame = layoutFrame
            contentView.configNotesArr()
        }
    }
    /// 这个用于滚动模式下的数据
    public var chapterModel:WLBookChapter! {
        didSet {
            contentView.attributedString = chapterModel.chapterContentAttr
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
        backgroundColor = .clear
        contentView = WLAttributedView(frame: bounds)
        contentView.shouldDrawImages = false
        contentView.shouldDrawLinks = true
        contentView.backgroundColor = .clear
        contentView.edgeInsets = UIEdgeInsets(top: 0, left: WLBookConfig.shared.readerEdget, bottom: 0, right: WLBookConfig.shared.readerEdget)
        addSubview(contentView)
    }
}
