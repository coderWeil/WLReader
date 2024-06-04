//
//  WLBookChapter+Display.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/4.
//  对html解析后的节点做特殊处理

import DTCoreText

extension WLBookChapter {
    /// 这里之所以要这么写，因为对应的epub解析出来的html文件，对应的标签层级都不同，只不过对每一层都做一次过滤，保证对应的节点正常
    public func setEelementDisplay(element:DTHTMLElement) {
        for node in element.childNodes {
            let _node = node as! DTHTMLElement
            configNoteDispaly(element: _node)
            setNodeDisplay(element: _node)
        }
    }
    private func setNodeDisplay(element:DTHTMLElement!) {
        if (element.childNodes != nil) {
            for node in element.childNodes {
                configNoteDispaly(element: node as! DTHTMLElement)
                setNodeDisplay(element: node as? DTHTMLElement)
            }
        }else {
            configNoteDispaly(element: element)
        }
    }
    private func configNoteDispaly(element:DTHTMLElement) {
        if element.name == "img" {
            setImageDisplay(element: element)
        }else if element.name == "h1" || element.name == "h2" {
            setHTitleDisplay(element: element)
        }else if element.name == "figcaption" {
            setFigcaptionDisplay(element: element)
        }
    }
    
    /// 更改图片的实际布局宽高
    private func setImageDisplay(element:DTHTMLElement) {
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
    private func setFigcaptionDisplay(element:DTHTMLElement) {
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
    private func setHTitleDisplay(element:DTHTMLElement) {
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
