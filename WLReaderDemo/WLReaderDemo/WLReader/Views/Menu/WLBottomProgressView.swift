//
//  WLBottomProgressView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/25.
//  阅读进度视图，包含当前阅读进度，切换上一章，下一章

import UIKit
import SnapKit

class WLBottomProgressView: WLReaderMenuBaseView {
    /// 上一章
    private var previousBtn:UIButton!
    /// 进度
    private var progressSlider:UISlider!
    /// 下一章
    private var nextBtn:UIButton!
    
    override func addSubviews() {
        super.addSubviews()
        previousBtn = UIButton(type: .custom)
        previousBtn.setTitle("上一章", for: .normal)
        previousBtn.setTitleColor(WL_READER_TEXT_COLOR, for: .normal)
        previousBtn.titleLabel?.font = WL_READER_FONT_14
        previousBtn.addTarget(self, action: #selector(_onClickPreviousEvent), for: .touchUpInside)
        addSubview(previousBtn)
        
        nextBtn = UIButton(type: .custom)
        nextBtn.setTitle("下一章", for: .normal)
        nextBtn.setTitleColor(WL_READER_TEXT_COLOR, for: .normal)
        nextBtn.titleLabel?.font = WL_READER_FONT_14
        nextBtn.addTarget(self, action: #selector(_onClickNextEvent), for: .touchUpInside)
        addSubview(nextBtn)
        
        progressSlider = UISlider()
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.maximumTrackTintColor = WL_READER_SLIDER_MAXTRACK
        progressSlider.minimumTrackTintColor = WL_READER_SLIDER_MINTRACK
        progressSlider.tintColor = WL_READER_SLIDER_DOT_COLOR
        progressSlider.setThumbImage(UIImage(named: "reader_slider")?.withRenderingMode(.alwaysTemplate), for: .normal)
        progressSlider.addTarget(self, action: #selector(_onSliderValueChange), for: .valueChanged)
        addSubview(progressSlider)
        
        previousBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(WL_READER_HORIZONTAL_MARGIN)
        }
        nextBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-WL_READER_HORIZONTAL_MARGIN)
        }
        progressSlider.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.previousBtn.snp.rightMargin).offset(20)
            make.right.equalTo(self.nextBtn.snp.leftMargin).offset(-20)
        }
    }
    @objc private func _onClickPreviousEvent() {
        menu.delegate?.readerMenuPreviousEvent?()
    }
    @objc private func _onClickNextEvent() {
        menu.delegate?.readerMenuNextEvent?()
    }
    @objc private func _onSliderValueChange() {
        menu.delegate?.readerMenuDraggingProgress?(progress: progressSlider.value)
    }
    public func reloadProgress() {
        if WLBookConfig.shared.bottomProgressIsChapter {
            previousBtn.setTitle("上一章", for: .normal)
            nextBtn.setTitle("下一章", for: .normal)
        }else {
            previousBtn.setTitle("上一页", for: .normal)
            nextBtn.setTitle("下一页", for: .normal)
        }
        progressSlider.value = menu.caclReadProgress()
    }
    public func updateMainColor() {
        previousBtn.setTitleColor(WL_READER_TEXT_COLOR, for: .normal)
        nextBtn.setTitleColor(WL_READER_TEXT_COLOR, for: .normal)
    }
}

