//
//  WLBookConfig.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/17.
//

import UIKit
import WCDBSwift

final class WLBookConfig: TableCodable {
    
    static let shared = WLBookConfig()
    /// 阅读区域的左右间距
    var readerEdget:CGFloat = WL_READER_HORIZONTAL_MARGIN
    /// 阅读内容的显示区域
    var readContentRect: CGRect {
        return CGRectMake(readerEdget, 0, WL_SCREEN_WIDTH - 2*readerEdget, WL_SCREEN_HEIGHT - WL_NAV_BAR_HEIGHT - WL_BOTTOM_HOME_BAR_HEIGHT - WL_READER_BOTTOM_PAGENUMBER_HEIGHT)
    }
    /// 翻页类型索引
    var effectTypeIndex:NSInteger! = 1
    /// 字体类型索引
    var fontTypeIndex:NSInteger! = 2
    /// 布局间距索引
    var spacingIndex:NSInteger! = 1
    /// 字体大小
    var fontSize:CGFloat! {
        return CGFloat(fontSizeInt)
    }
    var fontSizeInt:NSInteger! = 16
    
    /// 文本的行高的比例，默认是2
    var lineHeightMultiple:CGFloat {
        switch spacingIndex {
        case 0:
            return fontSize / 16.0 * 1.5
        case 1:
            return fontSize / 16.0 * 2
        case 2:
            return fontSize / 16.0 * 3
        default:
            return fontSize / 16.0 * 2
        }
    }
    /// 段落之间的间距
    var paragraphSpacing:CGFloat! {
        switch spacingIndex {
        case 0:
            return 5
        case 1:
            return 15
        case 2:
            return 25
        default:
            return 15
        }
    }
    /// 翻页类型
    var effetType:WLEffectType! {return WLEffectType(rawValue: effectTypeIndex)}
    /// 字体类型
    var fontType:WLReadFontNameType! {return WLReadFontNameType(rawValue: fontTypeIndex)}
    /// 布局间距类型
    var spacingType:WLReadSpacingType! {return WLReadSpacingType(rawValue: spacingIndex)}
    /// 是否显示分享，默认显示
    var showShareBtn:Bool = true
    /// 是否显示书签，默认显示
    var showMarkBtn:Bool = true
    
    var font:UIFont {
        let fontName = fontName
//        for fontFamily in UIFont.familyNames {
//            for name in UIFont.fontNames(forFamilyName: fontFamily) {
//                print(name)
//            }
//        }
        if fontName.count > 0 {
            return UIFont(name: fontName, size: fontSize)!
        }
        return UIFont.systemFont(ofSize: fontSize)
    }
    var boldFont:UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    var fontName:String {
        switch fontType {
        case .system:
            return ""
        case .black:
            return "Helvetica-Bold"
        case .song:
            return "Papyrus"
        case .kai:
            return "AmericanTypewriter-Light"
        case .fangSong:
            return "FZFangSong-Z02S"
        case .nscBold:
            return "NotoSerifSC-Bold"
        case .nscSemiBold:
            return "NotoSerifSC-SemiBold"
        case .notoLight:
            return "NotoSerifSC-Light"
        case .notoNormal:
            return "NotoSerifSC-Regular"
        case .notoMedium:
            return "NotoSerifSC-Medium"
        case .SHSSCVF:
            return "SourceHanSansSCVF-Regular"
        default:
            return ""
        }
    }
    var fontDisplayName:String {
        switch fontType {
        case .system:
            return "系统"
        case .black:
            return "黑体"
        case .song:
            return "宋体"
        case .kai:
            return "楷体"
        case .fangSong:
            return "仿宋"
        case .nscBold:
            return "思源黑体"
        case .nscSemiBold:
            return "思源宋体-粗"
        case .notoLight:
            return "思源宋体-细"
        case .notoNormal:
            return "思源宋体-常规"
        case .notoMedium:
            return "思源宋体-Medium"
        case .SHSSCVF:
            return "思源黑体-常规"
        default:
            return "系统"
        }
    }
    var effectTypeName:String {
        switch effetType {
        case .pageCurl:
            return "仿真"
        case .translation:
            return "平移"
        case .scroll:
            return "滚动"
        case .no:
            return "无效果"
        case .cover:
            return "覆盖"
        default:
            return "仿真"
        }
    }
    /// 背景颜色配置
    var readerBackgroundColorIndex:Int! = 5
    /// 亮度值，默认是1
    var readerBrightValue:Float! = 1
    var bottomProgressIsChapter:Bool! = true
    
    enum CodingKeys:String, CodingTableKey {
        typealias Root = WLBookConfig
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)

        // 翻页类型下标
        case effectTypeIndex
        // 字体类型下标
        case fontTypeIndex
        // 字体大小
        case fontSizeInt
        // 背景色下标
        case readerBackgroundColorIndex
        // 间距类型下标
        case spacingIndex
    }
    /// 读取数据库
    func readDB() {
        let object:WLBookConfig? = WLDataBase.shared.getObject(WLBOOK_CONFIG_TABLE_NAME)
        if let obj = object {
            effectTypeIndex = obj.effectTypeIndex
            fontTypeIndex = obj.fontTypeIndex
            fontSizeInt = obj.fontSizeInt
            readerBackgroundColorIndex = obj.readerBackgroundColorIndex
            spacingIndex = obj.spacingIndex
        }else {// 如果一开始数据库里没有，则进行插入操作
            WLDataBase.shared.insertOrReplace([self], WLBookConfig.Properties.all, tableName: WLBOOK_CONFIG_TABLE_NAME)
        }
    }
    func save() { // 保存记录的时候，需要将markFinished置为false
        WLDataBase.shared.update(WLBOOK_CONFIG_TABLE_NAME, on: WLBookConfig.Properties.all, with: self)
    }
}

