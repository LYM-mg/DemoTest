//
//  MGUploadToos1.swift
//  message
//
//  Created by newunion on 2019/7/22.
//  Copyright © 2019 italki. All rights reserved.
//  泛型回调
/*
 eg:
 MGUploadToos<ImageContent>().upload(path:
        "https://dev-api.longxins.com/api/v2/me/sendfilemessage",
        parameters: parameters,
              data: data,
       contentType: "image/jpeg", progress: { (value) in
    print(value)
 }, successed: { (result, t) in
    print(result)
 }) { (error) in
    print(error)
 }
 */


import UIKit
import MobileCoreServices

class MGUploadToos1 <T:Decodable> :NSObject, URLSessionDelegate, URLSessionTaskDelegate,URLSessionDataDelegate {

    //单例模式
//    static var shared = MGUploadToos()
    //上传进度回调
    var onProgress: ((Float) -> ())?
    private let boundary = "lymzijixiedewangluokuangjia"
    private var baseURL: String  {
        if ("".isEmpty) { // 线上环境
            return "https://qa-api.longxins.com/api/v2"
        }else {           // 开发环境
            return "https://dev-api.longxins.com/api/v2/"
        }
    }

    //background session
    lazy var session:URLSession = {
        let config = URLSessionConfiguration.default
        let currentSession = URLSession(configuration: config, delegate: self,delegateQueue: nil)
        return currentSession
    }()

    public func upload(path:String,parameters:[String:Any]?,data:Data,contentType:String,progress: ((_ pregressValue: Float) -> Swift.Void)?,successed:@escaping ((_ result : T?, _ error: Error?) -> Swift.Void), failure:@escaping ((_ error: Error?)  -> Swift.Void)) {
        self.onProgress = progress
        var trueURL: URL?
        if path.hasPrefix("https://") {
            trueURL = URL(string: path)
        }else {
            trueURL = URL(string: "\(baseURL)/\(path)")
        }
        let headers: [String: String] = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "text/html",
            "X-Device": "23",
            "X-Token": iToken ?? "",
            "X-InstallSource": "appstore",
            "User-Agent": "italki/\(appVersion);\(appId);\(osVersion);Apple;\(deviceVersion);iOS",
            "X-Browser-Key": browserId
        ]
        var request =  URLRequest(url: trueURL!, method: SYSHTTPMethod.post, headers: headers)
        request.addValue("text/xml", forHTTPHeaderField: "Content-Typ")
        request.addValue("text/html", forHTTPHeaderField: "Accept")
        request.addValue(" gzip;q=1.0, compress;q=0.5", forHTTPHeaderField: "Accept-Encoding")
        request.addValue(" zh-Hans-Ch;q=1.0", forHTTPHeaderField: "Accept-Language")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var mData = Data()
        if let param = parameters {
            for (key,value) in param {
                let data = self.getPart(key: key, value: value as AnyObject, isString: true)
                mData.append(data)
            }
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        let str = formatter.string(from: Date())
        let fileName = "\(str).jpeg"
        let dataStr = "--\(boundary)\r\nContent-Disposition: form-data; name=file;filename=\"\(fileName)\"\r\nContent-Type: \(contentType)\r\n\r\n"
        mData.append(dataStr.data(using: .utf8)!)
        mData.append(data)
        let endStr = "\r\n--\(boundary)--\r\n"
        mData.append(endStr.data(using: .utf8)!)
        request.httpBody = mData

        let task = session.uploadTask(with: request, from: mData) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    failure(error)
                    return
                }
                guard let validData = data, validData.count > 0 else {
                    failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
                    return
                }

                if let response = response as? HTTPURLResponse, [200,204, 205].contains(response.statusCode) {
                    do {

                        guard let dict:[String:Any] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] else {
                            failure(AFError.ResponseSerializationFailureReason.inputDataNil as? Error)
                            return
                        }

                        guard  let dataObject = dict["data"] else {
                        failure(AFError.ResponseSerializationFailureReason .inputDataNil as? Error)
                            return
                        }
                        let dataDict = try JSONSerialization.data(withJSONObject: dataObject, options: JSONSerialization.WritingOptions.prettyPrinted)

                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        if #available(iOS 10.0, *) {
                            decoder.dateDecodingStrategy = .iso8601
                        } else {
                            // Fallback on earlier versions
                        }
                        
