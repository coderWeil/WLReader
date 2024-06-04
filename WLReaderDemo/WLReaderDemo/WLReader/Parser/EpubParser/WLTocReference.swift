//
//  WLTocReference.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/16.
//

import Foundation

open class WLTocReference: NSObject {
    var children: [WLTocReference]!

    public var title: String!
    public var resource: WLResource?
    public var fragmentID: String?
    
    convenience init(title: String, resource: WLResource?, fragmentID: String = "") {
        self.init(title: title, resource: resource, fragmentID: fragmentID, children: [WLTocReference]())
    }

    init(title: String, resource: WLResource?, fragmentID: String, children: [WLTocReference]) {
        self.resource = resource
        self.title = title
        self.fragmentID = fragmentID
        self.children = children
    }
}

// MARK: Equatable

func ==(lhs: WLTocReference, rhs: WLTocReference) -> Bool {
    return lhs.title == rhs.title && lhs.fragmentID == rhs.fragmentID
}
