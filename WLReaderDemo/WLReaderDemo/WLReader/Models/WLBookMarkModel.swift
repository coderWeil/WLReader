//
//  WLBookMarkModel.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/23.
//  书签数据模型，需要提供读取书签，保存书签的功能

import UIKit
import WCDBSwift

final class WLBookMarkModel: TableCodable {
    /// 书籍名
    var bookName:String!
    /// 章节
    var chapterIndex:Int!
    /// 当前页面的location
    var pageLocation:Int!
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WLBookMarkModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case bookName
        case chapterIndex
        case pageLocation
    }
    /// 获取所有书签
    static func getAllMarkModels() -> [WLBookMarkModel]! {
        let marks:[WLBookMarkModel]? = WLDataBase.shared.getObjects(WLBOOK_MARK_TABLE_NAME)
        guard let marks = marks else {
            return []
        }
        return marks
    }
    // 添加
    func save() {
        WLDataBase.shared.insertOrReplace([self], WLBookMarkModel.Properties.all, tableName: WLBOOK_MARK_TABLE_NAME)
    }
    func remove() { // 移除
        WLDataBase.shared.delete(WLBOOK_MARK_TABLE_NAME, where: WLBookMarkModel.Properties.chapterIndex == chapterIndex!)
    }
    static func readMarkModel() -> WLBookMarkModel? {
        let model:WLBookMarkModel? = WLDataBase.shared.getObject(WLBOOK_MARK_TABLE_NAME, on: WLBookMarkModel.Properties.all, where: WLBookMarkModel.Properties.bookName == WLBookConfig.shared.bookName && WLBookMarkModel.Properties.chapterIndex == WLBookConfig.shared.currentChapterIndex && WLBookMarkModel.Properties.pageLocation == WLBookConfig.shared.currentPageLocation)
        return model
    }
}
