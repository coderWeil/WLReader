//
//  WLNoteBottomView.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/30.
//

import UIKit
import SnapKit

@objc protocol WLNoteBottomViewDelegate: NSObjectProtocol {
    @objc optional func didClickSubmit()
    @objc optional func didClickSelectImage()
}

class WLNoteBottomView: UIView, UITextViewDelegate {
    // 上传图片
    private var selectImageBtn:UIButton?
    // 输入框
    private var textView:UITextView?
    // 发表
    private var submitBtn:UIButton?
    
    public weak var delegate:WLNoteBottomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        backgroundColor = .white
        
        selectImageBtn = UIButton(type: .custom)
        selectImageBtn?.setTitle("选择", for: .normal)
        selectImageBtn?.setTitleColor(WL_READER_CURSOR_COLOR, for: .normal)
        selectImageBtn?.titleLabel?.font = WL_FONT(18)
        selectImageBtn?.addTarget(self, action: #selector(onSelectImage), for: .touchUpInside)
        addSubview(selectImageBtn!)
        
        textView = UITextView()
        textView?.backgroundColor = UIColor(named: "read_text_color_1")?.withAlphaComponent(0.3)
        textView?.layer.cornerRadius = 8.0
        textView?.delegate = self
        addSubview(textView!)
        
        submitBtn = UIButton(type: .custom)
        submitBtn?.setTitle("发表", for: .normal)
        submitBtn?.setTitleColor(WL_READER_CURSOR_COLOR, for: .normal)
        submitBtn?.titleLabel?.font = WL_FONT(16)
        submitBtn?.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        addSubview(submitBtn!)
        
        selectImageBtn?.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview().offset(-WL_BOTTOM_HOME_BAR_HEIGHT*0.5)
        })
        
        submitBtn?.snp.makeConstraints({ make in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview().offset(-WL_BOTTOM_HOME_BAR_HEIGHT*0.5)
        })
        textView?.snp.makeConstraints({ make in
            make.left.equalTo(self.selectImageBtn!.snp.right).offset(16)
            make.right.equalTo(self.submitBtn!.snp.left).offset(-16)
            make.top.equalTo(10)
            make.bottom.equalTo(-WL_BOTTOM_HOME_BAR_HEIGHT - 10)
            make.height.equalTo(36)
        })
    }
    @objc private func onSubmit() {
        self.delegate?.didClickSubmit?()
    }
    
    @objc private func onSelectImage() {
        delegate?.didClickSelectImage?()
    }
    
    // 获取当前输入文本
    public func getInputText() -> String? {
        return textView?.text
    }
    // 设置初始文本
    public func setOriginText(text:String?) {
        textView?.text = text
    }
}

extension WLNoteBottomView {
    func textViewDidChange(_ textView: UITextView) {
        let fittingSize = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
        let sizeThatFitsTextView = textView.sizeThatFits(fittingSize)
        var height = sizeThatFitsTextView.height
        if height >= 100 {
            height = 100
        }
        textView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}
