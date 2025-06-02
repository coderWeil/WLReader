//
//  WLBookNoteModel.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/2.
//  笔记，书签数据模型

import HandyJSON

enum WLBookNoteType: NSInteger, HandyJSONEnum {
    case mark = 1 // 书签
    case line = 2 // 划线
    case note = 3 // 笔记
}

enum WLNoteViewType:NSInteger {
    case text_text = 1 // 笔记是文本，引用是文本
    case text_image = 2 // 笔记是文本，引用是图片
    case image_text = 3 // 笔记是图片，引用是文本
    case image_image = 4 // 笔记是图片，引用是图片
    case textImage_text = 5 // 笔记是图文，引用是文本
    case textImage_image = 6 // 笔记是图文，引用是图片
    case null_text = 7 // 书签和划线，只有引用文本
    case null_image = 8 // 划线，只有引用图片
    case null = 9 // 什么也不是
}

class WLNoteListModel: HandyJSON {
    var totalPage:Int? // 总页数
    var pageSize:Int? // 页码
    var total:Int? // 总数量
    var currentPage:Int? // 当前页
    var list:[WLBookNoteModel]?
    
    required init() {
    }
}

class WLSourceContentModel: HandyJSON {
    // 内容来源类型 0 文本 1 图片
    var type:Int?
    // 文字
    var text:String?
    // 图片
    var imageUrl:String?
    // 本地图片资源路径，如 “image/02.jpg”
    var imageSource:String?
    
    required init() {
        
    }
}

class WLNoteContentModel: HandyJSON {
    // 文字
    var text:String?
    // 图片
    var imageUrl:String?
    
    required init() {
        
    }
}

class WLBookNoteModel: HandyJSON {
    // 书籍ID
    var bookIdStr:String?
    var bookId:Int64?
    // 用户头像
    var avatar:String?
    // 章节index
    var chapterNumber:Int?
    // 结束位置
    var endLocation:Int?
    // 开始位置
    var startLocation:Int?
    // 用户id
    var userId:String?
    var userName:String?
    // 笔记id
    var noteId:Int?
    var noteIdStr:String?
    // 是否显示笔记
    var allowDisplayed:Bool? = true
    // 时间
    var noteTime:String?
    // 审核状态
    var reviewStatus:Int?
    // 笔记来源内容
    var sourceContent:WLSourceContentModel?
    // 笔记内容
    var noteContent:WLNoteContentModel?
    // 标识是笔记还是书签, 默认是笔记 1：书签 2：划线 3：笔记
    var noteType:WLBookNoteType! = .note
    
    func mapping(mapper: HelpingMapper) {
       mapper <<<
           self.noteType <-- TransformOf<WLBookNoteType, NSInteger>(fromJSON: { rawValue in
               if let rawValue = rawValue {
                   return WLBookNoteType(rawValue: rawValue) ?? .note
               }
               return .note
           }, toJSON: { type in
               return type?.rawValue
           })
   }
                
    required init() {
        
    }
    
    // MARK - 返回对应的笔记列表cell类型
    public func getNoteViewType() -> WLNoteViewType {
        if self.noteType == .mark { // 书签
            return .null_text
        }
        if self.noteType == .line { // 划线
            if let _ = self.sourceContent?.imageUrl { // 图片
                return .null_image
            }
            // 不是划线图片，那就是文本
            return .null_text
        }
        if self.noteType == .note { // 笔记
            // 先看笔记有没有图片
            if let _ = self.noteContent?.imageUrl { // 有图片
                // 再看有没有文本
                if let _ = self.noteContent?.text { // 有文本
                    if let _ = self.sourceContent?.imageUrl { // 引用是图片
                        return .textImage_image
                    }else { // 引用是文本
                        return .textImage_text
                    }
                }else { // 没有文本
                    if let _ = self.sourceContent?.imageUrl { // 引用是图片
                        return .image_image
                    }else { // 引用是文本
                        return .image_text
                    }
                }
            }else { // 没有图片
                // 再看有没有文本
                if let _ = self.noteContent?.text { // 有文本
                    if let _ = self.sourceContent?.imageUrl { // 引用是图片
                        return .text_image
                    }else { // 引用是文本
                        return .text_text
                    }
                }else { // 没有文本
                    if let _ = self.sourceContent?.imageUrl { // 引用是图片
                        return .null_image
                    }else { // 引用是文本
                        return .null_text
                    }
                }
            }
        }
        return .null
    }
}
