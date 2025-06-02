//
//  WLBook.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/16.
//

import Foundation

open class WLEpubBook: NSObject {
    var metadata = WLMetadata()
    var spine = WLSpine()
    var smils = WLSmils()
    var version: Double?
    // 文件路径
    var directory: URL!
    
    public var opfResource: WLResource!
    public var tocResource: WLResource?
    public var uniqueIdentifier: String?
    public var coverImage: WLResource?
    /// 书籍名,包含了后缀
    public var name: String?
    /// 所有的资源文件
    public var resources = WLResources()
    /// 包含了所有的列表及嵌套，有书籍目录是有二级，三级的，列表目录用这个，一般是分区显示
    public var tableOfContents: [WLTocReference]!
    /// 这个是将所有的嵌套和列表都平铺开来了，一般在内容显示时用它，用来表示章节解析的
    public var flatTableOfContents: [WLTocReference]!

    var hasAudio: Bool {
        return smils.smils.count > 0
    }

    var title: String? {
        return metadata.titles.first
    }

    var authorName: String? {
        return metadata.creators.first?.name
    }

    // MARK: - Media Overlay Metadata
    // http://www.idpf.org/epub/301/spec/epub-mediaoverlays.html#sec-package-metadata

    var duration: String? {
        return metadata.find(byProperty: "media:duration")?.value
    }

    var activeClass: String {
        guard let className = metadata.find(byProperty: "media:active-class")?.value else {
            return "epub-media-overlay-active"
        }
        return className
    }

    var playbackActiveClass: String {
        guard let className = metadata.find(byProperty: "media:playback-active-class")?.value else {
            return "epub-media-overlay-playing"
        }
        return className
    }

    // MARK: - Media Overlay (SMIL) retrieval

    /**
     Get Smil File from a resource (if it has a media-overlay)
     */
    func smilFileForResource(_ resource: WLResource?) -> WLSmilFile? {
        guard let resource = resource, let mediaOverlay = resource.mediaOverlay else { return nil }

        // lookup the smile resource to get info about the file
        guard let smilResource = resources.findById(mediaOverlay) else { return nil }

        // use the resource to get the file
        return smils.findByHref(smilResource.href)
    }

    func smilFile(forHref href: String) -> WLSmilFile? {
        return smilFileForResource(resources.findByHref(href))
    }

    func smilFile(forId ID: String) -> WLSmilFile? {
        return smilFileForResource(resources.findById(ID))
    }
    
    // @NOTE: should "#" be automatically prefixed with the ID?
    func duration(for ID: String) -> String? {
        return metadata.find(byProperty: "media:duration", refinedBy: ID)?.value
    }
}
