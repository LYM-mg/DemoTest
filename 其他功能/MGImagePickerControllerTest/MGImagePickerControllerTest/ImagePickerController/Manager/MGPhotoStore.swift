//
//  MGPhotoStore.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/5.
//  Copyright © 2019 MG. All rights reserved.
//

import UIKit
import Photos

/// 负责请求图片的管理类
@available(iOS 8.0, *)
class MGPhotoStore: NSObject {

    /// 负责请求图片对象的图片库
    fileprivate let photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared()

    /// 配置类对象
    var config: MGPhotoConfig = MGPhotoConfig()

    /// 相册变化发生的回调
    var photoStoreHasChanged: ((_ changeInstance: PHChange) -> Void)?

    override init() {
        super.init()
        photoLibrary.register(self)
    }

    /// 初始化方法
    ///
    /// - Parameter config: 赋值配置类对象
    convenience init(config: MGPhotoConfig) {
        self.init()
        self.config = config
    }

    deinit {
        /// 移除观察者
        photoLibrary.unregisterChangeObserver(self as PHPhotoLibraryChangeObserver)
    }

    // MARK: fetch

    /// 获取photos提供的所有的智能分类相册组，与config属性无关
    ///
    /// - Parameter groups: 图片组对象
    public func fetch(groups: @escaping([PHAssetCollection]) -> Void) -> Void {
        mg_fetchBasePhotosGroup { (group) in
            guard let group = group else {
                return
            }
            MGPhotoHandleManager.resultToArray(group as! PHFetchResult<AnyObject>, complete: { (completeGroup, _) in
                let tempArray = self.mg_handleAssetCollection(completeGroup as? [PHAssetCollection] ?? [PHAssetCollection]())
                if  tempArray.count > 0 {
                    groups(tempArray)
                }
            })
        }
    }

    /// 根据photos提供的智能分类相册组 根据config中的groupNamesConfig属性进行筛别
    ///
    /// - Parameter groups: 图片组对象
    public func fetchDefault(groups: @escaping ([PHAssetCollection]) -> Void) -> Void {
        mg_fetchBasePhotosGroup { [weak self](result) in
            let strongSelf = self
            guard let result = result else { return }
            strongSelf!.mg_prepare(result, complete: { (defaultGroup) in
                let tempArray = strongSelf?.mg_handleAssetCollection(defaultGroup)

                if let tempArray = tempArray, tempArray.count > 0 {
                    groups(tempArray)
                }
            })
        }
    }

    /// 根据photos提供的智能分类相册组 根据config中的groupNamesConfig属性进行筛别 并添加上其他在手机中创建的相册
    ///
    /// - Parameter groups:
    public func fetchDefaultAllGroups(_ groups: @escaping (([PHAssetCollection], PHFetchResult<AnyObject>) -> Void)) {
        var defaultAllGroups = [PHAssetCollection]()

        // 获取
        fetchDefault { (defaultGroups) in

            defaultAllGroups.append(contentsOf: defaultGroups)

            //遍历自定义的组
            MGPhotoHandleManager.resultToArray(PHCollection.fetchTopLevelUserCollections(with: PHFetchOptions()) as! PHFetchResult<AnyObject>, complete: { (topLevelArray, result) in
                
                defaultAllGroups.append(contentsOf: topLevelArray as! [PHAssetCollection])
                //进行主线程回调
                if Thread.isMainThread {
                    groups(defaultAllGroups, result); return
                }
                DispatchQueue.global().async {
                    //主线程刷新UI
                    DispatchQueue.main.async {
                        groups(defaultAllGroups, result)
                    }
                }
            })
        }
    }

    // MARK: 相片

    /// 获取某个相册的所有照片的简便方法
    ///
    /// - Parameter group:
    /// - Returns:
    static func fetchPhotos(_ group: PHAssetCollection) -> PHFetchResult<AnyObject> {
        return PHAsset.fetchAssets(in: group, options: PHFetchOptions()) as! PHFetchResult<AnyObject>
    }

    // MARK: private function

