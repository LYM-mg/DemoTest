//
//  MGPhotosViewController.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/8.
//  Copyright © 2019 MG. All rights reserved.
//

import UIKit
import Photos

class MGPhotosViewController: UIViewController {
    let kMGPhotos_cellIdentifier = "kMGPhotosCellID"
    let kMGPhotos_resuableViewIdentifier = "kMGPhotosBottomReusableViewID"

    /// 缓存单例
    fileprivate let cacheManager = MGPhotosCacheManager.sharedInstance
    var assetCollection: PHAssetCollection? {
        willSet {
            assetResult = MGPhotoStore.fetchPhotos(newValue!)

            //初始化所有的图片数组
            MGPhotoHandleManager.fetchResult(in: assetResult as! PHFetchResult<PHAsset>, type: PHAssetMediaType.image) { (allPhotos) in

                self.photosAssetResult = allPhotos
            }
        }
    }

    /// 存储该组所有的asset对象组合
    var assetResult: PHFetchResult<AnyObject>? {
        willSet {
            //初始化cacheManager
            MGPhotosCacheManager.sharedInstance.mg_memset(assetIsPictureSignal: (newValue?.count)!)
            MGPhotosCacheManager.sharedInstance.mg_memset(assetIsSelectedSignal: (newValue?.count)!)

            //初始化所有的资源对象
            MGPhotoHandleManager.resultToPHAssetArray(newValue!) { (assets, _) in
                self.assetsInResult = assets as! [PHAsset]
            }
        }
    }
    /// 存放当前所有为选中的照片对象
    fileprivate var photosAssetResult = [PHAsset]()
    /// 存储该组所有的asset对象的数组
    fileprivate var assetsInResult = [PHAsset]()

    /// 显示的集合视图
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let height = (self.view.bounds.width - 3) / 4
        let size = CGSize(width: height, height: height)
        flowLayout.itemSize = size
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 1.0

