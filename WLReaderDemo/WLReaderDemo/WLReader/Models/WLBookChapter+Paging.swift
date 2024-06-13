//
//  WLBookChapter+Paging.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/4.
//  分页

import DTCoreText

extension WLBookChapter {
    /// 解析本章，获取分页
    public func paging() {
        let config = WLBookConfig.shared
        if forcePaging { // 强制分页之前，先将原有的分页清空
            pages.removeAll()
        }
        if chapterContentAttr == nil || forcePaging { // 强制分页，也需要更新设置
            var htmlData: Data!
            if self.bookType == .Epub {
                guard var htmlStr = try? String(contentsOf: fullHref) else {return}
                htmlStr = removePageBreaksAndHorizontalLines(from: htmlStr) // 移除分页符
                htmlData = htmlStr.data(using: .utf8)
//                guard let _htmlData = try? Data(contentsOf: fullHref) else { return }
//                htmlData = _htmlData
            }else if bookType == .Txt {
                let contentString = WLTxtParser.attributeText(with: self)
                htmlData = contentString?.data(using: .utf8)
            }
            // 先获取章节内容
            let options = [
                DTDefaultLinkColor  : WL_READER_CURSOR_COLOR.hexString(false),
                DTDefaultFontSize: String(format: "%.2f", config.fontSize),
                DTDefaultFontName: config.fontName,
                NSTextSizeMultiplierDocumentOption : 1.0,
                DTDefaultLineHeightMultiplier : config.lineHeightMultiple,
                DTDefaultFirstLineHeadIndent: "0.0",
                DTDefaultTextAlignment : "3",
                DTDefaultHeadIndent : "0.0",
                NSBaseURLDocumentOption : fullHref!,
                DTDefaultTextColor: WL_READER_TEXT_COLOR.hexString(false),
                DTMaxImageSize      : CGSize(width: config.readContentRect.width, height: config.readContentRect.width),
                DTBackgroundColorAttribute: UIColor.clear.hexString(false)
            ] as [String : Any]
            let builder = DTHTMLAttributedStringBuilder(html: htmlData, options: options, documentAttributes: nil)
            builder?.willFlushCallback = { element in
                self.setEelementDisplay(element: element!)
            }
            guard let attributedString = builder?.generatedAttributedString() else { return }
            chapterContentAttr = (attributedString as! NSMutableAttributedString)
        }
        // 如果之前有分页,且没有强制分页，说明已经有过分页，就不再二次分页了
        if pages.count > 0, !forcePaging {
            return
        }
        
        // 再分页
        let layouter = DTCoreTextLayouter.init(attributedString: chapterContentAttr)
        let rect = CGRect(origin: .zero, size: config.readContentRect.size)
        var frame = layouter?.layoutFrame(with: rect, range: NSRange(location: 0, length: chapterContentAttr.length))
        
        var pageVisibleRange:NSRange! = NSRange(location: 0, length: 0)
        var rangeOffset = 0
        var count = 1
        repeat {
            frame = layouter?.layoutFrame(with: rect, range: NSRange(location: rangeOffset, length: chapterContentAttr.length - rangeOffset))
            pageVisibleRange = frame?.visibleStringRange()
            if pageVisibleRange == nil {
                rangeOffset = 0
                continue
            }else {
                rangeOffset = pageVisibleRange!.location + pageVisibleRange!.length
            }
            let pageContent = chapterContentAttr.attributedSubstring(from: pageVisibleRange!)
            let pageModel = WLBookPage()
            pageModel.content = pageContent
            pageModel.contentRange = pageVisibleRange
            pageModel.page = count - 1
            pageModel.chapterContent = chapterContentAttr
            pageModel.pageStartLocation = pageVisibleRange.location
            if WLBookConfig.shared.currentChapterIndex == self.chapterIndex &&
                WLBookConfig.shared.currentPageLocation > 0 &&
                WLBookConfig.shared.currentPageLocation >= pageVisibleRange.location &&
                WLBookConfig.shared.currentPageLocation <= pageVisibleRange.location + pageVisibleRange.length {
                WLBookConfig.shared.currentPageIndex = count - 1
            }
            /// 计算高度
            let pageLayouter = DTCoreTextLayouter.init(attributedString: pageContent)
            let pageRect = CGRect(origin: .zero, size: CGSizeMake(config.readContentRect.width, .infinity))
            let pageFrame = pageLayouter?.layoutFrame(with: pageRect, range: NSRange(location: 0, length: pageContent.length))
            pageModel.contentHeight = pageFrame?.intrinsicContentFrame().size.height
            pages.append(pageModel)
            count += 1
        } while rangeOffset <= chapterContentAttr.length && rangeOffset != 0
        forcePaging = false
    }
    // 使用正则表达式删除 HTML 中的分页符和横线
        func removePageBreaksAndHorizontalLines(from html: String) -> String {
            // 移除分页符和横线的正则表达式
            let pageBreakPattern = "<hr lang=\"zh-CN\">分页符</hr>"
            
            var cleanedHtml = html
            
            // 移除分页符
            if let regex = try? NSRegularExpression(pattern: pageBreakPattern, options: .caseInsensitive) {
                cleanedHtml = regex.stringByReplacingMatches(in: cleanedHtml, options: [], range: NSRange(location: 0, length: cleanedHtml.utf16.count), withTemplate: "")
            }
                        
            return cleanedHtml
        }
}
