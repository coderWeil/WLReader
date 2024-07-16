//
//  WLNetworkConfig.swift
//  WLReaderDemo
//
//  Created by 李伟 on 2024/7/16.
//

import Foundation
class WLNetworkConfig: NSObject {
    static let shared = WLNetworkConfig()
    public var baseURL:URL?
    // 设置baseURL
    func config() {
        baseURL = URL(string: "xxxxx")
    }
}
