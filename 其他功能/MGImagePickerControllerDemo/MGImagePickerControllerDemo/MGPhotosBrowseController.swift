//
//  MGPhotosBrowseController.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/8.
//  Copyright © 2019 MG. All rights reserved.
//

import UIKit
import Photos

class MGPhotosBrowseController: UIViewController {
    struct MGPhotoBrowseViewModelAssociate
    {
        static let MG_photoBrowViewEndDeceleratingAssociate = UnsafeRawPointer(bitPattern: "mg_photoBrowViewEndDeceleratingAssociate".hashValue)
    }

    private let kMGPhotosBrowseCellID = "kMGPhotosBrowseCellID"
    let mg_deselectedImage = UIImage(named: "MGDeselected")
    let mg_selectedImage  = UIImage(named: "MGSelected")
    let mg_photoBackImage = UIImage(named: "MGPhotoBack")
    // MARK: public
    /// 当前图片的位置指数
    var current : Int = 0
    /// 是否是缩略图
    var isSelectOriginalPhoto: Bool = false

    lazy var MGScreenScale: CGFloat = {
        if (UIScreen.main.bounds.width > 700) {
            return 1.5;
        }
        return 2.0
    }()



    /// 存储图片所有资源对象
    var allAssets = [PHAsset]()

    /// 所有选择的的图片资源
    var allPhotoAssets = [PHAsset]()

    /// 浏览控制器将要消失的回调
    var mg_browseWilldisappearHandle : (() -> Void)?

    var isHiddenBar: Bool = false

    // MARK: private

    /// 展示图片的collectionView
    lazy fileprivate var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = self.view.frame.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collection : UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)

        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false

        if #available(iOS 10, *) {

            collection.prefetchDataSource = self
        }

        collection.register(MGPhotosBrowseCell.self, forCellWithReuseIdentifier: kMGPhotosBrowseCellID)

        return collection
    }()


    /// 顶部的bar
    lazy fileprivate var topBar: UIView = {
        let topBar : UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: DeviceTools.isIphoneX ? 88:64))
