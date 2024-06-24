//
//  NetworkAPIOO+Rx.swift
//  RxNetworks
//
//  Created by Condy on 2022/5/12.
//  https://github.com/yangKJ/RxNetworks

import Foundation
import RxSwift
import Moya

extension NetworkAPIOO {
    /// OOP Network request.
    /// Example:
    ///
    ///     let api = NetworkAPIOO.init()
    ///     api.cdy_ip = "https://www.httpbin.org"
    ///     api.cdy_path = "/ip"
    ///     api.cdy_method = APIMethod.get
    ///     api.cdy_plugins = [NetworkLoadingPlugin.init()]
    ///     api.cdy_testJSON = "{\"Condy\":\"yangkj310@gmail.com\"}"
    ///
    ///     api.cdy_HTTPRequest()
    ///         .asObservable()
    ///         .observe(on: MainScheduler.instance)
    ///         .subscribe { (data) in
    ///             print("\(data)")
    ///         } onError: { (error) in
    ///             print("Network failed: \(error.localizedDescription)")
    ///         }
    ///         .disposed(by: disposeBag)
    ///
    /// - Parameter callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
    /// - Returns: Observable sequence JSON object. May be thrown twice.
    public func cdy_HTTPRequest(_ callbackQueue: DispatchQueue? = nil) -> APIObservableJSON {
        request(callbackQueue: callbackQueue)
    }
}
