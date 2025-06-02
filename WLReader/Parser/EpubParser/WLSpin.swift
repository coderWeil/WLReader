//
//  WLSpin.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/16.
//

import Foundation

struct Spine {
    var linear: Bool
    var resource: WLResource

    init(resource: WLResource, linear: Bool = true) {
        self.resource = resource
        self.linear = linear
    }
}

class WLSpine: NSObject {
    var pageProgressionDirection: String?
    var spineReferences:[Spine]! = [Spine]()

    var isRtl: Bool {
        if let pageProgressionDirection = pageProgressionDirection , pageProgressionDirection == "rtl" {
            return true
        }
        return false
    }

    func nextChapter(_ href: String) -> WLResource? {
        var found = false;

        for item in spineReferences {
            if(found){
                return item.resource
            }

            if(item.resource.href == href) {
                found = true
            }
        }
        return nil
    }
}
