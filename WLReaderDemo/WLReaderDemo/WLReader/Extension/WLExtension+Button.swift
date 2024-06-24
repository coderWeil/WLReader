//
//  WLExtension+Button.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/23.
//

import UIKit

extension UIButton {
    /// 为UIView添加虚线下划线
    /// - Parameters:
    ///   - color: 虚线颜色
    ///   - height: 虚线高度
    ///   - dashPattern: 虚线样式
    func addDottedUnderline(color: UIColor = .black, height: CGFloat = 1.0, dashPattern: [NSNumber] = [2, 2]) {
        // 确保不会重复添加相同的虚线下划线
        self.removeDottedUnderline()
        
        // 创建虚线的CAShapeLayer
        let dottedLineLayer = CAShapeLayer()
        dottedLineLayer.strokeColor = color.cgColor
        dottedLineLayer.lineWidth = height
        dottedLineLayer.lineDashPattern = dashPattern
        
        // 设置虚线路径
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: self.bounds.height), CGPoint(x: self.bounds.width, y: self.bounds.height)])
        dottedLineLayer.path = path
        
        // 使用关联对象存储虚线的CAShapeLayer
        objc_setAssociatedObject(self, &AssociatedKeys.dottedUnderlineLayer, dottedLineLayer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // 动态调整下划线Layer的尺寸
        self.layoutIfNeeded()
        dottedLineLayer.frame = self.bounds
        
        // 将虚线的Layer添加到视图的Layer中
        self.layer.addSublayer(dottedLineLayer)
    }
    
    /// 移除UIView中的虚线下划线
    func removeDottedUnderline() {
        if let dottedLineLayer = objc_getAssociatedObject(self, &AssociatedKeys.dottedUnderlineLayer) as? CAShapeLayer {
            dottedLineLayer.removeFromSuperlayer()
        }
    }
    
    private struct AssociatedKeys {
        static var dottedUnderlineLayer = "dottedUnderlineLayer"
    }
}
