//
//  MessageNetwork.swift
//  message
//
//  Created by jiali on 2019/7/22.
//  Copyright © 2019 italki. All rights reserved.
//

import UIKit

enum VersionPrefix: String {
    case v2
    case v3
}

// MARK: - 请求工具类
class MessageNetWork <T: Decodable>: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    var type = ApiType.api
    var method: SYSHTTPMethod = .post
    var parameters: [String: Any] = [:]
    var versionPerfix = VersionPrefix.v2
    
    //上传进度回调
    var onProgress: ((Float) -> Void)?
    var downLoadProgress: ((Float) -> Void)?
    var completionHandlerBlock: ((URL?, Error?) -> Void)?
    var completionSuccessBlock: ((_ result: T?, _ response: [String: Any]?, _ error: Error?) -> Swift.Void)?
    var completionFailureBlock: ((_ error: Error?)  -> Swift.Void)?
    
    var tempPath: String?
    
    fileprivate var requestCacheArr = [String: URLSessionDataTask]()
    private var dataForUpData: Data = Data()
    private var urlString: String = ""
    private var contentType = "application/x-www-form-urlencoded; charset=utf-8"
    weak var dataTask: URLSessionDataTask?
    weak var session: URLSession?
    var downLoadedPath: String? = ""
    var downLoadingPath: String? = ""
    weak var downLoadTask: URLSessionDownloadTask?
    var outputStream: OutputStream?
    var tmpSize: Int64 = 0
    var totalSize: Int64 = 0
    
    convenience init(wholePath: String, method: SYSHTTPMethod, parameters: [String: Any], versionPerfix: VersionPrefix, type: ApiType) {
        self.init()
        self.method = method
        self.parameters = parameters
        self.type = type
        self.versionPerfix = versionPerfix
        urlString = getComponentsPath(path: wholePath)
    }
    
    var baseUrl: String {
        return ITChatRommModel.shared.host
    }
    
    lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private var defaultHeaders: [String: String] {
        return [
        "X-Device": "23",
        "X-Token": iToken,
        "X-InstallSource": "appstore",
        "User-Agent": "italki/\(appVersion);\(appId);\(osVersion);Apple;\(deviceVersion);iOS",
        "X-Browser-Key": browserId]
    }
    
    private func getComponentsPath(path: String) -> String {
        var urlStr = ""
        if path.hasPrefix("https://") {
            urlStr = "\(versionPerfix.rawValue)" + path
        } else {
            urlStr = "\(baseUrl)/\(versionPerfix.rawValue)/\(path)"
        }
        return urlStr
    }
    
    // 普通请求
    func request(
    path: String,
    method: SYSHTTPMethod,
    versionPerfix: VersionPrefix = .v2,
    parameters: [String: Any],
    encoding: MYURLEncoding? = nil) -> MessageNetWork {
        
        return MessageNetWork(wholePath: path, method: method, parameters: parameters, versionPerfix: versionPerfix, type: .api)
    }
    
    lazy var appVersion: String = {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return version
        }
        return ""
    }()
    
    var iToken: String {
        return ITChatRommModel.shared.token ?? ""
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
    func uploadRequest(
        path: String,
        data: Data,
        contentType: String,
        method: SYSHTTPMethod,
        versionPerfix: VersionPrefix = .v2,
        parameters: [String: Any]) -> MessageNetWork {
        let urlStr = getComponentsPath(path: path)
        let request = MessageNetWork(wholePath: urlStr, method: method, parameters: parameters, versionPerfix: versionPerfix, type: .upData)
        request.dataForUpData = data
        request.contentType = contentType
        return request
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
    func perform(progress: ((_ pregressValue: Float) -> Swift.Void)?, _ successBlock: ((_ result: T?, _ response: [String: Any]?, _ error: Error?) -> Swift.Void)?, _ failureBlock: ((_ error: Error?)  -> Swift.Void)?) {
        //HTTP头部需要传入的信息，如果没有可以省略 headers:
        // 1.生成session
        onProgress = progress
        completionSuccessBlock = successBlock
        completionFailureBlock = failureBlock
        guard let trueURL = URL(string: urlString) else {return}
        var request =  URLRequest(url: trueURL, method: method, headers: defaultHeaders)
        if type == .upData { // 上传
            request = getUpdataRequest(url: trueURL)
            let mData = getUpdataDate()
            let task = uploadTask(request: request, mData: mData)
            requestCacheArr[urlString] = task
            task.resume()
            self.dataTask = task
            return
        }
        
        // 普通请求
        //构造请求体
        if method == .post {
            var s = ""
            for (key, value) in parameters {
                s = "\(s)&\(key)=\(value)"
            }
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = s.data(using: .utf8)
        } else if method == .get {
            var compinents = URLComponents(string: urlString)
            var items = [URLQueryItem]()
            for (key, value) in parameters {
                items.append(URLQueryItem(name: key, value: "\(value)"))
            }
            items = items.filter {!$0.name.isEmpty}
            if !items.isEmpty {
                compinents?.queryItems = items
            }
            guard let getUrl = compinents?.url else { return }
            request =  URLRequest(url: getUrl, method: method, headers: defaultHeaders)
        }
        // 3.生成一个dataTask
        let dataTask = dateTack(request: request)
        // 5.开始请求
        requestCacheArr[urlString] = dataTask
        dataTask.resume()
        self.dataTask = dataTask
    }
    
    // MARK: - 上传相关
    // 构造请求体
    let boundary = "italkiitalkiitalki"
    
    private func getPart(key: String, value: Any, isString: Bool) -> Data {
        var muData = Data()
        var data: Data = Data()
        let s = "\(value)"
        if value is String {
            data = s.data(using: .utf8)!
        } else if value is Data {
            data = value as! Data
        } else if value is Int || value is Float || value is Double {
            var value: Int = value as? Int ?? 0
            data = NSData(bytes: &value, length: 4) as Data
        } else if value is UIImage {
            data = (value as! UIImage).jpegData(compressionQuality: 1.0) ?? Data()
        }
        
        let part = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(key)\"\r\n"
        muData.append(part.data(using: .utf8)!)
        muData.append("\r\n".data(using: .utf8)!)
        muData.append(data)
        muData.append("\r\n".data(using: .utf8)!)
        
        return muData
    }
    
    //上传代理方法，监听上传进度
    func urlSession(_ session: URLSession, task: URLSessionTask,
                    didSendBodyData bytesSent: Int64,
                    totalBytesSent: Int64,
                    totalBytesExpectedToSend: Int64) {
        //获取进度
        let written = (Float)(totalBytesSent)
        let total = (Float)(totalBytesExpectedToSend)
        let pro = written/total
        if let onProgress = onProgress {
            onProgress(pro)
        }
    }
    
    //上传代理方法，传输完毕后服务端返回结果
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        let str = String(data: data, encoding: String.Encoding.utf8)
//        debugprint("服务端返回结果：\(str)")
        var buffer = [UInt8](repeating: 0, count: data.count)
        data.copyBytes(to: &buffer, count: data.count)
        self.outputStream?.write(buffer, maxLength: data.count)
    }
    
    //上传代理方法，上传结束
    func urlSession(_ session: URLSession, task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        if error == nil {
            // 不一定是成功
            // 数据是肯定可以请求完毕
            // 判断, 本地缓存 == 文件总大小 {filename: filesize: md5:xxx}
            // 如果等于 => 验证, 是否文件完整(file md5 )
        } else {
            if let completionHandler = completionHandlerBlock {
                completionHandler(nil, error)
            }
        }
//        self.outputStream?.close()
    }
    
    private func responseDecodableObject(session: URLSession, data: Data?, response: URLResponse?, error: Error?) {
        for tempTask in self.requestCacheArr.values {
            if tempTask == self.requestCacheArr[self.urlString] {
                self.requestCacheArr.removeValue(forKey: self.urlString)
            }
        }
        session.finishTasksAndInvalidate()
        // 4.下面是回调部分，需要手动切换线程
        DispatchQueue.main.async {
            // 5.下面的几种情况参照了responseJSON方法的实现
            guard error == nil else {
                if let completionFailureBlock = self.completionFailureBlock {
                    completionFailureBlock(error)
                }
                return
            }
            guard let validData = data, validData.count > 0 else {
                if let completionFailureBlock = self.completionFailureBlock {
                    completionFailureBlock(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
                }
                return
            }
            if let response = response as? HTTPURLResponse {
                if self.versionPerfix == .v3 {
                    self.responseV3DecodableObject(response: response, data: validData)
                } else {
                    self.responseV2DecodableObject(response: response, data: validData)
                }
            } else { // 其他,
                if let completionFailureBlock = self.completionFailureBlock {
                    completionFailureBlock(error)
                }
            }
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

        let resp = response as? HTTPURLResponse
        let string = resp?.allHeaderFields["Content-Length"] as? String
        let stri = string?.components(separatedBy: "/").last
        self.totalSize = Int64(stri ?? "") ?? 0

        // 比对本地大小, 和 总大小
        if self.tmpSize == self.totalSize {
            // 1. 移动到下载完成文件夹
//            DiskCacheManager.moveFile(self.downLoadingPath!, self.downLoadedPath!)
            // 2. 取消本次请求
            completionHandler(URLSession.ResponseDisposition.cancel)
            return
        }
        if self.tmpSize > self.totalSize {
            // 1. 删除临时缓存
//            DiskCacheManager.deleteFile(self.downLoadingPath!)
            // 2. 从0 开始下载
            // 3. 取消请求
            completionHandler(URLSession.ResponseDisposition.cancel)
            return

        }
        // 继续接受数据
        // 确定开始下载数据
        self.outputStream = OutputStream(toFileAtPath: self.downLoadingPath!, append: true)
        self.outputStream?.open()
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func cancelAllHttpRequest() {
        for task in requestCacheArr.values {
            task.cancel()
        }
        requestCacheArr.removeAll()
    }

    func downloadFile(tempPath: String, progress: ((_ pregressValue: Float) -> Swift.Void)?, completionHandler: ((URL?, Error?) -> Void)?) {
        // 1.生成session
        self.tempPath = tempPath
        downLoadProgress = progress
        completionHandlerBlock = completionHandler
//        self.tmpSize = DiskCacheManager.fileSize(downLoadingPath ?? "")
        guard let trueURL = URL(string: urlString) else {return}
        var request = URLRequest(url: trueURL, method: method, headers: defaultHeaders)
        // 普通请求
        //构造请求体
        var compinents = URLComponents(string: urlString)
        var items = [URLQueryItem]()
        for (key, value) in parameters {
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        items = items.filter {!$0.name.isEmpty}
        if !items.isEmpty {
            compinents?.queryItems?.append(contentsOf: items)
        }
        guard let getUrl = compinents?.url else { return }
        request =  URLRequest(url: getUrl, method: method, headers: defaultHeaders)
 
        // 3.生成一个downloadTask
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        self.session = session
        let dataTask = session.downloadTask(with: request)
        // 5.开始请求
        dataTask.resume()
        self.downLoadTask = dataTask
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        //获取进度
        let written = (Float)(totalBytesWritten)
        let total = (Float)(totalBytesExpectedToWrite)
        let pro = written/total
        if let downLoadProgress = downLoadProgress {
            downLoadProgress(pro)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let completionHandler = completionHandlerBlock {
            var tempError: Error?
            do {
                try FileManager.default.moveItem(atPath: location.path, toPath: tempPath ?? downloadTask.response?.suggestedFilename ?? "*.text")
            } catch {
                tempError = error
            }
            //完成任务,
            session.finishTasksAndInvalidate()
            //清空Session
            self.session = nil
            completionHandler(location, tempError)
        }
    }
}

extension MessageNetWork {
    //暂停
//    func pauseCurrentTask() {
//        self.dataTask.suspend()
//    }
//    // 继续任务
//    func resumeCurrentTask() {
//        self.dataTask.resume()
//    }
    // 取消
    func cancelCurrentTask() {
        self.session?.invalidateAndCancel()
        self.session = nil
    }
    
    func cancelDownLoadFile() {
        downLoadTask?.cancel(byProducingResumeData: { [weak self] (_) in
            self?.downLoadTask = nil
        })
    }
    
    private func getUpdataRequest(url: URL) -> URLRequest {
        var request =  URLRequest(url: url, method: method, headers: defaultHeaders)
        request.addValue("text/html", forHTTPHeaderField: "Accept")
        request.addValue(" gzip;q=1.0, compress;q=0.5", forHTTPHeaderField: "Accept-Encoding")
        request.addValue(" zh-Hans-Ch;q=1.0", forHTTPHeaderField: "Accept-Language")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func getUpdataDate() -> Data {
        var mData = Data()
        for (key, value) in parameters {
            let data = getPart(key: key, value: value as AnyObject, isString: true)
            mData.append(data)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        let str = formatter.string(from: Date())
        let fileName = "\(str)" + "." + "\(dataForUpData.getImageFormat())"
        let dataStr = "--\(boundary)\r\nContent-Disposition: form-data; name=file;filename=\"\(fileName)\"\r\nContent-Type: \(contentType)\r\n\r\n"
        mData.append(dataStr.data(using: .utf8)!)
        mData.append(dataForUpData)
        let endStr = "\r\n--\(boundary)--\r\n"
        mData.append(endStr.data(using: .utf8)!)
        return mData
    }
    
    private func uploadTask(request: URLRequest, mData: Data) -> URLSessionDataTask {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        self.session = session
        let uploadTask = session.uploadTask(with: request, from: mData) {[weak self] (data, response, error) in
            guard let `self` = self else { return }
            self.responseDecodableObject(session: session, data: data, response: response, error: error)
        }
        return uploadTask
    }
    
    private func dateTack(request: URLRequest) -> URLSessionDataTask {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        self.session = session
        let dataTask = session.dataTask(with: request) {[weak self] (data, response, error) in
            guard let `self` = self else { return }
            self.responseDecodableObject(session: session, data: data, response: response, error: error)
        }
        return dataTask
    }
    
    func responseV2DecodableObject(response: HTTPURLResponse, data: Data) {
        do {
        guard let dict: [String: Any] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
            if let completionFailureBlock = self.completionFailureBlock {
                completionFailureBlock(AFError.ResponseSerializationFailureReason.inputDataNil as? Error)
            }
            return
        }
        guard  let successed = dict["success"] as? Int else {
            if let completionFailureBlock = self.completionFailureBlock {
                completionFailureBlock(AFError.ResponseSerializationFailureReason.inputDataNil as? Error)
            }
            return
        }
        if successed == 1 {
            guard  let dataObject = dict["data"] else {
                if let completionFailureBlock = self.completionFailureBlock {
                    completionFailureBlock(AFError.ResponseSerializationFailureReason.inputDataNil as? Error)
                }
                return
            }
            let dataDict = try JSONSerialization.data(withJSONObject: dataObject, options: JSONSerialization.WritingOptions.prettyPrinted)
            let object = try jsonDecoder.decode(T.self, from: dataDict)
            if let completionSuccessBlock = self.completionSuccessBlock {
                completionSuccessBlock(object, dict, nil)
            }
        } else {
            reporterError(dict: dict)
        }
        } catch {
            if let completionFailureBlock = self.completionFailureBlock {
                completionFailureBlock(error)
            }
        }
    }
    
    func responseV3DecodableObject(response: HTTPURLResponse, data: Data) {
        do {
            if [200, 201, 204, 205, 304].contains(response.statusCode) {
                if let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any], dict["error"] != nil {
                    reporterError(dict: dict)
                    return
                }
                let object = try jsonDecoder.decode(T.self, from: data)
                if let completionSuccessBlock = self.completionSuccessBlock {
                    completionSuccessBlock(object, nil, nil)
                }
            } else {
                reporterError(dict: nil)
            }
        } catch {
            if let completionFailureBlock = self.completionFailureBlock {
                completionFailureBlock(error)
            }
        }
    }
    
    func reporterError(dict: [String: Any]?) {
        guard let errorObject = dict?["error"] as? [String: Any] else {
            if let completionFailureBlock = self.completionFailureBlock {
                completionFailureBlock(AFError.ResponseSerializationFailureReason.inputDataNil as? Error)
            }
            return
        }
        let textCode = errorObject["text_code"] as? String
        let textList = errorObject["text_list"] as? [String]
        let err: Error = BaseError((errorObject["msg"] as? String) ?? "")
        ITChatRommModel.shared.errorReporter?(getTranslation(textCode: textCode, textList: textList) ?? "error", nil)
        if let completionFailureBlock = self.completionFailureBlock {
            completionFailureBlock(err)
        }
    }
}

// MARK: - 请求枚举
enum SYSHTTPMethod: String {
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

enum ApiType: String {
    case api    // 普通接口类型
    case upData
}

// MARK: - AFError
struct BaseError: Error {
    var desc = ""
    var localizedDescription: String {
        return desc
    }
    init(_ desc: String) {
        self.desc = desc
    }
}

enum AFError: Error {
    enum ParameterEncodingFailureReason {
        case missingURL
        case jsonEncodingFailed(error: Error)
        case propertyListEncodingFailed(error: Error)
    }
    
    enum ResponseSerializationFailureReason {
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
    case responseSerializationFailed(reason: ResponseSerializationFailureReason)
}

// MARK: - MYURLEncoding
struct MYURLEncoding {
    typealias Parameters = [String: Any]
    func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
    
    func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
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
    init(url: URL, method: SYSHTTPMethod, headers: [String: String]? = nil) {
        self.init(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
        self.httpMethod = method.rawValue
        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
}
