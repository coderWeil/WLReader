//
//  WLEnumList.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/14.
//

import UIKit

/// 翻页类型
enum WLEffectType:NSInteger {
    /// 仿真
    case pageCurl
    /// 平移
    case translation
    /// 滚动
    case scroll
    /// 无效果, 只有点击左右两侧才会切换
    case no
    /// 覆盖
    case cover
}
/// 阅读内容间距
enum WLReadSpacingType:NSInteger {
    /// 小
    case small
    /// 中
    case middle
    /// 大
    case big
}
/// 阅读字体类型
enum WLReadFontNameType:NSInteger {
    /// 系统字体
    case system
    /// 黑体
    case black
    /// 宋体
    case song
    /// 楷体
    case kai
    /// 方正仿宋
    case fangSong
    /// 思源黑体-粗
    case nscBold
    /// 思源黑体-半粗
    case nscSemiBold
    /// 思源宋体-细
    case notoLight
    /// 思源宋体-常规
    case notoNormal
    /// 思源宋体-medium
    case notoMedium
    /// 思源黑体
    case SHSSCVF
}
/// 书籍类型
enum WLBookType:NSInteger {
    case Epub // 上下
    case Txt // 设置
    case Pdf // 亮度
    case Mobi // 播放
    case NoneType // 播放
    /// 返回图书的类型
    static func bookSuffix(_ type: WLBookType) -> String {
        switch type {
        case .Epub:
            return "epub"
        case .Txt:
            return "txt"
        case .Pdf:
            return "pad"
        case .Mobi:
            return "mobi"
        case .NoneType:
            return "none"
        }
    }
    
    /// 返回图书的类型
    static func bookType(_ suffix: String) -> WLBookType {
        if suffix == "epub" {
            return .Epub
        }else if suffix == "txt" {
            return .Txt
        }else if suffix == "pdf" {
            return .Pdf
        }else if suffix == "mobi" {
            return .Mobi
        }else {
            return NoneType
        }
    }
}

let effectTypes = ["仿真", "平移", "滚动", "无效果", "覆盖"]
