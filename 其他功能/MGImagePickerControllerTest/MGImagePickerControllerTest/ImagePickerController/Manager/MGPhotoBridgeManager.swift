//
//  MGPhotoBridgeManager.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/8.
//  Copyright © 2019 MG. All rights reserved.
//

import UIKit
import Photos

/// 进行桥接进行回调的Manager
class MGPhotosBridgeManager: NSObject {
    /// 单例对象
    static let sharedInstance = MGPhotosBridgeManager()

    /// 获取图片之后的闭包
    var completeUsingImage: (([UIImage], [PHAsset]) -> Void)?

    /// 获取图片数据之后的闭包
    var completeUsingData: (([Data], [PHAsset]) -> Void)?

    /// 开始获取图片以及数据
    ///
    /// - Parameter assets: 选中的资源对象
    func start(renderFor assets: [PHAsset]) {
        // 渲染图片的大小
        let size = MGPhotosCacheManager.sharedInstance.imageSize

        // 如果为原图，忽略size
        let isIgnore = size.width < 0

        // 是否高清图
        let isHightQuarity = MGPhotosCacheManager.sharedInstance.isHightQuarity

        MGPhotoHandleManager.startRequestImage(imagesIn: assets, isHight: isHightQuarity, size: size, ignoreSize: isIgnore) { (images) in
            self.completeUsingImage?(images, assets)
        }
        //请求数据
        MGPhotoHandleManager.startRequestData(imagesIn: assets, isHight: isHightQuarity) { (datas) in
            self.completeUsingData?(datas, assets)
        }
    }
}
