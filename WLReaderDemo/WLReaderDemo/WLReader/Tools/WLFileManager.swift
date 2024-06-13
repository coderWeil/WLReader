//
//  WLFileManager.swift
//  DuKu
//
//  Created by 李伟 on 2024/5/30.
//

import Foundation

class WLFileManager: NSObject {
    static let shared = WLFileManager()
    
    let sessionManager: SessionManager = {
        var configuration = SessionConfiguration()
        configuration.allowsCellularAccess = true
        let path = Cache.defaultDiskCachePathClosure("WLReaderDownloads")
        let cacahe = Cache("WLReader", downloadPath: path)
        let manager = SessionManager("WLReader", configuration: configuration, cache: cacahe, operationQueue: DispatchQueue(label: "com.Tiercel.SessionManager.operationQueue"))
        return manager
    }()
    
    
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
    public func start(filePath:String) { // 到这里，那肯定是没有下载过，这个path是文件下载的链接
        sessionManager.download(filePath)
    }
    /**
     * 暂停下载
     */
    public func suspend(filePath:String) {
        sessionManager.suspend(filePath)
    }
    // MARK - 删除下载
    public func remove(filePath:String) {
        sessionManager.remove(filePath)
    }
}
