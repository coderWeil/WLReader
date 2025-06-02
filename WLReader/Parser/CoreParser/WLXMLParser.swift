//
//  WLXMLParser.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/17.
//  这个类是用来解析对应的xml文件

import Foundation
import AEXML
import DTCoreText

public class WLXmlNode {
    var tag: String
    var content: String
    var media: Bool {
        return ["h1", "h2", "h3", "h4", "h5", "h6"].contains(tag)
    }
    var isIgnore:Bool {
        return ["hr"].contains(tag)
    }
    
    /// 是否是一级标题,一级标题需要加粗，否则不需要
    var isFirstTitle: Bool {
        return tag == "h1"
    }
    
    
    init(_ tag: String, _ content: String) {
        self.tag = tag
        self.content = content
    }
}

public class WLXMLParser {
    public var xmlNodes = [WLXmlNode]()
    private var options = AEXMLOptions()
    private var baseHref: URL!
    init() {
        options.parserSettings.shouldProcessNamespaces = false
        options.parserSettings.shouldReportNamespacePrefixes = false
        options.parserSettings.shouldResolveExternalEntities = false
    }

    public func content(_ href: URL!) {
        do {
            self.baseHref = href
            let data = try Data(contentsOf: href)
            let xmlDoc = try AEXMLDocument(xml: data, options: options)
            for child in xmlDoc.root["body"].children {
                parserXml(child: child)
            }
        } catch {
            print(error)
        }
    }
    /// 解析XML标签
    func parserXml(child: AEXMLElement) {
        if child.children.count > 0 {
            for subChild in child.children {
                parserXml(child: subChild)
            }
        } else {
            if let value = child.value, value.count > 0 {
                // 如果上一段落是文本没必要新建模型，直接拼接到上一个模型上去
                // 因为某些文本文件有大量短段落，每段都生成属性字符串时会导致内存问题
//                if let prevNode = xmlNodes.last, prevNode.tag != "img", !prevNode.media {
//                    prevNode.content += ("\n"+value)
//                } else {
                if child.name != "hr" {
                    xmlNodes.append(WLXmlNode(child.name,value))
                }
                    
//                }
            } else {
                if child.name == "img", let src = child.attributes["src"] {
                    xmlNodes.append(WLXmlNode("img",src))
                } else if child.name == "image", let src = child.attributes["xlink:href"] {
                    xmlNodes.append(WLXmlNode("img", src))
                }
            }
        }
    }
    
    /// XML文件解析为属性字符串
    func attributeStr(_ config: WLBookConfig) -> NSMutableAttributedString {
        guard let href = baseHref else {
            return NSMutableAttributedString(string: "🆘🆘🆘 解析内容发生错误")
        }
        let text = NSMutableAttributedString()
        for xmlNode in xmlNodes {
            if xmlNode.tag == "img" {
                let path = href.deletingLastPathComponent().appendingPathComponent(xmlNode.content)
                let image = UIImage(contentsOfFile: path.path)
                if let image = image {
                    if image.size.width > config.readContentRect.width, let _ = image.cgImage {
//                        let rate = image.size.width / config.readContentRect.width
//                        let tempIma = UIImage(cgImage: cgimage, scale: rate, orientation: .up)
//                        let imageAttr = attachMent(image: tempIma, font: config.font)
//                        imageAttr.yy_lineSpacing = 10
//                        text.append(imageAttr)
//                        
//                        let lineBreak = NSMutableAttributedString(string: "\n")
//                        lineBreak.addAttribute(.font, value: config.font, range: NSMakeRange(0, lineBreak.length))
//                        text.append(lineBreak)
                    } else {
//                        let imageAttr = attachMent(image: image, font: config.font)
//                        imageAttr.yy_lineSpacing = 10
//                        text.append(imageAttr)
//                
//                        let lineBreak = NSMutableAttributedString(string: "\n")
//                        lineBreak.addAttribute(.font, value: config.font, range: NSMakeRange(0, lineBreak.length))
//                        text.append(lineBreak)
                    }
                }
            } else {
//                let conText = NSMutableAttributedString(string: xmlNode.content)
//                conText.yy_font = config.font
//                conText.yy_color = WL_READER_TEXT_COLOR
//                conText.yy_alignment = .justified
//                conText.yy_lineSpacing = 10
//                conText.yy_paragraphSpacing = config.paragraphSpacing
//                conText.yy_firstLineHeadIndent = 32
//                if xmlNode.media {
//                    conText.yy_alignment = .center
//                    conText.yy_font = config.boldFont
//                } else if xmlNode.tag == "blockquote" { // 引用
//                    conText.yy_color = WL_READER_TEXT_COLOR.withAlphaComponent(0.6)
//                    conText.yy_lineSpacing = 5
//                    conText.yy_paragraphSpacing = 10
//                } else if xmlNode.tag == "figcaption" { // 注解
//                    conText.yy_firstLineHeadIndent = 0
//                    conText.yy_paragraphSpacing = 5
//                    conText.yy_lineSpacing = 5
//                    conText.yy_alignment = .center
//                    conText.yy_color = WL_READER_TEXT_COLOR.withAlphaComponent(0.6)
//                    conText.yy_font = UIFont.italicSystemFont(ofSize: config.fontSize)
//                }
//                text.append(conText)
//                
//                let lineBreak = NSMutableAttributedString(string: "\n")
//                lineBreak.addAttribute(.font, value: config.font, range: NSMakeRange(0, lineBreak.length))
//                text.append(lineBreak)
                
            }
        }
        

        
        return text
    }
    
//    func attachMent(image: UIImage, font: UIFont) -> NSMutableAttributedString {
//        return NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .scaleAspectFit, attachmentSize: image.size, alignTo: font, alignment: .center)
//    }
}
