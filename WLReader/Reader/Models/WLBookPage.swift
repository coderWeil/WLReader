//
//  WLBookPage.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/17.
//

import Foundation

class WLBookPage: NSObject {
    /// 本页标题
    var title:String!
    /// 本页字数
    var word:Int!
    /// 当前是第几页
    var page:Int!
    /// 本页内容
    var content:NSAttributedString!
    /// 本章节的所有内容
    var chapterContent:NSAttributedString!
    /// 本页的范围
    var contentRange:NSRange!
    /// 本页内容文本
    var contentString:String! {
        return content.string
    }
    /// 本页内容高度，只在垂直滚动模式下有效
    var contentHeight:CGFloat! = 0
    /// 当前页的起始位置记录下
    var pageStartLocation:Int! = 0
    /// 当前页的结束位置
    var pageEndLocation:Int! = 0
}