        let collectionView: UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)

        collectionView.delegate = self
        collectionView.dataSource = self

        if #available(iOS 10, *) {
            collectionView.prefetchDataSource = self
        }

        collectionView.backgroundColor = .white

        //register
        collectionView.register(MGPhotosCell.self, forCellWithReuseIdentifier: kMGPhotos_cellIdentifier)
        collectionView.register(MGPhotosBottomReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: kMGPhotos_resuableViewIdentifier)

        return collectionView
    }()

    /// 底部的tabBar
    fileprivate lazy var bottomBar: UITabBar = {

        let safeBottomHeight: CGFloat = DeviceTools.isIphoneX ? 60:44
        return UITabBar(frame: CGRect(x: 0, y: self.view.bounds.height  - safeBottomHeight, width: self.view.bounds.width, height: safeBottomHeight))
    }()

    /// 预览按钮
    fileprivate lazy var bowerButton: UIButton = {

        let button = UIButton(frame: CGRect(x: 5, y: 5, width: 60, height: 30))
        button.center = CGPoint(x: button.center.x, y: self.bottomBar.bounds.height / 2)

        button.setTitle("预览", for: .normal)
        button.setTitle("预览", for: .disabled)

        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.25), for: .disabled)

        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.showsTouchWhenHighlighted = true

        //默认不可点击
        button.isEnabled = false

        //响应
        button.action(at: .touchUpInside, handle: { [weak self] (_) in

            if let strongSelf = self {
                let assets = MGPhotoHandleManager.assets(strongSelf.assetsInResult, status: MGPhotosCacheManager.sharedInstance.assetIsSelectedSignal)

                let index = 0

                strongSelf.jumpPhotosBrowseController(index: index, selectedAssets: assets)
            }
        })

        return button
    }()

    /// 发送按钮
    fileprivate lazy var sendButton: UIButton = {

        var button: UIButton = UIButton(frame: CGRect(x: self.bottomBar.bounds.width - 50 - 5, y: 0, width: 50, height: 40))

        button.center = CGPoint(x: button.center.x, y: self.bottomBar.bounds.height / 2)

        button.setTitle("发送", for: .normal)
        button.setTitle("发送", for: .disabled)

//        button.setTitle(getTranslation(textCode: "C0047"), for: .normal)
//        button.setTitle(getTranslation(textCode: "C0047"), for: .disabled)
        button.setTitleColor(0x2dd58a.mg_color, for: .normal)
        button.setTitleColor(0x2DD58A.mg_color.withAlphaComponent(0.25), for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.showsTouchWhenHighlighted = true

        //默认不可用
        button.isEnabled = false

        //发送
        button.action(at: .touchUpInside, handle: {[weak self] (_) in
            if let strongSelf = self {
                //获得筛选的数组
                let assets = MGPhotoHandleManager.filter(assetsIn: strongSelf.assetsInResult, status: MGPhotosCacheManager.sharedInstance.assetIsSelectedSignal)

                //进行回调
                self?.dismiss(animated: true, completion: {
                    MGPhotosBridgeManager.sharedInstance.start(renderFor: assets)
                })
            }
        })
        return button
    }()

    /// 显示数目的标签
    fileprivate lazy var numberOfLabel: UILabel = {

        var label: UILabel = UILabel(frame: CGRect(x: self.sendButton.frame.origin.x - 20, y: 0, width: 20, height: 20))
        label.center = CGPoint(x: label.center.x, y: self.sendButton.center.y)

        //        label.backgroundColor = .colorValue(with: 0x2dd58a)
        label.backgroundColor = 0x2dd58a.mg_color
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14)
        label.text = ""
        label.isHidden = true
        label.textColor = .white
        label.layer.cornerRadius = label.bounds.width / 2.0
        label.clipsToBounds = true

        return label
    }()

    /// 高清图的响应Control
    lazy fileprivate var hightQuarityControl: UIControl = {
        let control: UIControl = UIControl(frame: CGRect(x: self.bowerButton.frame.maxX + 10, y: 0, width: 100, height: self.bottomBar.bounds.height))
        //响应
        control.action(at: .touchUpInside, handle: { [weak self] (_) in
            if let strongSelf = self {
                // 变换标志位
                let isHightQuality = MGPhotosCacheManager.sharedInstance.isHightQuarity
                MGPhotosCacheManager.sharedInstance.isHightQuarity = !isHightQuality
                // 检测勾选原图
                strongSelf.mg_checkIsHightQuarity()
            }
        })

        return control
    }()

    /// 选中圆圈
    lazy fileprivate var signImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 15, height: 15))
        imageView.center = CGPoint(x: imageView.center.x, y: self.hightQuarityControl.bounds.height / 2)

        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    /// 原图:
    lazy fileprivate var sizeSignLabel: UILabel = {
        var width = NSAttributedString(string: "ORIGINAL SIZE", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]).boundingRect(with: CGSize(width: 100, height: 30), options: .usesLineFragmentOrigin, context: nil).width + 10

        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.center = CGPoint(x: label.center.x, y: self.hightQuarityControl.bounds.height / 2)
        label.textColor = .darkGray
        label.text = "ORIGINAL SIZE"
        label.sizeToFit()
        label.frame =  CGRect(x: self.signImageView.frame.maxX + 5, y: (self.hightQuarityControl.bounds.height-25) / 2, width: width, height: 25)
        return label
    }()

    // MARK: - system life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        if #available(iOS 11, *) {
            navigationItem.largeTitleDisplayMode = .never
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(MGPhotosViewController.dimiss))

        //添加视图
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        self.view.addSubview(bottomBar)
        bottomBar.addSubview(bowerButton)
        bottomBar.addSubview(sendButton)
        bottomBar.addSubview(numberOfLabel)
        bottomBar.addSubview(hightQuarityControl)
        hightQuarityControl.addSubview(signImageView)
        hightQuarityControl.addSubview(sizeSignLabel)
        hightQuarityControl.frame.size.width = 10 + signImageView.frame.size.width + sizeSignLabel.frame.size.width + 10

        let y: CGFloat = DeviceTools.isIphoneX ? -83 : -64
        collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        collectionView.contentInset = UIEdgeInsets(top: -y, left: 0, bottom: DeviceTools.isIphoneX ? 60:44, right: 0)

        /// 滚动到最底部
        if let aseets = assetResult, aseets.count > 0 {
            self.collectionView.scrollToItem(at: IndexPath(item: aseets.count-1, section: 0), at: .bottom, animated: false)
        }
    }
    @objc func dimiss() {
        self .dismiss(animated: true) { }
    }

    deinit {
//        print(#function)
        print("\(self.self)deinit")
        cacheManager.free()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MGPhotosViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 0)
    }
}

// MARK: - UICollectionViewDataSource
extension MGPhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetResult?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: MGPhotosCell = collectionView.dequeueReusableCell(withReuseIdentifier: kMGPhotos_cellIdentifier, for: indexPath) as! MGPhotosCell
        //开始获取图片对象
        let currentAsset = (assetResult?[indexPath.item] as! PHAsset)

        let height = (collectionView.bounds.width - 3) / 4
        let size = CGSize(width: height, height: height)
        //获得详细信息
        MGPhotoHandleManager.asset(representionIn: currentAsset, size: size) { (image, asset) in

            var isImage = false
            if asset.mediaType == .image {
                isImage = true
                self.cacheManager.assetIsPictureSignal[indexPath.item] = true
            }

            cell.mg_imageView.image = image
            cell.mg_chooseControl.isHidden = !isImage

            // 如果不是图片对象，显示时长等
            if !isImage {
                cell.mg_messageView.isHidden = isImage
                //                cell?.ritl_messageLabel.text = ritl_timeFormat(timeDuation)
                cell.mg_messageLabel.text = currentAsset.duration.mg_time
            }
        }

        //响应3D Touch
        if #available(iOS 9.0, *) {
            // 确认为3D Touch可用
            if traitCollection.forceTouchCapability == .available {
                registerForPreviewing(with: self, sourceView: cell)
            }
        }

        // 选中
        cell.chooseImageDidSelectHandle = { [weak self](sender) in
            if let strongSelf = self {
                if strongSelf.handle(didSelectedImageAt: indexPath) {
                    sender.selected(strongSelf.cacheManager.assetIsSelectedSignal[indexPath.item])
                }
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let resuableView: MGPhotosBottomReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: kMGPhotos_resuableViewIdentifier, for: indexPath) as! MGPhotosBottomReusableView

        // 设置显示的数目
        resuableView.mg_numberOfAsset = (assetResult?.count)!

        return resuableView
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = assetResult?[indexPath.item] as! PHAsset
        guard asset.mediaType == .image else {
            return
        }
        //获得当前的位置
        let index: Int = photosAssetResult.firstIndex(of: asset)!
        self.jumpPhotosBrowseController(index: index, selectedAssets: photosAssetResult)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return MGPhotosCacheManager.sharedInstance.assetIsPictureSignal[indexPath.item]
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        (cell as! MGPhotosCell).selected(cacheManager.assetIsSelectedSignal[indexPath.item])
    }
}