//        topBar.barStyle = .black
        topBar.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        topBar.setBackgroundImage(UIColor.black.withAlphaComponent(0.6).mg_image, for: UIBarMetrics.default)

        return topBar
    }()


    /// 返回
    lazy fileprivate var backItem: UIButton = {
        //位置
        let backItem = UIButton(frame: CGRect(x: 5, y: self.topBar.bounds.height - 44, width: 44, height: 44))
//        backItem.center = CGPoint(x: backItem.center.x, y: (self.topBar.bounds.height - 44) / 2)

        //属性
        backItem.setImage(mg_photoBackImage, for: .normal)
        backItem.setTitleColor(.white, for: .normal)
        backItem.titleLabel?.font = .systemFont(ofSize: 30)
        backItem.titleLabel?.textAlignment = .center

        //响应
        backItem.action(at: .touchUpInside, handle: { [weak self](sender) in
            self?.navigationController?.popViewController(animated: true)
        })

        return backItem
    }()


    /// 选择
    lazy fileprivate var selectedItem : UIButton = {
        let button : UIButton = UIButton(frame: CGRect(x: self.topBar.bounds.width - 44 - 10, y: self.topBar.bounds.height - 44, width: 44, height: 44))
//        button.center = CGPoint(x: button.center.x, y: (self.topBar.bounds.height - 44) / 2)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom: 8, right: 10)
        button.setImage(mg_deselectedImage, for: .normal)
        button.action(at: .touchUpInside, handle: {[weak self] (sender) in
            self!.select()
        })

        return button
    }()


    /// 底部的tabBar
    lazy fileprivate var bottomBar : UITabBar = {
        let safeBottomHeight: CGFloat = DeviceTools.isIphoneX ? 60:44
        let bottomBar :UITabBar = UITabBar(frame: CGRect(x: 0, y: self.view.bounds.height - safeBottomHeight, width: self.view.bounds.width, height: safeBottomHeight))

        bottomBar.barStyle = .black
        bottomBar.backgroundImage = UIColor.black.withAlphaComponent(0.6).mg_image
        return bottomBar
    }()


    /// 发送按钮
    lazy fileprivate var sendButton : UIButton = {
        let button : UIButton = UIButton(frame: CGRect(x: self.bottomBar.bounds.width - 50 - 5, y: 0, width: 50, height: 40))
        button.center = CGPoint(x: button.center.x, y: self.bottomBar.bounds.height / 2)

        button.setTitle("发送", for: .normal)
        button.setTitleColor(0x2dd58a.mg_color, for: .normal)
        button.setTitleColor(0x2DD58A.mg_color.withAlphaComponent(0.25), for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center

        button.action(at: .touchUpInside, handle: { [weak self](sender) in
            if let strongSelf = self {
                //获得筛选的数组
                let assets = MGPhotoHandleManager.filter(assetsIn: strongSelf.allAssets, status: MGPhotosCacheManager.sharedInstance.assetIsSelectedSignal)

                //进行回调
                MGPhotosBridgeManager.sharedInstance.start(renderFor: assets)
                self?.dismiss(animated: true, completion: nil)
            }
        })

        return button
    }()


    /// 显示数目的标签
    lazy fileprivate var numberLabel : UILabel = {
        let label : UILabel = UILabel(frame: CGRect(x: self.sendButton.frame.origin.x - 20, y: 0, width: 20, height: 20))
        label.center = CGPoint(x: label.center.x, y: self.sendButton.center.y)

        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "8"
        //        label.backgroundColor = .colorValue(with: 0x2dd58a)
        label.backgroundColor = 0x2dd58a.mg_color
        label.textColor = .white
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()

    /// 高清图的响应Control
    lazy fileprivate var hightQuarityControl : UIControl = {
        let control : UIControl = UIControl(frame: CGRect(x: 0, y: 0, width: 150, height: self.bottomBar.bounds.height))

        //响应
        control.action(at: .touchUpInside, handle: { [weak self](sender) in
            if let strongSelf = self {
                strongSelf.mg_hightQualityStatusChanged()
            }
        })

        return control
    }()


    /// 选中圆圈
    lazy fileprivate var signImageView : UIImageView = {
        let imageView : UIImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 15, height: 15))
        imageView.center = CGPoint(x: imageView.center.x, y: self.hightQuarityControl.bounds.height / 2)

        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()


    /// 原图:
    lazy fileprivate var sizeSignLabel : UILabel = {
        var width = NSAttributedString(string: "原图", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)]).boundingRect(with: CGSize(width: 100, height: 30), options: .usesLineFragmentOrigin, context: nil).width + 10

        let label : UILabel = UILabel(frame: CGRect(x:self.signImageView.frame.maxX + 5 , y: 0, width: width, height: 25))

        label.center = CGPoint(x: label.center.x, y: self.hightQuarityControl.bounds.height / 2)
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.text = "原图:"
        return label
    }()


    /// 等待
    lazy fileprivate var indicator : UIActivityIndicatorView = {

        let indicator : UIActivityIndicatorView = UIActivityIndicatorView(style: .white)

        indicator.frame = CGRect(x: self.sizeSignLabel.frame.maxX + 5, y: 0, width: 15, height: 15)
        indicator.center = CGPoint(x: indicator.center.x, y: self.hightQuarityControl.bounds.height / 2)
        indicator.hidesWhenStopped = true

        return indicator
    }()


    /// 照片大小
    lazy fileprivate var sizeLabel : UILabel = {

        let label = UILabel(frame: CGRect(x: self.sizeSignLabel.frame.maxX + 5, y: 0, width: self.hightQuarityControl.bounds.width - self.sizeSignLabel.bounds.width, height: 25))

        label.center = CGPoint(x: label.center.x, y: self.hightQuarityControl.bounds.height / 2)
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.text = ""

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11,*) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        }else {
             automaticallyAdjustsScrollViewInsets = false
        }

        view.addSubview(collectionView)
        view.addSubview(topBar)
        view.addSubview(bottomBar)

        topBar.addSubview(backItem)
        topBar.addSubview(selectedItem)

        bottomBar.addSubview(hightQuarityControl)
        bottomBar.addSubview(sendButton)
        bottomBar.addSubview(numberLabel)

        hightQuarityControl.addSubview(signImageView)
        hightQuarityControl.addSubview(sizeSignLabel)
        hightQuarityControl.addSubview(indicator)
        hightQuarityControl.addSubview(sizeLabel)


        //滚动到当前
        collectionView.scrollToItem(at: IndexPath(item: self.current, section: 0), at: .centeredHorizontally, animated: false)

        mg_checkSendStatusChanged()
        self.isSelectOriginalPhoto = MGPhotosCacheManager.sharedInstance.isHightQuarity
        if isSelectOriginalPhoto {
            self.mg_hightQualityStatusChanged()
        }
        mg_update(sizeForHightQuarity: mg_checkHightQuarityStatus())

        sendViewBarShouldChangedSignal()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        if mg_browseWilldisappearHandle != nil {
            mg_browseWilldisappearHandle!()
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //标记
        scrollViewDidEndDecelerating(collectionView)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    deinit {
        print("\(self.self)deinit")
    }
}

extension MGPhotosBrowseController : UICollectionViewDataSource {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let collectionView = scrollView as! UICollectionView

