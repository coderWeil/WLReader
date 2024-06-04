//
//  WLReaderColor.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/25.
//  颜色配置

import UIKit

/// 阅读内容视图可供选择的背景颜色
let WL_READER_BG_COLORS = [UIColor.white, WL_READER_COLOR_238_224_202, WL_READER_COLOR_205_239_205, WL_READER_COLOR_206_233_241, WL_READER_COLOR_58_52_54, WL_READER_COLOR_IMAGE]
/// 阅读内容视图可供选择的字体颜色
let WL_READER_TEXT_COLORS = [WL_READER_TEXT_COLOR_33_33_33, WL_READER_TEXT_COLOR_33_33_33, WL_READER_TEXT_COLOR_33_33_33, WL_READER_TEXT_COLOR_33_33_33, UIColor.white, WL_READER_TEXT_COLOR_33_33_33]
/// 左右游标的颜色
let WL_READER_CURSOR_COLOR = UIColor.RGB(r: 178, g: 41, b: 44)
/// 选中文字的颜色
let WL_READER_SELECTED_COLOR = UIColor.RGB(r: 178, g: 41, b: 44).withAlphaComponent(0.5)
/// 菜单栏可供选择的背景颜色
let WL_READER_MENU_BG_COLORS = [UIColor.white, WL_READER_COLOR_238_224_202, WL_READER_COLOR_205_239_205, WL_READER_COLOR_206_233_241, WL_READER_COLOR_58_52_54, WL_READER_COLOR_IMAGE]
/// 菜单栏可供选择的tint颜色
let WL_READER_TINT_COLORS = [WL_READER_TEXT_COLOR_33_33_33, WL_READER_TEXT_COLOR_33_33_33, WL_READER_TEXT_COLOR_33_33_33, WL_READER_TEXT_COLOR_33_33_33, UIColor.white, WL_READER_TEXT_COLOR_33_33_33]
/// 进度条的缓冲底色
let WL_READER_SLIDER_MAXTRACK:UIColor = UIColor(rgba: "#9b9b9b")
/// 进度条的已读进度颜色
let WL_READER_SLIDER_MINTRACK:UIColor = UIColor.RGB(r: 178, g: 41, b: 44)
/// 进度条的原点颜色
let WL_READER_SLIDER_DOT_COLOR:UIColor = UIColor.RGB(r: 178, g: 41, b: 44).withAlphaComponent(0.5)
/// 牛皮黄颜色
let WL_READER_COLOR_IMAGE = UIColor(patternImage: UIImage(named: "read_bg_0")!)


// MARK - 下面是阅读器相关需要动态变化的颜色
/// 阅读器背景色
var WL_READER_BG_COLOR:UIColor! {
    return WL_READER_BG_COLORS[WLBookConfig.shared.readerBackgroundColorIndex]
}
/// 阅读器正文颜色
var WL_READER_TEXT_COLOR:UIColor! {
    return WL_READER_TEXT_COLORS[WLBookConfig.shared.readerBackgroundColorIndex]
}
/// 菜单栏的背景色
var WL_READER_MENU_BG_COLOR:UIColor! {
    return WL_READER_MENU_BG_COLORS[WLBookConfig.shared.readerBackgroundColorIndex]
}
let WL_READER_TEXT_COLOR_33_33_33 = UIColor(rgba: "#333333")
/// 下面是几种可供选择的阅读器背景色
let WL_READER_COLOR_238_224_202 = UIColor.RGB(r: 238, g: 224, b: 202)
let WL_READER_COLOR_205_239_205 = UIColor.RGB(r: 205, g: 239, b: 205)
let WL_READER_COLOR_206_233_241 = UIColor.RGB(r: 206, g: 233, b: 241)
let WL_READER_COLOR_58_52_54 = UIColor.RGB(r: 58, g: 52, b: 54)


