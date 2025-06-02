//
//  WLReaderBottomView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/24.
// 
//  章节列表，设置，笔记，上一章下一章切换(非滚动模式下有)

import UIKit
import SnapKit

class WLReaderBottomView: WLReaderMenuBaseView {
    private var progressView:WLBottomProgressView!
    private var functionView:WLBottomFunctionView!
    private var lineView:UIView!
    
    override func addSubviews() {
        super.addSubviews()
        
        lineView = UIView()
        lineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
        addSubview(lineView)
        
        progressView = WLBottomProgressView(menu: self.menu)
        addSubview(progressView)
        
        functionView = WLBottomFunctionView(menu: self.menu)
        addSubview(functionView)
        
        
        
        lineView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        progressView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(self.lineView.snp.bottom)
            make.height.equalTo(WL_READER_PROGRESS_HEIGHT)
        }
        functionView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-WL_BOTTOM_HOME_BAR_HEIGHT)
            make.top.equalTo(self.progressView.snp.bottom)
        }
        
    }
    public func updateMainColor() {
        functionView.updateMainColor()
        functionView.backgroundColor = WL_READER_MENU_BG_COLOR
        progressView.backgroundColor = WL_READER_MENU_BG_COLOR
        progressView.updateMainColor()
        lineView.backgroundColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.2)
    }
    public func reloadProgress() {
        progressView.reloadProgress()
    }
}
