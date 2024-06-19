//
//  WLNoteConfig.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/15.
//  笔记相关的数据处理类

import UIKit

class WLNoteConfig: NSObject {
    static let shared = WLNoteConfig()
    // 记录当前章节选中的范围，这个是以章节为维度
    var selectedRange:NSRange?
    // 用来保存所有的章节笔记数据
    var noteDataDic:[String: [WLBookNoteModel]]?
    // 记录下当前展示的章节
    var currentChapterModel:WLBookChapter?
    
    class func clear() {
        WLNoteConfig.shared.noteDataDic = nil
        WLNoteConfig.shared.selectedRange = nil
        WLNoteConfig.shared.currentChapterModel = nil
    }
}
