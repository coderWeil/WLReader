//
//  WLSmilsElement.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/16.
//

import Foundation

class WLSmilElement: NSObject {
    var name: String // the name of the tag: <seq>, <par>, <text>, <audio>
    var attributes: [String: String]!
    var children: [WLSmilElement]

    init(name: String, attributes: [String:String]!) {
        self.name = name
        self.attributes = attributes
        self.children = [WLSmilElement]()
    }

    // MARK: - Element attributes

    func getId() -> String! {
        return getAttribute("id")
    }

    func getSrc() -> String! {
        return getAttribute("src")
    }

    /**
     Returns array of Strings if `epub:type` attribute is set. An array is returned as there can be multiple types specified, seperated by a whitespace
     */
    func getType() -> [String]! {
        let type = getAttribute("epub:type", defaultVal: "")
        return type!.components(separatedBy: " ")
    }

    /**
     Use to determine if this element matches a given type

     **Example**

     epub:type="bodymatter chapter"
     isType("bodymatter") -> true
     */
    func isType(_ aType:String) -> Bool {
        return getType().contains(aType)
    }

    func getAttribute(_ name: String, defaultVal: String!) -> String! {
        return attributes[name] != nil ? attributes[name] : defaultVal;
    }

    func getAttribute(_ name: String ) -> String! {
        return getAttribute(name, defaultVal: nil)
    }

    // MARK: - Retrieving children elements

    // if <par> tag, a <text> is required (http://www.idpf.org/epub/301/spec/epub-mediaoverlays.html#sec-smil-par-elem)
    func textElement() -> WLSmilElement! {
        return childWithName("text")
    }

    func audioElement() -> WLSmilElement! {
        return childWithName("audio")
    }

    func videoElement() -> WLSmilElement! {
        return childWithName("video")
    }

    func childWithName(_ name:String) -> WLSmilElement! {
        for el in children {
            if( el.name == name ){
                return el
            }
        }
        return nil;
    }

    func childrenWithNames(_ name:[String]) -> [WLSmilElement]! {
        var matched = [WLSmilElement]()
        for el in children {
            if( name.contains(el.name) ){
                matched.append(el)
            }
        }
        return matched;
    }

    func childrenWithName(_ name:String) -> [WLSmilElement]! {
        return childrenWithNames([name])
    }

    // MARK: - Audio clip info

    func clipBegin() -> Double {
        let val = audioElement().getAttribute("clipBegin", defaultVal: "")
        return val!.clockTimeToSeconds()
    }

    func clipEnd() -> Double {
        let val = audioElement().getAttribute("clipEnd", defaultVal: "")
        return val!.clockTimeToSeconds()
    }
}
