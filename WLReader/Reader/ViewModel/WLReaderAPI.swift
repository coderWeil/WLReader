//
//  WLReaderAPI.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/24.
//

import RxSwift
import RxAlamofire
import Moya

enum WLReaderAPI {
    case addNote(params:[String:Any])
    case editNote(params:[String:Any])
    case deleteNote(params:[String:Any])
    case notePage(params:[String:Any])
    case upload(image:UIImage?)
}

extension WLReaderAPI: WLBaseAPI {
    var baseURL: URL {
        return WLNetworkConfig.shared.baseURL!
    }
    var path: String {
        switch self {
        case .addNote(_):
            return "/api/v1/duku/reading/note/addOrEdit"
        case .editNote(_):
            return "/api/v1/duku/reading/note/addOrEdit"
        case .deleteNote(_):
            return "/api/v1/duku/reading/note/deleteNote"
        case .notePage(_):
            return "/api/v1/duku/reading/note/notePage"
        case .upload(_):
            return "/api/v1/duku/worker/upload"
        }
    }
    var method: Moya.Method {
        switch self {
        case .addNote(_):
            return .post
        case .editNote(_):
            return .post
        case .deleteNote(_):
            return .post
        case .notePage(_):
            return .get
        case .upload(_):
            return .post
        }
    }
    var task: Moya.Task {
        switch self {
        case .addNote(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .editNote(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .deleteNote(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .notePage(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .upload(let image):
            let formData = MultipartFormData(provider: .data(image!.jpegData(compressionQuality: 0.5)!), name: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            let multipartData = [formData]
            
            return .uploadMultipart(multipartData)
        }
    }
    var headers: [String : String]? {
        return [:]
    }
}
