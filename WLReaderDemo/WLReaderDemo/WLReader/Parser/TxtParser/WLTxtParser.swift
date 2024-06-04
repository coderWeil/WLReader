//
//  WLParseTXT.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/13.
//  纯文本文件的解析 txt格式

import UIKit
import DTCoreText

class WLTxtParser: NSObject {
    let book:WLTxtBook! = WLTxtBook()
    func parseBook(path: String!) throws -> WLTxtBook {
        let url = URL.init(fileURLWithPath: path)
        do {
            let content = try String.init(contentsOf: url, encoding: String.Encoding.utf8)
            var models: [WLTxtChapter] = []
            var titles = Array<String>()
            // 构造读书数据模型
            let document = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let newPath: NSString = path as NSString
            let fileName = newPath.lastPathComponent.split(separator: ".").first
            let bookPath = document! + "/Books/\(String(fileName!))"
            if FileManager.default.fileExists(atPath: bookPath) == false {
                try? FileManager.default.createDirectory(atPath: bookPath, withIntermediateDirectories: true, attributes: nil)
            }
            
            let results = WLTxtParser.doTitleMatchWith(content: content)
            if results.count == 0 {
                let model = WLTxtChapter()
                model.title = "开始"
                model.path = path
                models.append(model)
            }else {
                var endIndex = content.startIndex
                for (index, result) in results.enumerated() {
                    let startIndex = content.index(content.startIndex, offsetBy: result.range.location)
                    endIndex = content.index(startIndex, offsetBy: result.range.length)
                    let currentTitle = String(content[startIndex...endIndex])
                    titles.append(currentTitle)
                    let chapterPath = bookPath + "/chapter" + String(index + 1) + ".txt"
                    let model = WLTxtChapter()
                    model.title = currentTitle
                    model.path = chapterPath
                    models.append(model)
                    
                    if FileManager.default.fileExists(atPath: chapterPath) {
                        continue
                    }
                    var endLoaction = 0
                    if index == results.count - 1 {
                        endLoaction = content.count - 1
                    }else {
                        endLoaction = results[index + 1].range.location - 1
                    }
                    let startLocation = content.index(content.startIndex, offsetBy: result.range.location)
                    let subString = String(content[startLocation...content.index(content.startIndex, offsetBy: endLoaction)])
                    try! subString.write(toFile: chapterPath, atomically: true, encoding: String.Encoding.utf8)
                    
                }
                self.book.chapters = models
            }
            return self.book
        }catch {
            print(error)
            throw error
        }
    }
    class func attributeText(with chapterModel: WLBookChapter!) -> NSMutableAttributedString! {
        let tmpUrl = chapterModel.fullHref!
        let tmpString = try? String.init(contentsOf: tmpUrl, encoding: String.Encoding.utf8)
        if tmpString == nil {
            return nil
        }
        let textString: String = tmpString!
        
        let results = doTitleMatchWith(content: textString)
        var titleRange = NSRange(location: 0, length: 0)
        if results.count != 0 {
            titleRange = results[0].range
        }
        let startLocation = textString.index(textString.startIndex, offsetBy: titleRange.location)
        let endLocation = textString.index(startLocation, offsetBy: titleRange.length - 1)
        let titleString = String(textString[startLocation...endLocation])
        let contentString = String(textString[textString.index(after: endLocation)...textString.index(before: textString.endIndex)])
        let paraString = formatChapterString(contentString: contentString)
        
        let paragraphStyleTitle = NSMutableParagraphStyle()
        paragraphStyleTitle.alignment = NSTextAlignment.center
        let dictTitle:[NSAttributedString.Key: Any] = [.font:UIFont.boldSystemFont(ofSize: 19),
                                                       .paragraphStyle:paragraphStyleTitle]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = WLBookConfig.shared.lineHeightMultiple
        paragraphStyle.paragraphSpacing = 20
        paragraphStyle.alignment = NSTextAlignment.justified
        let font = UIFont.systemFont(ofSize: 16)
        let dict: [NSAttributedString.Key: Any] = [.font:font,
                                                   .paragraphStyle:paragraphStyle,
                                                   .foregroundColor:UIColor.black]
        
        let newTitle = "\n" + titleString + "\n\n"
        let attrString = NSMutableAttributedString.init(string: newTitle, attributes: dictTitle)
        let content = NSMutableAttributedString.init(string: paraString, attributes: dict)
        attrString.append(content)
        
        return attrString
    }
        
    class func formatChapterString(contentString: String) -> String {
        let paragraphArray = contentString.split(separator: "\n")
        var newParagraphString: String = ""
        for (index, paragraph) in paragraphArray.enumerated() {
            let string0 = paragraph.replacingOccurrences(of: " ", with: "")
            let string1 = string0.replacingOccurrences(of: "\t", with: "")
            var newParagraph = string1.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if newParagraph.count != 0 {
                newParagraph = "\t" + newParagraph
                if index != paragraphArray.count - 1 {
                    newParagraph = newParagraph + "\n"
                }
                newParagraphString.append(String(newParagraph))
            }
        }
        return newParagraphString
    }
    
    class func doTitleMatchWith(content: String) -> [NSTextCheckingResult] {
        let pattern = "第[ ]*[0-9一二三四五六七八九十百千]*[ ]*[章回].*"
        let regExp = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let results = regExp.matches(in: content, options: .reportCompletion, range: NSMakeRange(0, content.count))
        return results
    }
}
