//
//  MessageNetwork.swift
//  message
//
//  Created by jiali on 2019/7/22.
//  Copyright © 2019 italki. All rights reserved.
//

import UIKit
import Darwin

// MARK: - 请求工具类
class MessageNetWork: NSObject {
    public typealias HTTPHeaders = [String: String]
    static let share = MessageNetWork()
    var baseUrl: String = "https://qa-api.longxins.com/api/v2"
    var type = ApiType.api
    var method: SYSHTTPMethod = .post
    var parameters:[String: Any] = [:]

    private var dataForUpData: Data = Data()
    private var urlString: String = ""
    private var contentType = "application/x-www-form-urlencoded; charset=utf-8"
    
    convenience init(wholePath: String, type: ApiType) {
        self.init()
        urlString = wholePath
        self.type = type
    }
    
    // 普通请求
    public func request(path: String) -> MessageNetWork {
        if path.contains("https://") {
           return MessageNetWork(wholePath: "\(path)", type: .api)
        }else {
           return MessageNetWork(wholePath: "\(baseUrl)/\(path)", type: .api)
        }
    }
    
    lazy var appVersion: String = {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return version
        }
        return ""
    }()

    var iToken: String? {
        return UserDefaults.standard.string(forKey: "italki_i_token") ?? ""

    }
    
    lazy var appName: String = {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return appName
        }
        return "unknown"
    }()
    
    lazy var appId: String = {
        return Bundle.main.bundleIdentifier ?? "unknown"
    }()
    
    lazy var osVersion: String = {
        return "\(UIDevice.current.systemName)\(UIDevice.current.systemVersion)"
    }()
    
    lazy var browserId: String = {
        if let id =  UserDefaults.standard.string(forKey: "X-Browser-Key") {
            return id
        } else {
            let id = UUID.init().uuidString
            UserDefaults.standard.set(id, forKey: "X-Browser-Key")
            return id
        }
    }()
    
    lazy var deviceVersion: String = {
        return UIDevice.current.model
    }()
    
    // 上传请求
    public func updataRequest(path: String, data: Data, contentType: String) -> MessageNetWork {
        var urlStr:String?
        if path.hasPrefix("https://") {
            urlStr = path
        }else {
            urlStr = "\(baseUrl)/\(path)"
        }
        let request = MessageNetWork(wholePath: urlStr!, type: .upData)
        request.dataForUpData = data
        request.contentType = contentType
        return request
    }
    
    // 请求的时候提示文字
    public func progressTitle(_ string: String) -> MessageNetWork{
        DispatchQueue.main.async {
//            SVProgressHUD.setDefaultStyle(.dark)
            //            SVProgressHUD.setDefaultMaskType(.clear)
            //            SVProgressHUD.setBackgroundColor(.black)
            //            SVProgressHUD.setForegroundColor(.white)
//            SVProgressHUD.setDefaultAnimationType(.flat)
//            SVProgressHUD.show(withStatus: string)
        }
        return self
    }
    
    //请求成功时需要调用的代码封装为一个嵌套的方法，以便复用
    //同理请求失败需要执行的代码
    // MARK: - 外部控制器的方法
    /**
     通用请求方法
     - parameter succeed: 请求成功回调
     - parameter failure: 请求失败回调
     - parameter error: 错误信息
     */
    public func perform(successed:@escaping ((_ result: Any?, _ error: Error?) -> Swift.Void), failure:@escaping ((_ error: Error?)  -> Swift.Void)) {
        //HTTP头部需要传入的信息，如果没有可以省略 headers:
        // 1.生成session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let trueURL = URL(string: urlString)
        let headers: HTTPHeaders = [
            "X-Device": "23",
            "X-Token": iToken ?? "",
            "X-InstallSource": "appstore",
            "User-Agent": "italki/\(appVersion);\(appId);\(osVersion);Apple;\(deviceVersion);iOS",
            "X-Browser-Key": browserId]
        var request =  URLRequest(url: trueURL!, method: method, headers: headers)
        // 2.这里我没有设置参数，使用了默认的编码方式
        var encodedURLRequest: URLRequest
        do {
            encodedURLRequest = try MYURLEncoding().encode(request, with: parameters)
        } catch {
            failure(error)
            return
        }
        
        if self.type == .upData { // 上传

            request.addValue("text/html", forHTTPHeaderField: "Accept")
            request.addValue(" gzip;q=1.0, compress;q=0.5", forHTTPHeaderField: "Accept-Encoding")
            request.addValue(" zh-Hans-Ch;q=1.0", forHTTPHeaderField: "Accept-Language")
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//            request.addValue("\(self.contentType)\r\n", forHTTPHeaderField: "Content-Type")


            var mData = Data()
            for (key,value) in parameters {
                let data = self.getPart(key: key, value: value as AnyObject, isString: true)
                mData.append(data)
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            formatter.locale = NSLocale(localeIdentifier: "en") as Locale
            let str = formatter.string(from: Date())
            let fileName = "\(str).jpeg"
            let dataStr = "--\(boundary)\r\nContent-Disposition: form-data; name=file;filename=\"\(fileName)\"\r\nContent-Type: \(self.contentType)\r\n\r\n"
            mData.append(dataStr.data(using: .utf8)!)
            mData.append(self.dataForUpData)
            let endStr = "\r\n--\(boundary)--\r\n"
            mData.append(endStr.data(using: .utf8)!)
//            request.httpBody = mData

            let task = session.uploadTask(with: request, from: mData) { (data, response, error) in
                DispatchQueue.main.async {
//                    SVProgressHUD.dismiss(withDelay: 0.5)
                    guard error == nil else {
                        failure(error)
                        return
                    }
                    guard let validData = data, validData.count > 0 else {
                        failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
                        return
                    }
                    
                    if let response = response as? HTTPURLResponse, [200, 204, 205].contains(response.statusCode) {
                        do {
                            let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                            successed(dict, nil)
                        } catch {
                            failure(AFError.ResponseSerializationFailureReason.jsonSerializationFailed(error: error) as? Error)
                        }
                    } else { // 其他, 204, 205
                        failure(AFError.ResponseSerializationFailureReason.stringSerializationFailed(encoding: String.Encoding.utf8) as? Error)
                    }
                }
            }
            task.resume()
            return
        }
        
        // 普通请求
        //构造请求体
        var s = ""
        for (key, value) in parameters {
            s = "\(s)&\(key)=\(value)"
        }
        
        request.addValue(self.contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = s.data(using: .utf8)
        // 3.生成一个dataTask
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            // 4.下面是回调部分，需要手动切换线程
            DispatchQueue.main.async {
//                SVProgressHUD.dismiss()
                // 5.下面的几种情况参照了responseJSON方法的实现
                guard error == nil else {
                    failure(error)
                    return
                }
                guard let validData = data, validData.count > 0 else {
                    failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
                    return
                }
                
                if let response = response as? HTTPURLResponse, [200, 204, 205].contains(response.statusCode) {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                        successed(dict, nil)
                    } catch {
                        failure(AFError.ResponseSerializationFailureReason.jsonSerializationFailed(error: error) as? Error)
                    }
                } else { // 其他,
                    failure(AFError.ResponseSerializationFailureReason.stringSerializationFailed(encoding: String.Encoding.utf8) as? Error)
                }
            }
        }
        // 5.开始请求
        dataTask.resume()
    }
    
    
    // MARK: - 上传相关
    // 构造请求体
    let boundary = "hahahazijixiedewangluokuangjia"
    
    func getPart(key: String, value: Any, isString: Bool) -> Data {
        var muData = Data()
        var data: Data = Data()
        let s = "\(value)"
        if value is String {
            data = s.data(using: .utf8)!
        } else if (value is Data) {
            data = value as! Data
        }else if (value is Int||value is Float || value is Double) {
            var value: Int = value as! Int

            data = NSData(bytes: &value, length: 4) as Data
        } else if (value is UIImage) {
            data = (value as! UIImage).jpegData(compressionQuality: 1.0) ?? Data()
        }

        let part = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(key)\"\r\n"
        muData.append(part.data(using: .utf8)!)
         muData.append("\r\n".data(using: .utf8)!)
        muData.append(data)
        muData.append("\r\n".data(using: .utf8)!)
        
        return muData
    }
}

