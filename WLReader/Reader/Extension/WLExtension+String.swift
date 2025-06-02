//
//  WLExtension+String.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/22.
//

import Foundation

extension String {
    /// 正则替换字符
    func replacingCharacters(_ pattern:String, _ template:String) ->String {
        do {
            let regularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            return regularExpression.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, (self as NSString).length), withTemplate: template)
            
        } catch {return self}
    }
    /// 中文转英文
    func transformFromChinese() -> String {
        let mutabString = self.mutableCopy() as! CFMutableString
        CFStringTransform(mutabString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(mutabString, nil, kCFStringTransformStripCombiningMarks, false)
        return mutabString as String
    }
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    var abbreviatingWithTildeInPath: String {
        return (self as NSString).abbreviatingWithTildeInPath
    }
    
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    func appendingPathExtension(_ str: String) -> String {
        return (self as NSString).appendingPathExtension(str) ?? self+"."+str
    }
    func clockTimeToSeconds() -> Double {
        
        let val = self.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if( val.isEmpty ){ return 0 }
        
        let formats = [
            "HH:mm:ss.SSS"  : "^\\d{1,2}:\\d{2}:\\d{2}\\.\\d{1,3}$",
            "HH:mm:ss"      : "^\\d{1,2}:\\d{2}:\\d{2}$",
            "mm:ss.SSS"     : "^\\d{1,2}:\\d{2}\\.\\d{1,3}$",
            "mm:ss"         : "^\\d{1,2}:\\d{2}$",
            "ss.SSS"         : "^\\d{1,2}\\.\\d{1,3}$",
            ]
        
        // search for normal duration formats such as `00:05:01.2`
        for (format, pattern) in formats {
            
            if val.range(of: pattern, options: .regularExpression) != nil {
                
                let formatter = DateFormatter()
                formatter.dateFormat = format
                let time = formatter.date(from: val)
                
                if( time == nil ){ return 0 }
                
                formatter.dateFormat = "ss.SSS"
                let seconds = (formatter.string(from: time!) as NSString).doubleValue
                
                formatter.dateFormat = "mm"
                let minutes = (formatter.string(from: time!) as NSString).doubleValue
                
                formatter.dateFormat = "HH"
                let hours = (formatter.string(from: time!) as NSString).doubleValue
                
                return seconds + (minutes*60) + (hours*60*60)
            }
        }
        
        // if none of the more common formats match, check for other possible formats
        
        // 2345ms
        if val.range(of: "^\\d+ms$", options: .regularExpression) != nil{
            return (val as NSString).doubleValue / 1000.0
        }
        
        // 7.25h
        if val.range(of: "^\\d+(\\.\\d+)?h$", options: .regularExpression) != nil {
            return (val as NSString).doubleValue * 60 * 60
        }
        
        // 13min
        if val.range(of: "^\\d+(\\.\\d+)?min$", options: .regularExpression) != nil {
            return (val as NSString).doubleValue * 60
        }
        
        return 0
    }
    /// 正则搜索相关字符位置
    func matches(_ pattern:String) ->[NSTextCheckingResult] {
        if isEmpty {return []}
        do {
            let regularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            return regularExpression.matches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, self.count))
            
        } catch {return []}
    }
    
    // 计算两个汉字的宽度
   static func caclHeadIndent() -> String {
        let str = "汉字"
        let width = (str as NSString).size(withAttributes: [.font:WLBookConfig.shared.font]).width
       return "\(width)"
    }
}

extension CGFloat {
    // 计算两个汉字的宽度
   static func caclHeadIndent() -> CGFloat {
        let str = "汉字"
        let width = (str as NSString).size(withAttributes: [.font:WLBookConfig.shared.font]).width
       return width
    }
}