                        let object = try decoder.decode(T.self, from: dataDict)
                        successed(object, nil)
                    }catch {
                        failure(AFError.ResponseSerializationFailureReason.jsonSerializationFailed(error: error) as? Error)
                    }
                }else { // 其他, 204, 205
                    failure(AFError.ResponseSerializationFailureReason.stringSerializationFailed(encoding: String.Encoding.utf8) as? Error)
                }
            }
        }
        task.resume()
    }

    // 构造请求参数Data
    func getPart(key: String,value: AnyObject,isString: Bool) -> Data {
        var muData = Data()
        var data:Data = Data()
        let s = "\(value)"
        if value is String {
            data = s.data(using: .utf8)!
        } else if (value is Data) {
            data = value as! Data
        }
//        }else if (value is Int||value is Float || value is Double) {
//            var value: Int = value as! Int
//
//            data = NSData(bytes: &value, length: 32) as Data
//        }else if (value is UIImage) {
//            data = (value as! UIImage).jpegData(compressionQuality: 1.0) ?? Data()
//        }

        let part = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(key)\"\r\n"
        muData.append(part.data(using: .utf8)!)
        muData.append("\r\n".data(using: .utf8)!)
        muData.append(data)
        muData.append("\r\n".data(using: .utf8)!)

        return muData
    }

    var iToken: String? {
        return  UserDefaults.standard.string(forKey: "italki_i_token") ?? ""

    }
    lazy var appVersion: String = {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return version
        }
        return ""
    }()

    var appName: String = {
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

    //上传代理方法，监听上传进度
    func urlSession(_ session: URLSession, task: URLSessionTask,
                    didSendBodyData bytesSent: Int64, totalBytesSent: Int64,
                    totalBytesExpectedToSend: Int64) {
        //获取进度
        let written = (Float)(totalBytesSent)
        let total = (Float)(totalBytesExpectedToSend)
        let pro = written/total
        if let onProgress = onProgress {
            onProgress(pro)
        }
    }


    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {

    }

    //上传代理方法，传输完毕后服务端返回结果
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let str = String(data: data, encoding: String.Encoding.utf8)
        print("服务端返回结果：\(str!)")
    }

    //上传代理方法，上传结束

    func urlSession(_ session: URLSession, task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        print("上传结束!")
    }

    //session完成事件
    //    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    //        //主线程调用
    //        DispatchQueue.main.async {
    //            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
    //                let completionHandler = appDelegate.backgroundSessionCompletionHandler {
    //                appDelegate.backgroundSessionCompletionHandler = nil
    //                //调用此方法告诉操作系统，现在可以安全的重新suspend你的app
    //                completionHandler()
    //            }
    //        }
    //    }
}

/// 多文件
extension MGUploadToos1 {
    //创建请求
    static func createRequest(url: URL,
                              parameters: [String: String]?,
                              files: [(name:String, path:String)]) -> URLRequest{
        //分隔线
        let boundary = "Boundary-\(UUID().uuidString)"

        //上传地址
        var request = URLRequest(url: url)
        //请求类型为POST
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")

        //创建表单body
        request.httpBody = try! createBody(with: parameters, files: files, boundary: boundary)
        return request
    }

