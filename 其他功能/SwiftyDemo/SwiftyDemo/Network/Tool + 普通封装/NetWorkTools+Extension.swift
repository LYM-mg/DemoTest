//
//  NetWorkTools+Extension.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/15.
//  Copyright © 2019 firestonetmt. All rights reserved.
//  网络状态判断

import UIKit
import Alamofire

// MARK: -
// MARK: -  判断网络类型
//（与官方风格一致，推荐使用）
enum NetworkStatus {
    case noNetWork     // 没有网络
    case viaWWAN
    case viaWWAN2g     // 2G
    case viaWWAN3g     // 3G
    case viaWWAN4g     // 4G
    case wifi          // WIFI
    case other
}

extension NetWorkTools {
    /// 获取网络状态
    class func getNetworkStates() -> NetworkStatus? {
        guard let object1 = UIApplication.shared.value(forKey: "statusBar") as? NSObject else { return nil }
        guard let object2 = object1.value(forKey: "foregroundView") as? UIView else { return nil }
        let subviews = object2.subviews

        var status = NetworkStatus.noNetWork

        for child in subviews {
            if child.isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!) {
                // 获取到状态栏码
                guard let networkType = child.value(forKey: "dataNetworkType") as? Int else { return nil }
                switch (networkType) {
                case 0: // 无网模式
                    status =  NetworkStatus.noNetWork;
                case 1: // 2G模式
                    status =  NetworkStatus.viaWWAN2g;
                case 2: // 3G模式
                    status =  NetworkStatus.viaWWAN3g;
                case 3: // 4G模式
                    status =  NetworkStatus.viaWWAN4g;
                case 5: // WIFI模式
                    status =  NetworkStatus.wifi;
                default:
                    break
                }
            }
        }

        // 返回网络类型
        return status;
    }

    // MARK: - global function
    ///Alamofire监控网络，只能调用一次监听一次
    func AlamofiremonitorNet(result: @escaping (NetworkStatus) -> Void) {
        let manager = NetworkReachabilityManager(host: "www.apple.com")
        manager?.listener = { status in
            print("网络状态: \(status)")
            if status == .reachable(.ethernetOrWiFi) { //WIFI
                result(.wifi)
            } else if status == .reachable(.wwan) { // 蜂窝网络
                result(.viaWWAN)
            } else if status == .notReachable { // 无网络
                result(.noNetWork)
            } else { // 其他
                result(.other)
            }
        }
        manager?.startListening()//开始监听网络
    }

    //Alamofire监控网络，只能调用一次监听一次
    func NetWorkIsReachable() -> Bool {
        let manager = NetworkReachabilityManager(host: "www.apple.com")
        manager?.startListening()//开始监听网络
        return manager?.isReachable ?? false;
    }
}
