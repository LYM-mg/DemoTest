//
//  ViewController.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/3/26.
//  Copyright © 2019年 firestonetmt. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire
import Foundation

#if DEBUG // 调试

#else     // 其他环境

#endif


class Content1:Codable {
    var name: String?
    var age: Int?
    var sex: String?
    var born_in: String?

    static func creat(name: String?,age: Int?,sex: String?,born_in: String?) -> Content1{
        let v = Content1()
        v.name    = name
        v.age     = age
        v.sex     = sex
        v.born_in = born_in
        return v
    }

    func ss() {
        print("没有崩溃")
    }
}




//let v333:Content1? = objectArray[3] as? Content1
//v333?.name
//v333?.ss()
//let v444:Content1? = objectArray[1] as? Content1
//v444?.name
//v444?.ss()

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var ceshi = ["1","2"]
        ceshi.safe_object(at: 1)

        let v3:Content1 = Content1.creat(name: "笨蛋小li612313", age: 231, sex:  "女", born_in: "2013")
        let v4:Content1 = Content1.creat(name: "笨蛋小li6", age: 231, sex:  "男", born_in: "1993")
        var  objectArray = [v3,v4]
        let v33 = objectArray.safe_object(at: 3)
        v33?.name
        v33?.ss()
        let v44:Content1? = objectArray.safe_object(at: 1)
        v44?.name
        v44?.ss()

        let v333 = objectArray[safeIndex: 3]
        v333?.name
        v333?.ss()
        let v444 = objectArray[safeIndex: 1]
        v444?.name
        v444?.ss()
        objectArray[safeIndex:5] = v3

        objectArray[1] = v3
        let v5 = Content1.creat(name: "z笨猪就是你", age: 123, sex:  "男", born_in: "2312")
        objectArray[safeIndex:1] = v5
        let _ = objectArray[safeIndex:3]
        objectArray[safeIndex:4] = v5
        UINavigationBar.appearance().isTranslucent = false

        let kfManager = KingfisherManager.shared
        // 通过manager 获取cache
        let cache = kfManager.cache

        let isCached = cache.isCached(forKey: "urlStr")

        // 通过manager 获取downloader
        let downloader = kfManager.downloader
