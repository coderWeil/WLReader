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
        guard let childNodes = element.childNodes else { return }
        for node in childNodes {
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
        if element.name == "img" || element.name == "image" {
            setImageDisplay(element: element)
        }else if element.name == "h1" || element.name == "h2" {
            setHTitleDisplay(element: element)
        }else if element.name == "figcaption" {
            setFigcaptionDisplay(element: element)
        }else if element.name == "blockquote" {
            setBlockquoteDisplay(element: element)
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
                    // 图片的宽高比
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
                if displayHeight! > WLBookConfig.shared.readContentRect.height { // 如果图片高度比预定的显示高度要高，则给个默认的高度为最大高度值减去50，如果不这么做，在分页的时候，图片单独占一页会发现pageVisible的range对应的length 为0，就没法正确分页了，这个是比较坑的
                    displayHeight = WLBookConfig.shared.readContentRect.height - 50
                }
//                displayHeight = WLBookConfig.shared.readContentRect.height - 50
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
            fontDescriptor?.pointSize = WLBookConfig.shared.fontSize + 4.0
            fontDescriptor?.boldTrait = true
            element.fontDescriptor = fontDescriptor
        }
    }
    private func setBlockquoteDisplay(element:DTHTMLElement) {
        if let childNodes = element.childNodes, childNodes.count > 0 {
            for node in childNodes {
                setBlockquoteDisplay(element: node as! DTHTMLElement)
            }
        }else {
            let paragraphStyle = element.paragraphStyle
            paragraphStyle?.alignment = .center
            paragraphStyle?.lineHeightMultiple = 1.5
            element.paragraphStyle = paragraphStyle
            let fontDescriptor = element.fontDescriptor
            fontDescriptor?.italicTrait = true
            fontDescriptor?.pointSize = 14
            element.fontDescriptor = fontDescriptor
            element.textColor = WL_READER_TEXT_COLOR.withAlphaComponent(0.8)
        }
    }
}
