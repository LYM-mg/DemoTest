//
//  MGPhotoCacheManager.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/8.
//  Copyright © 2019 MG. All rights reserved.
//

import Foundation
import UIKit

/// 负责缓存选择图片对象的管理者
class MGPhotosCacheManager: NSObject {
    // MARK: public
    static let MGPhotosOriginSize: CGSize = CGSize(width: -100, height: -100)
    /// 单例对象
    static let sharedInstance = MGPhotosCacheManager()

    /// 最大允许选择的图片数目，默认为9张
    var maxNumeberOfSelectedPhoto = 9

    /// 记录当前选择的数目
    var numberOfSelectedPhoto = 0

    /// 图片的大小，默认为mgPhotoOriginSize，请求时会按照原图大小
    var imageSize = MGPhotosCacheManager.MGPhotosOriginSize

    /// 资源是否为原图，默认为false
    var isHightQuarity = false

    /// 资源是否被选中的标志位
    var assetIsPictureSignal = [Bool]()

    /// 资源是否被选中的标志位
    var assetIsSelectedSignal = [Bool]()

    /// 初始化资源是否为图片的标志位
    ///
    /// - Parameter count: 初始化的长度
    func mg_memset(assetIsPictureSignal count: Int) {
        assetIsPictureSignal.removeAll()
        assetIsPictureSignal = [Bool](repeating: false, count: count)
    }

    /// 初始化资源是否被选择的标志位
    ///
    /// - Parameter count: 初始化长度
    func mg_memset(assetIsSelectedSignal count: Int) {
        assetIsSelectedSignal.removeAll()
        assetIsSelectedSignal = [Bool](repeating: false, count: count)
    }
    
    /// 修改当前位置资源的选中状态
    ///
    /// - Parameter index: 资源所在的位置
    /// - Returns: 修改结果
    @discardableResult func mg_change(selecteStatusIn index: Int) -> Bool {
        if index > assetIsSelectedSignal.count {
            return false
        }

        //修改状态
        assetIsSelectedSignal[index] = !assetIsSelectedSignal[index]

        return true
    }

    func free() {

        numberOfSelectedPhoto = 0
        isHightQuarity = false
        assetIsSelectedSignal = [Bool]()
        assetIsPictureSignal = [Bool]()
    }

    func reset() {

        maxNumeberOfSelectedPhoto = 9
    }

    /// 还原所有的资源
    @available(iOS, deprecated: 8.0, message: "Use free() and reset() instead")
    func freeAllSignal () {
        numberOfSelectedPhoto = 0
        maxNumeberOfSelectedPhoto = 9
        isHightQuarity = false
        assetIsSelectedSignal = [Bool]()
        assetIsPictureSignal = [Bool]()
    }

    // MARK: private
}
