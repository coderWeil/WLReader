//
//  WLMetadata.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/16.
//

import Foundation

struct WLAuthor {
    var name: String
    var role: String
    var fileAs: String

    init(name: String, role: String, fileAs: String) {
        self.name = name
        self.role = role
        self.fileAs = fileAs
    }
}

/**
 A Book's identifier.
 */
struct WLIdentifier {
    var id: String?
    var scheme: String?
    var value: String?

    init(id: String?, scheme: String?, value: String?) {
        self.id = id
        self.scheme = scheme
        self.value = value
    }
}

/**
 A date and his event.
 */
struct WLEventDate {
    var date: String
    var event: String?

    init(date: String, event: String?) {
        self.date = date
        self.event = event
    }
}

/**
 A metadata tag data.
 */
struct WLMeta {
    var name: String?
    var content: String?
    var id: String?
    var property: String?
    var value: String?
    var refines: String?

    init(name: String? = nil, content: String? = nil, id: String? = nil, property: String? = nil,
         value: String? = nil, refines: String? = nil) {
        self.name = name
        self.content = content
        self.id = id
        self.property = property
        self.value = value
        self.property = property
        self.value = value
        self.refines = refines
    }
}

/**
 Manages book metadata.
 */
class WLMetadata {
    var creators = [WLAuthor]()
    var contributors = [WLAuthor]()
    var dates = [WLEventDate]()
    var language = "en-US"
    var titles = [String]()
    var identifiers = [WLIdentifier]()
    var subjects = [String]()
    var descriptions = [String]()
    var publishers = [String]()
    var format = WLMediaType.epub.name
    var rights = [String]()
    var metaAttributes = [WLMeta]()

    /**
     Find a book unique identifier by ID

     - parameter id: The ID
     - returns: The unique identifier of a book
     */
    func find(identifierById id: String) -> WLIdentifier? {
        return identifiers.filter({ $0.id == id }).first
    }

    func find(byName name: String) -> WLMeta? {
        return metaAttributes.filter({ $0.name == name }).first
    }

    func find(byProperty property: String, refinedBy: String? = nil) -> WLMeta? {
        return metaAttributes.filter {
            if let refinedBy = refinedBy {
                return $0.property == property && $0.refines == refinedBy
            }
            return $0.property == property
        }.first
    }
}
