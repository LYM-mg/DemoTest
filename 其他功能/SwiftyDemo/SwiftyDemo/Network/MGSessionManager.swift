//
//  MGSessionManager.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/3.
//  Copyright © 2019年 firestonetmt. All rights reserved.
//

import UIKit
import Alamofire

class MGSessionManager: NSObject {
    public static let `default` = MGSessionManager()
    var baseURL: String?
    let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
}

extension MGSessionManager {
    var defaultHeaders: [String: String] {
        return [:]
    }

    /// 普通封装接口，需要传很多参数
    @discardableResult
    func request(
        _ urlPath: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest {
            var requestURL: String = ""
            if (baseURL != nil) {
                if urlPath.hasPrefix(baseURL!) {
                    requestURL = urlPath
                }else {
                    requestURL = "\(baseURL!)"+"/"+"\(urlPath)"
                }
            } else {
                requestURL = urlPath
            }
//            let requestURL = baseURL.appendingPathComponent(urlPath)
            let requestHeaders = (headers ?? [String: String]()).merging(defaultHeaders) { (vOne, vTwo) -> String in
                return vOne
            }
            var encodingT = encoding
//            if method == .post {
//                encodingT = JSONEncoding.default
//            }
            return manager.request(requestURL, method: method, parameters: parameters, encoding: encodingT, headers: headers)
    }

    /// 封装接口，参数由 MGRequestable这个协议()提供
    func request<T: MGRequestable>(_ request: T) -> DataRequest {
        return MGSessionManager.default.request(request.urlPath, method: request.method, parameters: request.parameters)
    }

    static func configWith(_ baseURL: String) {
        MGSessionManager.default.baseURL = baseURL
    }
}

// MARK: - MGRequestable
protocol MGRequestable {
    var method: HTTPMethod { get }
    var urlPath: String { get }
    var parameters: [String: Any]? { get }
}

extension MGRequestable {
    func request<T: Decodable>(completionHandler: @escaping (DataResponse<MGResponse<T>>) -> Void) {
        MGSessionManager.default.request(self).mgResponseDecodableObject(completionHandler: completionHandler)
    }
}


