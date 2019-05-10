//
//  MGAPiConfig.swift
//  MGDS_Swift
//
//  Created by i-Techsys.com on 2017/7/27.
//  Copyright © 2017年 i-Techsys. All rights reserved.

import UIKit

/*  如何使用：
举个🌰 eg:
    API.File.upload(["by_module":"3","key":"FILES"], imageData: UIImageJPEGRepresentation(image, 0.9)! as NSData, imageName: "FILES").progressTitle("上传中")

举个🌰2 eg:
    let parameters: [String: Any] = ["method":"baidu.ting.billboard.billCategory","kflag":"1","from":"ios","version":"5.5.6","channel":"appstore","operator":"1","format":"json"]

    API.Home.Base.getHomeList(parameters: parameters).progressTitle("正在加载。。。").perform(successed: { (reslut, err) in
        let song = LYMSong.mj_object(withKeyValues: reslut)
    }) { (err) in
        print(err)
    }
 */

struct API{
    // 用于上传数据
    static var tronUpdata = NetWorkTools()
    
    // 用于请求普通接口
    static var tron = NetWorkTools()
}

// 结构体,这里可以把每一个模块的的接口再细分，分别创建一个文件对应写扩展
extension API {
    struct File {
//        //上传图片文件
//        static  func upload(_ parameters: [String:Any]?,imageData:NSData,imageName:String) -> NetWorkTools {
//            let request = tronUpdata.request(path: "common/File/upload", data: imageData as Data,contentType:"image/jpeg")
//            request.parameters = parameters ?? [:]
//            request.method = .post
//            request.type = .upData
//            return request
//        }
    }
    
    struct Common {
        struct Base {
            // 登录接口测试
            static  func login(parameters: [String:Any]?) -> NetWorkTools {
                let request: NetWorkTools = tron.request(path: "ReportService/UserEdit")
                request.parameters = parameters ?? [:]
                request.method = .get
                return request
            }
            // 获取列表
            static  func get_one(parameters: [String:Any]?) -> NetWorkTools {
                let request: NetWorkTools = tron.request(path: "ReportService/ProdProgressList")
                request.parameters = parameters ?? [:]
                request.method = .get
                return request
            }
        }
    }
}

// MARK: - 账户
extension API {
    struct User {
        struct Login {
            // 登录接口测试
            static  func login(parameters: [String:Any]? = nil) -> NetWorkTools {
                let request: NetWorkTools = tron.request(path: "ReportService/UserEdit")
                request.parameters = parameters ?? [:]
                request.method = .get
                return request
            }
            // 获取列表
            static  func get_one(parameters: [String:Any]?) -> NetWorkTools {
                let request: NetWorkTools = tron.request(path: "ReportService/ProdProgressList")
                request.parameters = parameters ?? [:]
                request.method = .get
                return request
            }
        }
        struct Reigist {
            // 登录接口测试
            static  func login(parameters: [String:Any]? = nil) -> NetWorkTools {
                let request: NetWorkTools = tron.request(path: "ReportService/UserEdit")
                request.parameters = parameters ?? [:]
                request.method = .get
                return request
            }
            // 获取列表
            static  func get_one(parameters: [String:Any]?) -> NetWorkTools {
                let request: NetWorkTools = tron.request(path: "ReportService/ProdProgressList")
                request.parameters = parameters ?? [:]
                request.method = .get
                return request
            }
        }
    }

    struct Home {
        struct Base {
            // 登录接口测试
            static  func login(parameters: [String:Any]?) -> NetWorkTools {
                let request: NetWorkTools = tron.request(path: "ReportService/UserEdit")
                request.parameters = parameters ?? [:]
                request.method = .get
                return request
            }
            // 获取列表
            static  func getHomeList(parameters: [String:Any]? = nil) -> NetWorkTools {
                let request: NetWorkTools = tron.request(path: "http://tingapi.ting.baidu.com/v1/restserver/ting")
                request.parameters = parameters ?? [:]
                request.method = .get
                return request
            }
        }
    }
}