//        downloader.downloadImage(with: URL(string: "urlStr")!, options: nil, progressBlock: { (dd, ff) in
//
//        }) { (result) in
//            switch result {
//                case .success(let value):
////                    self.base.setImage(value.image, for: state)
//                case .failure:
//                    break
//            }
//        }
//        // 设置options, 你可以设置你的newCache/newDownloader以及其他配置
//        kfManager.defaultOptions = [.targetCache(newCache), .downloader(newDownloader), .forceRefresh, .backgroundDecode, .onlyFromCache, .downloadPriority(1.0)]
        // 检索
        let resource = ImageResource(downloadURL: URL(string: "http://xxxx.com")!, cacheKey: "text")
        let retriveImageTask = kfManager.retrieveImage(with: resource, options: nil, progressBlock: nil, completionHandler: {
            (image, error, cacheType, imageURL) in
            if error == nil { // 已下载
                print("检索图片成功")
            } else {  // 未下载
                print("检索图片失败")
            }
        })

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.leftClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(self.rightClick))
        let btn = UIButton()
        btn.mg.sss()
        btn.frame = CGRect(x: 50, y: 88, width: 50, height: 50)
        btn.setTitle("闪烁", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        view.addSubview(btn)
        let shareView = MGLayerView(frame: CGRect(origin: .zero, size: btn.mg_size))
//        shareView.center = btn.center
        btn.addTarget(self, action: #selector(self.share(_:)), for: .touchUpInside)
        shareView.shareColor = .randomColor()
        btn.addSubview(shareView)
        shareView.starAnimation()
        shareView.tapBlock = {
            shareView.pauseAnimation()
        }


        let btn2 = UIButton()
        btn2.frame = CGRect(x: 50, y: 140, width: 50, height: 50)
        btn2.setTitle("闪烁", for: .normal)
        btn2.setTitleColor(.lightGray, for: .normal)
        view.addSubview(btn2)
        let shareView2 = MGLayerView(frame: CGRect(origin: .zero, size: btn2.mg_size))
        //        shareView.center = btn.center
        btn2.addTarget(self, action: #selector(self.share(_:)), for: .touchUpInside)
        shareView2.shareColor = .randomColor()
        btn2.addSubview(shareView2)
        shareView2.starAnimation()

        shareView2.tapBlock = {
            shareView.resumeAnimation()
        }

        view.lym.sss()
        btn.lym.sss()

        let btn1 = UIButton()
        btn1.frame = CGRect(x: 250, y: 88, width: 80, height: 50)
        btn1.setTitle("点击闪烁", for: .normal)
        btn1.backgroundColor = .black
        btn1.setTitleColor(.lightGray, for: .normal)
        btn1.addTarget(self, action: #selector(self.share(_:)), for: .touchUpInside)
        btn1.contentVerticalAlignment = .center
        btn1.contentHorizontalAlignment = .center
        view.addSubview(btn1)
        let shareView1 = MGLayerView(frame: CGRect(origin: .zero, size: btn1.mg_size))//MGLayerView(frame:  btn1.frame)
        shareView1.shareColor = .yellow
        shareView1.repeatCount = 1;
        shareView1.tag = 9999;
        btn1.addSubview(shareView1)
        shareView1.tapBlock = {
            shareView1.starAnimation()
        }
//        self.view.insertSubview(shareView1, belowSubview: btn1)

//        shareView1.starAnimation()

        setUpMainView()
        let request = SettingRequest(password: "123")
        MGSessionManager.default.request(request).mgResponseDecodableObject { (response: DataResponse<MGResponse<HSUserData>>) in
            print(response)
        }
        MGSessionManager.default.request("Room/GetNewRoomOnline?page=1", method: .get, parameters: nil).mgResponseDecodableObject { (response: DataResponse<MGResponse<MGServicelData1>>) in
            print(response)
        }
    }

    @objc func share(_ btn: UIButton) {
        if let shareView = self.view.viewWithTag(9999), shareView is MGLayerView{
            (shareView as! MGLayerView).starAnimation()
        }
    }

    func setUpMainView() {
        // 如何给UITextView设置placeHodler(占位文字)
        let ideaTextView = UITextView()
        ideaTextView.backgroundColor = UIColor.orange
        ideaTextView.frame =  CGRect(x: 20, y: 200, width: 300, height: 200)
        let placeHolderLabel = UILabel()
        placeHolderLabel.text = "写下你的问题或建议，我们将及时跟进解决（建议上传截图帮助我们解决问题，感谢！）"
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.font = UIFont.systemFont(ofSize: 15)
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.sizeToFit()
        ideaTextView.addSubview(placeHolderLabel)
        ideaTextView.setValue(placeHolderLabel, forKeyPath: "_placeholderLabel")
        ideaTextView.font = placeHolderLabel.font

        view.addSubview(ideaTextView);


        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.lineBreakMode = .byCharWrapping
        let contentString = NSMutableAttributedString(string: "1、增加家人列表，主人可管理家人列表 \n2、修复状态栏在注册界面和忘记密码界面不显示的BUG\n3、修复状态栏在注册界面和忘记密码界面不显示的BUG\n4、修复状态栏在注册界面和忘记密码界面不显示的BUG", attributes: [
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
            ])

        ideaTextView.attributedText = contentString

        print(Date())
    }

    @objc func leftClick() {
        self.navigationController?.pushViewController(LeftViewController(), animated: true)
    }

    @objc func rightClick() {
        self.navigationController?.pushViewController(BViewController(), animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        SessionManager.default.request(URL(string: "http://live.9158.com/Room/GetNewRoomOnline?page=1")!, method: .get, parameters: nil).mgResponseObject { (response: DataResponse<MGServicelData>) in
//            switch response.result {
//            case .success(let value):
//                print(value)
//            case .failure(let error):
//                print(error)
//            }
//        }
        print(Date())
        print(Date(timeIntervalSinceNow: 0))

        let isOn = isProtraitLockOn()
        print(isOn)

        let isAir = isIpadAir()
        print(isAir)
    }
    func isIpadAir() -> Bool {
        var systemInfo: utsname = utsname()
        uname(&systemInfo)
        let name = "12"
        let platform = String(cString: "\(systemInfo.machine)", encoding: .ascii)
        if platform == "iPad4,1" || platform == "iPad4,2" || platform == "iPad4,3" || platform == "iPad5,3" || platform == "iPad5,4"{
            return true
        }
        return false
    }

    func isProtraitLockOn() -> Bool {
        let app = UIApplication.shared
        var foregroundView: UIView?
        var cls: UIView.Type?


        let statusBar: UIView? = app.value(forKeyPath: "statusBar") as? UIView
        guard statusBar != nil else {
            return false
        }

        foregroundView = statusBar?.value(forKeyPath: "foregroundView") as? UIView
        if foregroundView == nil {
            let statusBarView = statusBar!.value(forKeyPath: "statusBar") as? UIView
            if statusBarView != nil {
                foregroundView = statusBarView!.value(forKeyPath: "foregroundView") as? UIView
            }
        }
//        foregroundView = statusBar!.value(forKeyPath: "statusBar") as? UIView)?.value(forKeyPath: "foregroundView") as? UIView
        cls = NSClassFromString("_UIStatusBarImageView") as? UIView.Type

        var isOn = false
        for child in foregroundView?.subviews ?? [] {
            if let cls1 = cls, child.isKind(of: cls1), child.frame.size.equalTo(CGSize(width: 11.5, height: 10.0)) {
                isOn = true
                break
            }
        }
        return isOn
    }
}

extension UIView {
    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
    }

    open override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
}

struct SettingRequest: MGRequestable {
    var password: String
    var method: HTTPMethod {
        return .get
    }

    var urlPath: String {
        return "setpasswordbytoken"
    }

    var parameters: [String : Any]? {
        return ["password": password]
    }
}

struct HSUserData: Codable {
    /**
     *  health只有有值就代表台灯未使用过或者损坏 (-1)
     */
    var health: Int?
    //* 日期
    var day = ""
    //* start
    var start: Int?
    //* end
    var end: Int?
    //* end
    var minutes = ""
    //* distance
    var distance: Int?
    //* posture
    var posture: Int?
}

class Son: NSObject {
    /**
     *  health只有有值就代表台灯未使用过或者损坏 (-1)
     */
    var health: Int?
    //* 日期
    var day = ""
    //* start
    var start: Int?
    //* end
    var end: Int?
    //* end
    var minutes = ""
    //* distance
    var distance: Int?
    //* posture
    var posture: Int?
}

class MGServicelData<T>: MGModel {
    var msg:String = ""
    var code: String = ""
    var data: T?

}

class MGData: MGModel {
    var totalPage:Int = 0
    var list: [MGHot]?
}

class MGHot: MGModel {
    // MARK: - 属性
    /** 直播图 */
    var bigpic: String!
    /** 主播头像 */
    var smallpic: String!
    /** 直播流地址 */
    var flv: String!
    /** 所在城市 */
    var gps: String!
    /** 主播名 */
    var myname: String!
    /** 个性签名 */
    var signatures: String!
    /** 用户ID */
    var userId: String!
    /** 民族 */
    var nation : String!
    /** 民族Flag */
    var nationFlag : String!

    /** 用户IDX */
    var useridx: NSNumber!
    /** 星级 */
    var starlevel: NSNumber! {
        didSet {
            if ((self.starlevel) != nil) {
                starImage = UIImage(named: "girl_star\(starlevel!)_40x19")
            }
        }
    }

    /** 朝阳群众数目 */
    var allnum: NSNumber!
    /** 这玩意未知 */
    var lrCurrent: NSNumber!
    /** 直播房间号码 */
    var roomid: NSNumber!
    /** 所处服务器 */
    var serverid: NSNumber!

    var isSign: NSNumber!
    var level: NSNumber!
    var grade: NSNumber!
    /** 排名 */
    var pos: NSNumber!
    /** starImage */
    var starImage: UIImage!

    // MARK: - 属性
    // MARK: String
    /** 直播地址 */
    //    var flv: String?
    /** 昵称 */
    var nickname: String?
    /** 照片地址 */
    var photo: String?
    /** 所在地区 */
    var position: String?


    // MARK: NSNumber
    var newField: NSNumber!
    /** 性别 */
    var sex: NSNumber!
    /** 是否是新人 */
    var newStar: NSNumber!

    // MARK: - 属性
}

struct MGServicelData1: Codable {
    var msg:String?
    var code: String?
    var data: MGData1?
}

struct MGData1: Codable {
    var totalPage:Int?
    var list: [MGHot12]?
}

struct MGHot12: Codable {
    // MARK: - 属性
    /** 直播图 */
    var bigpic: String?
    /** 主播头像 */
    var smallpic: String?
    /** 直播流地址 */
    var flv: String?
    /** 所在城市 */
//    var gps: String?
//    /** 主播名 */
//    var myname: String?
//    /** 个性签名 */
//    var signatures: String?
//    /** 用户ID */
//    var userId: String?
//    /** 民族 */
//    var nation : String?
//    /** 民族Flag */
//    var nationFlag : String?
//
//    /** 用户IDX */
//    var useridx: NSNumber?
//    /** 星级 */
//    var starlevel: NSNumber?
////    {
////        didSet {
////            if ((self.starlevel) != nil) {
////                starImage = UIImage(named: "girl_star\(starlevel!)_40x19")
////            }
////        }
////    }
//
//    /** 朝阳群众数目 */
//    var allnum: NSNumber?
//    /** 这玩意未知 */
//    var lrCurrent: NSNumber?
//    /** 直播房间号码 */
//    var roomid: NSNumber?
//    /** 所处服务器 */
//    var serverid: NSNumber?
//
//    var isSign: NSNumber?
//    var level: NSNumber?
//    var grade: NSNumber?
//    /** 排名 */
//    var pos: NSNumber?
//    /** starImage */
//    var starImage: UIImage?
//
//    // MARK: - 属性
//    // MARK: String
//    /** 直播地址 */
//    //    var flv: String?
//    /** 昵称 */
//    var nickname: String?
//    /** 照片地址 */
//    var photo: String?
//    /** 所在地区 */
//    var position: String?
//
//
//    // MARK: NSNumber
//    var newField: NSNumber?
//    /** 性别 */
//    var sex: NSNumber?
//    /** 是否是新人 */
//    var newStar: NSNumber?
//
//    // MARK: - 属性
}

struct HSUser1111: Codable {
    /**
     *  health只有有值就代表台灯未使用过或者损坏 (-1)
     */
    var health: Int?
    var data:HSUser2222;
}

struct HSUser2222: Codable {
    /**
     *  health只有有值就代表台灯未使用过或者损坏 (-1)
     */
    var health: Int?
}

struct HSUser333: Codable {
    /**
     *  health只有有值就代表台灯未使用过或者损坏 (-1)
     */
    var health: Int?
    var data:HSUser2222;

    init(health:Int?,data:HSUser2222) {
        self.health = health
        self.data = data
    }
    init() {
        self.init()
    }
}

func test() {
    let data = HSUser2222(health: 12)
    let _: HSUser1111? = HSUser1111(health: 12, data: data)
    let _ = HSUser333()
}


