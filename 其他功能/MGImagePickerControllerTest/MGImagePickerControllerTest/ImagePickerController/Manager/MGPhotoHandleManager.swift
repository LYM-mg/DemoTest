//
//  MGPhotoHandleManager.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/8.
//  Copyright © 2019 MG. All rights reserved.
//

import UIKit
import Photos
import ObjectiveC

extension PHCachingImageManager {
    static let defalut = PHCachingImageManager()
}

/// 进行数据类型转换的Manager
class MGPhotoHandleManager: NSObject {
    /// 用以描述runtime关联属性
    struct MGPhotoAssociate {

        static let mg_assetCollectionAssociate = UnsafeRawPointer(bitPattern: "mg_assetCollection".hashValue)
        static let mg_cacheAssociate = UnsafeRawPointer(bitPattern: "mg_CacheAssociate".hashValue)
        static let mg_assetCacheSizeAssociate = UnsafeRawPointer(bitPattern: "mg_assetCacheSizeAssociate".hashValue)
    }

    /// PHFetchResult对象转成数组的方法
    ///
    /// - Parameters:
    ///   - result: 转型的fetchResult对象
    ///   - complete: 完成的闭包
    public static func resultToArray(_ result: PHFetchResult<AnyObject>, complete: @escaping ([AnyObject], PHFetchResult<AnyObject>) -> Void) {
        guard result.count != 0 else { complete([], result); return }
        var array = [AnyObject]()

        //开始遍历
        result.enumerateObjects({ (object, index, _) in
            // 过滤自定义空数组
            if object.isKind(of: PHAssetCollection.self) && object.estimatedAssetCount > 0  {
                let assetResult = PHAsset.fetchAssets(in: object as! PHAssetCollection, options: PHFetchOptions())

                debugPrint(object.localizedTitle ?? "没有名字")
                // 过滤空数组
                if assetResult.count != 0 {
                    array.append(object)
                }else {
                }
                if index == result.count - 1 {
                    complete(array, result)
                }
            }else {
                if index == result.count - 1 {
                    complete(array, result)
                }
            }
        })
    }

    /// PHFetchResult对象转成PHAsset数组的方法
    ///
    /// - Parameters:
    ///   - result: 转型的fetchResult对象 PHAsset
    ///   - complete: 完成的闭包
    public static func resultToPHAssetArray(_ result: PHFetchResult<AnyObject>, complete: @escaping ([AnyObject], PHFetchResult<AnyObject>) -> Void) {
        guard result.count != 0 else { complete([], result); return }
        var array = [AnyObject]()

        //开始遍历
        result.enumerateObjects({ (object, index, _) in
            if object.isKind(of: PHAsset.self) {
               array.append(object)
            }
            complete(array, result)
        })
    }

    /// 获得选择的图片数组
    ///
    /// - Parameters:
    ///   - allAssets: 所有的资源数组
    ///   - status: 选中状态
    /// - Returns:
    public static func assets(_ allAssets: [PHAsset], status: [Bool]) -> [PHAsset] {
        var assethandle = [PHAsset]()

        for i in 0 ..< allAssets.count {

            let status = status[i]

            if status {

                assethandle.append(allAssets[i])
            }
        }
        return assethandle
    }

    /// 获取PHAssetCollection的详细信息
    ///
    /// - Parameters:
    ///   - size: 获得封面图片的大小
    ///   - completion: 取组的标题、照片资源的预估个数以及封面照片,默认为最新的一张
    public static func assetCollection(detailInformationFor collection: PHAssetCollection, size: CGSize, completion: @escaping ((String?, UInt, UIImage?) -> Void)) {
        let assetResult = PHAsset.fetchAssets(in: collection, options: PHFetchOptions())

        if assetResult.count == 0 {
            completion(collection.localizedTitle, 0, UIImage())
            return
        }

        let image: UIImage? = ((objc_getAssociatedObject(collection, MGPhotoHandleManager.MGPhotoAssociate.mg_assetCollectionAssociate!)) as? UIImage)

        if  image != nil {
            completion(collection.localizedTitle, UInt(assetResult.count), image)
            return
        }

        //开始重新获取图片
        let scale = UIScreen.main.scale
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        PHCachingImageManager.default().requestImage(for: assetResult.lastObject!, targetSize: newSize, contentMode: PHImageContentMode.aspectFill, options: nil, resultHandler: { (realImage, _) in
            completion(collection.localizedTitle, UInt(assetResult.count), realImage)
        })
    }