        let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)

        //获得当前记录的位置
        let index = current

        // 判断是否为第一次进入
        let shouldIgnoreCurrentIndex = objc_getAssociatedObject(self, MGPhotoBrowseViewModelAssociate.MG_photoBrowViewEndDeceleratingAssociate!)

        // 如果不是第一次进入并且索引没有变化，不操作
        if shouldIgnoreCurrentIndex != nil && index == currentIndex  {

            return
        }

        current = currentIndex

        //修改
        objc_setAssociatedObject(self, MGPhotoBrowseViewModelAssociate.MG_photoBrowViewEndDeceleratingAssociate!, false, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)

//        //获得indexPath
//        let indexPath = IndexPath(item: currentIndex, section: 0)
//
//        //请求高清图片
//        image(at: indexPath, in: scrollView as! UICollectionView, isThum: false) { [weak self](image, asset) in
//            if let strongSelf = self {
//                //获得当前cell
//                let cell = strongSelf.collectionView.cellForItem(at: indexPath)
//
//                UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
//                    if cell != nil {
//                        (cell as! MGPhotosBrowseCell).mg_imageView.image = image
//                    }
//
//                }, completion: nil)
//            }
//        }

        //执行判定
        let cacheManager = MGPhotosCacheManager.sharedInstance
        self.selectedItem.setImage((cacheManager.assetIsSelectedSignal[mg_index(indexFromAllPhotosToAll: currentIndex)] ? mg_selectedImage : mg_deselectedImage)!, for: .normal)

        self.mg_check(hightQuarityChangedAt: currentIndex)
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return allPhotoAssets.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell : MGPhotosBrowseCell = collectionView.dequeueReusableCell(withReuseIdentifier: kMGPhotosBrowseCellID, for: indexPath) as! MGPhotosBrowseCell


        self.image(at: indexPath, in: collectionView, isThum: false) {(image, asset) in
            DispatchQueue.main.async {
                cell.mg_imageView.image = image
            }
        }

//        if (self.isSelectOriginalPhoto)  {
//            self.mg_check(hightQuarityChangedAt: indexPath.item)
//        }

        cell.mg_photoBrowerSimpleTapHandle = { [unowned self] (cell) in
            self.sendViewBarShouldChangedSignal()
        }

        return cell
    }
}


// MARK: - 操作处理
extension MGPhotosBrowseController {
    /// 获得当前的位置的图片对象
    ///
    /// - Parameters:
    ///   - indexPath: 所在位置
    ///   - collection: collectionView
    ///   - isThum: 是否为缩略图，如果为false，则按照图片原始比例获得
    ///   - completion: 完成
    func image(at indexPath:IndexPath,in collection:UICollectionView,isThum:Bool,completion:@escaping ((UIImage,PHAsset) -> Void))
    {
        //默认图片大小
        var pixelWidth:CGFloat = self.view.frame.size.width * self.MGScreenScale
        DispatchQueue.global().async {
            //获得当前资源
            let asset = self.allPhotoAssets[indexPath.item]

            //图片比
            let scale = CGFloat(asset.pixelHeight) * 1.0 / CGFloat(asset.pixelWidth)

            // 超宽图片
            if (scale > 1.8) {
                pixelWidth = pixelWidth * scale;
            }
            // 超高图片
            if (scale < 0.2) {
                pixelWidth = pixelWidth * 0.5;
            }

            // 如果不是缩略图
//        if !isThum {
//            let height = (collection.bounds.width - 10) * scale
//
//            size = CGSize(width: height / scale, height: height)
//        }
            let pixelHeight = pixelWidth / scale;
            let imageSize = CGSize(width:pixelWidth,height:pixelHeight);

            MGPhotoHandleManager.asset(representionIn: asset, size: imageSize) { (image, asset) in

                completion(image,asset)
            }
        }
    }

    /// 检测当前发送按钮状态
    func mg_checkSendStatusChanged() {
        let count = MGPhotosCacheManager.sharedInstance.numberOfSelectedPhoto
        let enable = count >= 1

        self.sendButton.isEnabled = enable

        let hidden = count == 0
        numberLabel.isHidden = hidden
        if !hidden {
            numberLabel.text = "\(count)"
            numberLabel.transform = CGAffineTransform(scaleX: 0.1,y: 0.1)
            UIView.animate(withDuration: 0.3, animations: {
                self.numberLabel.transform = .identity
            })
        }
    }

