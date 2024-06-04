//
//  WLBookNoteModel.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/2.
//

import UIKit

class WLBookNoteModel: NSObject {
    // 章节index
    var chapteIndex:Int!
    // 笔记的位置
    var range:NSRange!
    // 笔记对应的内容
    var content:NSAttributedString!
    // 笔记
    var note:String!
}
