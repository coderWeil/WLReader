//
//  WLBookParser.swift
//  DTCoreTextDemo
//
//  Created by 李伟 on 2024/5/17.
//

import Foundation

open class WLBookParser: NSObject {
    /// 图书路径
    var bookPath:String!// 这个可能是本地的，也可能是网络下载下来的存储到本地的路径
    var bookURL:URL!
    /// 图书类型
    var bookType:WLBookType!
    /// 回调
    private var parserCallback:((WLBookModel?, Bool) -> ())?
    
    init(_ path:String) {
        self.bookPath = path
        self.bookURL = URL(fileURLWithPath: path)
        self.bookType = WLBookType.bookType(bookURL.pathExtension.lowercased())
    }
    // MARK - 开始解析
    func parseBook(parserCallback: @escaping (WLBookModel?, Bool) ->()) {
        self.parserCallback = parserCallback
        DispatchQueue.global().async {
            switch self.bookType {
            case .Epub:
                self.parseEpubBook()
            case .Txt:
                self.parseTxtBook()
            default:
                print("暂时无法解析")
            }
        }
    }
    // MARK - Epub类型解析
    private func parseEpubBook() {
        do {
            let epub = try WLEpubParser().readEpub(epubPath: bookPath, removeEpub: false)
            let bookModel = WLBookModel(epub: epub)
            DispatchQueue.main.async {
                self.parserCallback?(bookModel, true)
            }
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.parserCallback?(nil, false)
            }
        }
    }
    
    // MARK - TXT 类型解析
    private func parseTxtBook() {
        do {
            let txt = try WLTxtParser().parseBook(path: bookPath)
            let bookModel = WLBookModel(txt: txt)
            DispatchQueue.main.async {
                self.parserCallback?(bookModel, true)
            }
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.parserCallback?(nil, false)
            }
        }
    }
}
