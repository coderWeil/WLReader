//
//  WLBookCatalogueModel.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/21.
//  章节列表数据

import UIKit

class WLBookCatalogueModel: NSObject {
    // 章节列表Id
    var catalogId:String?
    // 章节名
    var catalogueName:String?
    // 章节层级
    var level:Int! = 0
    // 章节对应的页码
    var pageChapterIndex:Int! = 0
    
    // 页码范围
    var pageIndexRange:NSRange!
    // 章节的子章节
    var children:[WLBookCatalogueModel]?
    // 父章节
    var parent:WLBookCatalogueModel?
    // 章节的路径
    var chapterHref:URL?
    // 对应的章节index
    var chapterIndex:Int! = 0
    var fragmentID:String?
    var link:String!
    
    var source:String! {
        get {
            let component = self.link.components(separatedBy: "#")
            return component.first
        }
    }
    
    var anchor:String! {
        get {
            let components = self.link.components(separatedBy: "#")
            if components.count == 2 {
                return components.last
            }
            return ""
        }
    }
    
    private func nextCatalog() -> WLBookCatalogueModel? {
        var node = self
        while node.level > 0 { // 表明子章节存在的
            let firstChild = node.children!.first
            if let firstChild = firstChild {
                return firstChild
            }
            // 没有子章节，找兄弟章节
            let nextSibling = nextSibling()
            if let nextSibling = nextSibling {
                return nextSibling
            }
            // 没有兄弟章节，找父节点的兄弟
            node = self.parent!.nextSibling()!
        }
        return nil
    }
    private func nextSibling() -> WLBookCatalogueModel? {
        if level > 0 {
            let parentCatalog = parent!
            let index = parentCatalog.children!.firstIndex(of: self)
            if index! < parentCatalog.children!.count - 1 {
                return parentCatalog.children![index!+1]
            }
        }
        return nil
    }
}