    /// 点击选择按钮,触发ritl_browseSelectedBtnRefreshHandle
    ///
    /// - Parameter scrollView: collectionView
    func select() {
        let cacheManager = MGPhotosCacheManager.sharedInstance

        //获得当前偏移量
        let currentIndex = mg_index(indexFromAllPhotosToAll: Int(self.collectionView.contentOffset.x / collectionView.bounds.width)) 

        //修改标志位
        let temp = cacheManager.assetIsSelectedSignal[currentIndex] ? -1 : 1

        cacheManager.numberOfSelectedPhoto += temp

        //判断是否达到上限
        guard cacheManager.numberOfSelectedPhoto <= cacheManager.maxNumeberOfSelectedPhoto else {

            //退回
            cacheManager.numberOfSelectedPhoto -= 1

            //弹出警告
            present(alertControllerShow: UInt(cacheManager.maxNumeberOfSelectedPhoto))
            return
        }

        //修改状态
        cacheManager.mg_change(selecteStatusIn: currentIndex)

        //检测
        mg_checkSendStatusChanged()

        //执行
        self.selectedItem.setImage((cacheManager.assetIsSelectedSignal[currentIndex] ? mg_selectedImage : mg_deselectedImage)!, for: .normal)
    }

    /// 弹出alert控制器
    ///
    /// - Parameter count: 限制的数目
    func present(alertControllerShow count:UInt) {
        let alertController = UIAlertController(title: ("你最多可以选择\(count)张照片"), message: nil, preferredStyle: UIAlertController.Style.alert)

        alertController.addAction(UIAlertAction(title: "知道了", style: UIAlertAction.Style.cancel, handler: { (action) in

        }))

        present(alertController, animated: true, completion: nil)
    }

    /// 检测当前是否为高清状态，并执行响应的block
    ///
    /// - Parameter index: 当前展示图片的索引
    fileprivate func mg_check(hightQuarityChangedAt index:Int) {
        let cacheManager =  MGPhotosCacheManager.sharedInstance

        guard cacheManager.isHightQuarity else {
            return
        }

        let currentAsset = self.allPhotoAssets[index]

        self.indicator.startAnimating()
        self.sizeLabel.isHidden = true
        DispatchQueue.global().async {
            //获取高清数据
            MGPhotoHandleManager.asset(hightQuarityFor: currentAsset, Size: CGSize(width: currentAsset.pixelWidth, height: currentAsset.pixelHeight)) { (imageSize) in
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.sizeLabel.isHidden = false
                    self.sizeLabel.text = imageSize
                }
            }
        }
    }

    /// 检测浏览是否为高清状态
    func mg_checkHightQuarityStatus() -> Bool{
        return (MGPhotosCacheManager.sharedInstance.isHightQuarity)
    }

    /// 更新高清显示的状态
    ///
    /// - Parameter isHight: 是否为高清状态
    func mg_update(sizeForHightQuarity isHight:Bool) {

        let signColor = isHight ? 0x2dd58a.mg_color :  UIColor.darkGray
        let textColor = isHight ? UIColor.white : UIColor.darkGray

        // 设置UI
        signImageView.backgroundColor = signColor
        sizeSignLabel.textColor = textColor
        sizeLabel.textColor = textColor

        if !isHight {
            indicator.stopAnimating()
            sizeLabel.text = ""
        }
    }

    /// 高清状态发生变化
    ///
    /// - Parameter scrollView:
    func mg_hightQualityStatusChanged() {
        let isHightQuality = MGPhotosCacheManager.sharedInstance.isHightQuarity

        // 变换标志位
        MGPhotosCacheManager.sharedInstance.isHightQuarity = !isHightQuality

        let isHight  = mg_checkHightQuarityStatus()
        self.isSelectOriginalPhoto = isHight
        self.mg_update(sizeForHightQuarity: isHight)

        //进入高清图进行计算
        if !isHightQuality {

            mg_check(hightQuarityChangedAt: Int(collectionView.contentOffset.x / collectionView.bounds.width))

        }
    }

    /// 从所有的图片资源转换为所有资源的位置
    ///
    /// - Parameter index: 在所有图片资源的位置
    /// - Returns: 资源对象在所有资源中的位置
    fileprivate func mg_index(indexFromAllPhotosToAll index:Int) -> Int
    {
        let currentAsset = allPhotoAssets[index]

        return allAssets.index(of: currentAsset)!
    }

    /// bar对象的隐藏
    func sendViewBarShouldChangedSignal() {
        self.isHiddenBar = !self.isHiddenBar

        self.topBar.isHidden = self.isHiddenBar
        self.bottomBar.isHidden = self.isHiddenBar
    }
}

extension MGPhotosBrowseController : UICollectionViewDelegateFlowLayout
{
    func collectonViewModel(didEndDisplayCellForItemAt index: IndexPath) {
        //执行判定
        let cacheManager = MGPhotosCacheManager.sharedInstance
        self.selectedItem.setImage((cacheManager.assetIsSelectedSignal[index.item] ? mg_selectedImage : mg_deselectedImage)!, for: .normal)

    }
}


@available(iOS 10, *)
extension MGPhotosBrowseController : UICollectionViewDataSourcePrefetching
{


    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {


    }


    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {


    }

}

