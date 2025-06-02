//
//  File.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/25.
//

import UIKit


func WL_FONT(_ size:CGFloat) -> UIFont {return UIFont.systemFont(ofSize: size)}

let WL_READER_FONT_14 = WL_FONT(14)

/// 字数变化步长
let WL_READER_FONT_SIZE_CHANGE_STEP:CGFloat = 2
/// 阅读器最小字号
let WL_READER_FONT_SIZE_MIN:CGFloat = 12
/// 阅读器最大字号
let WL_READER_FONT_SIZE_MAX:CGFloat = 30

/// 字体数组
let fontNames:[String] = ["系统", "黑体", "宋体", "楷体", "仿宋", "思源黑体-SemiBold", "思源黑体-Bold", "思源宋体-lgiht", "思源宋体-regular", "思源宋体-medium","思源黑体-regular"]

/// 字体类型模型
struct WLFontTypeModel {
    var name:String!
    var type:WLReadFontNameType!
    var index:Int!
}
