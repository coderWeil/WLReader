//
//  WLBottomFunctionView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/25.
//  功能视图,包含有章节入口，笔记，设置入口

import UIKit
import SnapKit

class WLBottomFunctionView: WLReaderMenuBaseView {
    /// 章节入口
    private var catalogueView:UIView!
    private var catalogueBtn:UIButton!
    /// 笔记
    private var noteView:UIView!
    private var noteBtn:UIButton!
    /// 亮度调节
    private var brightView:UIView!
    private var brightBtn:UIButton!
    /// 设置
    private var settingView:UIView!
    private var settingBtn:UIButton!
    
    override func addSubviews() {
        super.addSubviews()
        catalogueView = UIView()
        addSubview(catalogueView)
        
        noteView = UIView()
        addSubview(noteView)
        
        brightView = UIView()
        addSubview(brightView)
        
        settingView = UIView()
        addSubview(settingView)
        
        catalogueView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1/4.0)
        }
        noteView.snp.makeConstraints { make in
            make.left.equalTo(self.catalogueView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1/4.0)
        }
        brightView.snp.makeConstraints { make in
            make.left.equalTo(self.noteView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1/4.0)
        }
        settingView.snp.makeConstraints { make in
            make.left.equalTo(self.brightView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1/4.0)
        }
        
        catalogueBtn = UIButton(type: .custom)
        catalogueBtn.setImage(UIImage(named: "reader_catalogue")!.withRenderingMode(.alwaysTemplate), for: .normal)
        catalogueBtn.tintColor = WL_READER_TEXT_COLOR
        catalogueBtn.addTarget(self, action: #selector(_onCatalogueClick), for: .touchUpInside)
        catalogueView.addSubview(catalogueBtn)
        
        noteBtn = UIButton(type: .custom)
        noteBtn.setImage(UIImage(named: "reader_note")!.withRenderingMode(.alwaysTemplate), for: .normal)
        noteBtn.tintColor = WL_READER_TEXT_COLOR
        noteBtn.addTarget(self, action: #selector(_onNoteClick), for: .touchUpInside)
        noteView.addSubview(noteBtn)
        
        brightBtn = UIButton(type: .custom)
        brightBtn.setImage(UIImage(named: "reader_light_right")!.withRenderingMode(.alwaysTemplate), for: .normal)
        brightBtn.tintColor = WL_READER_TEXT_COLOR
        brightBtn.addTarget(self, action: #selector(_onBgColorClick), for: .touchUpInside)
        brightView.addSubview(brightBtn)
        
        settingBtn = UIButton(type: .custom)
        settingBtn.setImage(UIImage(named: "reader_setting")!.withRenderingMode(.alwaysTemplate), for: .normal)
        settingBtn.tintColor = WL_READER_TEXT_COLOR
        settingBtn.addTarget(self, action: #selector(_onSettingClick), for: .touchUpInside)
        settingView.addSubview(settingBtn)
        
        catalogueBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(WL_READER_HORIZONTAL_MARGIN)
            make.centerY.equalToSuperview()
        }
        noteBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-WL_READER_HORIZONTAL_MARGIN)
        }
        brightBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(WL_READER_HORIZONTAL_MARGIN)
        }
        settingBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-WL_READER_HORIZONTAL_MARGIN)
        }
    }
    
    @objc func _onCatalogueClick() {
        menu.delegate?.readerMenuClickCatalogueEvent?(menu: menu)
    }
    @objc func _onSettingClick() {
        menu.showSettingView(show: true)
        menu.delegate?.readerMenuClickSettingEvent?(menu: menu)
    }
    @objc func _onBgColorClick() {
        menu.showBgColorView(show: true)
    }
    @objc func _onNoteClick() {
        menu.showNoteView(show: true)
        menu.delegate?.readerMenuClickNoteEvent?()
    }
    public func updateMainColor() {
        catalogueBtn.tintColor = WL_READER_TEXT_COLOR
        noteBtn.tintColor = WL_READER_TEXT_COLOR
        brightBtn.tintColor = WL_READER_TEXT_COLOR
        settingBtn.tintColor = WL_READER_TEXT_COLOR
    }
}