// MARK: - 操作处理
extension MGPhotosViewController {
    /// 图片被选中的处理方法
    ///
    /// - Parameter index: 所在的位置
    /// - Returns: 是否选中
    func handle(didSelectedImageAt index: IndexPath) -> Bool {
        //修改标志位
        let isSelected = cacheManager.assetIsSelectedSignal[index.item]
        //记录
        cacheManager.numberOfSelectedPhoto += (isSelected ? -1 : 1)

        //如果已经超出最大限制
        guard cacheManager.numberOfSelectedPhoto <= cacheManager.maxNumeberOfSelectedPhoto else {

            cacheManager.numberOfSelectedPhoto -= 1

            //弹出提醒框
            self.present(alertControllerShow: UInt(cacheManager.maxNumeberOfSelectedPhoto))

            return false
        }

        //修改
        cacheManager.assetIsSelectedSignal[index.item] = !isSelected

        //检测变化
        mg_checkSendStatusChanged()

        return true
    }

    /// 检测当前可用状态
    func mg_checkSendStatusChanged() {
        let count = cacheManager.numberOfSelectedPhoto
        let enable = count >= 1

        self.bowerButton.isEnabled = enable
        self.sendButton.isEnabled = enable

        let hidden = count == 0
        numberOfLabel.isHidden = hidden
        if !hidden {
            numberOfLabel.text = "\(count)"
            numberOfLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.3, animations: {
                self.numberOfLabel.transform = .identity
            })
        }
    }

    /// 检测勾选原图
    func mg_checkIsHightQuarity() {
        // 检测勾选原图
        let isHightQuality = MGPhotosCacheManager.sharedInstance.isHightQuarity
        let textColor = isHightQuality ? 0x2dd58a.mg_color : UIColor.darkGray
        let signColor = isHightQuality ? 0x2dd58a.mg_color : UIColor.lightGray
        // 设置UI
        self.signImageView.backgroundColor = signColor
        self.sizeSignLabel.textColor       = textColor
    }

    /// 弹出alert控制器
    ///
    /// - Parameter count: 限制的数目
    func present(alertControllerShow count: UInt) {
        let alertController = UIAlertController(title: ("你最多可以选择\(count)张照片"), message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "知道了", style: UIAlertAction.Style.cancel, handler: { (action) in

        }))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
@available(iOS 10, *)
extension MGPhotosViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {

    }
}

@available(iOS 9.0, *)
extension MGPhotosViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {

        let indexPath = collectionView.indexPath(for: previewingContext.sourceView as! MGPhotosCell)

        // 获取当前的图片对象
        let asset = assetResult?[indexPath!.item] as! PHAsset

        guard asset.mediaType == .image else {
            return
        }

        //获得当前的位置
        let index: Int = photosAssetResult.firstIndex(of: asset)!
        jumpPhotosBrowseController(index: index, selectedAssets: photosAssetResult)
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        //获得索引
        guard let item = collectionView.indexPath(for: previewingContext.sourceView as! UICollectionViewCell)?.item else {
            return nil
        }

        //获得当前的资源
        let asset: PHAsset = self.assetResult?[item] as! PHAsset

        guard asset.mediaType == .image else {
            return nil
        }

        let viewController = MGPhotosPreviewController()

        viewController.showAsset = asset

        return viewController
    }

    // 跳转到浏览控制器
    func jumpPhotosBrowseController(index: Int, selectedAssets: [PHAsset]) {
        //初始化控制器
        let viewController = MGPhotosBrowseController()

        // photoDidTapShouldBrowerHandle?(assetResult!,assetsInResult as id,photosAssetResult as id,asset,index)
        //设置
        viewController.allAssets = self.assetsInResult
        viewController.allPhotoAssets = selectedAssets
        viewController.current = Int(index)

        //刷新当前的视图
        viewController.mg_browseWilldisappearHandle = { [weak self] in
            if let strongSelf = self {
                strongSelf.collectionView.reloadData()
                //检测发送按钮的可用性
                strongSelf.mg_checkSendStatusChanged()
                // 检测勾选原图
                strongSelf.mg_checkIsHightQuarity()
            }
        }
        //进入下一个浏览控制器
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
