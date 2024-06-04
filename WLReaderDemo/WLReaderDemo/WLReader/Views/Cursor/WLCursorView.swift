//
//  WLCursorView.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/3.
//

import UIKit

class WLCursorView: UIView {
    // 游标颜色
    var color:UIColor
    var isTorB:Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
     init(frame: CGRect, color:UIColor) {
        self.color = color
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        color.set()
        let rectW:CGFloat = bounds.width / 2
        ctx?.addRect(CGRect(x: (bounds.width - rectW) / 2, y: (isTorB ? 1 : 0), width: rectW, height: bounds.height - 1))
        ctx?.fillPath()
        if isTorB {
            ctx?.addEllipse(in: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width))
        }else{
            ctx?.addEllipse(in: CGRect(x: 0, y: bounds.height - bounds.width, width: bounds.width, height: bounds.width))
        }
        color.set()
        ctx?.fillPath()
    }
}
