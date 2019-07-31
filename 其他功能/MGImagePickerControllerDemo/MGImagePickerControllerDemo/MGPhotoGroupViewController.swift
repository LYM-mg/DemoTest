//
//  MGPhotoGroupViewController.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/5.
//  Copyright © 2019 MG. All rights reserved.
//

import UIKit
import Photos


class MGPhotoGroupViewController: UITableViewController {
    // MARK: - public
    /// 最大的选择数量，默认为9
    var mg_maxNumberOfSelectedPhoto = 9 {
        willSet {
            guard newValue > 0 else {
                return
            }
        MGPhotosCacheManager.sharedInstance.maxNumeberOfSelectedPhoto = newValue
        }
    }


    /// 当前图片的规格，默认为MGPhotoOriginSize，原始比例
    var mg_imageSize = MGPhotosCacheManager.MGPhotosOriginSize {
        willSet {

            MGPhotosCacheManager.sharedInstance.imageSize = newValue
        }
    }


    /// 获取图片之后的闭包
    var mg_completeUsingImage:(([UIImage]) -> Void)? {

        willSet {

            MGPhotosBridgeManager.sharedInstance.completeUsingImage = newValue
        }
    }


    /// 获取图片数据之后的闭包
    var mg_completeUsingData:(([Data]) -> Void)? {

        willSet {

            MGPhotosBridgeManager.sharedInstance.completeUsingData = newValue
        }
    }


    fileprivate let kMGPhotoGroupCellID = "kMGPhotoGroupCellID"
    /// 请求图片对象的store
    lazy fileprivate var photoStore = MGPhotoStore()
    /// 存放所有组的数据源
    lazy fileprivate var groups = [PHAssetCollection]()
    /// 图片的尺寸
    fileprivate let imageSize : CGSize = CGSize(width: 60, height: 60)

    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化tableView相关属性
        tableView.tableFooterView = UIView()
        tableView.register(MGPhotoGroupCell.self, forCellReuseIdentifier: kMGPhotoGroupCellID)
        tableView.rowHeight = 80;
        navigationItem.title = "相册"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissVc))

        fetchDefaultGroups()

        //获得权限
        let status = PHPhotoLibrary.authorizationStatus()

        if status == .denied || status == .restricted {
            let alertController = UIAlertController(title: "提示", message: "应用照片权限受限,请在设置中启用", preferredStyle: .alert)

            let action = UIAlertAction(title: "好的", style: .default, handler: { action in
            })

            alertController.addAction(action)
            present(alertController, animated: true)
        }
    }

    /// 控制器模态弹回，触发dismissGroupBlock
    @objc func dismissVc() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MGPhotoGroupCell = tableView.dequeueReusableCell(withIdentifier: kMGPhotoGroupCellID, for: indexPath) as! MGPhotoGroupCell

        let collection =  groups[indexPath.row]
        MGPhotoHandleManager.assetCollection(detailInformationFor: collection, size: imageSize) { (title, count, image) in
            if let image = image,let title = title {
                cell.mg_titleLabel.text = "\(title)+(\(count))"
                cell.mg_imageView.image = image
            }
        }

        return cell
    }


    // MARK: - delegate
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = groups[indexPath.row]

        jumpPhotosViewController(collection: collection, animated: true)
    }
}

extension MGPhotoGroupViewController {
    /// 请求获取默认的相册组，完成触发fetchGroupsCompletion
    func fetchDefaultGroups() {
        photoStore.fetchDefaultAllGroups { [weak self](allGroups, collections) in

            if let strongSelf = self {
                strongSelf.groups = allGroups
                // 默认跳转第一个
                strongSelf.jumpPhotosViewController(collection: allGroups.first!, animated: false)
                strongSelf.tableView.reloadData()
            }
        }
    }

    // 跳转
    func jumpPhotosViewController(collection:PHAssetCollection, animated:Bool) {
        //跳转viewController
        let viewController = MGPhotosViewController()

        //设置标题
        viewController.navigationItem.title = collection.localizedTitle!
        viewController.assetCollection = collection//(collection as! PHAssetCollection)
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
}
