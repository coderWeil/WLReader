//
//  WLReaderColor.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/25.
//  颜色配置

import UIKit

/// 阅读内容视图可供选择的背景颜色
let WL_READER_BG_COLORS = [UIColor(named: "read_bg_color_1"), UIColor(named: "read_bg_color_2"), UIColor(named: "read_bg_color_3"), UIColor(named: "read_bg_color_4"), UIColor(named: "read_bg_color_5"), WL_READER_COLOR_IMAGE]
/// 阅读内容视图可供选择的字体颜色
let WL_READER_TEXT_COLORS = [UIColor(named: "read_text_color_1"), UIColor(named: "read_text_color_1"), UIColor(named: "read_text_color_1"), UIColor(named: "read_text_color_1"), UIColor(named: "read_text_color_2"), UIColor(named: "read_text_color_1")]
/// 左右游标的颜色
let WL_READER_CURSOR_COLOR = UIColor(named: "read_cursor_color_1")!
/// 选中文字的颜色
let WL_READER_SELECTED_COLOR = UIColor(named: "read_select_color_1")!
/// 菜单栏可供选择的背景颜色
let WL_READER_MENU_BG_COLORS = [UIColor(named: "read_bg_color_1"), UIColor(named: "read_bg_color_2"), UIColor(named: "read_bg_color_3"), UIColor(named: "read_bg_color_4"), UIColor(named: "read_bg_color_5"), WL_READER_COLOR_IMAGE]
/// 进度条的缓冲底色
let WL_READER_SLIDER_MAXTRACK:UIColor = UIColor(named: "read_slider_maxTrack_color")!
/// 进度条的已读进度颜色
let WL_READER_SLIDER_MINTRACK:UIColor = UIColor(named: "read_slider_minTrack_color")!
/// 进度条的原点颜色
let WL_READER_SLIDER_DOT_COLOR:UIColor = UIColor(named: "read_slider_dot_color")!
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

