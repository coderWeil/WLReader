//
//  NetworkCachePlugin.swift
//  RxNetworks
//
//  Created by Condy on 2021/10/6.
//  https://github.com/yangKJ/RxNetworks

import Foundation
import Moya
import CacheX

/// Network cache plugin type
public enum NetworkCacheType {
    /** 只从网络获取数据，且数据不会缓存在本地 */
    /** Only get data from the network, and the data will not be cached locally */
    case ignoreCache
    /** 先从网络获取数据，同时会在本地缓存数据 */
    /** Get the data from the network first, and cache the data locally at the same time */
    case networkOnly
    /** 先从缓存读取数据，如果没有再从网络获取 */
    /** Read the data from the cache first, if not, then get it from the network */
    case cacheElseNetwork
    /** 先从网络获取数据，如果没有在从缓存获取，此处的没有可以理解为访问网络失败，再从缓存读取 */
    /** Get data from the network first, if not from the cache */
    case networkElseCache
    /** 先从缓存读取数据，然后在从网络获取并且缓存，可能会获取到两次数据 */
    /** Data is first read from the cache, then retrieved from the network and cached, Maybe get `twice` data */
    case cacheThenNetwork
}

/// 缓存插件，基于`CacheX`封装使用
/// Cache plugin, based on `CacheX` package use
public struct NetworkCachePlugin {
    
    public let options: Options
    
    public init(options: Options = .ignoreCache) {
        self.options = options
    }
    
    public init(cacheType: NetworkCacheType = .ignoreCache) {
        let options = Options(cacheType: cacheType)
        self.init(options: options)
    }
}

extension NetworkCachePlugin {
    public struct Options {
        /// Network cache plugin type
        let cacheType: NetworkCacheType
        /// Encryption type, default md5
        let cryptoType: CacheX.CryptoType
        /// Storage type, default disk and memory.
        let cachedOptions: CacheX.CachedOptions
        
        public init(cacheType: NetworkCacheType, cryptoType: CryptoType = .md5, cachedOptions: CachedOptions = .diskAndMemory) {
            self.cacheType = cacheType
            self.cryptoType = cryptoType
            self.cachedOptions = cachedOptions
        }
    }
}

extension NetworkCachePlugin.Options {
    /** 只从网络获取数据，且数据不会缓存在本地 */
    /** Only get data from the network, and the data will not be cached locally */
    public static let ignoreCache: NetworkCachePlugin.Options = .init(cacheType: .ignoreCache)
    /** 先从网络获取数据，同时会在本地缓存数据 */
    /** Get the data from the network first, and cache the data locally at the same time */
    public static let networkOnly: NetworkCachePlugin.Options = .init(cacheType: .networkOnly)
    /** 先从缓存读取数据，如果没有再从网络获取 */
    /** Read the data from the cache first, if not, then get it from the network */
    public static let cacheElseNetwork: NetworkCachePlugin.Options = .init(cacheType: .cacheElseNetwork)
    /** 先从网络获取数据，如果没有在从缓存获取，此处的没有可以理解为访问网络失败，再从缓存读取 */
    /** Get data from the network first, if not from the cache */
    public static let networkElseCache: NetworkCachePlugin.Options = .init(cacheType: .networkElseCache)
    /** 先从缓存读取数据，然后在从网络获取并且缓存，可能会获取到两次数据 */
    /** Data is first read from the cache, then retrieved from the network and cached, Maybe get `twice` data */
    public static let cacheThenNetwork: NetworkCachePlugin.Options = .init(cacheType: .cacheThenNetwork)
}

extension NetworkCachePlugin: PluginSubType {
    
    public var pluginName: String {
        return "Cache"
    }
    
    public func configuration(_ request: HeadstreamRequest, target: TargetType) -> HeadstreamRequest {
        switch options.cacheType {
        case .cacheElseNetwork, .cacheThenNetwork:
            if let response = self.readCacheResponse(target) {
                request.result = .success(response)
            }
            if options.cacheType == .cacheElseNetwork {
                request.endRequest = true
            }
        default:
            break
        }
        return request
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if case .success(let response) = result {
            switch self.options.cacheType {
            case .networkElseCache, .cacheThenNetwork, .cacheElseNetwork:
                self.saveCacheResponse(response, target: target)
            default:
                break
            }
        }
    }
    
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch options.cacheType {
        case .networkElseCache:
            switch result {
            case .success:
                return result
            case .failure:
                if let response = self.readCacheResponse(target) {
                    return .success(response)
                }
            }
        default:
            break
        }
        return result
    }
}

extension NetworkCachePlugin {
    
    private func readCacheResponse(_ target: TargetType) -> Moya.Response? {
        let key = options.cryptoType.encryptedString(with: X.requestLink(with: target))
        guard let model = CacheManager.default.storage.fetchCached(forKey: key, options: options.cachedOptions),
              let statusCode = model.statusCode,
              let data = model.data else {
            return nil
        }
        return Response(statusCode: statusCode, data: data)
    }
    
    private func saveCacheResponse(_ response: Moya.Response?, target: TargetType) {
        guard let response = response else { return }
        let key = options.cryptoType.encryptedString(with: X.requestLink(with: target))
        let model = CacheModel(data: response.data, statusCode: response.statusCode)
        CacheManager.default.storage.storeCached(model, forKey: key, options: options.cachedOptions)
    }
}
