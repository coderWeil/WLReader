//
//  WLReaderAPI.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/24.
//

import RxNetworks

enum WLReaderAPI {
    case addNote(params:[String:Any])
    case editNote(params:[String:Any])
    case deleteNote(id:Int)
    case notePage(currentPage:Int, pageSize:Int, bookId:Int, chapterNumber:Int)
}

extension WLReaderAPI: NetworkAPI {
    var ip: APIHost {
        return BoomingSetup.baseURL
    }
    var path: String {
        switch self {
        case .addNote(_):
            return "/api/v1/duku/reading/note/addOrEdit"
        case .editNote(_):
            return "/api/v1/duku/reading/note/addOrEdit"
        case .deleteNote(_):
            return "/api/v1/duku/reading/note/deleteNote"
        case .notePage(_, _, _, _):
            return "/api/v1/duku/reading/note/notePage"
        }
    }
    var method: APIMethod {
        switch self {
        case .addNote(_):
            return .post
        case .editNote(_):
            return .post
        case .deleteNote(_):
            return .post
        case .notePage(_, _, _, _):
            return .get
        }
    }
    var parameters: APIParameters? {
        switch self {
        case .addNote(let params):
            return params
        case .editNote(let params):
            return params
        case .deleteNote(let id):
            return ["id": id]
        case .notePage(let currentPage, let pageSize, let bookId, let chapterNumber):
            return ["currentPage":currentPage, "pageSize":pageSize, "bookId":bookId, "chapterNumber":chapterNumber]
        }
    }
}