    /// 获取PHAsset的照片资源
    /// - Parameters:
    ///   - asset: 获取资源的对象
    ///   - size: 截取图片的大小
    ///   - completion: 获取的图片，以及当前的资源对象
    public static func asset(representionIn asset: PHAsset, size: CGSize, completion: @escaping ((UIImage, PHAsset) -> Void)) {
        if let cacheAssociate = MGPhotoHandleManager.MGPhotoAssociate.mg_cacheAssociate, objc_getAssociatedObject(asset, cacheAssociate) == nil {
            objc_setAssociatedObject(asset, MGPhotoHandleManager.MGPhotoAssociate.mg_cacheAssociate!, [CGSize](), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        var caches: [CGSize] = objc_getAssociatedObject(asset, MGPhotoHandleManager.MGPhotoAssociate.mg_cacheAssociate!) as! [CGSize]
        let scale = UIScreen.main.scale
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        //开始请求
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        // 同步获得图片, 只会返回1张图片
        option.isSynchronous = true
        option.isNetworkAccessAllowed = true//默认关闭
        let fileName: String? = asset.value(forKeyPath: "filename") as? String
        if let fileName = fileName, fileName.hasSuffix("GIF") {
            option.version = .original
        }

        PHCachingImageManager.default().requestImage(for: asset, targetSize: newSize, contentMode: PHImageContentMode.aspectFill, options: option) { (image, info) in
            if !((info![PHImageResultIsDegradedKey] as? NSNumber)?.boolValue ?? false) {
                //这样只会走一次获取到高清图时
                DispatchQueue.main.async(execute: {
                    completion(image ?? UIImage(), asset)
                })
            }
        }

        //进行缓存
        if !caches.contains(newSize) {

            (PHCachingImageManager.default() as! PHCachingImageManager).startCachingImages(for: [asset], targetSize: newSize, contentMode: PHImageContentMode.aspectFill, options: PHImageRequestOptions())

            caches.append(newSize)

            //重新赋值
            objc_setAssociatedObject(asset, MGPhotoHandleManager.MGPhotoAssociate.mg_cacheAssociate!, caches, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }

    }

    /// 获取PHAsset的高清图片资源
    ///
    /// - Parameters:
    ///   - asset: 获取资源的对象
    ///   - size: 获取图片的大小
    ///   - completion: 完成
    public static func asset(hightQuarityFor asset: PHAsset, Size size: CGSize, completion: @escaping ((String) -> Void)) {
        let newSize = size

        if let assetCache = MGPhotoAssociate.mg_assetCacheSizeAssociate, objc_getAssociatedObject(asset, assetCache) == nil {
            let associateData = [String: Any]()//Dictionary<String, Any>
            objc_setAssociatedObject(asset, assetCache, associateData, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }

        /// 获得当前所有的存储
        var assicciateData = objc_getAssociatedObject(asset, MGPhotoAssociate.mg_assetCacheSizeAssociate!) as! [String: Any]

        guard assicciateData.index(forKey: NSCoder.string(for: newSize)) == nil else {

            let index = assicciateData.index(forKey: NSCoder.string(for: newSize))//获得索引
            let size = assicciateData[index!].value as! String//获得数据

            completion(size); return
        }

        let options = PHImageRequestOptions()
//        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        let fileName: String? = asset.value(forKeyPath: "filename") as? String
        if let fileName = fileName, fileName.hasSuffix("GIF") {
            options.version = .original
        }
        //请求数据
        PHCachingImageManager.default().requestImageData(for: asset, options: options) { (data, _, _, _) in

            guard let data = data else {
                //回调
                completion("0B")
                return
            }
            //进行数据转换
            //            let size = mg_dataSize((data?.count)!)
            let size = (data.count).mg_dataSize

            //新增值
            assicciateData.updateValue(size, forKey: NSCoder.string(for: newSize))

            //缓存
            objc_setAssociatedObject(asset, MGPhotoAssociate.mg_assetCacheSizeAssociate!, assicciateData, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)

            //回调
            completion(size)
        }
    }

    /// 获取PHFetchResult符合媒体类型的PHAsset对象
    ///
    /// - Parameters:
    ///   - result: 获取数据的对象
    ///   - type: 媒体类型
    ///   - enumerateObject: 每次获得符合媒体类型的对象调用一次
    ///   - matchedObject: 每次都会调用一次
    ///   - completion: 完成之后返回存放符合媒体类型的PHAsset数组
    public static func fetchResult(in result: PHFetchResult<PHAsset>, type: PHAssetMediaType, enumerateObject: ((PHAsset) -> Void)?, matchedObject: ((PHAsset) -> Void)?, completion: (([PHAsset]) -> Void)?) {
        var assets = [PHAsset]()

        // 如果当前没有数据
        guard result.count >= 0 else {

            completion?(assets);return
        }
        //开始遍历
        result.enumerateObjects({ (obj, idx, _) in

            // 每次回调
            enumerateObject?(obj)

            // 如果是类型相符合
            if obj.mediaType == type {

                matchedObject?(obj)
                assets.append(obj)
            }

            if idx == result.count - 1 { // 说明完成

                completion?(assets)
            }
        })
    }
    
    /// 获取PHFetchResult符合媒体类型的PHAsset对象
    ///
    /// - Parameters:
    ///   - result: 获取资源的对象
    ///   - type: 媒体类型
    ///   - completion: 完成之后返回存放符合媒体类型的PHAsset数组
    public static func fetchResult(in result: PHFetchResult<PHAsset>, type: PHAssetMediaType, completion: (([PHAsset]) -> Void)?) {
        fetchResult(in: result, type: type, enumerateObject: nil, matchedObject: nil, completion: completion)
    }
    
    /// 获得选择的资源数组
    ///
    /// - Parameters:
    ///   - assets: 存放资源的数组
    ///   - status: 对应资源的选中状态数组
    /// - Returns: 筛选完毕的数组
    public static func filter(assetsIn assets: [PHAsset], status: [Bool]) -> [PHAsset] {
        var assetHandle = [PHAsset]()
        for asset in assets {
            //如果状态为选中
            if status[assets.firstIndex(of: asset)!] {

                assetHandle.append(asset)
            }
        }
        return assetHandle
    }
}

extension MGPhotoHandleManager {
    /// 获取资源中的图片对象
    ///
    /// - Parameters:
    ///   - assets: 需要请求的asset数组
    ///   - isHight: 图片是否需要高清图
    ///   - size:  当前图片的截取size
    ///   - ignoreSize: 是否无视size属性，按照图片原本大小获取
    ///   - completion: 返回存放images的数组
    static func startRequestImage(imagesIn assets: [PHAsset], isHight: Bool, size: CGSize, ignoreSize: Bool, completion: @escaping (([UIImage]) -> Void)) {
        var images = [UIImage]()
        var newSize = size

        for i in 0 ..< assets.count {
            //获取资源
            let asset = assets[i]
            //重置大小
            if ignoreSize {
                newSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            }
            //图片类型
            let mode = isHight ? PHImageRequestOptionsDeliveryMode.highQualityFormat : PHImageRequestOptionsDeliveryMode.fastFormat
            //初始化option
            let option = PHImageRequestOptions()
            option.deliveryMode = mode
            option.isSynchronous = true
            option.isNetworkAccessAllowed = true
            let fileName: String? = asset.value(forKeyPath: "filename") as? String
            if let fileName = fileName, fileName.hasSuffix("GIF") {
                option.version = .original
            }

            //开始请求
            PHImageManager.default().requestImage(for: asset, targetSize: newSize, contentMode: PHImageContentMode.aspectFill, options: option, resultHandler: { (image, _) in

                //添加
                images.append(image!)

                if images.count == assets.count {

                    completion(images)
                }
            })
        }
    }

    /// 获取资源中图片的数据对象
    ///
    /// - Parameters:
    ///   - assets: 需要请求的asset数组
    ///   - isHight: 图片是否需要高清图
    ///   - completion: 返回存放images的数组
    static func startRequestData(imagesIn assets: [PHAsset], isHight: Bool, completion: @escaping (([Data]) -> Void)) {
        var datas = [Data]()

        for i in 0 ..< assets.count {
            let asset = assets[i]

            let mode = isHight ? PHImageRequestOptionsDeliveryMode.highQualityFormat : PHImageRequestOptionsDeliveryMode.fastFormat

            //初始化option
            let option = PHImageRequestOptions()
            option.deliveryMode = mode
            option.isSynchronous = true
            option.isNetworkAccessAllowed = true
            let fileName: String? = asset.value(forKeyPath: "filename") as? String
            if let fileName = fileName, fileName.hasSuffix("GIF") {
                option.version = .original
            }

            //请求数据
            PHImageManager.default().requestImageData(for: asset, options: option, resultHandler: { (data, _, _, _) in

                if let data = data {
                     datas.append(data)
                }

                if datas.count == assets.count {
                    completion(datas)
                }
            })
        }
    }
}