// MARK: - 请求枚举
public enum SYSHTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public enum ApiType: String{
    case api    // 普通接口类型
    case upData
}

// MARK: - AFError
public enum AFError: Error {
    public enum ParameterEncodingFailureReason {
        case missingURL
        case jsonEncodingFailed(error: Error)
        case propertyListEncodingFailed(error: Error)
    }
    
    public enum MultipartEncodingFailureReason {
        case bodyPartURLInvalid(url: URL)
        case bodyPartFilenameInvalid(in: URL)
        case bodyPartFileNotReachable(at: URL)
        case bodyPartFileNotReachableWithError(atURL: URL, error: Error)
        case bodyPartFileIsDirectory(at: URL)
        case bodyPartFileSizeNotAvailable(at: URL)
        case bodyPartFileSizeQueryFailedWithError(forURL: URL, error: Error)
        case bodyPartInputStreamCreationFailed(for: URL)
        
        case outputStreamCreationFailed(for: URL)
        case outputStreamFileAlreadyExists(at: URL)
        case outputStreamURLInvalid(url: URL)
        case outputStreamWriteFailed(error: Error)
        
        case inputStreamReadFailed(error: Error)
    }
    
    public enum ResponseValidationFailureReason {
        case dataFileNil
        case dataFileReadFailed(at: URL)
        case missingContentType(acceptableContentTypes: [String])
        case unacceptableContentType(acceptableContentTypes: [String], responseContentType: String)
        case unacceptableStatusCode(code: Int)
    }
    
    public enum ResponseSerializationFailureReason {
        case inputDataNil
        case inputDataNilOrZeroLength
        case inputFileNil
        case inputFileReadFailed(at: URL)
        case stringSerializationFailed(encoding: String.Encoding)
        case jsonSerializationFailed(error: Error)
        case propertyListSerializationFailed(error: Error)
    }
    
    case invalidURL(url: URL)
    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
    case multipartEncodingFailed(reason: MultipartEncodingFailureReason)
    case responseValidationFailed(reason: ResponseValidationFailureReason)
    case responseSerializationFailed(reason: ResponseSerializationFailureReason)
}

// MARK: - MYURLEncoding
struct MYURLEncoding {
    public typealias Parameters = [String: Any]
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
    
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    
    func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    func encodesParametersInURL(with method: SYSHTTPMethod) -> Bool {
        switch method {
        case .get, .head, .delete:
            return true
        default:
            return false
        }
    }
    
    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest
        guard let parameters = parameters else { return urlRequest }
        
        if let method = SYSHTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), encodesParametersInURL(with: method) {
            guard let url = urlRequest.url else {
                throw AFError.parameterEncodingFailed(reason: .missingURL)
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
        } else {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
        }
        
        return urlRequest
    }
}

// MARK: - other
extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

extension URLRequest {
    public init(url: URL, method: SYSHTTPMethod, headers: [String: String]? = nil)  {
        self.init(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5)
        self.httpMethod = method.rawValue
        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
}
