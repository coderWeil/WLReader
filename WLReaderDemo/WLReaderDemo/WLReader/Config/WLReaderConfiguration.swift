//
//  WLReaderConfiguration.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/25.
//  阅读相关配置

import UIKit

/// 屏幕高度
let WL_SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height
/// 屏幕宽度
let WL_SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
/// 是否是X以上机型
let WL_ISX: Bool = WL_SCREEN_HEIGHT >= 812.0
/// 顶部状态栏高度
let WL_STATUS_BAR_HEIGHT: CGFloat = WL_ISX ? 44.0 : 20.0
/// 导航栏高度
let WL_NAV_BAR_HEIGHT: CGFloat = WL_STATUS_BAR_HEIGHT + 44.0
/// 底部栏高度
let WL_BOTTOM_HOME_BAR_HEIGHT: CGFloat = WL_ISX ? 34 : 0
/// TabBar高度
let WL_TAB_BAR_HEIGHT: CGFloat = WL_BOTTOM_HOME_BAR_HEIGHT + 49.0
/// 阅读器底部工具栏高度
let WL_READER_BOTTOM_HEIGHT:CGFloat = WL_BOTTOM_HOME_BAR_HEIGHT + 80
/// 阅读器设置页面高度
let WL_READER_SETTING_HEIGHT:CGFloat = WL_BOTTOM_HOME_BAR_HEIGHT + 170.0
/// 阅读器进度条视图高度
let WL_READER_PROGRESS_HEIGHT:CGFloat = 44
/// 默认的动画时长
let WL_READER_DEFAULT_ANIMATION_DURATION:CGFloat = 0.25
/// 默认左侧间距
let WL_READER_HORIZONTAL_MARGIN:CGFloat = 10.0
/// 章节列表的宽度
let WL_READER_CHAPTERLIST_WIDTH:CGFloat = WL_SCREEN_WIDTH - 30
/// 字体类型切换视图高度
let WL_READER_FONTTYPE_HEIGHT:CGFloat = WL_BOTTOM_HOME_BAR_HEIGHT + 450.0
/// 翻页方式视图高度
let WL_READER_EFFECTTYPE_HEIGHT:CGFloat = WL_BOTTOM_HOME_BAR_HEIGHT + 300.0
/// 背景色视图高度
let WL_READER_BACKGROUND_HEIGHT:CGFloat = WL_BOTTOM_HOME_BAR_HEIGHT + 170.0
/// 笔记视图高度
let WL_READER_NOTE_HEIGHT:CGFloat = WL_SCREEN_HEIGHT - WL_NAV_BAR_HEIGHT
/// 底部页码视图高度
let WL_READER_BOTTOM_PAGENUMBER_HEIGHT:CGFloat = 24

/// 翻页类型模型
struct WLEffectTypeModel {
    var name:String!
    var type:WLEffectType!
    var index:Int!
}
