//
//  NetworkHttpHeaderPlugin.swift
//  Alamofire
//
//  Created by Condy on 2023/10/15.
//  https://github.com/yangKJ/RxNetworks

import Foundation
import Alamofire
import Moya

/// 添加网络请求头插件
/// 相同元素时刻，该插件会覆盖`BoomingSetup.baseHeaders`参数
public struct NetworkHttpHeaderPlugin {
    
    public let headers: [Alamofire.HTTPHeader]
    public let choiceValueType: ChoiceValueType
    
    public enum ChoiceValueType {
        /// Complete replacement.
        case replacement
        /// Only take `baseHeaders`.
        case baseHeaders
        /// At the same time, the same data takes `baseHeaders`.
        case coexistAndBaseHeaders
        /// At the same time, the same data takes `NetworkHttpHeaderPlugin`.
        case coexistAndPlugin
    }
    
    public init(headers: [Alamofire.HTTPHeader], choice type: ChoiceValueType = .coexistAndPlugin) {
        self.headers = headers
        self.choiceValueType = type
    }
    
    /// The dictionary representation of all headers.
    /// This representation does not preserve the current order of the instance.
    private var toHeaders: [String: String] {
        let namesAndValues = headers.map { ($0.name, $0.value) }
        return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
    }
    
    var dictionary: [String: String] {
        switch choiceValueType {
        case .replacement:
            return toHeaders
        case .baseHeaders:
            return BoomingSetup.baseHeaders
        case .coexistAndBaseHeaders:
            return toHeaders.merging(BoomingSetup.baseHeaders) { $1 }
        case .coexistAndPlugin:
            // Merge the dictionaries and take the second value
            return BoomingSetup.baseHeaders.merging(toHeaders) { $1 }
        }
    }
}

extension NetworkHttpHeaderPlugin: PluginSubType {
    
    public var pluginName: String {
        return "HTTPHeader"
    }
}