    //创建表单body
    static func createBody(with parameters: [String: String]?,
                           files: [(name:String, path:String)],
                           boundary: String) throws -> Data {
        var body = Data()

        //添加普通参数数据
        if parameters != nil {
            for (key, value) in parameters! {
                // 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }

        //添加文件数据
        for file in files {
            let url = URL(fileURLWithPath: file.path)
            let filename = url.lastPathComponent
            let data = try Data(contentsOf: url)
            let mimetype = mimeType(pathExtension: url.pathExtension)

            // 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=file; filename=\(filename)\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n") //文件类型
            body.append(data) //文件主体
            body.append("\r\n") //使用\r\n来表示这个这个值的结束符
        }

        // --分隔线-- 为整个表单的结束符
        body.append("--\(boundary)--\r\n")
        return body
    }

    //根据后缀获取对应的Mime-Type
    static func mimeType(pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                           pathExtension as NSString,
                                                           nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                .takeRetainedValue() {
                return mimetype as String
            }
        }
        //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
        return "application/octet-stream"
    }
}

extension MGUploadToos1 {

}

////扩展Data
//extension Data {
//    //增加直接添加String数据的方法
//    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
//        if let data = string.data(using: encoding) {
//            append(data)
//        }
//    }
//}

//// MARK: - 请求枚举
//public enum SYSHTTPMethod: String {
//    case options = "OPTIONS"
//    case get     = "GET"
//    case head    = "HEAD"
//    case post    = "POST"
//    case put     = "PUT"
//    case patch   = "PATCH"
//    case delete  = "DELETE"
//    case trace   = "TRACE"
//    case connect = "CONNECT"
//}
//
//
//// MARK: - AFError
//public enum AFError: Error {
//    public enum ParameterEncodingFailureReason {
//        case missingURL
//        case jsonEncodingFailed(error: Error)
//        case propertyListEncodingFailed(error: Error)
//    }
//
//    public enum MultipartEncodingFailureReason {
//        case bodyPartURLInvalid(url: URL)
//        case bodyPartFilenameInvalid(in: URL)
//        case bodyPartFileNotReachable(at: URL)
//        case bodyPartFileNotReachableWithError(atURL: URL, error: Error)
//        case bodyPartFileIsDirectory(at: URL)
//        case bodyPartFileSizeNotAvailable(at: URL)
//        case bodyPartFileSizeQueryFailedWithError(forURL: URL, error: Error)
//        case bodyPartInputStreamCreationFailed(for: URL)
//
//        case outputStreamCreationFailed(for: URL)
//        case outputStreamFileAlreadyExists(at: URL)
//        case outputStreamURLInvalid(url: URL)
//        case outputStreamWriteFailed(error: Error)
//
//        case inputStreamReadFailed(error: Error)
//    }
//
//    public enum ResponseValidationFailureReason {
//        case dataFileNil
//        case dataFileReadFailed(at: URL)
//        case missingContentType(acceptableContentTypes: [String])
//        case unacceptableContentType(acceptableContentTypes: [String], responseContentType: String)
//        case unacceptableStatusCode(code: Int)
//    }
//
//    public enum ResponseSerializationFailureReason {
//        case inputDataNil
//        case inputDataNilOrZeroLength
//        case inputFileNil
//        case inputFileReadFailed(at: URL)
//        case stringSerializationFailed(encoding: String.Encoding)
//        case jsonSerializationFailed(error: Error)
//        case propertyListSerializationFailed(error: Error)
//    }
//
//    case invalidURL(url: URL)
//    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
//    case multipartEncodingFailed(reason: MultipartEncodingFailureReason)
//    case responseValidationFailed(reason: ResponseValidationFailureReason)
//    case responseSerializationFailed(reason: ResponseSerializationFailureReason)
//}
//
//// MARK: - MYURLEncoding
//struct MYURLEncoding {
//    public typealias Parameters = [String: Any]
//    public func escape(_ string: String) -> String {
//        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
//        let subDelimitersToEncode = "!$&'()*+,;="
//
//        var allowedCharacterSet = CharacterSet.urlQueryAllowed
//        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
//
//        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
//    }
//
//    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
//        var components: [(String, String)] = []
//
//        if let dictionary = value as? [String: Any] {
//            for (nestedKey, value) in dictionary {
//                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
//            }
//        } else if let array = value as? [Any] {
//            for value in array {
//                components += queryComponents(fromKey: "\(key)[]", value: value)
//            }
//        } else if let value = value as? NSNumber {
//            if value.isBool {
//                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
//            } else {
//                components.append((escape(key), escape("\(value)")))
//            }
//        } else if let bool = value as? Bool {
//            components.append((escape(key), escape((bool ? "1" : "0"))))
//        } else {
//            components.append((escape(key), escape("\(value)")))
//        }
//
//        return components
//    }
//
//
//    func query(_ parameters: [String: Any]) -> String {
//        var components: [(String, String)] = []
//
//        for key in parameters.keys.sorted(by: <) {
//            let value = parameters[key]!
//            components += queryComponents(fromKey: key, value: value)
//        }
//
//        return components.map { "\($0)=\($1)" }.joined(separator: "&")
//    }
//
//    func encodesParametersInURL(with method: SYSHTTPMethod) -> Bool {
//        switch method {
//        case .get, .head, .delete:
//            return true
//        default:
//            return false
//        }
//    }
//
//    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
//        var urlRequest = urlRequest
//        guard let parameters = parameters else { return urlRequest }
//
//        if let method = SYSHTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), encodesParametersInURL(with: method) {
//            guard let url = urlRequest.url else {
//                throw AFError.parameterEncodingFailed(reason: .missingURL)
//            }
//
//            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
//                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
//                urlComponents.percentEncodedQuery = percentEncodedQuery
//                urlRequest.url = urlComponents.url
//            }
//        } else {
//            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
//                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
//            }
//
//            urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
//        }
//
//        return urlRequest
//    }
//}
//
//// MARK: - other
//extension NSNumber {
//    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
//}
//
//extension URLRequest {
//    public init(url: URL, method: SYSHTTPMethod, headers: [String: String]? = nil)  {
//        self.init(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5)
//        self.httpMethod = method.rawValue
//        if let headers = headers {
//            for (headerField, headerValue) in headers {
//                setValue(headerValue, forHTTPHeaderField: headerField)
//            }
//        }
//    }
//}

