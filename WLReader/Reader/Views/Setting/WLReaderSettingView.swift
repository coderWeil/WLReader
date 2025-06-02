//
//  WLReaderSettingView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/24.
//  字体，翻页，亮度，字号，背景，对齐方式

import UIKit
import SnapKit

class WLReaderSettingView: WLReaderMenuBaseView {
    private var closeBtn:UIButton!
    /// 字号更改
    private var fontSizeView:UIView!
    private var subBtn:UIButton!
    private var fontSizeLabel:UILabel!
    private var addBtn:UIButton!
    /// 字体更改
    private var fontTypeView:UIControl!
    private var fontTypeLabel:UILabel!
    private var fontTypeArrow:UIImageView!
    /// 翻页方式
    private var effectTypeView:UIControl!
    private var effectTypeLabel:UILabel!
    private var effectTypeArrow:UIImageView!
    /// 行间距更改
    private var lineSpacingView:UIView!
    private var tightLineSpacing:UIButton!
    private var middleLineSpacing:UIButton!
    private var slightLineSpacing:UIButton!
    private var lineView:UIView!
    
    override func addSubviews() {
        super.addSubviews()
        initCloseBtn()
        initFontSizeView()
        initFontTypeView()
        initEffectTypeView()
        initLineSpacingView()
    }
    private func initCloseBtn() {
        lineView = UIView()
        lineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
        addSubview(lineView)
        
        closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage(named: "reader_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeBtn.addTarget(self, action: #selector(_onCloseEvent), for: .touchUpInside)
        closeBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -90 / 180)
        closeBtn.tintColor = WL_READER_TEXT_COLOR
        addSubview(closeBtn)
        lineView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        closeBtn.snp.makeConstraints { make in
            make.left.equalTo(WL_READER_HORIZONTAL_MARGIN)
            make.top.equalTo(20)
            make.width.height.equalTo(15)
        }
    }
    private func initFontSizeView() {
        fontSizeView = UIView()
        fontSizeView.layer.cornerRadius = 20
        fontSizeView.backgroundColor = WL_READER_SLIDER_MAXTRACK.withAlphaComponent(0.3)
        addSubview(fontSizeView)
        
        subBtn = UIButton(type: .custom)
        subBtn.setTitle("-", for: .normal)
        subBtn.setTitleColor(WL_READER_TEXT_COLOR, for: .normal)
        subBtn.titleLabel?.font = WL_READER_FONT_14
        subBtn.addTarget(self, action: #selector(_onClickSubFontEvent), for: .touchUpInside)
        fontSizeView.addSubview(subBtn)
        
        fontSizeLabel = UILabel()
        fontSizeLabel.font = WL_READER_FONT_14
        fontSizeLabel.text = "\(Int(WLBookConfig.shared.fontSize))"
        fontSizeLabel.textColor = WL_READER_TEXT_COLOR
        fontSizeView.addSubview(fontSizeLabel)
        
        addBtn = UIButton(type: .custom)
        addBtn.setTitle("+", for: .normal)
        addBtn.setTitleColor(WL_READER_TEXT_COLOR, for: .normal)
        addBtn.titleLabel?.font = WL_READER_FONT_14
        addBtn.addTarget(self, action: #selector(_onClickAddFontEvent), for: .touchUpInside)
        fontSizeView.addSubview(addBtn)
        
        fontSizeView.snp.makeConstraints { make in
            make.left.equalTo(WL_READER_HORIZONTAL_MARGIN)
            make.top.equalTo(self.closeBtn.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(1/2.0).offset(-WL_READER_HORIZONTAL_MARGIN - 10)
            make.height.equalTo(40)
        }
        fontSizeLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        subBtn.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        addBtn.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
    }
    private func initFontTypeView() {
        fontTypeView = UIControl()
        fontTypeView.layer.cornerRadius = 20
        fontTypeView.backgroundColor = WL_READER_SLIDER_MAXTRACK.withAlphaComponent(0.3)
        fontTypeView.addTarget(self, action: #selector(_onClickChangeFontTypeEvent), for: .touchUpInside)
        addSubview(fontTypeView)
        
        fontTypeLabel = UILabel()
        fontTypeLabel.textColor = WL_READER_TEXT_COLOR
        fontTypeLabel.font = WL_READER_FONT_14
        fontTypeView.addSubview(fontTypeLabel)
        
        fontTypeArrow = UIImageView()
        fontTypeArrow.image = UIImage(named: "reader_back")?.withRenderingMode(.alwaysTemplate)
        fontTypeArrow.tintColor = WL_READER_TEXT_COLOR
        fontTypeArrow.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
        fontTypeView.addSubview(fontTypeArrow)
        
        fontTypeView.snp.makeConstraints { make in
            make.right.equalTo(-WL_READER_HORIZONTAL_MARGIN)
            make.width.height.centerY.equalTo(self.fontSizeView)
        }
        fontTypeArrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
            make.width.height.equalTo(15)
        }
        fontTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(self.fontTypeArrow.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    private func initEffectTypeView() {
        effectTypeView = UIControl()
        effectTypeView.layer.cornerRadius = 20
        effectTypeView.backgroundColor = WL_READER_SLIDER_MAXTRACK.withAlphaComponent(0.3)
        effectTypeView.addTarget(self, action: #selector(_onClickChangeEffectTypeEvent), for: .touchUpInside)
        addSubview(effectTypeView)
        
        effectTypeLabel = UILabel()
        effectTypeLabel.font = WL_READER_FONT_14
        effectTypeLabel.text = WLBookConfig.shared.effectTypeName
        effectTypeLabel.textColor = WL_READER_TEXT_COLOR
        effectTypeView.addSubview(effectTypeLabel)
        
        effectTypeArrow = UIImageView()
        effectTypeArrow.image = UIImage(named: "reader_back")?.withRenderingMode(.alwaysTemplate)
        effectTypeArrow.tintColor = WL_READER_TEXT_COLOR
        effectTypeArrow.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
        effectTypeView.addSubview(effectTypeArrow)
        
        effectTypeView.snp.makeConstraints { make in
            make.left.width.height.equalTo(self.fontSizeView)
            make.top.equalTo(self.fontSizeView.snp.bottom).offset(20)
        }
        
        effectTypeArrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
            make.width.height.equalTo(15)
        }
        effectTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(self.effectTypeArrow.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    private func initLineSpacingView() {
        lineSpacingView = UIView()
        lineSpacingView.layer.cornerRadius = 20
        lineSpacingView.backgroundColor = WL_READER_SLIDER_MAXTRACK.withAlphaComponent(0.3)
        addSubview(lineSpacingView)
        
        tightLineSpacing = UIButton(type: .custom)
        tightLineSpacing.setImage(UIImage(named: "spacing_tight")?.withRenderingMode(.alwaysTemplate), for: .normal)
        tightLineSpacing.addTarget(self, action: #selector(_onClickChangeLineSpacingTight), for: .touchUpInside)
        lineSpacingView.addSubview(tightLineSpacing)
        
        middleLineSpacing = UIButton(type: .custom)
        middleLineSpacing.setImage(UIImage(named: "spacing_middle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        middleLineSpacing.addTarget(self, action: #selector(_onClickChangeLineSpacingMiddle), for: .touchUpInside)
        lineSpacingView.addSubview(middleLineSpacing)
        
        slightLineSpacing = UIButton(type: .custom)
        slightLineSpacing.setImage(UIImage(named: "spacing_slight")?.withRenderingMode(.alwaysTemplate), for: .normal)
        slightLineSpacing.addTarget(self, action: #selector(_onClickChangeLineSpacingSlight), for: .touchUpInside)
        lineSpacingView.addSubview(slightLineSpacing)
        
        lineSpacingView.snp.makeConstraints { make in
            make.right.equalTo(-WL_READER_HORIZONTAL_MARGIN)
            make.width.height.centerY.equalTo(self.effectTypeView)
        }
        slightLineSpacing.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1/3.0)
        }
        middleLineSpacing.snp.makeConstraints { make in
            make.centerY.width.equalTo(self.slightLineSpacing)
            make.left.equalTo(self.slightLineSpacing.snp.right)
        }
        tightLineSpacing.snp.makeConstraints { make in
            make.centerY.width.equalTo(self.slightLineSpacing)
            make.right.equalToSuperview()
        }
        reload()
    }
    public func reload() {
        slightLineSpacing.tintColor = WLBookConfig.shared.spacingType == .big ? WL_READER_SLIDER_MINTRACK : WL_READER_TEXT_COLOR
        middleLineSpacing.tintColor = WLBookConfig.shared.spacingType == .middle ? WL_READER_SLIDER_MINTRACK : WL_READER_TEXT_COLOR
        tightLineSpacing.tintColor = WLBookConfig.shared.spacingType == .small ? WL_READER_SLIDER_MINTRACK : WL_READER_TEXT_COLOR
        effectTypeLabel.text = WLBookConfig.shared.effectTypeName
        fontTypeLabel.text = WLBookConfig.shared.fontDisplayName
    }
    
    // MARK - 减小字体
    @objc private func _onClickSubFontEvent() {
        let fontSize = WLBookConfig.shared.fontSize  - WL_READER_FONT_SIZE_CHANGE_STEP
        if fontSize >= WL_READER_FONT_SIZE_MIN   {
            WLBookConfig.shared.fontSizeInt = NSInteger(fontSize)
            fontSizeLabel.text = "\(Int(fontSize))"
            menu.delegate?.readerMenuChangeFontSize?(menu: menu)
        }
    }
    // MARK - 增大字体
    @objc private func _onClickAddFontEvent() {
        let fontSize = WLBookConfig.shared.fontSize + WL_READER_FONT_SIZE_CHANGE_STEP
        if fontSize <= WL_READER_FONT_SIZE_MAX  {
            WLBookConfig.shared.fontSizeInt = NSInteger(fontSize)
            fontSizeLabel.text = "\(Int(fontSize))"
            menu.delegate?.readerMenuChangeFontSize?(menu: menu)
        }
    }
    // MARK - 字体切换点击
    @objc private func _onClickChangeFontTypeEvent() {
        menu.showFontTypeView(show: true)
    }
    // MARK - 翻页方式切换点击
    @objc private func _onClickChangeEffectTypeEvent() {
        menu.showEffectTypeView(show: true)
    }
    // MARK - 行间距调整点击
    @objc private func _onClickChangeLineSpacingSlight() {
        WLBookConfig.shared.spacingIndex = 2
        menu.delegate?.readerMenuChangeLineSpacing?(menu: menu)
        reload()
    }
    @objc private func _onClickChangeLineSpacingMiddle() {
        WLBookConfig.shared.spacingIndex = 1
        menu.delegate?.readerMenuChangeLineSpacing?(menu: menu)
        reload()
    }
    @objc private func _onClickChangeLineSpacingTight() {
        WLBookConfig.shared.spacingIndex = 0
        menu.delegate?.readerMenuChangeLineSpacing?(menu: menu)
        reload()
    }
    @objc private func _onCloseEvent() {
        menu.showSettingView(show: false)
    }
    public func updateMainColor() {
        lineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
        closeBtn.tintColor = WL_READER_TEXT_COLOR
        subBtn.setTitleColor(WL_READER_TEXT_COLOR, for: .normal)
        addBtn.setTitleColor(WL_READER_TEXT_COLOR, for: .normal)
        fontSizeView.backgroundColor = WL_READER_SLIDER_MAXTRACK.withAlphaComponent(0.3)
        fontSizeLabel.textColor = WL_READER_TEXT_COLOR
        fontTypeView.backgroundColor = WL_READER_SLIDER_MAXTRACK.withAlphaComponent(0.3)
        fontTypeLabel.textColor = WL_READER_TEXT_COLOR
        fontTypeArrow.tintColor = WL_READER_TEXT_COLOR
        effectTypeView.backgroundColor = WL_READER_SLIDER_MAXTRACK.withAlphaComponent(0.3)
        effectTypeLabel.textColor = WL_READER_TEXT_COLOR
        effectTypeArrow.tintColor = WL_READER_TEXT_COLOR
        lineSpacingView.backgroundColor = WL_READER_SLIDER_MAXTRACK.withAlphaComponent(0.3)
        reload()
    }
}
