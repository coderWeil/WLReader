//
//  WLBrightnessView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/26.
//  亮度，背景

import UIKit
import SnapKit

class WLBgColorView: WLReaderMenuBaseView {
    private var closeBtn:UIButton!
    /// 亮度调节
    private var leftImageView:UIImageView!
    private var brightSlider:UISlider!
    private var rightImageView:UIImageView!
    /// 默认提供的几种背景色配置
    var bgItems:[UIButton]! = []
    var selectItem:UIButton!
    private var lineView:UIView!
    override func addSubviews() {
        super.addSubviews()
        initCloseBtn()
        initBrightnessView()
        initBackgroundColor()
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
    /// 亮度调节
    private func initBrightnessView() {
        leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "reader_light_left")!.withRenderingMode(.alwaysTemplate)
        leftImageView.tintColor = WL_READER_TEXT_COLOR
        addSubview(leftImageView)
        
        brightSlider = UISlider()
        brightSlider.minimumValue = 0
        brightSlider.maximumValue = 1
        brightSlider.maximumTrackTintColor = WL_READER_SLIDER_MAXTRACK
        brightSlider.minimumTrackTintColor = WL_READER_SLIDER_MINTRACK
        brightSlider.tintColor = WL_READER_SLIDER_DOT_COLOR
        brightSlider.setThumbImage(UIImage(named: "reader_slider")?.withRenderingMode(.alwaysTemplate), for: .normal)
        brightSlider.addTarget(self, action: #selector(_onSliderValueChange), for: .valueChanged)
        brightSlider.value = Float(UIScreen.main.brightness)
        addSubview(brightSlider)
        
        rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "reader_light_right")!.withRenderingMode(.alwaysTemplate)
        rightImageView.tintColor = WL_READER_TEXT_COLOR
        addSubview(rightImageView)
        
        leftImageView.snp.makeConstraints { make in
            make.top.equalTo(self.closeBtn.snp.bottom).offset(20)
            make.left.equalTo(WL_READER_HORIZONTAL_MARGIN)
            make.width.height.equalTo(20)
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.leftImageView.snp.centerY)
            make.right.equalTo(-WL_READER_HORIZONTAL_MARGIN)
            make.width.height.equalTo(20)
        }
        brightSlider.snp.makeConstraints { make in
            make.left.equalTo(self.leftImageView.snp.right).offset(20)
            make.right.equalTo(self.rightImageView.snp.left).offset(-20)
            make.centerY.equalTo(self.leftImageView.snp.centerY)
        }
    }
    /// 背景色选择
    private func initBackgroundColor() {
        
        for i in 0..<WL_READER_BG_COLORS.count {
            let color = WL_READER_BG_COLORS[i]
            let item = UIButton(type: .custom)
            item.tag = i
            item.backgroundColor = color
            item.layer.cornerRadius = 6
            item.layer.borderColor = WL_READER_CURSOR_COLOR.cgColor
            item.layer.borderWidth = 0
            item.addTarget(self, action: #selector(clickItem(_:)), for: .touchUpInside)
            addSubview(item)
            bgItems.append(item)
            if i == WLBookConfig.shared.readerBackgroundColorIndex { selectItem(item) }
            
        }
        var lastItem:UIButton! = nil
        let itemW:CGFloat = 30
        let space:CGFloat = (WL_SCREEN_WIDTH - 2 * WL_READER_HORIZONTAL_MARGIN - CGFloat(bgItems.count) * itemW) / (CGFloat(bgItems.count) - 1)
        for i in 0..<bgItems.count {
            let item = bgItems[i]
            if lastItem == nil {
                item.snp.makeConstraints { make in
                    make.left.equalTo(WL_READER_HORIZONTAL_MARGIN)
                    make.top.equalTo(self.leftImageView.snp.bottom).offset(20)
                    make.width.height.equalTo(itemW)
                }
            }else {
                item.snp.makeConstraints { make in
                    make.left.equalTo(lastItem.snp.right).offset(space)
                    make.centerY.equalTo(lastItem.snp.centerY)
                    make.width.height.equalTo(itemW)
                }
            }
            lastItem = item
        }
        
    }
    private func selectItem(_ item:UIButton) {
        selectItem?.layer.borderWidth = 0
        item.layer.borderWidth = 1.5
        selectItem = item
    }
    @objc private func clickItem(_ item:UIButton) {
        if selectItem == item { return }
        selectItem(item)
        WLBookConfig.shared.readerBackgroundColorIndex = item.tag
        menu?.delegate?.readerMenuChangeBgColor?(menu: menu)
        menu.updateSubviewBackground()
    }
    @objc private func _onSliderValueChange() {
        menu.delegate?.readerMenuChangeBrightness?(value: brightSlider.value)
        UIScreen.main.brightness = CGFloat(brightSlider.value)
    }
    @objc private func _onCloseEvent() {
        menu.showBgColorView(show: false)
    }
    public func updateMainColor() {
        closeBtn.tintColor = WL_READER_TEXT_COLOR
        lineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
        leftImageView.tintColor = WL_READER_TEXT_COLOR
        rightImageView.tintColor = WL_READER_TEXT_COLOR
    }
}
