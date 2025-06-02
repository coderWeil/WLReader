//
//  WLManifierView.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/27.
//  选中拖动过程中的放大镜

import UIKit

/// 放大比例
private let WL_MANIFIER_SCALE = 1.5
/// 放大区域
private let WL_MANIFIER_WH:CGFloat = 120

private var manifierView:WLManifierView!

class WLManifierView: UIView {
    weak var targetView:UIView!
    var locatePoint: CGPoint = CGPoint() {
        didSet {
            self.center = CGPoint(x: locatePoint.x, y: locatePoint.y)
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = WL_MANIFIER_WH / 2
        self.layer.masksToBounds = true
        backgroundColor = WL_READER_BG_COLOR
    }
    
    init() {
        
        super.init(frame: CGRect(x: 0, y: 0, width: WL_MANIFIER_WH, height: WL_MANIFIER_WH))
        
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = WL_MANIFIER_WH / 2
        self.layer.masksToBounds = true
        backgroundColor = WL_READER_BG_COLOR
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if targetView != nil{
            let ctx = UIGraphicsGetCurrentContext()
            ctx?.translateBy(x: self.frame.width/2, y: self.frame.height/2)
            ctx?.scaleBy(x: WL_MANIFIER_SCALE, y: WL_MANIFIER_SCALE)
            ctx?.translateBy(x: -1 * locatePoint.x, y: -1 * (locatePoint.y))
            targetView.layer.render(in: ctx!)
        }

    }
}
