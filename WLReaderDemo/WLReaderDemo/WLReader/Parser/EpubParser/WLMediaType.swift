//
//  WLMediaType.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/16.
//

import Foundation

public struct WLMediaType: Equatable {
    public let name: String
    public let defaultExtension: String
    public let extensions: [String]

    public init(name: String, defaultExtension: String, extensions: [String] = []) {
        self.name = name
        self.defaultExtension = defaultExtension
        self.extensions = extensions
    }
}

// MARK: - Equatable

/// :nodoc:
public func == (lhs: WLMediaType, rhs: WLMediaType) -> Bool {
    guard lhs.name == rhs.name else { return false }
    guard lhs.defaultExtension == rhs.defaultExtension else { return false }
    guard lhs.extensions == rhs.extensions else { return false }
    return true
}


/**
 Manages mediatypes that are used by epubs.
 */
extension WLMediaType {
    static let xhtml = WLMediaType(name: "application/xhtml+xml", defaultExtension: "xhtml", extensions: ["htm", "html", "xhtml", "xml"])
    static let epub = WLMediaType(name: "application/epub+zip", defaultExtension: "epub")
    static let ncx = WLMediaType(name: "application/x-dtbncx+xml", defaultExtension: "ncx")
    static let opf = WLMediaType(name: "application/oebps-package+xml", defaultExtension: "opf")
    static let javaScript = WLMediaType(name: "text/javascript", defaultExtension: "js")
    static let css = WLMediaType(name: "text/css", defaultExtension: "css")

    // images
    static let jpg = WLMediaType(name: "image/jpeg", defaultExtension: "jpg", extensions: ["jpg", "jpeg"])
    static let png = WLMediaType(name: "image/png", defaultExtension: "png")
    static let gif = WLMediaType(name: "image/gif", defaultExtension: "gif")
    static let svg = WLMediaType(name: "image/svg+xml", defaultExtension: "svg")

    // fonts
    static let ttf = WLMediaType(name: "application/x-font-ttf", defaultExtension: "ttf")
    static let ttf1 = WLMediaType(name: "application/x-font-truetype", defaultExtension: "ttf")
    static let ttf2 = WLMediaType(name: "application/x-truetype-font", defaultExtension: "ttf")
    static let openType = WLMediaType(name: "application/vnd.ms-opentype", defaultExtension: "otf")
    static let woff = WLMediaType(name: "application/font-woff", defaultExtension: "woff")

    // audio
    static let mp3 = WLMediaType(name: "audio/mpeg", defaultExtension: "mp3")
    static let mp4 = WLMediaType(name: "audio/mp4", defaultExtension: "mp4")
    static let ogg = WLMediaType(name: "audio/ogg", defaultExtension: "ogg")

    static let smil = WLMediaType(name: "application/smil+xml", defaultExtension: "smil")
    static let xpgt = WLMediaType(name: "application/adobe-page-template+xml", defaultExtension: "xpgt")
    static let pls = WLMediaType(name: "application/pls+xml", defaultExtension: "pls")

    static let mediatypes = [xhtml, epub, ncx, opf, jpg, png, gif, javaScript, css, svg, ttf, ttf1, ttf2, openType, woff, mp3, mp4, ogg, smil, xpgt, pls]

    /**
     Gets the MediaType based on the file mimetype.
     - parameter name:     The mediaType name
     - parameter fileName: The file name to extract the extension
     - returns: A know mediatype or create a new one.
     */
    static func by(name: String, fileName: String?) -> WLMediaType {
        for mediatype in mediatypes {
            if mediatype.name == name {
                return mediatype
            }
        }
        let ext = fileName?.pathExtension ?? ""
        return WLMediaType(name: name, defaultExtension: ext)
    }

    /**
     Gets the MediaType based on the file extension.
     */
    static func by(fileName: String) -> WLMediaType? {
        let ext = "." + (fileName as NSString).pathExtension
        return mediatypes.filter({ $0.extensions.contains(ext) }).first
    }

    /**
     Compare if the resource is a image.
     - returns: `true` if is a image and `false` if not
     */
    static func isBitmapImage(_ mediaType: WLMediaType) -> Bool {
        return mediaType == jpg || mediaType == png || mediaType == gif
    }

    /**
     Gets the MediaType based on the file extension.
     */
    static func determineMediaType(_ fileName: String) -> WLMediaType? {
        let ext = fileName.pathExtension

        for mediatype in mediatypes {
            if mediatype.defaultExtension == ext {
                return mediatype
            }
            if mediatype.extensions.contains(ext) {
                return mediatype
            }
        }
        return nil
    }
}

