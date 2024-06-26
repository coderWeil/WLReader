//
//  WLResources.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/16.
//

import Foundation

open class WLResources: NSObject {
    
    var resources = [String: WLResource]()

    /**
     Adds a resource to the resources.
     */
    func add(_ resource: WLResource) {
        self.resources[resource.href] = resource
    }

    // MARK: Find

    /**
     Gets the first resource (random order) with the give mediatype.

     Useful for looking up the table of contents as it's supposed to be the only resource with NCX mediatype.
     */
    func findByMediaType(_ mediaType: WLMediaType) -> WLResource? {
        for resource in resources.values {
            if resource.mediaType != nil && resource.mediaType == mediaType {
                return resource
            }
        }
        return nil
    }

    /**
     Gets the first resource (random order) with the give extension.

     Useful for looking up the table of contents as it's supposed to be the only resource with NCX extension.
     */
    func findByExtension(_ ext: String) -> WLResource? {
        for resource in resources.values {
            if resource.mediaType != nil && resource.mediaType.defaultExtension == ext {
                return resource
            }
        }
        return nil
    }

    /**
     Gets the first resource (random order) with the give properties.

     - parameter properties: ePub 3 properties. e.g. `cover-image`, `nav`
     - returns: The Resource.
     */
    func findByProperty(_ properties: String) -> WLResource? {
        for resource in resources.values {
            if resource.properties == properties {
                return resource
            }
        }
        return nil
    }

    /**
     Gets the resource with the given href.
     */
    func findByHref(_ href: String) -> WLResource? {
        guard !href.isEmpty else { return nil }

        // This clean is neede because may the toc.ncx is not located in the root directory
        let cleanHref = href.replacingOccurrences(of: "../", with: "")
        return resources[cleanHref]
    }

    /**
     Gets the resource with the given href.
     */
    func findById(_ id: String?) -> WLResource? {
        guard let id = id else { return nil }

        for resource in resources.values {
            if let resourceID = resource.id, resourceID == id {
                return resource
            }
        }
        return nil
    }

    /**
     Whether there exists a resource with the given href.
     */
    func containsByHref(_ href: String) -> Bool {
        guard !href.isEmpty else { return false }

        return resources.keys.contains(href)
    }

    /**
     Whether there exists a resource with the given id.
     */
    func containsById(_ id: String?) -> Bool {
        guard let id = id else { return false }

        for resource in resources.values {
            if let resourceID = resource.id, resourceID == id {
                return true
            }
        }
        return false
    }
}
