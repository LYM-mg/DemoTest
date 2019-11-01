//
//  DataRequest+NSObject.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/17.
//  Copyright © 2019 firestonetmt. All rights reserved.


import UIKit
import Alamofire
import MJExtension
import SwiftyJSON

// MARK:  - 协议 MGModelProtocol
protocol MGModelProtocol {
    init(_ json: JSON!);
}

/*  如何使用：
 举个🌰eg:
    // LYMSong是遵守MGModelProtocol的模型
    let parameters: [String: Any] = ["method":"baidu.ting.billboard.billCategory","kflag":"1","from":"ios","version":"5.5.6","channel":"appstore","operator":"1","format":"json"]
    // 封装Alamofire
    MGSessionManager.default.request("http://tingapi.ting.baidu.com/v1/restserver/ting", method: .post, parameters: parameters).lym.responseObject { (response: DataResponse<LYMSong>) in
             switch response.result {
                 case .success(let song):
                     print(song)
                     break
                 case .failure(let error):
                     print(error)
                     break
             }
    }

    // 原生Alamofire
    SessionManager.default.request("http://tingapi.ting.baidu.com/v1/restserver/ting", method: .post, parameters: parameters).lym.responseObject { (response:DataResponse<LYMSong>) in
            switch response.result {
                case .success(let song):
                    print(song)
                    break
                 case .failure(let error):
                     print(error)
                     break
            }
    }

 /// 如果数据统一格式  比较好处理
 """
    {
        data: { },         // 数据（可以进一层，先判断成功与否再去解析数据）
        success: true,     // 成功与否
        errMsg: "错误提示"
    }
 """

 */

// MARK:  - 参考responseJSON 构造泛型返回,继承NSObject
extension DataRequest {
    // MARK:  - 继承NSObject
    public static func jsonResponseSerializer<T:NSObject>(
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DataResponseSerializer<T>
    {
        return DataResponseSerializer { _, response, data, error in
            return DataRequest.itDecodeToObject(response: response, data: data,error: error,options: options)
        }
    }

    private static func itDecodeToObject<T:NSObject>(response: HTTPURLResponse?, data: Data?,error: Error?,options: JSONSerialization.ReadingOptions) -> Result<T> {
        guard error == nil else { return .failure(error!) }

        if let response = response, [204, 205].contains(response.statusCode) { return .success(T()) }

        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }
        do{
            let json = try JSONSerialization.jsonObject(with: validData, options: options)
            return .success(T.self.mj_object(withKeyValues: json))
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }

    // MARK:  - 遵守MGModelProtocol协议的 并且使用SwiftyJSON解析数据，当然你也可以用别的框架
    fileprivate static func jsonResponseSerializer<T:MGModelProtocol>(
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DataResponseSerializer<T>
    {
        return DataResponseSerializer { _, response, data, error in
            return DataRequest.itDecodeToObject(response: response, data: data,error: error,options: options)
        }
    }

    private static func itDecodeToObject<T:MGModelProtocol>(response: HTTPURLResponse?, data: Data?,error: Error?,options: JSONSerialization.ReadingOptions) -> Result<T> {
        guard error == nil else { return .failure(error!) }

        if let response = response, [204, 205].contains(response.statusCode) { return .success(T(JSON())) }

        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }

        do {
            let dataJson = try JSON(data: validData)
            return .success(T.self.init(dataJson))
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
}

// MARK: - 命名空间
extension DataRequest: LYMNamespacePotocol {}
extension  LYMTypeWrapperProtocol where WrappedType == DataRequest {
    /// 参考responseJSON 构造泛型返回
    @discardableResult
    func responseObject<T:NSObject>(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> WrappedType
    {
        return wrappedValue.response(
            queue: queue,
            responseSerializer: DataRequest.jsonResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }

    @discardableResult
    func responseObject<T:MGModelProtocol>(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<T>) -> Void)
         -> WrappedType
    {
         return wrappedValue.response(queue: queue,
                                     responseSerializer: DataRequest.jsonResponseSerializer(options: options),
                                     completionHandler: completionHandler)

    }
}
