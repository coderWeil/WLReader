//
//  WLBookChapter+Paging.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/4.
//  分页

import DTCoreText

extension WLBookChapter {
    /// 解析本章，获取分页
    public func paging(_ bookModel:WLBookModel) {
        let config = WLBookConfig.shared
        if forcePaging { // 强制分页之前，先将原有的分页清空
            pages.removeAll()
        }
        if chapterContentAttr == nil || forcePaging { // 强制分页，也需要更新设置
            var htmlData: Data!
            if self.bookType == .Epub {
                guard var htmlStr = try? String(contentsOf: fullHref) else {return}
                htmlStr = removePageBreaksAndHorizontalLines(from: htmlStr) // 移除分页符
                htmlStr = insertFragmentIDForHtml(html: htmlStr)
                htmlData = htmlStr.data(using: .utf8)
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
                DTDefaultFirstLineHeadIndent: String.caclHeadIndent(),
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
            getFragmentIDMarkLocation()
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
            if bookModel.chapterIndex == self.chapterIndex &&
                bookModel.currentPageLocation > 0 &&
                bookModel.currentPageLocation >= pageVisibleRange.location &&
                bookModel.currentPageLocation <= pageVisibleRange.location + pageVisibleRange.length {
                bookModel.pageIndex = count - 1
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
        // 判断目录中的章节处于哪一页
        getCataloguePageIndex(bookModel: bookModel)
    }
    // 使用正则表达式删除 HTML 中的分页符和横线
    func removePageBreaksAndHorizontalLines(from html: String) -> String {
        // 移除分页符和横线的正则表达式
        var pageBreakPattern = "<hr lang=\"zh-CN\">分页符</hr>"
        
        var cleanedHtml = html
        
        // 移除分页符
        if let regex = try? NSRegularExpression(pattern: pageBreakPattern, options: .caseInsensitive) {
            cleanedHtml = regex.stringByReplacingMatches(in: cleanedHtml, options: [], range: NSRange(location: 0, length: cleanedHtml.utf16.count), withTemplate: "")
        }
        pageBreakPattern = "\r"
        if let regex = try? NSRegularExpression(pattern: pageBreakPattern, options: .caseInsensitive) {
            cleanedHtml = regex.stringByReplacingMatches(in: cleanedHtml, options: [], range: NSRange(location: 0, length: cleanedHtml.utf16.count), withTemplate: "\n")
        }
        pageBreakPattern = "\n"
        if let regex = try? NSRegularExpression(pattern: pageBreakPattern, options: .caseInsensitive) {
            cleanedHtml = regex.stringByReplacingMatches(in: cleanedHtml, options: [], range: NSRange(location: 0, length: cleanedHtml.utf16.count), withTemplate: "<p></p>")
        }
        pageBreakPattern = "<p></p>"
        if let regex = try? NSRegularExpression(pattern: pageBreakPattern, options: .caseInsensitive) {
            cleanedHtml = regex.stringByReplacingMatches(in: cleanedHtml, options: [], range: NSRange(location: 0, length: cleanedHtml.utf16.count), withTemplate: "")
        }
        return cleanedHtml
    }
    private func insertFragmentIDForHtml(html:String) -> String! {
        var originHtml = html
        let pattern = #"<p\s+[^>]*id="([^"]+)"[^>]*>"#
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
                    
            // 查找并替换每个带有 id 属性的 <p> 标签
            let modifiedText = regex.stringByReplacingMatches(in: originHtml, options: [],
                                                              range: NSRange(originHtml.startIndex..<originHtml.endIndex, in: originHtml),
                                                              withTemplate: "${id=$1}$0")
            
            originHtml = modifiedText
            
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }
        return originHtml
    }

    // 获取fragmentID所在章节分页的location
    private func getFragmentIDMarkLocation() {
        let mutableStr = NSMutableString(string: chapterContentAttr.string)
        let mutableAttString = chapterContentAttr.mutableCopy() as! NSMutableAttributedString
        var locationWithPageIdMapping: [String: Int] = [:]
        
        let idMarkRegex = "\\$\\{id=([^}]+)\\}"
        var offset = 0
        do {
            let regex = try NSRegularExpression(pattern: idMarkRegex, options: [])
            var range = NSRange(location: 0, length: mutableStr.length)
            
            while let match = regex.firstMatch(in: mutableStr as String, options: [], range: range) {
                // 获取整个匹配内容
                let fullMatch = (mutableStr.substring(with: match.range) as NSString)
                // 提取捕获组中的id值
                let idValue = fullMatch.replacingOccurrences(of: "\\$\\{id=", with: "", options: .regularExpression, range: NSMakeRange(0, fullMatch.length)).replacingOccurrences(of: "\\}", with: "", options: .regularExpression)
                
                // 计算并存储匹配位置
                let adjustedLocation = match.range.location + offset
                locationWithPageIdMapping[idValue] = adjustedLocation
                
                // 可以修改的匹配范围变量
                var matchRange = match.range
                
                // 检查并删除匹配范围之前的多余换行符
                if match.range.location > 0 {
                    var newlineCount = 0
                    while match.range.location - newlineCount - 1 >= 0 && mutableStr.character(at: match.range.location - newlineCount - 1) == 10 {
                        newlineCount += 1
                    }
                    if newlineCount > 0 {
                        let removeRange = NSRange(location: match.range.location - newlineCount, length: newlineCount)
                        mutableStr.deleteCharacters(in: removeRange)
                        mutableAttString.deleteCharacters(in: removeRange)
                        offset -= newlineCount
                        
                        // 更新匹配位置
                        matchRange.location -= newlineCount
                    }
                }
                
                // 获取需要删除范围内的所有属性
                let attributes = mutableAttString.attributes(at: matchRange.location, longestEffectiveRange: nil, in: matchRange)

                // 移除这些属性
                for attribute in attributes {
                    mutableAttString.removeAttribute(attribute.key, range: matchRange)
                }
                
                mutableStr.deleteCharacters(in: matchRange)
                mutableAttString.deleteCharacters(in: matchRange)
                
                offset -= matchRange.length
                
                range = NSRange(location: matchRange.location, length: mutableStr.length - matchRange.location)
            }
            
            chapterContentAttr = mutableAttString
            locationWithFragmentIDMap = locationWithPageIdMapping
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }
    }
    // 获取章节目录中的页码
    private func getCataloguePageIndex(bookModel:WLBookModel) {
        getCataloguePageIndex(catalogues: bookModel.catalogues)
        for catalogue in bookModel.catalogues {
            if let children = catalogue.children, children.count > 0  {
                getCataloguePageRange(catalogues: children)
            }
        }
    }
    // 获取章节列表每一个章节对应的页面Index
    private func getCataloguePageIndex(catalogues:[WLBookCatalogueModel]) {
        for catalogue in catalogues {
            if let child = catalogue.children, child.count > 0 {
                getCataloguePageIndex(catalogues: child)
            }else {
                let fragmentID = catalogue.fragmentID
                if let fragmentID = fragmentID {
                    let location = self.locationWithFragmentIDMap[fragmentID]
                    if let location = location {
                        for page in self.pages {
                            if location >= page.pageStartLocation {
                                catalogue.pageChapterIndex = page.page
                            }
                        }
                    }
                }
            }
        }
    }
    // MARK - 获取章节列表章节对应的页面范围
    private func getCataloguePageRange(catalogues:[WLBookCatalogueModel]) {
        var previous:WLBookCatalogueModel? = catalogues.first
        for item in catalogues {
            getCataloguePageRange(previous: previous, current: item)
            previous = item
        }
        if previous == catalogues.last, let previous = previous { // 最后一个
            previous.pageIndexRange = NSRange(location: previous.pageChapterIndex, length: self.pages.count - previous.pageChapterIndex - 1)
        }
    }
    private func getCataloguePageRange(previous:WLBookCatalogueModel?, current:WLBookCatalogueModel?) {
        if previous == current {
            return
        }
        if let previous = previous, let current = current {
            previous.pageIndexRange = NSRange(location: previous.pageChapterIndex, length: current.pageChapterIndex - previous.pageChapterIndex - 1)
        }
    }
}
