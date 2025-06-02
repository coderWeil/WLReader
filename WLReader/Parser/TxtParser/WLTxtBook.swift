//
//  WLTxtBook.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/17.
//

import Foundation
public class WLTxtChapter:NSObject {
    var content: String?
    var title: String!
    var page: Int! // 页数
    var count: Int! // 字数
    var path: String!
}

open class WLTxtBook: NSObject {
    var bookId: String!
    var title: String!
    var author: String!
    var directory: URL!
    var contentDirectory: URL!
    var chapters: [WLTxtChapter]!
}
