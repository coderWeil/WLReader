//
//  DKReadContainerView.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/14.
//  阅读容器，实际承载阅读主视图的视图容器

import UIKit

@objc protocol WLContainerDelegate: NSObjectProtocol {
    @objc optional func didClickCover(container:WLContainerView)
}

class WLContainerView: UIView {
    /// 覆盖层，这个在章节列表显示的时候才显示
    private var coverBtn:UIButton!
    public weak var delegate:WLContainerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        coverBtn = UIButton(type: .custom)
        coverBtn.backgroundColor = .black.withAlphaComponent(0.4)
        coverBtn.alpha = 0
        coverBtn.addTarget(self, action: #selector(_onCoverClick), for: .touchUpInside)
        addSubview(coverBtn)
    }
    @objc private func _onCoverClick() {
        showCover(show: false)
        if let del = delegate {
            del.didClickCover?(container: self)
        }
    }
    public func showCover(show:Bool) {
        if show {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.coverBtn.alpha = 1.0
            }
        }else {
            UIView.animate(withDuration: WL_READER_DEFAULT_ANIMATION_DURATION) {
                self.coverBtn.alpha = 0.0
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        coverBtn.frame = bounds
    }
}