    /// 获取最基本的智能分组
    ///
    /// - Parameter _: 获取到的回调closer
    private func mg_fetchBasePhotosGroup(complete: @escaping ((PHFetchResult<PHAssetCollection>?) -> Void)) {
        mg_checkAuthorizationState(allow: { () in
            //获取智能分组
            let smartGroups = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)

            // 准许
            complete((smartGroups))

        }, denied: {() in
            //获得权限
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .denied || status == .restricted {

            }
        }) 
    }

    // MARK: 检测权限

    /// 检测是否获得图片库的权限
    ///
    /// - Parameters:
    ///   - allow: 允许操作
    ///   - denied: 不允许操作
    func mg_checkAuthorizationState(allow: @escaping () -> Void, denied: @escaping() -> Void) {
        //获得权限
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: allow() //允许
        case .notDetermined://询问
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    allow()
                } else {
                    denied()
                }
            })
        case .denied: break //不允许
        case .restricted: denied()
        default:
            break
        }
    }

    /// 将处理数组中的 胶卷相册拍到第一位
    ///
    /// - Parameter assCollection: 需要处理的数组
    /// - Returns: 处理完毕的数组
    private func mg_handleAssetCollection(_ assCollection: [PHAssetCollection]) -> [PHAssetCollection] {
        var collections: [PHAssetCollection] = assCollection
        for i in 0 ..< assCollection.count {
            //获取资源
            let collection = assCollection[i]

            guard let collectionTitle = collection.localizedTitle else { continue }

            if collectionTitle.isEqual(NSLocalizedString(ConfigurationAllPhotos, comment: "")) || collectionTitle.isEqual(NSLocalizedString(ConfigurationCameraRoll, comment: "")) {
                collections.swapAt(i, 0) // 交换位置
//                collections.remove(at: i)
//                collections.insert(collection, at: 0)
            }
        }
        return collections
    }

    /// 将configuration属性中的分类进行筛选
    ///
    /// - Parameters:
    ///   - result: 进行筛选的result
    ///   - complete: 处理完毕的数组
    private func mg_prepare(_ result: PHFetchResult<PHAssetCollection>, complete: @escaping(([PHAssetCollection]) -> Void)) {
        var preparationCollections = [PHAssetCollection]()
        result.enumerateObjects({ (obj, idx, _) in
            if obj.isKind(of: PHAssetCollection.self) && obj.estimatedAssetCount > 0 {
//                //获取出但前相簿内的图片
//                let resultsOptions = PHFetchOptions()
//                resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
//                                                                   ascending: false)]
//                resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
//                                                       PHAssetMediaType.image.rawValue)
                let assetResult = MGPhotoStore.fetchPhotos(obj)
                debugPrint(obj.localizedTitle ?? "")
                // 过滤空数组
                if assetResult.count != 0 {
                    preparationCollections.append(obj)
                }
            }
        })
        complete(preparationCollections)
    }
}

// MARK: - 监听变化
extension MGPhotoStore: PHPhotoLibraryChangeObserver {
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.photoStoreHasChanged?(changeInstance)
    }
}

// MARK: - 对组的操作
extension MGPhotoStore {
    /// 创建一个相册
    ///
    /// - Parameters:
    ///   - title: 相册的名称
    ///   - complete: 完成
    ///   - fail: 失败
    func add(customGroupNamed title: String, complete: @escaping(() -> Void), fail: @escaping((String?) -> Void)) {
        photoLibrary.performChanges({
            //执行请求
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)

        }) { (success, error) in

            if success == true {
                complete()
                return
            }
            fail(error?.localizedDescription)
        }
    }

    /// 创建一个相册
    ///
    /// - Parameters:
    ///   - title: 相册的名称
    ///   - photos: 同时添加进相册的默认图片
    ///   - complete: 完成
    ///   - fail: 失败
    func add(customGroupNamed title: String, including photos: [PHAsset], complete: @escaping(() -> Void), fail: @escaping((String?) -> Void)) {
        photoLibrary.performChanges({

            let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)

            //添加图片资源
            request.addAssets(photos as NSFastEnumeration)

        }) { (success, error) in

            if success == true {
                complete()
                return
            }
            fail(error?.localizedDescription)
        }
    }

    /// 检测是否存在同名相册,如果存在返回第一个同名相册
    ///
    /// - Parameters:
    ///   - title: 相册的名称
    ///   - result: 如果存在返回第一个同名相册
    func check(groupnamed title: String, result closure: @escaping((Bool, PHAssetCollection) -> Void)) {
        MGPhotoHandleManager.resultToArray(PHCollection.fetchTopLevelUserCollections(with: PHFetchOptions()) as! PHFetchResult<AnyObject>) { (topLevelArray, _) in
            var isExist = false
            var isExistCollection: PHAssetCollection?
            //开始遍历
            for i in 0 ..< topLevelArray.count {

                if topLevelArray[i].localizedDescription == title {
                    isExist = true
                    isExistCollection = (topLevelArray[i] as! PHAssetCollection)
                    break
                }
            }
            closure(isExist, isExistCollection!)
        }
    }
}

// MARK: - 对照片的处理
extension MGPhotoStore {
    /// 向组对象中添加image对象
    ///
    /// - Parameters:
    ///   - image: 添加的image
    ///   - collection: 组
    ///   - completeHandle: 完成
    ///   - fail: 失败
    func add(_ image: UIImage, to collection: PHAssetCollection, completeHandle: @escaping(() -> Void), fail: @escaping((_ error: String) -> Void)) {
        photoLibrary.performChanges({

            if collection.canPerform(PHCollectionEditOperation.addContent) {
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let groupRequest = PHAssetCollectionChangeRequest(for: collection)
                groupRequest?.addAssets([request.placeholderForCreatedAsset!] as NSFastEnumeration)
            }

        }) { (success, error) in
            if success == true {
                completeHandle()
                return
            }
            fail(error?.localizedDescription ?? "")
        }
    }
    
    /// 向组对象中添加image对象
    ///
    /// - Parameters:
    ///   - path: image对象的路径
    ///   - collection: 组
    ///   - completeHandle: 完成
    ///   - fail: 失败
    func add(imageAtPath path: String, to collection: PHAssetCollection, completeHandle: @escaping(() -> Void), fail: @escaping((_ error: String) -> Void)) {
        let image = UIImage(contentsOfFile: path)

        add(image!, to: collection, completeHandle: completeHandle, fail: fail)
    }
}
