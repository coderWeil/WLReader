//
//  WLBookChapter+Display.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/4.
//  对html解析后的节点做特殊处理

import DTCoreText

extension WLBookChapter {
    /// 更改图片的实际布局宽高
    public func setImageDisplay(element:DTHTMLElement) {
        if let childNodes = element.childNodes, childNodes.count > 0 {
            for node in childNodes {
                setImageDisplay(element: node as! DTHTMLElement)
            }
        }else {
            if element.name == "img" {
                var displayWidth: CGFloat? = nil
                var displayHeight: CGFloat? = nil
                
                if let width = element.attributes["width"] as? String {
                    displayWidth = CGFloat(Double(width) ?? 0)
                }
                if let height = element.attributes["height"] as? String {
                    displayHeight = CGFloat(Double(height) ?? 0)
                }
                let imageAttachment = element.textAttachment!
                let image = imageAttachment.image
                guard let image = image else { return }
                
                if displayWidth == nil || displayHeight == nil {
                    // 根据画布宽度和图片的实际尺寸调整显示尺寸
                    let aspectRatio = image.size.width / image.size.height
                    if displayWidth == nil, let height = displayHeight {
                        displayWidth = height * aspectRatio
                    } else if displayHeight == nil, let width = displayWidth {
                        displayHeight = width / aspectRatio
                    } else {
                        displayWidth = min(WLBookConfig.shared.readContentRect.width, image.size.width)
                        displayHeight = displayWidth! / aspectRatio
                    }
                }
                
                guard let finalWidth = displayWidth, let finalHeight = displayHeight else { return }
                imageAttachment.displaySize = CGSize(width: finalWidth, height: finalHeight)
            }
        }
    }
    /// 设置图片描述的文本样式
    public func setFigcaptionDisplay(element:DTHTMLElement) {
        if let childNodes = element.childNodes, childNodes.count > 0 {
            for node in childNodes {
                setFigcaptionDisplay(element: node as! DTHTMLElement)
            }
        }else {
            element.textColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.8)
            let paragraphStyle = element.paragraphStyle
            paragraphStyle?.alignment = .center
            paragraphStyle?.lineHeightMultiple = 1.2
            paragraphStyle?.paragraphSpacing = 0
            element.paragraphStyle = paragraphStyle
            let fontDescriptor = element.fontDescriptor
            fontDescriptor?.pointSize = 14
            element.fontDescriptor = fontDescriptor
        }
    }
    /// 更改标题的布局
    public func setHTitleDisplay(element:DTHTMLElement) {
        if let childNodes = element.childNodes, childNodes.count > 0 {
            for node in childNodes {
                setHTitleDisplay(element: node as! DTHTMLElement)
            }
        }else {
            let paragraphStyle = element.paragraphStyle
            paragraphStyle?.alignment = .center
            paragraphStyle?.lineHeightMultiple = 4
            paragraphStyle?.paragraphSpacing = 0
            element.paragraphStyle = paragraphStyle
            let fontDescriptor = element.fontDescriptor
            fontDescriptor?.pointSize = 20
            fontDescriptor?.boldTrait = true
            element.fontDescriptor = fontDescriptor
            
        }
    }
}
