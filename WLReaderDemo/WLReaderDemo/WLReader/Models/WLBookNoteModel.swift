//
//  WLBookNoteModel.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/2.
//  笔记，书签数据模型

import UIKit

enum WLBookNotType {
    case note
    case mark
}

class WLBookNoteModel: NSObject {
    // 笔记id
    var noteId:Int!
    // 章节index
    var chapteIndex:Int!
    // 笔记的位置
    var range:NSRange!
    // 笔记来源内容
    var sourceContent:String!
    var sourceImageUrl:String!
    
    // 笔记对应的内容
    var content:NSAttributedString!
    // 笔记
    var text:String!
    // 图片
    var imageUrl:String!
    
    // 标识是笔记还是书签, 默认是笔记
    var tag:WLBookNotType! = .note
}
