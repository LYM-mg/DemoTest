//
//  DataRequestExtension.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/3.
//  Copyright © 2019年 firestonetmt. All rights reserved.
//

import UIKit
import Alamofire
import MJExtension
import SwiftyJSON

public let mgDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}()

public let mgEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dateEncodingStrategy = .iso8601
    return encoder
}()

public struct MGNetworkingError: Codable {
    public let code: String
    public let textCode: String?
    public let msg: String?
    //    let requestId: String
}

public struct MGResponse<T: Decodable>: Decodable {
    public let data: T?
    public let success: Int
    public let error: MGNetworkingError?
}

public struct LYMResponse<T> {
    public let data: T?
    public let success: Int
    public let error: MGNetworkingError?
}

// MARK: - mgDecodeToObject Decodable
extension DataRequest {
    private static func mgDecodeToObject<T: Decodable>(
        decoder: JSONDecoder,
        response: HTTPURLResponse?,
        data: Data?)
        -> Result<T> {
        let result = Request.serializeResponseData(response: response, data: data, error: nil)

        switch result {
        case .success(let data):
            do {
                let object = try decoder.decode(MGResponse<T>.self, from: data)
                if object.success == 1, let data = object.data {
                    return .success(data)
                } else if let itError = object.error {
                    return .failure(itError as! Error)
                }
                //TODO be more specific
                return .failure(NSError.init())
            }
            catch {
                return .failure(error)
            }
        case .failure(let error): return .failure(error)
        }
    }

    @discardableResult
    /// 字典
    public func mgResponseDecodableObject<T: Decodable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self {
        return response(queue: queue,
                        responseSerializer: DataRequest.mgDecodableObjectSerializer(mgDecoder),
                        completionHandler: completionHandler)
    }

    fileprivate static func mgDecodableObjectSerializer<T: Decodable>(
        _ decoder: JSONDecoder)
        -> DataResponseSerializer<T> {
        return DataResponseSerializer<T> { request, response, data, error in
            if let error = error {
                return .failure(error)
            }
            return DataRequest.mgDecodeToObject(decoder: decoder, response: response, data: data)
        }
    }

    /// 数组
    public func mgResponseDecodableArrayObject<T: Decodable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self {
            return response(queue: queue,
                            responseSerializer: DataRequest.mgDecodableObjectArraySerializer(mgDecoder),
                            completionHandler: completionHandler)
    }

    private static func mgDecodableObjectArraySerializer<T: Decodable>(_ decoder: JSONDecoder) -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            if let error = error {
                return .failure(error)
            }
            return DataRequest.mgDecodeToObject(decoder: decoder, response: response, data: data)
        }
    }
}


extension DataRequest {
    private static func DecodableObjectSerializer<T: Decodable>(_ keyPath: String?, _ decoder: JSONDecoder) -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            if let error = error {
                return .failure(error)
            }
            if let keyPath = keyPath {
                if keyPath.isEmpty {
                    return .failure(AlamofireDecodableError.emptyKeyPath)
                }
                return DataRequest.decodeToObject(byKeyPath: keyPath, decoder: decoder, response: response, data: data)
            }
            return DataRequest.decodeToObject(decoder: decoder, response: response, data: data)
        }
    }

    private static func decodeToObject<T: Decodable>(decoder: JSONDecoder, response: HTTPURLResponse?, data: Data?) -> Result<T> {
        let result = Request.serializeResponseData(response: response, data: data, error: nil)

        switch result {
        case .success(let data):
            do {
                let object = try decoder.decode(T.self, from: data)
                return .success(object)
            }
            catch {
                return .failure(error)
            }
        case .failure(let error): return .failure(error)
        }
    }

    private static func decodeToObject<T: Decodable>(byKeyPath keyPath: String, decoder: JSONDecoder, response: HTTPURLResponse?, data: Data?) -> Result<T> {
        let result = Request.serializeResponseJSON(options: [], response: response, data: data, error: nil)

        switch result {
        case .success(let json):
            if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
                do {
                    let data = try JSONSerialization.data(withJSONObject: nestedJson)
                    let object = try decoder.decode(T.self, from: data)
                    return .success(object)
                }
                catch {
                    return .failure(error)
                }
            }
            else {
                return .failure(AlamofireDecodableError.invalidKeyPath)
            }
        case .failure(let error): return .failure(error)
        }
    }


    /// Adds a handler to be called once the request has finished.

    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter keyPath:           The keyPath where object decoding should be performed. Default: `nil`.
    /// - parameter decoder:           The decoder that performs the decoding of JSON into semantic `Decodable` type. Default: `JSONDecoder()`.
    /// - parameter completionHandler: The code to be executed once the request has finished and the data has been mapped by `JSONDecoder`.

    /// - returns: The request.
    @discardableResult
    public func responseDecodableObject<T: Decodable>(queue: DispatchQueue? = nil, keyPath: String? = nil, decoder: JSONDecoder = JSONDecoder(), completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.DecodableObjectSerializer(keyPath, decoder), completionHandler: completionHandler)
    }
}

public enum AlamofireDecodableError: Error {
    case invalidKeyPath
    case emptyKeyPath
}

extension AlamofireDecodableError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .invalidKeyPath:   return "Nested object doesn't exist by this keyPath."
        case .emptyKeyPath:     return "KeyPath can not be empty."
        }
    }
}
