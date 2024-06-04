//
//  WLReaderTopView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/24.
//  返回，分享，书签

import UIKit
import SnapKit

class WLReaderTopView: WLReaderMenuBaseView {
    /// 内容视图
    private var contentView:UIView!
    private var backBtn:UIButton!
    private var shareBtn:UIButton!
    private var markBtn:UIButton!
    /// 底部下划线
    private var lineView:UIView!
        
   override func addSubviews() {
       super.addSubviews()
        contentView = UIView()
        contentView.backgroundColor = .clear
        addSubview(contentView)
        
        backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "reader_back")!.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = WL_READER_TEXT_COLOR
        backBtn.addTarget(self, action: #selector(_onBackEvent), for: .touchUpInside)
        contentView.addSubview(backBtn)
        
        shareBtn = UIButton(type: .custom)
        shareBtn.setImage(UIImage(named: "reader_share")!.withRenderingMode(.alwaysTemplate), for: .normal)
        shareBtn.tintColor = WL_READER_TEXT_COLOR
        shareBtn.isHidden = !WLBookConfig.shared.showShareBtn
        shareBtn.addTarget(self, action: #selector(_onShareEvent), for: .touchUpInside)
        contentView.addSubview(shareBtn)
        
        markBtn = UIButton(type: .custom)
        markBtn.setImage(UIImage(named: "reader_mark")!.withRenderingMode(.alwaysTemplate), for: .normal)
        markBtn.setImage(UIImage(named: "reader_mark_selected")!.withRenderingMode(.alwaysTemplate), for: .selected)
        markBtn.tintColor = WL_READER_TEXT_COLOR
        markBtn.isHidden = !WLBookConfig.shared.showMarkBtn
        markBtn.addTarget(self, action: #selector(_onMarkEvent), for: .touchUpInside)
        contentView.addSubview(markBtn)
       
       lineView = UIView()
       lineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
       contentView.addSubview(lineView)
        
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(WL_STATUS_BAR_HEIGHT)
        }
        
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(WL_READER_HORIZONTAL_MARGIN)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        markBtn.snp.makeConstraints { make in
            make.right.equalTo(-WL_READER_HORIZONTAL_MARGIN)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        shareBtn.snp.makeConstraints { make in
            make.right.equalTo(self.markBtn.snp_leftMargin).offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
       lineView.snp.makeConstraints { make in
           make.left.bottom.right.equalToSuperview()
           make.height.equalTo(0.5)
       }
    }
    
    @objc private func _onBackEvent() {
        menu?.delegate?.readerMenuBackEvent?()
    }
    
    @objc private func _onShareEvent() {
        menu?.delegate?.readerMenuShareEvent?()
    }
    @objc private func _onMarkEvent() {
        markBtn.isSelected = !markBtn.isSelected
        markBtn.tintColor = markBtn.isSelected ? WL_READER_CURSOR_COLOR : WL_READER_TEXT_COLOR
        menu?.delegate?.readerMenuMarkEvent?(selected: markBtn.isSelected)
    }
    public func updateMainColor() {
        backBtn.tintColor = WL_READER_TEXT_COLOR
        shareBtn.tintColor = WL_READER_TEXT_COLOR
        markBtn.tintColor = markBtn.isSelected ? WL_READER_CURSOR_COLOR : WL_READER_TEXT_COLOR
        lineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
    }
    public func updateTopView() {
        let markModel:WLBookMarkModel? = WLBookMarkModel.readMarkModel()
        if markModel != nil {
            markBtn.isSelected = true
        }else {
            markBtn.isSelected = false
        }
        markBtn.tintColor = markBtn.isSelected ? WL_READER_CURSOR_COLOR : WL_READER_TEXT_COLOR
    }
}
