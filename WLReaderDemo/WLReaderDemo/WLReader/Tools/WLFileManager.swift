//
//  WLFileManager.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/30.
//

import Foundation

class WLFileManager: NSObject {
    static let shared = WLFileManager()
    
    /**
     * 查询文件是否下载过
     * - Parameter filePath 文件地址
     */
    class func fileExist(filePath:String) -> Bool {
        var path = filePath
        if filePath.hasPrefix("http") { // 表示是网络地址
            let fileURL = URL(string: filePath)
            let fileName = fileURL?.lastPathComponent
            WLBookConfig.shared.bookName = fileName
            path = kApplicationDocumentsDirectory + fileName!
        }else {
            let fileURL = URL(fileURLWithPath: filePath)
            let fileName = fileURL.lastPathComponent
            WLBookConfig.shared.bookName = fileName
            path = kApplicationDocumentsDirectory + fileName
        }
        return FileManager.default.fileExists(atPath: path)
    }
    /**
     * 开始下载
     * - Parameter filePath 文件地址
     */
    class func start(filePath:String) { // 到这里，那肯定是没有下载过，这个path是文件下载的链接
        let url = URL(string: filePath)
        
    }
    /**
     * 停止下载
     */
    class func stop(filePath:String) {
        
    }
}
