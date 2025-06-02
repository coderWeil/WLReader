//
//  WLResource.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/16.
//

import Foundation
open class WLResource: NSObject {
    var id: String!
    var properties: String?
    var mediaType: WLMediaType!
    var mediaOverlay: String?
    
    public var href: String!
    public var fullHref: String!

    func basePath() -> String! {
        if href == nil || href.isEmpty { return nil }
        var paths = fullHref.components(separatedBy: "/")
        paths.removeLast()
        return paths.joined(separator: "/")
    }
}

// MARK: Equatable

func ==(lhs: WLResource, rhs: WLResource) -> Bool {
    return lhs.id == rhs.id && lhs.href == rhs.href
}
